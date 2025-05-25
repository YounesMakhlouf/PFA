import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/config/routes.dart';
import 'package:pfa/l10n/app_localizations.dart';
import 'package:pfa/models/user.dart';
import 'package:pfa/providers/global_providers.dart';
import 'package:pfa/screens/error_screen.dart';
import 'package:pfa/screens/generic_loading_screen.dart';
import 'package:pfa/widgets/avatar_display.dart';

class SelectChildProfileScreen extends ConsumerStatefulWidget {
  const SelectChildProfileScreen({super.key});

  @override
  ConsumerState<SelectChildProfileScreen> createState() =>
      _SelectChildProfileScreenState();
}

class _SelectChildProfileScreenState
    extends ConsumerState<SelectChildProfileScreen> {
  void _selectProfile(Child profile) {
    final logger = ref.read(loggingServiceProvider);
    final navigator = Navigator.of(context);
    logger.info("Selected profile: ${profile.childId} (${profile.firstName})");
    ref.read(activeChildProvider.notifier).set(profile);
    if (mounted) {
      logger.debug("Popping SelectChildProfileScreen.");
      navigator.pop();
    }
  }

  void _navigateToAddProfile() {
    Navigator.of(context).pushNamed(AppRoutes.createChildProfile);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final logger = ref.read(loggingServiceProvider);
    final profilesAsync = ref.watch(initialChildProfilesProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.whoIsPlayingPrompt,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  Expanded(
                    child: profilesAsync.when(
                      loading: () => GenericLoadingScreen(
                          message: l10n.loadingProfilesMessage),
                      error: (err, st) {
                        logger.error(
                            "SelectChildProfileScreen: Error loading profiles",
                            err,
                            st);
                        return ErrorScreen(
                            errorMessage:
                                "${l10n.applicationError}: ${err.toString()}");
                      },
                      data: (profiles) {
                        profiles.sort((a, b) => a.firstName
                            .toLowerCase()
                            .compareTo(b.firstName.toLowerCase()));

                        if (profiles.isEmpty) {
                          logger.warning(
                              "SelectChildProfileScreen: Reached with empty profile list. Navigating to create.");
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (context.mounted) {
                              Navigator.of(context).pushReplacementNamed(
                                  AppRoutes.createChildProfile);
                            }
                          });
                          return Center(
                              child: Text(l10n.noProfilesFoundMessage));
                        }

                        return GridView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: profiles.length == 1
                                ? 1
                                : (profiles.length <= 4 ? 2 : 3),
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20,
                            childAspectRatio: profiles.length == 1 ? 1.2 : 0.9,
                          ),
                          itemCount: profiles.length,
                          itemBuilder: (context, index) {
                            final profile = profiles[index];
                            // Add animation to each card
                            return _buildProfileCard(context, theme, profile)
                                .animate()
                                .fadeIn(
                                    duration: 300.ms, delay: (100 * index).ms)
                                .slideY(
                                    begin: 0.2,
                                    duration: 300.ms,
                                    delay: (100 * index).ms,
                                    curve: Curves.easeOut);
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add_circle_outline),
                    label: Text(l10n.addChildProfileButton),
                    onPressed: _navigateToAddProfile,
                    style: theme.elevatedButtonTheme.style?.copyWith(
                      backgroundColor: WidgetStateProperty.all(
                          theme.colorScheme.secondaryContainer),
                      foregroundColor: WidgetStateProperty.all(
                          theme.colorScheme.onSecondaryContainer),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(
      BuildContext context, ThemeData theme, Child profile) {
    return Card(
      child: InkWell(
        onTap: () => _selectProfile(profile),
        borderRadius: theme.cardTheme.shape is RoundedRectangleBorder
            ? (theme.cardTheme.shape as RoundedRectangleBorder).borderRadius
                as BorderRadius
            : BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AvatarDisplay(
                avatarUrlOrPath: profile.avatarUrl,
                radius: 45,
              ),
              const SizedBox(height: 16),
              Text(
                profile.firstName,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
