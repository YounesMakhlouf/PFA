import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/config/app_theme.dart';
import 'package:pfa/l10n/app_localizations.dart';
import 'package:pfa/config/routes.dart';
import 'package:pfa/providers/global_providers.dart';
import 'package:pfa/widgets/game_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    });
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
    final logger = ref.read(loggingServiceProvider);

    final activeChild = ref.watch(activeChildProvider);
    logger.debug(
        "HomeScreen build: Watched active child is ${activeChild?.childId ?? 'null'}");

    if (activeChild == null) {
      logger.warning(
          "HomeScreen build: Active child is null. Showing loading. Check AuthGate logic.");
      return Scaffold(body: const Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(activeChild.firstName),
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.account_circle_outlined),
              tooltip: l10n.manageProfilesTooltip,
              onSelected: (value) {
                if (value == 'add') {
                  Navigator.pushNamed(context, AppRoutes.createChildProfile);
                } else if (value == 'switch') {
                  final profiles =
                      ref.read(initialChildProfilesProvider).valueOrNull ?? [];
                  if (profiles.length > 1) {
                    logger.info("Navigating to SelectChildProfileScreen");
                    Navigator.pushNamed(context, AppRoutes.selectChildProfile,
                        arguments: {"profiles": profiles});
                  } else {
                    logger.info(
                        "Switch profile selected, but only one profile exists.");
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.onlyOneProfileExists)));
                  }
                }
              },
              itemBuilder: (BuildContext context) {
                final profilesCount = ref
                        .read(initialChildProfilesProvider)
                        .valueOrNull
                        ?.length ??
                    0;
                return <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'add',
                    child: Text(l10n.addChildProfileButton),
                  ),
                  PopupMenuItem<String>(
                    value: 'switch',
                    enabled: profilesCount > 1, // Disable if only one profile
                    child: Text(l10n.switchChildProfileButton),
                  ),
                ];
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: l10n.logout,
              onPressed: _handleLogout,
            ),
          ],
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: _buildGameGrid(context, l10n, theme),
        ));
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

  Widget _buildGameGrid(
      BuildContext context, AppLocalizations l10n, ThemeData theme) {
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
