import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../l10n/app_localizations.dart';

abstract class User {
  final String userId;
  final String email;
  final String password; // TODO: this should be handled securely
  final DateTime createdAt;

  User({
    String? userId,
    required this.email,
    required this.password,
    DateTime? createdAt,
  })  : userId = userId ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();
}

/// Represents a special condition that a child might have
enum SpecialCondition {
  AUTISM,
  ADHD,
  DYSLEXIA,
  DYSCALCULIA,
  SPEAKING_DIFFICULTIES
}

extension SpecialConditionExtension on SpecialCondition {
  String displayName(BuildContext context) {
    switch (this) {
      case SpecialCondition.AUTISM:
        return AppLocalizations.of(context).autism;
      case SpecialCondition.ADHD:
        return AppLocalizations.of(context).adhd;
      case SpecialCondition.DYSLEXIA:
        return AppLocalizations.of(context).dyslexia;
      case SpecialCondition.DYSCALCULIA:
        return AppLocalizations.of(context).dyscalculia;
      case SpecialCondition.SPEAKING_DIFFICULTIES:
        return AppLocalizations.of(context).speakingDifficulties;
    }
  }
}

class Child extends User {
  final String firstName;
  final String lastName;
  final DateTime birthdate;
  final String? avatarUrl;
  final List<SpecialCondition> specialConditions;

  Child({
    super.userId,
    required super.email,
    required super.password,
    super.createdAt,
    required this.firstName,
    required this.lastName,
    required this.birthdate,
    this.avatarUrl,
    required this.specialConditions,
  });

  String get fullName => '$firstName $lastName';

  /// Returns the child's age in years
  int get age {
    final now = DateTime.now();
    int age = now.year - birthdate.year;
    if (now.month < birthdate.month ||
        (now.month == birthdate.month && now.day < birthdate.day)) {
      age--;
    }
    return age;
  }
}

class Educator extends User {
  final String speciality;

  Educator({
    super.userId,
    required super.email,
    required super.password,
    super.createdAt,
    required this.speciality,
  });
}
