import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pfa/repositories/child_repository.dart';
import 'package:pfa/services/child_service.dart';

import 'child_service_test.mocks.dart';

@GenerateMocks([ChildRepository])
void main() {
  late MockChildRepository mockChildRepository;
  late ChildService childService;

  setUp(() {
    mockChildRepository = MockChildRepository();
    childService = ChildService(childRepository: mockChildRepository);
  });

  group('ChildService Tests', () {
    const childId = 'test_child_id';
    const educatorEmail = 'educator@example.com';

    group('getEducators', () {
      test('should return a list of educator emails on success', () async {
        final expectedEducators = [
          'educator1@example.com',
          'educator2@example.com'
        ];
        when(mockChildRepository.getEducatorsForChild(childId))
            .thenAnswer((_) async => expectedEducators);

        final result = await childService.getEducators(childId: childId);

        expect(result, expectedEducators);
        verify(mockChildRepository.getEducatorsForChild(childId)).called(1);
      });

      test('should throw an exception if repository throws an exception',
          () async {
        when(mockChildRepository.getEducatorsForChild(childId))
            .thenThrow(Exception('Repository error'));

        expect(
          () => childService.getEducators(childId: childId),
          throwsA(isA<Exception>()),
        );
        verify(mockChildRepository.getEducatorsForChild(childId)).called(1);
      });
    });

    group('addEducator', () {
      test('should return success message on successful addition', () async {
        const successMessage = 'Educator added successfully';
        when(mockChildRepository.addEducatorByEmail(childId, educatorEmail))
            .thenAnswer((_) async => successMessage);

        final result = await childService.addEducator(
            childId: childId, educatorEmail: educatorEmail);

        expect(result, successMessage);
        verify(mockChildRepository.addEducatorByEmail(childId, educatorEmail))
            .called(1);
      });

      test('should throw an exception if repository throws an exception',
          () async {
        when(mockChildRepository.addEducatorByEmail(childId, educatorEmail))
            .thenThrow(Exception('Repository error'));

        expect(
          () => childService.addEducator(
              childId: childId, educatorEmail: educatorEmail),
          throwsA(isA<Exception>()),
        );
        verify(mockChildRepository.addEducatorByEmail(childId, educatorEmail))
            .called(1);
      });
    });

    group('removeEducator', () {
      test('should return success message on successful removal', () async {
        const successMessage = 'Educator removed successfully';
        when(mockChildRepository.removeEducatorByEmail(childId, educatorEmail))
            .thenAnswer((_) async => successMessage);

        final result = await childService.removeEducator(
            childId: childId, educatorEmail: educatorEmail);

        expect(result, successMessage);
        verify(mockChildRepository.removeEducatorByEmail(
                childId, educatorEmail))
            .called(1);
      });

      test('should throw an exception if repository throws an exception',
          () async {
        when(mockChildRepository.removeEducatorByEmail(childId, educatorEmail))
            .thenThrow(Exception('Repository error'));

        expect(
          () => childService.removeEducator(
              childId: childId, educatorEmail: educatorEmail),
          throwsA(isA<Exception>()),
        );
        verify(mockChildRepository.removeEducatorByEmail(
                childId, educatorEmail))
            .called(1);
      });
    });
  });
}
