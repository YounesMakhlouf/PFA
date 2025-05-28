import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:collection/collection.dart';
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
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case SpecialCondition.AUTISM:
        return l10n.autism;
      case SpecialCondition.ADHD:
        return l10n.adhd;
      case SpecialCondition.DYSLEXIA:
        return l10n.dyslexia;
      case SpecialCondition.DYSCALCULIA:
        return l10n.dyscalculia;
      case SpecialCondition.SPEAKING_DIFFICULTIES:
        return l10n.speakingDifficulties;
    }
  }
}

class Child {
  final String childId;
  final String accountId; // Foreign Key linking to parent's auth.users.id
  final String firstName;
  final String? lastName;
  final DateTime birthdate;
  final String? avatarUrl;
  final Set<SpecialCondition> specialConditions;
  final DateTime createdAt;
  final DateTime updatedAt;

  Child({
    required this.childId,
    required this.accountId,
    required this.firstName,
    this.lastName,
    required this.birthdate,
    this.avatarUrl,
    required this.specialConditions,
    required this.createdAt,
    required this.updatedAt,
  });

  String get fullName {
    if (lastName != null && lastName!.isNotEmpty) {
      return '$firstName $lastName';
    }
    return firstName;
  }

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

  Map<String, dynamic> toJson() {
    return {
      'account_id': accountId,
      'first_name': firstName,
      'last_name': lastName,
      'birthdate': birthdate.toIso8601String().substring(0, 10),
      'avatar_url': avatarUrl,
      'special_conditions': specialConditions.map((e) => e.name).toList()
    };
  }

  factory Child.fromJson(Map<String, dynamic> json) {
    DateTime parseRequiredDateTime(String? dateStr) {
      if (dateStr == null) {
        return DateTime.now();
      }
      return DateTime.parse(dateStr).toLocal();
    }

    Set<SpecialCondition> parseConditions(dynamic conditionsData) {
      if (conditionsData is List) {
        return conditionsData
            .map((item) => item?.toString())
            .nonNulls
            .map((name) =>
                SpecialCondition.values.firstWhereOrNull((e) => e.name == name))
            .whereType<SpecialCondition>()
            .toSet();
      }
      return {}; // Return empty set if data is not a list or is null
    }

    return Child(
      childId: json['child_id'] as String,
      accountId: json['user_id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String?,
      birthdate: parseRequiredDateTime(json['birthdate'] as String?),
      avatarUrl: json['avatar_url'] as String?,
      specialConditions: parseConditions(json['special_conditions']),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
