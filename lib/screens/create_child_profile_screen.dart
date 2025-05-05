import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pfa/l10n/app_localizations.dart';
import 'package:pfa/config/app_theme.dart';
import 'package:pfa/models/user.dart';
import 'package:pfa/config/routes.dart';
import 'package:pfa/providers/global_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateChildProfileScreen extends ConsumerStatefulWidget {
  const CreateChildProfileScreen({super.key});

  @override
  ConsumerState<CreateChildProfileScreen> createState() =>
      _CreateChildProfileScreenState();
}

class _CreateChildProfileScreenState
    extends ConsumerState<CreateChildProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  String? _selectedAvatarPath;
  DateTime? _selectedBirthdate;
  final Set<SpecialCondition> _selectedConditions = {};
  bool _isLoading = false;

  final List<String> _defaultAvatarPaths = [
    'assets/images/avatars/avatar1.png',
    'assets/images/avatars/avatar2.png',
    'assets/images/avatars/avatar3.png',
    'assets/images/avatars/avatar4.png',
  ];

  @override
  void initState() {
    super.initState();

    if (_defaultAvatarPaths.isNotEmpty) {
      _selectedAvatarPath = _defaultAvatarPaths.first;
    }
    ref
        .read(loggingServiceProvider)
        .info("CreateChildProfileScreen initialized");
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthdate ?? DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 25),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.primary,
                  onPrimary: AppColors.textLight,
                  onSurface: AppColors.textPrimary,
                ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedBirthdate) {
      setState(() {
        _selectedBirthdate = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    FocusScope.of(context).unfocus();

    final logger = ref.read(loggingServiceProvider);
    final childRepository = ref.read(childRepositoryProvider);

    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      logger.info('Submitting child profile form');

      try {
        final firstName = _firstNameController.text.trim();
        final lastName = _lastNameController.text.trim().isEmpty
            ? null
            : _lastNameController.text.trim();
        // TODO: Handle custom avatar upload. For now, we just save the selected asset path (or null). This should be a Supabase Storage URL after upload
        final avatarUrl = _selectedAvatarPath;

        logger.debug(
            'Calling repository createChildProfile for name: $firstName');

        final newChildProfile = await childRepository.createChildProfile(
            firstName: firstName,
            lastName: lastName,
            birthdate: _selectedBirthdate,
            avatarUrl: avatarUrl,
            specialConditions:
                _selectedConditions); // TODO: I disabled email verification because it would need another screen in between (before creating a new child profile) as the parent is only considered logged in when the email verification is done

        logger.info(
            'Child profile created successfully for $firstName: ${newChildProfile?.childId}');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)
                  .profileCreatedSuccess(firstName)),
              backgroundColor: AppColors.success,
            ),
          );
          Navigator.of(context).pushReplacementNamed(AppRoutes.home);
        }
      } catch (e, stackTrace) {
        logger.error('Failed to create child profile', e, stackTrace);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  '${AppLocalizations.of(context).errorCreatingProfile} ${e.toString().replaceFirst("Exception: ", "")}'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    } else {
      logger.warning('Child profile form validation failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final logger = ref.read(loggingServiceProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.createChildProfileTitle),
        automaticallyImplyLeading: false, // No back button in this flow
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- Avatar Selection ---
                Text(
                  l10n.selectAvatarPrompt,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16,
                  runSpacing: 16,
                  children: _defaultAvatarPaths.map((path) {
                    final isSelected = _selectedAvatarPath == path;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedAvatarPath = path),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.transparent,
                            width: 3.0,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor:
                              Colors.grey[200], // Placeholder background
                          backgroundImage: AssetImage(path),
                          onBackgroundImageError: (_, __) {
                            logger.error("Failed to load avatar asset: $path");
                          },
                        ),
                      ),
                    );
                  }).toList(),
                  // TODO: Add button for custom image upload later
                ),
                const SizedBox(height: 32),

                // --- First Name ---
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: "${l10n.firstNameLabel} *",
                    hintText: l10n.enterFirstNameHint,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: AppColors.textLight,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.errorFirstNameRequired;
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),

                // --- Last Name ---
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: l10n.lastNameLabelOptional,
                    hintText: l10n.enterLastNameHintOptional,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: AppColors.textLight,
                  ),
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),

                // --- Birthdate ---
                Text(
                  l10n.birthdateLabelOptional,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color:
                          AppColors.textPrimary.withAlpha((0.7 * 255).round())),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  icon: const Icon(Icons.calendar_today, size: 20),
                  label: Text(
                    _selectedBirthdate == null
                        ? l10n.selectDateButton
                        : DateFormat.yMMMd().format(_selectedBirthdate!),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  onPressed: () => _selectDate(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    foregroundColor: AppColors.textPrimary,
                    side: BorderSide(
                        color:
                            AppColors.primary.withAlpha((0.5 * 255).round())),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 24),

                // --- Special Conditions ---
                Text(
                  l10n.specialConditionsLabelOptional,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color:
                          AppColors.textPrimary.withAlpha((0.7 * 255).round())),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: SpecialCondition.values.map((condition) {
                    final isSelected = _selectedConditions.contains(condition);
                    return FilterChip(
                      label: Text(condition.displayName(context)),
                      selected: isSelected,
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            _selectedConditions.add(condition);
                          } else {
                            _selectedConditions.remove(condition);
                          }
                        });
                      },
                      selectedColor:
                          AppColors.primaryLight.withAlpha((0.8 * 255).round()),
                      checkmarkColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textPrimary,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      backgroundColor: AppColors.background,
                      shape: StadiumBorder(
                          side: BorderSide(
                              color: AppColors.primary
                                  .withAlpha((0.3 * 255).round()))),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 40),

                // --- Submit Button ---
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : _submitForm, // Disable button when loading
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: AppColors.textLight),
                        )
                      : Text(l10n.createProfileButton),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
