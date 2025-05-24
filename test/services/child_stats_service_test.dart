import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pfa/models/stats_summary.dart';
import 'package:pfa/repositories/child_stats_repository.dart';
import 'package:pfa/services/child_stats_service.dart';

import 'child_stats_service_test.mocks.dart';

@GenerateMocks([ChildStatsRepository])
void main() {
  late ChildStatsService childStatsService;
  late MockChildStatsRepository mockChildStatsRepository;

  setUp(() {
    mockChildStatsRepository = MockChildStatsRepository();
    childStatsService =
        ChildStatsService(statsRepository: mockChildStatsRepository);
  });

  group('ChildStatsService Tests', () {
    const childUuid = 'test-child-uuid';
    final mockStatsSummary = StatsSummary(
      sessionsPlayed: 3,
      accuracy: 25,
      avgTime: 120,
      hintUsageRatio: 10,
    );

    group('getStats', () {
      test(
          'should return stats from repository and cache them when not in cache',
          () async {
        // Arrange
        when(mockChildStatsRepository.getStats(
          childUuid: childUuid,
          category: null,
          periodStart: null,
          periodEnd: null,
        )).thenAnswer((_) async => mockStatsSummary);

        // Act
        final result = await childStatsService.getStats(childUuid: childUuid);

        // Assert
        expect(result, mockStatsSummary);
        verify(mockChildStatsRepository.getStats(
          childUuid: childUuid,
          category: null,
          periodStart: null,
          periodEnd: null,
        )).called(1);

        // Act again to check cache
        final cachedResult =
            await childStatsService.getStats(childUuid: childUuid);
        expect(cachedResult, mockStatsSummary);
        // Verify repository was not called again
        verifyNever(mockChildStatsRepository.getStats(
          childUuid: childUuid,
          category: anyNamed('category'),
          periodStart: anyNamed('periodStart'),
          periodEnd: anyNamed('periodEnd'),
        ));
      });

      test('should return cached stats when available', () async {
        // Arrange: First call to populate cache
        when(mockChildStatsRepository.getStats(
          childUuid: childUuid,
          category: 'colors',
          periodStart: null,
          periodEnd: null,
        )).thenAnswer((_) async => mockStatsSummary);
        await childStatsService.getStats(
            childUuid: childUuid, category: 'colors');

        // Act: Second call
        final result = await childStatsService.getStats(
            childUuid: childUuid, category: 'colors');

        // Assert
        expect(result, mockStatsSummary);
        // Verify repository was only called once (during the first call)
        verify(mockChildStatsRepository.getStats(
          childUuid: childUuid,
          category: 'colors',
          periodStart: null,
          periodEnd: null,
        )).called(1);
      });

      test('should call repository with correct date range for "week" filter',
          () async {
        // Arrange
        final now = DateTime.now();
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final expectedStartDate =
            DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
        final expectedEndDate =
            DateTime(now.year, now.month, now.day, 23, 59, 59);

        when(mockChildStatsRepository.getStats(
          childUuid: childUuid,
          category: null,
          periodStart: expectedStartDate,
          periodEnd: expectedEndDate,
        )).thenAnswer((_) async => mockStatsSummary);

        // Act
        await childStatsService.getStats(
            childUuid: childUuid, timeFilter: 'week');

        // Assert
        verify(mockChildStatsRepository.getStats(
          childUuid: childUuid,
          category: null,
          periodStart: expectedStartDate,
          periodEnd: expectedEndDate,
        )).called(1);
      });

      test('should return null if repository returns null', () async {
        // Arrange
        when(mockChildStatsRepository.getStats(
          childUuid: childUuid,
          category: null,
          periodStart: null,
          periodEnd: null,
        )).thenAnswer((_) async => null);

        // Act
        final result = await childStatsService.getStats(childUuid: childUuid);

        // Assert
        expect(result, isNull);
      });
    });
  });
}
