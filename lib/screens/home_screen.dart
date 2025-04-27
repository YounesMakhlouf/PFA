import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pfa/config/app_theme.dart';
import 'package:pfa/l10n/app_localizations.dart';
import 'package:pfa/config/routes.dart';
import 'package:pfa/services/logging_service.dart';
import 'package:pfa/services/supabase_service.dart';
import 'package:pfa/ui/game_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
  final _logger = LoggingService();
  final _supabaseService = SupabaseService();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  Future<void> _handleLogout() async {
    _logger.info('Logout button tapped');
    try {
      await _supabaseService.signOut();
      _logger.info('Sign out successful');

      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.auth,
          (Route<dynamic> route) => false, // Remove all previous routes
        );
      }
    } catch (e, stackTrace) {
      _logger.error('Error during sign out', e, stackTrace);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    final List<Map<String, dynamic>> gameData = [
      {
        'title': AppLocalizations.of(context).colorsAndShapes,
        'imagePath': 'assets/images/colors_icon.png',
        'iconData': Icons.color_lens_outlined,
        'route': AppRoutes.multipleChoiceGame,
        'args': {'gameId': GameIds.colorsGame},
      },
      {
        'title': AppLocalizations.of(context).animals,
        'imagePath': 'assets/images/animals_icon.png',
        'iconData': Icons.pets,
        'route': null,
        'args': null,
      }, // TODO: Change these to be retrieved from the database
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.learningGames),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout', // TODO: Localize
            onPressed: _handleLogout,
          ),
        ],
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24.0, bottom: 12.0),
              child: Text(
                AppLocalizations.of(context).learningGames,
                style: theme.textTheme.headlineMedium,
              ),
            ),
            Expanded(
              child: Padding(
                padding: theme.cardTheme.margin ?? const EdgeInsets.all(16.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16.0,
                    crossAxisSpacing: 16.0,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: gameData.length,
                  itemBuilder: (context, index) {
                    final game = gameData[index];
                    final bool isEnabled = game['route'] != null;

                    return GameCardWidget(
                      title: game['title'],
                      imagePath: game['imagePath'],
                      iconData: game['iconData'],
                      isEnabled: isEnabled,
                      onTap: isEnabled
                          ? () => _navigateToGame(
                              context, game['route'], game['args'])
                          : null,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToGame(
      BuildContext context, String routeName, dynamic arguments) {
    final navigator = Navigator.of(context);
    SystemChrome.setPreferredOrientations(
            [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight])
        .then((_) {
      if (!mounted) return;
      navigator.pushNamed(routeName, arguments: arguments);
    });
  }
}
