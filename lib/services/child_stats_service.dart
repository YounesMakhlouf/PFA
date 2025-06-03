import 'package:pfa/models/stats_summary.dart';
import 'package:pfa/repositories/child_stats_repository.dart';

class ChildStatsService {
  final ChildStatsRepository _statsRepository;
  final Map<String, StatsSummary> _statsCache = {};

  ChildStatsService({required ChildStatsRepository statsRepository})
      : _statsRepository = statsRepository;

  Future<StatsSummary?> getStats({
    required String childUuid,
    String? category,
    String timeFilter = 'all',
  }) async {
    final cacheKey = _generateCacheKey(category, timeFilter);

    // Return cached value if available
    if (_statsCache.containsKey(cacheKey)) {
      return _statsCache[cacheKey];
    }
    // Fetch fresh data
    final range = _getDateRange(timeFilter);
    final stats = await _statsRepository.getStats(
      childUuid: childUuid,
      category: category,
      periodStart: range?['start'],
      periodEnd: range?['end'],
    );

    if (stats != null) {
      _statsCache[cacheKey] = stats;
    }
    return stats;
  }

  Map<String, DateTime>? _getDateRange(String timeFilter) {
    final now = DateTime.now();
    switch (timeFilter.toLowerCase()) {
      case 'week':
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        return {
          'start':
              DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day),
          'end': DateTime(now.year, now.month, now.day, 23, 59, 59),
        };
      case 'all':
      default:
        return null;
    }
  }

  String _generateCacheKey(String? category, String timeFilter) {
    return '${category ?? "ALL"}|$timeFilter';
  }
}
