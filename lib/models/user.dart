import 'package:uuid/uuid.dart';

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
  String get displayName {
    switch (this) {
      case SpecialCondition.AUTISM:
        return 'التوحد';
      case SpecialCondition.ADHD:
        return 'فرط الحركة ونقص الانتباه';
      case SpecialCondition.DYSLEXIA:
        return 'عسر القراءة';
      case SpecialCondition.DYSCALCULIA:
        return 'عسر الحساب';
      case SpecialCondition.SPEAKING_DIFFICULTIES:
        return 'صعوبات في النطق';
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
    String? userId,
    required String email,
    required String password,
    DateTime? createdAt,
    required this.firstName,
    required this.lastName,
    required this.birthdate,
    this.avatarUrl,
    required this.specialConditions,
  }) : super(
          userId: userId,
          email: email,
          password: password,
          createdAt: createdAt,
        );

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
    String? userId,
    required String email,
    required String password,
    DateTime? createdAt,
    required this.speciality,
  }) : super(
          userId: userId,
          email: email,
          password: password,
          createdAt: createdAt,
        );
}
