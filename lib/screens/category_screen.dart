import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/config/app_theme.dart';
import 'package:pfa/constants/const.dart';
import 'package:pfa/l10n/app_localizations.dart';
import 'package:pfa/config/routes.dart';
import 'package:pfa/models/game.dart';
import 'package:pfa/providers/global_providers.dart';
import 'package:pfa/screens/error_screen.dart';
import 'package:pfa/screens/generic_loading_screen.dart';
import 'package:pfa/utils/supabase_utils.dart';
import 'package:pfa/widgets/game_card.dart';

class CategoryGamesScreen extends ConsumerWidget {
  final GameCategory category;

  const CategoryGamesScreen({required this.category, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final logger = ref.read(loggingServiceProvider);
    final gamesAsync = ref.watch(gamesByCategoryProvider(category));

    return Scaffold(
        appBar: AppBar(
          title: Text(category.localizedName(context)),
          backgroundColor: theme.appBarTheme.backgroundColor,
          foregroundColor: theme.appBarTheme.foregroundColor,
          elevation: theme.appBarTheme.elevation,
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
            child: gamesAsync.when(loading: () {
          logger.debug("CategoryGamesScreen: Loading games for $category...");
          return GenericLoadingScreen(
              message: "Loading games for $category...");
        }, error: (err, st) {
          logger.error("CategoryGamesScreen: Error loading games for $category",
              err, st);
          return ErrorScreen(errorMessage: l10n.errorLoadingGamesDetails(err));
        }, data: (games) {
          logger.debug(
              "CategoryGamesScreen: Displaying ${games.length} games for $category.");
          if (games.isEmpty) {
            return Center(
                child: Text(l10n.noGamesInCategoryAvailable(
                    category.localizedName(context))));
          }

          return _buildGameGrid(context, ref, l10n, theme, games);
        })));
  }
}

void _navigateToGame(BuildContext context, WidgetRef ref, String routeName,
    Map<String, dynamic>? arguments) {
  final navigator = Navigator.of(context);
  final logger = ref.read(loggingServiceProvider);
  logger.info("Navigating to route: $routeName with args: $arguments");
  navigator.pushNamed(routeName, arguments: arguments);
}

Widget _buildGameGrid(
  BuildContext context,
  WidgetRef ref,
  AppLocalizations l10n,
  ThemeData theme,
  List<Game> games,
) {
  final displayGames = games;

  final translationService = ref.read(translationServiceProvider);

  return GridView.builder(
    padding: const EdgeInsets.all(16.0),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 16.0,
      crossAxisSpacing: 16.0,
      childAspectRatio: 0.85,
    ),
    itemCount: displayGames.length,
    itemBuilder: (context, index) {
      final game = displayGames[index];
      final bool isEnabled = true;
      final String? fullImageUrl = getSupabasePublicUrl(
        ref,
        bucketId: StorageBuckets.gameAssets,
        filePath: game.pictureUrl,
      );

      final translatedTitle =
          translationService.getTranslatedText(context, game.name);

      return GameCardWidget(
        title: translatedTitle,
        backgroundColor: AppTheme.lightTheme.colorScheme.primaryContainer,
        imagePath: fullImageUrl,
        isEnabled: isEnabled,
        onTap: isEnabled
            ? () => _navigateToGame(
                  context,
                  ref,
                  AppRoutes.multipleChoiceGame,
                  {'gameId': game.gameId},
                )
            // ignore: dead_code
            : null,
      );
    },
  );
}
