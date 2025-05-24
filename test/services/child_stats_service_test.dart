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

      test('should use different cache keys for different categories',
          () async {
        // Arrange
        final mockStatsSummaryColors = StatsSummary(
          sessionsPlayed: 5,
          accuracy: 30,
          avgTime: 100,
          hintUsageRatio: 5,
        );
        final mockStatsSummaryNumbers = StatsSummary(
          sessionsPlayed: 8,
          accuracy: 20,
          avgTime: 150,
          hintUsageRatio: 15,
        );

        when(mockChildStatsRepository.getStats(
          childUuid: childUuid,
          category: 'colors',
          periodStart: null,
          periodEnd: null,
        )).thenAnswer((_) async => mockStatsSummaryColors);

        when(mockChildStatsRepository.getStats(
          childUuid: childUuid,
          category: 'numbers',
          periodStart: null,
          periodEnd: null,
        )).thenAnswer((_) async => mockStatsSummaryNumbers);

        // Act: Fetch for 'colors'
        final resultColors = await childStatsService.getStats(
            childUuid: childUuid, category: 'colors');
        // Act: Fetch for 'numbers'
        final resultNumbers = await childStatsService.getStats(
            childUuid: childUuid, category: 'numbers');

        // Assert
        expect(resultColors, mockStatsSummaryColors);
        expect(resultNumbers, mockStatsSummaryNumbers);
        verify(mockChildStatsRepository.getStats(
          childUuid: childUuid,
          category: 'colors',
          periodStart: null,
          periodEnd: null,
        )).called(1);
        verify(mockChildStatsRepository.getStats(
          childUuid: childUuid,
          category: 'numbers',
          periodStart: null,
          periodEnd: null,
        )).called(1);

        // Act again to check cache for 'colors'
        final cachedResultColors = await childStatsService.getStats(
            childUuid: childUuid, category: 'colors');
        expect(cachedResultColors, mockStatsSummaryColors);
        verifyNever(mockChildStatsRepository.getStats(
          childUuid: childUuid,
          category: 'colors',
          periodStart: anyNamed('periodStart'),
          periodEnd: anyNamed('periodEnd'),
        )); // Should not call again for colors

        // Act again to check cache for 'numbers'
        final cachedResultNumbers = await childStatsService.getStats(
            childUuid: childUuid, category: 'numbers');
        expect(cachedResultNumbers, mockStatsSummaryNumbers);
        verifyNever(mockChildStatsRepository.getStats(
          childUuid: childUuid,
          category: 'numbers',
          periodStart: anyNamed('periodStart'),
          periodEnd: anyNamed('periodEnd'),
        )); // Should not call again for numbers
      });

      test('should call repository with null date range for "all" filter',
          () async {
        // Arrange
        when(mockChildStatsRepository.getStats(
          childUuid: childUuid,
          category: 'animals',
          periodStart: null,
          periodEnd: null,
        )).thenAnswer((_) async => mockStatsSummary);

        // Act
        await childStatsService.getStats(
            childUuid: childUuid, category: 'animals', timeFilter: 'all');

        // Assert
        verify(mockChildStatsRepository.getStats(
          childUuid: childUuid,
          category: 'animals',
          periodStart: null,
          periodEnd: null,
        )).called(1);
      });

      test('should correctly use cache with category and timeFilter', () async {
        // Arrange
        final now = DateTime.now();
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final expectedStartDate =
            DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
        final expectedEndDate =
            DateTime(now.year, now.month, now.day, 23, 59, 59);

        when(mockChildStatsRepository.getStats(
          childUuid: childUuid,
          category: 'fruits',
          periodStart: expectedStartDate,
          periodEnd: expectedEndDate,
        )).thenAnswer((_) async => mockStatsSummary);

        // Act: First call to populate cache
        await childStatsService.getStats(
            childUuid: childUuid, category: 'fruits', timeFilter: 'week');

        // Assert: Verify repository was called
        verify(mockChildStatsRepository.getStats(
          childUuid: childUuid,
          category: 'fruits',
          periodStart: expectedStartDate,
          periodEnd: expectedEndDate,
        )).called(1);

        // Act: Second call with same parameters
        final cachedResult = await childStatsService.getStats(
            childUuid: childUuid, category: 'fruits', timeFilter: 'week');

        // Assert: Result is from cache, repository not called again
        expect(cachedResult, mockStatsSummary);
        verifyNever(mockChildStatsRepository.getStats(
          childUuid: childUuid,
          category: 'fruits',
          periodStart: expectedStartDate,
          periodEnd: expectedEndDate,
        ));
      });
    });
  });
}
