import 'package:pfa/models/global_stats_summary.dart';
import 'package:pfa/models/category_stats_summary.dart';
import 'package:pfa/services/supabase_service.dart';
import 'package:pfa/services/logging_service.dart';

class ChildStatsRepository {
  final SupabaseService _supabaseService;
  final LoggingService _logger;

  ChildStatsRepository({
    required SupabaseService supabaseService,
    required LoggingService logger,
  })  : _supabaseService = supabaseService,
        _logger = logger;

  Future<GlobalStatsSummary?> getGlobalStats({
    required String childUuid,
    DateTime? periodStart,
    DateTime? periodEnd,
  }) async {
    try {
      final response = await _supabaseService.client.rpc(
        'get_child_stats',
        params: {
          'child_uuid': childUuid,
          'period_start': periodStart?.toIso8601String(),
          'period_end': periodEnd?.toIso8601String(),
        },
      );

      if (response == null || response is! List || response.isEmpty) {
        _logger.error("Supabase returned empty or invalid data", null);
        return null;
      }

      return GlobalStatsSummary.fromJson(response.first);
    } catch (e, stackTrace) {
      _logger.error('Failed to get range stats', e, stackTrace);
      return null;
    }
  }

  /// Category-specific stats
  Future<CategoryStatsSummary?> getCategoryStats({
    required String childUuid,
    required String category,
    DateTime? periodStart,
    DateTime? periodEnd,
  }) async {
    try {
      final response = await _supabaseService.client.rpc(
        'get_category_stats',
        params: {
          'child_uuid': childUuid,
          'selected_category': category,
          'period_start': periodStart?.toIso8601String(),
          'period_end': periodEnd?.toIso8601String(),
        },
      );

      if (response == null || response is! List || response.isEmpty) {
        _logger.error("Supabase returned empty or invalid data", null);
        return null;
      }

      return CategoryStatsSummary.fromJson(response.first);
    } catch (e, stackTrace) {
      _logger.error('Failed to get category stats', e, stackTrace);
      return null;
    }
  }
}
