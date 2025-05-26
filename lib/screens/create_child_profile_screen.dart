import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pfa/l10n/app_localizations.dart';
import 'package:pfa/models/user.dart';
import 'package:pfa/providers/global_providers.dart';
import 'package:pfa/widgets/avatar_display.dart';

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
    final theme = Theme.of(context);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthdate ?? DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 25),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: theme.colorScheme.primary,
              onPrimary: theme.colorScheme.onPrimary,
              onSurface: theme.colorScheme.onSurface,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
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
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
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
        ref.invalidate(initialChildProfilesProvider);
        if (!mounted) return;
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(
                AppLocalizations.of(context).profileCreatedSuccess(firstName)),
            backgroundColor: Theme.of(context).colorScheme.tertiary,
          ),
        );
        logger.info("Popping CreateChildProfileScreen after success.");
        if (navigator.canPop()) {
          navigator.pop();
        } else {
          logger.warning("CreateChildProfileScreen cannot pop.");
        }
      } catch (e, stackTrace) {
        logger.error('Failed to create child profile', e, stackTrace);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  '${AppLocalizations.of(context).errorCreatingProfile} ${e.toString().replaceFirst("Exception: ", "")}'),
              backgroundColor: Theme.of(context).colorScheme.error,
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
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.createChildProfileTitle),
        automaticallyImplyLeading: Navigator.canPop(context),
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
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
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 20,
                  runSpacing: 20,
                  children: _defaultAvatarPaths.map((path) {
                    final isSelected = _selectedAvatarPath == path;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedAvatarPath = path),
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : Colors.transparent,
                            width: 3.0,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: theme.colorScheme.primary
                                        .withValues(alpha: 0.3),
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                  )
                                ]
                              : [],
                        ),
                        child: AvatarDisplay(
                          avatarUrlOrPath: path,
                          radius: 45,
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
                  ),
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),

                // --- Birthdate ---
                Material(
                  color: theme.inputDecorationTheme.fillColor ??
                      theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () => _selectDate(context),
                    borderRadius: BorderRadius.circular(10),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: l10n.birthdateLabelOptional,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedBirthdate == null
                                ? l10n.selectDateButton
                                : DateFormat.yMMMd(l10n.localeName)
                                    .format(_selectedBirthdate!),
                            style: theme.textTheme.bodyLarge,
                          ),
                          Icon(Icons.calendar_today_outlined, size: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // --- Special Conditions ---
                Text(
                  l10n.specialConditionsLabelOptional,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
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
                    );
                  }).toList(),
                ),
                const SizedBox(height: 40),

                // --- Submit Button ---
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: theme.elevatedButtonTheme.style?.copyWith(
                    padding: WidgetStateProperty.all(const EdgeInsets.symmetric(
                        vertical: 18)), // Ensure good height
                  ),
                  // Disable button when loading
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: theme.colorScheme.onPrimary),
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
