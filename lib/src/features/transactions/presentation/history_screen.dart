import 'package:finance_ai_app/src/constants/colors.dart';
import 'package:finance_ai_app/src/features/transactions/application/history_controller.dart';
import 'package:finance_ai_app/src/features/transactions/domain/category_item.dart';
import 'package:finance_ai_app/src/features/transactions/domain/history_summary.dart';
import 'package:finance_ai_app/src/features/transactions/domain/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  List<DateTime> _availableMonths = [];
  bool _isInitialLoading = true;
  final ScrollController _monthTabController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadMonths();
  }

  @override
  void dispose() {
    _monthTabController.dispose();
    super.dispose();
  }

  Future<void> _loadMonths() async {
    final months = await ref
        .read(historyControllerProvider.notifier)
        .getAvailableMonths();

    if (mounted) {
      setState(() {
        _availableMonths = months;
        if (_availableMonths.isNotEmpty) {
          _selectedMonth = _availableMonths.last;
        }
        _isInitialLoading = false;
      });

      // Scroll to the end (most recent month) after build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_monthTabController.hasClients) {
          _monthTabController.jumpTo(
            _monthTabController.position.maxScrollExtent,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final summaryAsync = ref.watch(historySummaryProvider(_selectedMonth));
    final groupedAsync = ref.watch(groupedTransactionsProvider(_selectedMonth));

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: _isInitialLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    const Row(
                      children: [
                        Text(
                          'History',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildMonthTabs(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Column(
                          children: [
                            summaryAsync.when(
                              data: (summary) => _buildSummaryCard(summary),
                              loading: () => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              error: (e, _) => Center(child: Text('Error: $e')),
                            ),

                            const SizedBox(height: 24),

                            groupedAsync.when(
                              data: (groupedDocs) =>
                                  _buildGroupedList(groupedDocs),
                              loading: () => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              error: (e, _) => Center(child: Text('Error: $e')),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildMonthTabs() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        controller: _monthTabController,
        scrollDirection: Axis.horizontal,
        itemCount: _availableMonths.length,
        itemBuilder: (context, index) {
          final month = _availableMonths[index];
          final isSelected =
              month.month == _selectedMonth.month &&
              month.year == _selectedMonth.year;
          String label = DateFormat('MM/yyyy').format(month);

          if (month.month == DateTime.now().month &&
              month.year == DateTime.now().year) {
            label = 'This Month';
          } else if (month.month == DateTime.now().month - 1 &&
              month.year == DateTime.now().year) {
            label = 'Last Month';
          }

          return GestureDetector(
            onTap: () => setState(() {
              _selectedMonth = month;
            }),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(30),
                border: isSelected
                    ? null
                    : Border.all(color: Colors.grey.shade200),
              ),
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.textOnPrimary
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(HistorySummary summary) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem(
            'INFLOW',
            formatter.format(summary.totalInflow),
            AppColors.income,
          ),
          _buildSummaryItem(
            'OUTFLOW',
            formatter.format(summary.totalOutflow),
            AppColors.expense,
          ),
          _buildSummaryItem(
            'NET TOTAL',
            formatter.format(summary.netTotal),
            AppColors.textPrimary,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildGroupedList(Map<String, List<TransactionModel>> groupedDocs) {
    if (groupedDocs.isEmpty) {
      return const Center(child: Text('No transactions found'));
    }

    final sortedKeys = groupedDocs.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sortedKeys.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final dateKey = sortedKeys[index];
        final transactions = groupedDocs[dateKey]!;
        final date = DateTime.parse(dateKey);

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Text(
                  '${date.day}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  DateFormat('MMM').format(date).toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                children: [
                  ...transactions.map((tx) => _buildTransactionItem(tx)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTransactionItem(TransactionModel tx) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    final isIncome = tx.type == TransactionType.income;
    final category = kCategories.firstWhere((c) => c.name == tx.category);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: category.color,
            child: Icon(category.icon, color: AppColors.surface),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.description.isEmpty ? tx.category : tx.description,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 2),

                Text(
                  DateFormat('dd MMM yyyy').format(tx.date),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          Text(
            "${isIncome ? '+' : '-'}${formatter.format(tx.amount)}",
            style: TextStyle(
              color: isIncome ? AppColors.income : AppColors.expense,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
