import 'package:intl/intl.dart';
import 'package:pfa/models/global_stats_summary.dart';
import 'package:pfa/models/category_stats_summary.dart';
import 'package:pfa/repositories/child_stats_repository.dart';

class ChildStatsService {
  final ChildStatsRepository _statsRepository;

  ChildStatsService({required ChildStatsRepository statsRepository})
      : _statsRepository = statsRepository;

  /// Unified global stats with time filter
  Future<GlobalStatsSummary?> getGlobalStats({
    required String childUuid,
    required String timeFilter,
  }) async {
    final range = _getDateRange(timeFilter);
    return _statsRepository.getGlobalStats(
      childUuid: childUuid,
      periodStart: range?['start'],
      periodEnd: range?['end'],
    );
  }

  /// Unified category stats with time filter
  Future<CategoryStatsSummary?> getCategoryStats({
    required String childUuid,
    required String category,
    required String timeFilter,
  }) async {
    final range = _getDateRange(timeFilter);
    return _statsRepository.getCategoryStats(
      childUuid: childUuid,
      category: category,
      periodStart: range?['start'],
      periodEnd: range?['end'],
    );
  }

  Map<String, DateTime>? _getDateRange(String timeFilter) {
    final now = DateTime.now();
    switch (timeFilter.toLowerCase()) {
      case 'week':
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        return {
          'start': DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day),
          'end': DateTime(now.year, now.month, now.day, 23, 59, 59),
        };
      case 'all':
      default:
        return null;
    }
  }
}

