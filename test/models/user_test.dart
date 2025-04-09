import 'package:flutter_test/flutter_test.dart';
import 'package:pfa/models/user.dart';

void main() {
  group('Child', () {
    test('should create a Child with all required fields', () {
      final child = Child(
        email: 'test@example.com',
        password: 'password123',
        firstName: 'Ahmed',
        lastName: 'Ali',
        birthdate: DateTime(2015, 5, 10),
        specialConditions: [SpecialCondition.AUTISM],
      );

      expect(child.userId, isNotEmpty);
      expect(child.email, 'test@example.com');
      expect(child.password, 'password123');
      expect(child.firstName, 'Ahmed');
      expect(child.lastName, 'Ali');
      expect(child.birthdate, DateTime(2015, 5, 10));
      expect(child.specialConditions, [SpecialCondition.AUTISM]);
      expect(child.createdAt, isNotNull);
    });

    test('should calculate age correctly', () {
      final birthdate = DateTime(DateTime.now().year - 8, DateTime.now().month,
          DateTime.now().day + 1);
      final child = Child(
        email: 'test@example.com',
        password: 'password123',
        firstName: 'Ahmed',
        lastName: 'Ali',
        birthdate: birthdate,
        specialConditions: [],
      );

      expect(child.age, 7); // Should be 7 because birthday is tomorrow

      final birthdateToday = DateTime(
          DateTime.now().year - 8, DateTime.now().month, DateTime.now().day);
      final childBirthdayToday = Child(
        email: 'test@example.com',
        password: 'password123',
        firstName: 'Ahmed',
        lastName: 'Ali',
        birthdate: birthdateToday,
        specialConditions: [],
      );

      expect(
          childBirthdayToday.age, 8); // Should be 8 because birthday is today
    });

    test('should return full name correctly', () {
      final child = Child(
        email: 'test@example.com',
        password: 'password123',
        firstName: 'Ahmed',
        lastName: 'Ali',
        birthdate: DateTime(2015, 5, 10),
        specialConditions: [],
      );

      expect(child.fullName, 'Ahmed Ali');
    });
  });

  group('Educator', () {
    test('should create an Educator with all required fields', () {
      final educator = Educator(
        email: 'teacher@example.com',
        password: 'password123',
        speciality: 'Special Education',
      );

      expect(educator.userId, isNotEmpty);
      expect(educator.email, 'teacher@example.com');
      expect(educator.password, 'password123');
      expect(educator.speciality, 'Special Education');
      expect(educator.createdAt, isNotNull);
    });
  });

  group('SpecialCondition', () {
    test('should have correct enum values', () {
      expect(SpecialCondition.values.length, 5);
      expect(SpecialCondition.values, contains(SpecialCondition.AUTISM));
      expect(SpecialCondition.values, contains(SpecialCondition.ADHD));
      expect(SpecialCondition.values, contains(SpecialCondition.DYSLEXIA));
      expect(SpecialCondition.values, contains(SpecialCondition.DYSCALCULIA));
      expect(SpecialCondition.values,
          contains(SpecialCondition.SPEAKING_DIFFICULTIES));
    });
  });
}
