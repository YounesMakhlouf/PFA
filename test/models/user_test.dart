import 'package:flutter_test/flutter_test.dart';
import 'package:pfa/models/user.dart';
import 'package:uuid/uuid.dart';

void main() {
  const uuid = Uuid();

  group('Child Model', () {
    final testChildId = uuid.v4();
    final testAccountId = uuid.v4(); // Parent's account ID
    final testBirthdate = DateTime(2018, 5, 15);
    final testCreationTime = DateTime(2024, 1, 1, 10, 0, 0);
    final testUpdateTime = DateTime(2024, 1, 10, 11, 0, 0);

    test('should create a Child with all required fields and some optional',
        () {
      final birthdate = DateTime(2018, 5, 15);
      final conditions = {
        SpecialCondition.AUTISM,
        SpecialCondition.SPEAKING_DIFFICULTIES
      };

      final child = Child(
        childId: testChildId,
        accountId: testAccountId,
        firstName: 'Liam',
        lastName: 'Smith',
        birthdate: birthdate,
        avatarUrl: 'assets/avatars/avatar1.png',
        specialConditions: conditions,
        createdAt: testCreationTime,
        updatedAt: testUpdateTime,
      );

      expect(child.childId, testChildId);
      expect(child.accountId, testAccountId);
      expect(child.firstName, 'Liam');
      expect(child.lastName, 'Smith');
      expect(child.birthdate, birthdate);
      expect(child.avatarUrl, 'assets/avatars/avatar1.png');
      expect(child.specialConditions, conditions);
      expect(child.createdAt, testCreationTime);
      expect(child.updatedAt, testUpdateTime);
    });

    test('should create a Child with only required fields', () {
      final child = Child(
        childId: testChildId,
        accountId: testAccountId,
        firstName: 'Sara',
        birthdate: DateTime(2018, 5, 15),
        // lastName is nullable
        // avatarUrl is nullable
        specialConditions: {}, // Required, but can be empty Set
        createdAt: testCreationTime,
        updatedAt: testUpdateTime,
      );

      expect(child.childId, testChildId);
      expect(child.accountId, testAccountId);
      expect(child.firstName, 'Sara');
      expect(child.lastName, isNull);
      expect(child.birthdate, DateTime(2018, 5, 15));
      expect(child.avatarUrl, isNull);
      expect(child.specialConditions, isEmpty);
      expect(child.createdAt, testCreationTime);
      expect(child.updatedAt, testUpdateTime);
    });

    test('should calculate age correctly', () {
      // Child born almost 8 years ago (birthday tomorrow)
      final birthdateAlmost8 = DateTime(DateTime.now().year - 8,
          DateTime.now().month, DateTime.now().day + 1);
      final childAlmost8 = Child(
          childId: uuid.v4(),
          accountId: uuid.v4(),
          firstName: 'Test',
          birthdate: birthdateAlmost8,
          specialConditions: {},
          createdAt: DateTime.now(),
          updatedAt: DateTime.now());
      expect(childAlmost8.age, 7);

      // Child born exactly 8 years ago (birthday today)
      final birthdateToday8 = DateTime(
          DateTime.now().year - 8, DateTime.now().month, DateTime.now().day);
      final childToday8 = Child(
          childId: uuid.v4(),
          accountId: uuid.v4(),
          firstName: 'Test',
          birthdate: birthdateToday8,
          specialConditions: {},
          createdAt: DateTime.now(),
          updatedAt: DateTime.now());
      expect(childToday8.age, 8);

      // Child born just over 8 years ago (birthday yesterday)
      final birthdateYesterday8 = DateTime(DateTime.now().year - 8,
          DateTime.now().month, DateTime.now().day - 1);
      final childYesterday8 = Child(
          childId: uuid.v4(),
          accountId: uuid.v4(),
          firstName: 'Test',
          birthdate: birthdateYesterday8,
          specialConditions: {},
          createdAt: DateTime.now(),
          updatedAt: DateTime.now());
      expect(childYesterday8.age, 8);

      // Test edge case: birthdate in the future
      final futureBirthdate = DateTime.now().add(const Duration(days: 365));
      final futureChild = Child(
          childId: uuid.v4(),
          accountId: uuid.v4(),
          firstName: 'Future',
          birthdate: futureBirthdate,
          specialConditions: {},
          createdAt: DateTime.now(),
          updatedAt: DateTime.now());
      expect(futureChild.age, 0);
    });

    test('should return full name correctly', () {
      final childBothNames = Child(
          childId: uuid.v4(),
          accountId: uuid.v4(),
          birthdate: DateTime(2018, 5, 15),
          firstName: 'Ahmed',
          lastName: 'Ali',
          specialConditions: {},
          createdAt: DateTime.now(),
          updatedAt: DateTime.now());
      expect(childBothNames.fullName, 'Ahmed Ali');

      // Test with only first name (last name null)
      final childFirstNameOnly = Child(
          childId: uuid.v4(),
          accountId: uuid.v4(),
          birthdate: DateTime(2018, 5, 15),
          firstName: 'Samia',
          lastName: null,
          specialConditions: {},
          createdAt: DateTime.now(),
          updatedAt: DateTime.now());
      expect(childFirstNameOnly.fullName, 'Samia');

      // Test with only first name (last name empty string)
      final childFirstNameEmptyLast = Child(
          childId: uuid.v4(),
          accountId: uuid.v4(),
          birthdate: DateTime(2018, 5, 15),
          firstName: 'Samia',
          lastName: '',
          specialConditions: {},
          createdAt: DateTime.now(),
          updatedAt: DateTime.now());
      expect(childFirstNameEmptyLast.fullName, 'Samia');

      // Test with empty first name (should ideally not happen due to validation)
      final childEmptyFirst = Child(
          childId: uuid.v4(),
          accountId: uuid.v4(),
          birthdate: DateTime(2018, 5, 15),
          firstName: '',
          lastName: 'Ben Salah',
          specialConditions: {},
          createdAt: DateTime.now(),
          updatedAt: DateTime.now());
      expect(childEmptyFirst.fullName, ' Ben Salah'); // Note the leading space
    });

    test('Child.fromJson parses correctly with all fields', () {
      final jsonData = {
        'child_id': testChildId,
        'account_id': testAccountId,
        'first_name': 'Liam',
        'last_name': 'Smith',
        'birthdate': '2018-05-15',
        'avatar_url': '/avatars/liam.png',
        'special_conditions': ['AUTISM', 'ADHD'],
        'created_at': testCreationTime.toIso8601String(),
        'updated_at': testUpdateTime.toIso8601String(),
      };

      final child = Child.fromJson(jsonData);

      expect(child.childId, testChildId);
      expect(child.accountId, testAccountId);
      expect(child.firstName, 'Liam');
      expect(child.lastName, 'Smith');
      expect(child.birthdate, DateTime(2018, 5, 15));
      expect(child.avatarUrl, '/avatars/liam.png');
      expect(child.specialConditions,
          {SpecialCondition.AUTISM, SpecialCondition.ADHD});
      expect(
          child.createdAt.isAtSameMomentAs(testCreationTime.toLocal()), isTrue);
      expect(
          child.updatedAt.isAtSameMomentAs(testUpdateTime.toLocal()), isTrue);
    });

    test('Child.fromJson parses correctly with null/missing optional fields',
        () {
      final jsonData = {
        'child_id': testChildId,
        'account_id': testAccountId,
        'first_name': 'Sara',
        'last_name': null, // Explicit null
        'birthdate': testBirthdate.toIso8601String(),
        // 'avatar_url': null,// Missing field
        'special_conditions': [], // Empty array
        'created_at': testCreationTime.toIso8601String(),
        'updated_at': testUpdateTime.toIso8601String(),
      };

      final child = Child.fromJson(jsonData);

      expect(child.lastName, isNull);
      expect(child.birthdate, DateTime(2018, 5, 15));
      expect(child.avatarUrl, isNull);
      expect(child.specialConditions, isEmpty);
    });

    test('Child.fromJson handles invalid condition strings gracefully', () {
      final jsonData = {
        'child_id': testChildId,
        'account_id': testAccountId,
        'first_name': 'Test',
        'special_conditions': [
          'AUTISM',
          'INVALID_CONDITION',
          null,
          'ADHD'
        ], // Mix valid, invalid, null
        'birthdate': testBirthdate.toIso8601String(),
        'created_at': testCreationTime.toIso8601String(),
        'updated_at': testUpdateTime.toIso8601String(),
      };

      final child = Child.fromJson(jsonData);

      // Should only contain the valid, non-null conditions
      expect(child.specialConditions,
          {SpecialCondition.AUTISM, SpecialCondition.ADHD});
    });

    test('toJsonForDatabase produces correct map', () {
      final birthdate = DateTime(2018, 5, 15);
      final conditions = {
        SpecialCondition.AUTISM,
        SpecialCondition.SPEAKING_DIFFICULTIES
      };

      final child = Child(
        childId: testChildId,
        accountId: testAccountId,
        firstName: 'Liam',
        lastName: 'Smith',
        birthdate: birthdate,
        avatarUrl: 'avatars/liam.png',
        specialConditions: conditions,
        createdAt: testCreationTime,
        updatedAt: testUpdateTime,
      );

      final jsonMap = child.toJson();

      expect(jsonMap['account_id'], testAccountId);
      expect(jsonMap['first_name'], 'Liam');
      expect(jsonMap['last_name'], 'Smith');
      expect(jsonMap['birthdate'], '2018-05-15'); // Check format
      expect(jsonMap['avatar_url'], 'avatars/liam.png');
      expect(jsonMap['special_conditions'],
          containsAll(['AUTISM', 'SPEAKING_DIFFICULTIES']));
      expect(jsonMap['special_conditions'], hasLength(2));

      // Ensure fields generated by DB are not included
      expect(jsonMap.containsKey('child_id'), isFalse);
      expect(jsonMap.containsKey('created_at'), isFalse);
      expect(jsonMap.containsKey('updated_at'), isFalse);
    });
  });

  group('SpecialCondition Enum', () {
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
