import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/config/app_theme.dart';
import 'package:pfa/l10n/app_localizations.dart';
import 'package:pfa/config/routes.dart';
import 'package:pfa/models/game.dart';
import 'package:pfa/providers/global_providers.dart';
import 'package:pfa/screens/error_screen.dart';
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
                else if (value == 'view_stats') {
                  logger.info("Navigating to StatsScreen for child: ${activeChild.childId}");
                  Navigator.pushNamed(
                    context,
                    AppRoutes.stats,
                    arguments: {'childUuid': activeChild.childId},
                  );
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
                  const PopupMenuDivider(),
                  PopupMenuItem<String>(
                    value: 'view_stats',
                    child: Row(
                      children: [
                        Icon(Icons.bar_chart_outlined, color: theme.colorScheme.primary),
                        const SizedBox(width: 8),
                        Text("View Stats"), //TODO: Add to l10n
                      ],
                    ),
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
