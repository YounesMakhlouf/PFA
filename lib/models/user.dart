import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../l10n/app_localizations.dart';

abstract class User {
  final String userId;
  final String email;
  final DateTime createdAt;

  User({
    String? userId,
    required this.email,
    DateTime? createdAt,
  })  : userId = userId ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'email': email,
      'created_at': createdAt.toIso8601String(),
    };
  }
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
    if (birthdate.isAfter(now)) {
      return 0;
    }
    int age = now.year - birthdate.year;
    if (now.month < birthdate.month ||
        (now.month == birthdate.month && now.day < birthdate.day)) {
      age--;
    }
    return age < 0 ? 0 : age;
  }

  @override
  Map<String, dynamic> toJson() {
    final baseJson = super.toJson();
    return {
      ...baseJson,
      'first_name': firstName,
      'last_name': lastName,
      'birthdate': birthdate.toIso8601String(),
      'avatar_url': avatarUrl,
    };
  }

  factory Child.fromJson(Map<String, dynamic> json,
      {List<SpecialCondition>? specialConditions}) {
    return Child(
      userId: json['user_id'],
      email: json['email'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      firstName: json['first_name'],
      lastName: json['last_name'],
      birthdate: DateTime.parse(json['birthdate']),
      avatarUrl: json['avatar_url'],
      specialConditions: specialConditions ?? [],
    );
  }
}

class Educator extends User {
  final String speciality;

  Educator({
    super.userId,
    required super.email,
    super.createdAt,
    required this.speciality,
  });

  @override
  Map<String, dynamic> toJson() {
    final baseJson = super.toJson();
    return {
      ...baseJson,
      'speciality': speciality,
    };
  }

  factory Educator.fromJson(Map<String, dynamic> json) {
    return Educator(
      userId: json['user_id'],
      email: json['email'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      speciality: json['speciality'],
    );
  }
}
