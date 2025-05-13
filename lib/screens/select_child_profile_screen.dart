import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/config/app_theme.dart';
import 'package:pfa/config/routes.dart';
import 'package:pfa/l10n/app_localizations.dart';
import 'package:pfa/models/user.dart';
import 'package:pfa/providers/global_providers.dart';
import 'package:pfa/screens/generic_loading_screen.dart';
import 'package:pfa/widgets/avatar_display.dart';

class SelectChildProfileScreen extends ConsumerStatefulWidget {
  final List<Child> profiles;

  const SelectChildProfileScreen({required this.profiles, super.key});

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
      appBar: AppBar(
        title: Text(l10n.selectChildProfileTitle),
        automaticallyImplyLeading: false,
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.whoIsPlayingPrompt,
                    style: theme.textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: profilesAsync.when(
                      loading: () => const GenericLoadingScreen(
                          message: "Initializing..."),
                      error: (err, st) {
                        logger.error(
                            "SelectChildProfileScreen: Error loading profiles",
                            err,
                            st);
                        return Center(
                            child: Text(
                                "$AppLocalizations.applicationError: $err"));
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
                          return const Center(
                              child: Text("No profiles found..."));
                        }

                        return ListView.separated(
                          shrinkWrap: true,
                          itemCount: profiles.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final profile = profiles[index];
                            return _buildProfileCard(context, theme, profile);
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.add_circle_outline),
                    label: Text(l10n.addChildProfileButton),
                    onPressed: _navigateToAddProfile,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      foregroundColor: theme.colorScheme.primary,
                      side: BorderSide(
                          color: theme.colorScheme.primary
                              .withAlpha((0.5 * 255).round())),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
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
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _selectProfile(profile),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Row(
            children: [
              AvatarDisplay(
                avatarUrl: profile.avatarUrl,
                radius: 30,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  profile.firstName,
                  style: theme.textTheme.titleLarge,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.arrow_forward_ios,
                  size: 18, color: AppColors.disabled),
            ],
          ),
        ),
      ),
    );
  }
}
