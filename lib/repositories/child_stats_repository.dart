import 'package:pfa/models/stats_summary.dart';
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

  Future<StatsSummary?> getStats({
    required String childUuid,
    String? category,
    DateTime? periodStart,
    DateTime? periodEnd,
  }) async {
    try {
      final isGlobalStats = (category == "ALL");
      final rpcFunctionName = isGlobalStats ? 'get_global_child_stats' : 'get_child_stats';
      final params = {
        'child_uuid': childUuid,
        'period_start': periodStart?.toIso8601String(),
        'period_end': periodEnd?.toIso8601String(),
        if (!isGlobalStats) 'selected_category': category,
      };

      final response = await _supabaseService.client.rpc(
        rpcFunctionName,
        params: params,
      );
      print(params);
      print(response);

      if (response == null || response is! List || response.isEmpty) {
        _logger.error("Supabase returned empty or invalid data", null);
        return null;
      }

      return StatsSummary.fromJson(response.first);
    } catch (e, stackTrace) {
      _logger.error('Failed to get range stats', e, stackTrace);
      return null;
    }
  }
}
