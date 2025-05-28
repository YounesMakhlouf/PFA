import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/config/routes.dart';
import 'package:pfa/l10n/app_localizations.dart';
import 'package:pfa/models/game.dart';
import 'package:pfa/providers/global_providers.dart';
import 'package:pfa/screens/error_screen.dart';
import 'package:pfa/screens/generic_loading_screen.dart';
import 'package:pfa/widgets/category_card_widget.dart';

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
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    logger.info('Logout button tapped');
    try {
      await supabaseService.signOut();
      logger.info('Sign out successful');
    } catch (e, stackTrace) {
      logger.error('Error during sign out', e, stackTrace);
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
              content: Text(l10n.applicationError),
              backgroundColor: theme.colorScheme.error),
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
      return GenericLoadingScreen(message: l10n.loadingProfilesMessage);
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(activeChild.firstName),
          actions: [
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert_outlined,
                  color: theme.appBarTheme.actionsIconTheme?.color),
              tooltip: l10n.manageProfilesTooltip,
              onSelected: (value) {
                if (value == 'switch') {
                  logger.info("Navigating to SelectChildProfileScreen");
                  Navigator.pushNamed(context, AppRoutes.selectChildProfile);
                } else if (value == 'view_stats') {
                  logger.info(
                      "Navigating to StatsScreen for child: ${activeChild.childId}");
                  Navigator.pushNamed(
                    context,
                    AppRoutes.stats,
                    arguments: {'childUuid': activeChild.childId},
                  );
                } else if (value == 'settings') {
                  logger.info("Navigating to SettingsScreen");
                  Navigator.pushNamed(context, AppRoutes.settings);
                }
              },
              color: theme.popupMenuTheme.color ?? theme.colorScheme.surface,
              shape: theme.popupMenuTheme.shape ??
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
              itemBuilder: (BuildContext context) {
                return <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'switch',
                    child: ListTile(
                      leading: Icon(Icons.switch_account_outlined,
                          color: theme.colorScheme.primary),
                      title: Text(l10n.switchChildProfileButton,
                          style: theme.textTheme.bodyMedium),
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem<String>(
                    value: 'view_stats',
                    child: ListTile(
                      leading: Icon(Icons.bar_chart_outlined,
                          color: theme.colorScheme.primary),
                      title: Text(l10n.viewStats,
                          style: theme.textTheme.bodyMedium),
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'settings',
                    child: ListTile(
                      leading: Icon(Icons.settings_outlined,
                          color: theme.colorScheme.primary),
                      title: Text(l10n.settingsTitle,
                          style: theme.textTheme.bodyMedium),
                    ),
                  ),
                ];
              },
            ),
            IconButton(
              icon: Icon(Icons.logout,
                  color: theme.appBarTheme.actionsIconTheme?.color),
              tooltip: l10n.logout,
              onPressed: _handleLogout,
            ),
          ],
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: _buildCategoryGrid(context, ref, l10n, theme),
        ));
  }

  Widget _buildCategoryGrid(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    final List<GameCategory> displayCategories =
        GameCategory.values.where((c) => c != GameCategory.UNKNOWN).toList();

    if (displayCategories.isEmpty) {
      return ErrorScreen(errorMessage: l10n.noGameCategoriesAvailable);
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
        childAspectRatio: 0.9,
      ),
      itemCount: displayCategories.length,
      itemBuilder: (context, index) {
        final category = displayCategories[index];

        return CategoryCardWidget(
          category: category,
          onTap: () {
            ref.read(loggingServiceProvider).info("Tapped category: $category");
            Navigator.pushNamed(
              context,
              AppRoutes.categoryGames,
              arguments: {'category': category},
            );
          },
        );
      },
    );
  }
}
