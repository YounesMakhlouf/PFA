import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/l10n/app_localizations.dart';
import 'package:pfa/screens/error_screen.dart';
import 'package:pfa/screens/generic_loading_screen.dart';

import '../models/category_option.dart';
import '../models/game.dart' as game;
import '../models/stats_summary.dart';
import '../providers/global_providers.dart';
import '../services/child_stats_service.dart';
import '../widgets/accuracy_bar_chart.dart';
import '../widgets/stats_container.dart';
import '../widgets/category_filter_dropdown.dart';
import '../widgets/time_filter_dropdown.dart';

class StatsScreen extends ConsumerStatefulWidget {
  final String childUuid;
  const StatsScreen({super.key, required this.childUuid});

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  late final ChildStatsService _statsService;

  // global
  StatsSummary? _stats;
  bool _loadingStats = true;
  String? _statsError;

  // chart
  Map<String, double>? _categoryAccuracies;
  bool _loadingChart = true;
  String? _chartError;

  // Time filter states
  String _timeFilter = 'all';
  String _selectedCategory = 'ALL';

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _loadInitialData();
  }

  void _initializeServices() {
    _statsService = ref.read(childStatsServiceProvider);
  }

  Future<void> _loadInitialData() async {
    await Future.wait([_loadStats(), _loadCategoryChartData()]);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.statsTitle),
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: RefreshIndicator(
        // Add pull-to-refresh
        onRefresh: _loadInitialData,
        color: theme.colorScheme.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildStatsSummarySection(context, theme, l10n),
              const SizedBox(height: 32),
              _buildCategoryChartSection(context, theme, l10n),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  //TODO: refactoring: move helper functions to viewModel
  Future<void> _loadStats() async {
    setState(() {
      _loadingStats = true;
      _statsError = null;
    });

    try {
      final stats = await _statsService.getStats(
        childUuid: widget.childUuid,
        timeFilter: _timeFilter,
        category: _selectedCategory,
      );
      if (_stats == null && !_loadingStats) {
        setState(
            () => _statsError = AppLocalizations.of(context)!.applicationError);
      }
      setState(() => _stats = stats);
    } catch (e) {
      setState(
          () => _statsError = AppLocalizations.of(context)!.applicationError);
    } finally {
      setState(() => _loadingStats = false);
    }
  }

  Future<void> _loadCategoryChartData() async {
    setState(() {
      _loadingChart = true;
      _chartError = null;
    });

    try {
      final Map<String, double> result = {};
      // Prime cache for all categories with 'all' time filter
      for (var category in game.GameCategory.values) {
        final stats = await _statsService.getStats(
          childUuid: widget.childUuid,
          category: category.name,
          timeFilter: 'all',
        );
        result[category.name] = stats?.accuracy ?? 0.0;
      }

      final sortedResult = Map.fromEntries(
          result.entries.toList()..sort((a, b) => b.value.compareTo(a.value)));

      setState(() => _categoryAccuracies = sortedResult);
    } catch (e) {
      setState(() => _chartError = AppLocalizations.of(context)!.statsError);
    } finally {
      setState(() => _loadingChart = false);
    }
  }

  Widget _buildStatsSummarySection(
      BuildContext context, ThemeData theme, AppLocalizations l10n) {
    if (_statsError != null) {
      return ErrorScreen(errorMessage: _statsError!);
    }

    final categoryOptions = [
      CategoryOption(value: 'ALL', label: l10n.all),
      ...game.GameCategory.values
          .where((c) => c != game.GameCategory.UNKNOWN)
          .map((category) => CategoryOption(
                value: category.name,
                label: category.localizedName(context),
              )),
    ];

    return Stack(
      children: [
        Opacity(
          opacity: _loadingStats ? 0.5 : 1.0,
          child: AbsorbPointer(
            absorbing: _loadingStats,
            child: Card(
              elevation: theme.cardTheme.elevation,
              shape: theme.cardTheme.shape,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: StatsContainer(
                  title: l10n.categoryStatsTitle,
                  headerTrailing: Row(
                    children: [
                      SizedBox(
                        width: 120,
                        child: TimeFilterDropdown(
                          value: _timeFilter,
                          onChanged: _handleTimeFilterChange,
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 120,
                        child: CategoryDropdown(
                          value: _selectedCategory,
                          categories: categoryOptions,
                          onChanged: _handleCategoryChange,
                        ),
                      ),
                    ],
                  ),
                  accuracy: _stats?.accuracy != null
                      ? '${_stats!.accuracy.toStringAsFixed(1)}%'
                      : '--%',
                  avgTime: _stats?.avgTime != null
                      ? _formatMilliseconds(_stats!.avgTime.toInt())
                      : '--:--',
                  hintsUsed: _stats?.hintUsageRatio != null
                      ? '${_stats!.hintUsageRatio.toStringAsFixed(1)}%'
                      : '-.-',
                ),
              ),
            ),
          ),
        ),
        if (_loadingStats)
          const Positioned.fill(
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  Widget _buildCategoryChartSection(
      BuildContext context, ThemeData theme, AppLocalizations l10n) {
    if (_chartError != null) return ErrorScreen(errorMessage: _chartError!);
    if (_loadingChart) {
      return const GenericLoadingScreen();
    }

    if (_categoryAccuracies == null || _categoryAccuracies!.isEmpty) {
      return Text(l10n.statsError);
    }

    return AccuracyBarChart(categoryAccuracies: _categoryAccuracies!);
  }

  String _formatMilliseconds(int ms) {
    final duration = Duration(milliseconds: ms);
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _handleTimeFilterChange(String? value) {
    if (value == null || value == _timeFilter) return;
    setState(() => _timeFilter = value);
    _loadStats();
  }

  void _handleCategoryChange(String? value) {
    if (value == null) return;
    setState(() => _selectedCategory = value);
    _loadStats();
  }
}
