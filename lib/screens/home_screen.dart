import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/config/app_theme.dart';
import 'package:pfa/l10n/app_localizations.dart';
import 'package:pfa/config/routes.dart';
import 'package:pfa/models/user.dart';
import 'package:pfa/providers/global_providers.dart';
import 'package:pfa/screens/error_screen.dart';
import 'package:pfa/widgets/game_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomeScreen> {
  bool _isProfileCheckComplete = false;
  String? _loadingError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      _checkChildProfilesAndNavigate();
    });
  }

  Future<void> _checkChildProfilesAndNavigate() async {
    final logger = ref.read(loggingServiceProvider);
    final childRepository = ref.read(childRepositoryProvider);
    final navigator = Navigator.of(context);

    logger.info("HomeScreen: Checking for child profiles...");
    try {
      List<Child> profiles = await childRepository.getChildProfilesForParent();
      if (!mounted) return;
      if (profiles.isEmpty) {
        logger.info(
            "HomeScreen: No child profiles found. Navigating to CreateChildProfileScreen.");
        navigator.pushNamed(AppRoutes.createChildProfile);
        return;
      } else {
        logger.info("HomeScreen: ${profiles.length} child profile(s) found.");
        if (profiles.length > 1) {
          logger.warning(
              "HomeScreen: Multiple profiles exist, but selection screen not implemented. Showing home.");
          // TODO: Implement active child selection logic
        }
        setState(() {
          _isProfileCheckComplete = true;
        });
      }
    } catch (e, stackTrace) {
      logger.error("HomeScreen: Error fetching child profiles", e, stackTrace);
      if (mounted) {
        setState(() {
          _loadingError = e.toString();
          _isProfileCheckComplete = true;
        });
      }
    }
  }

  Future<void> _handleLogout() async {
    final logger = ref.read(loggingServiceProvider);
    final supabaseService = ref.read(supabaseServiceProvider);
    logger.info('Logout button tapped');
    try {
      await supabaseService.signOut();
      logger.info('Sign out successful');
    } catch (e, stackTrace) {
      logger.error('Error during sign out', e, stackTrace);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).applicationError),
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

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.learningGames),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: l10n.logout,
            onPressed: _handleLogout,
          ),
        ],
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: _buildBody(context, l10n, theme),
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

  Widget _buildBody(
      BuildContext context, AppLocalizations l10n, ThemeData theme) {
    if (_loadingError != null) {
      return ErrorScreen(errorMessage: _loadingError!);
    }

    if (!_isProfileCheckComplete) {
      return Center(
          child: CircularProgressIndicator(color: theme.colorScheme.primary));
    }

    final List<Map<String, dynamic>> gameData = [
      {
        'title': l10n.colorsAndShapes,
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

    return Column(
      children: [
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
                            context,
                            game['route'],
                            game['args'],
                          )
                      : null,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
