import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pfa/l10n/app_localizations.dart';

import '../models/CategoryOption.dart';
import '../models/category_stats_summary.dart';
import '../models/global_stats_summary.dart';
import '../repositories/child_stats_repository.dart';
import '../services/child_stats_service.dart';
import '../services/logging_service.dart';
import '../services/supabase_service.dart';
import '../ui/accuracy_bar_chart.dart';
import '../ui/big_stat_box.dart';
import '../ui/category_filter_dropdown.dart';
import '../ui/time_filter_dropdown.dart';
import '../constants/const.dart' as constants;

class StatsScreen extends StatefulWidget {
  final String childUuid;
  const StatsScreen({super.key, required this.childUuid});
  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  late final ChildStatsService _statsService;
  // global
  GlobalStatsSummary? _globalStats;
  bool _loadingGlobal = true;
  String? _globalError;
  // category
  CategoryStatsSummary? _categoryStats;
  bool _loadingCategory = true;
  String? _categoryError;
  // chart
  Map<String, double>? _categoryAccuracies;
  bool _loadingChart = true;
  String? _chartError;
  // Time filter states
  String _globalTimeFilter = 'all';
  String _categoryTimeFilter = 'week';
  String _selectedCategory = 'NUMBERS';

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _loadInitialData();
    //set to portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void _initializeServices() {
    _statsService = ChildStatsService(
      statsRepository: ChildStatsRepository(
        supabaseService: SupabaseService(),
        logger: LoggingService(),
      ),
    );
  }

  Future<void>  _loadInitialData() async {
    await Future.wait([_loadGlobalStats(), _loadCategoryStats(),_loadCategoryChartData()]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stats')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildGlobalStatsSection(),
            const SizedBox(height: 24),
            _buildCategoryStatsSection(context),
            const SizedBox(height: 24),
            _buildCategoryChartSection()

          ],
        ),
      ),
    );
  }

  //TODO: refactoring: move helper functions to viewModel
  Future<void> _loadGlobalStats() async {
    setState(() {
      _loadingGlobal = true;
      _globalError = null;
    });

    try {
      final stats = await _statsService.getGlobalStats(
        childUuid: widget.childUuid,
        timeFilter: _globalTimeFilter,
      );

      setState(() => _globalStats = stats);
    } catch (e) {
      setState(() => _globalError = 'Failed to load global stats');
    } finally {
      setState(() => _loadingGlobal = false);
    }
  }

  Future<void> _loadCategoryStats() async {
    setState(() {
      _loadingCategory = true;
      _categoryError = null;
    });

    try {
      final stats = await _statsService.getCategoryStats(
        childUuid: widget.childUuid,
        category: _selectedCategory,
        timeFilter: _categoryTimeFilter,
      );

      setState(() => _categoryStats = stats);
    } catch (e) {
      setState(() => _categoryError = 'Failed to load category stats');
    } finally {
      setState(() => _loadingCategory = false);
    }
  }
  Future<void> _loadCategoryChartData() async {
    setState(() {
      _loadingChart = true;
      _chartError = null;
    });

    try {
      final Map<String, double> result = {};

      for (final category in constants.game_categories) {
        final stats = await _statsService.getCategoryStats(
          childUuid: widget.childUuid,
          category: category,
          timeFilter: 'all',
        );
        result[category] = stats?.accuracy ?? 0.0;
      }
      setState(() => _categoryAccuracies = result);
    } catch (e) {
      setState(() => _chartError = 'Failed to load chart data');
    } finally {
      setState(() => _loadingChart = false);
    }
  }
  Widget _buildGlobalStatsSection() {
    if (_globalError != null) return _buildError(_globalError!);
    if (_globalStats == null && !_loadingGlobal) {
      return _buildError('No global stats available');
    }
    return Stack(
      children: [
        Opacity(
          opacity: _loadingGlobal ? 0.5 : 1.0,
          child: AbsorbPointer(
            absorbing: _loadingGlobal,
            child: StatsContainer(
              title: AppLocalizations.of(context).globalStatsTitle,
              headerTrailing: TimeFilterDropdown(
                value: _globalTimeFilter,
                onChanged: _handleGlobalTimeFilterChange,
              ),
              accuracy: _globalStats?.accuracy != null
                  ? '${_globalStats!.accuracy.toStringAsFixed(1)}%'
                  : '--%',
              avgTime: _globalStats?.avgTime != null
                  ? _formatMilliseconds(_globalStats!.avgTime.toInt())
                  : '--:--',
              hintsUsed: _globalStats?.hintUsageRatio != null
                  ? '${_globalStats!.hintUsageRatio.toStringAsFixed(1)}%'
                  : '--%',
            ),
          ),
        ),
        if (_loadingGlobal)
          const Positioned.fill(
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  Widget _buildCategoryStatsSection(BuildContext context) {
    if (_categoryError != null) return _buildError(_categoryError!);
    if (_categoryStats == null && !_loadingCategory) {
      return _buildError('No category stats available');
    }
    final categoryOptions = [
      CategoryOption(value: 'NUMBERS', label: AppLocalizations.of(context).numbers),
      CategoryOption(value: 'COLORS_SHAPES', label: AppLocalizations.of(context).colorsAndShapes),
      CategoryOption(value: 'EMOTIONS', label: AppLocalizations.of(context).emotions),
      CategoryOption(value: 'LOGICAL_THINKING', label: AppLocalizations.of(context).logicalThinking),
      CategoryOption(value: 'ANIMALS', label: AppLocalizations.of(context).animals),
      CategoryOption(value: 'FRUITS_VEGETABLES', label: AppLocalizations.of(context).fruitsAndVegetables),
    ];

    return Stack(
      children: [
        Opacity(
          opacity: _loadingCategory ? 0.5 : 1.0,
          child: AbsorbPointer(
            absorbing: _loadingCategory,
            child: StatsContainer(
              title: AppLocalizations.of(context).categoryStatsTitle,
              headerTrailing: Row(
                children: [
                  TimeFilterDropdown(
                    value: _categoryTimeFilter,
                    onChanged: _handleCategoryTimeFilterChange,
                  ),
                  const SizedBox(width: 16),
                  CategoryDropdown(
                    value: _selectedCategory,
                    categories: categoryOptions,
                    onChanged: _handleCategoryChange,
                  ),
                ],
              ),
              accuracy: _categoryStats?.accuracy != null
                  ? '${_categoryStats!.accuracy.toStringAsFixed(1)}%'
                  : '--%',
              avgTime: _categoryStats?.avgTime != null
                  ? _formatMilliseconds(_categoryStats!.avgTime.toInt())
                  : '--:--',
              hintsUsed: _categoryStats?.hintUsageRatio != null
                  ? '${_categoryStats!.hintUsageRatio.toStringAsFixed(1)}%'
                  : '-.-',
            ),
          ),
        ),
        if (_loadingCategory)
          const Positioned.fill(
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
  Widget _buildCategoryChartSection() {
    if (_chartError != null) return _buildError(_chartError!);
    if (_loadingChart) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_categoryAccuracies == null || _categoryAccuracies!.isEmpty) {
      return const Text('No chart data available');
    }

    return AccuracyBarChart(
        categoryAccuracies: _categoryAccuracies!,
        context: context,
    );
  }

  Widget _buildError(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        message,
        style: TextStyle(color: Colors.red.shade700),
        textAlign: TextAlign.center,
      ),
    );
  }

  String _formatMilliseconds(int ms) {
    final duration = Duration(milliseconds: ms);
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _handleGlobalTimeFilterChange(String? value) {
    if (value == null || value == _globalTimeFilter) return;
    setState(() => _globalTimeFilter = value);
    _loadGlobalStats();
  }

  void _handleCategoryTimeFilterChange(String? value) {
    if (value == null || value == _categoryTimeFilter) return;
    setState(() => _categoryTimeFilter = value);
    _loadCategoryStats();
  }

  void _handleCategoryChange(String? value) {
    if (value == null || value == _selectedCategory) return;
    setState(() => _selectedCategory = value);
    _loadCategoryStats();
  }


}