import 'package:finance_ai_app/src/features/auth/data/auth_repository.dart';
import 'package:finance_ai_app/src/features/transactions/data/transaction_repository.dart';
import 'package:finance_ai_app/src/features/transactions/domain/history_summary.dart';
import 'package:finance_ai_app/src/features/transactions/domain/transaction_model.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'history_controller.g.dart';

@riverpod
Stream<List<TransactionModel>> allTransactions(Ref ref) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user == null) return Stream.value([]);

  return ref.watch(transactionRepositoryProvider).watchTransactions(user.uid);
}

@riverpod
AsyncValue<Map<String, List<TransactionModel>>> groupedTransactions(
  Ref ref,
  DateTime selectedMonth,
) {
  final transactionsAsync = ref.watch(allTransactionsProvider);

  return transactionsAsync.whenData((transactions) {
    final filtered = transactions.where(
      (tx) =>
          tx.date.month == selectedMonth.month &&
          tx.date.year == selectedMonth.year,
    );

    Map<String, List<TransactionModel>> grouped = {};
    for (var tx in filtered) {
      final dateKey = DateFormat('yyyy-MM-dd').format(tx.date);
      if (grouped[dateKey] == null) grouped[dateKey] = [];
      grouped[dateKey]!.add(tx);
    }
    return grouped;
  });
}

@riverpod
AsyncValue<HistorySummary> historySummary(Ref ref, DateTime selectedMonth) {
  final transactionsAsync = ref.watch(allTransactionsProvider);

  return transactionsAsync.whenData((transactions) {
    double inflow = 0;
    double outflow = 0;

    for (var tx in transactions) {
      if (tx.date.month == selectedMonth.month &&
          tx.date.year == selectedMonth.year) {
        if (tx.type == TransactionType.income) {
          inflow += tx.amount;
        } else {
          outflow += tx.amount;
        }
      }
    }

    return HistorySummary(
      totalInflow: inflow,
      totalOutflow: outflow,
      netTotal: inflow - outflow,
    );
  });
}

@riverpod
class HistoryController extends _$HistoryController {
  @override
  FutureOr<void> build() {}

  Future<List<DateTime>> getAvailableMonths() async {
    final user = ref.read(authStateChangesProvider).value;
    if (user == null) return [DateTime.now()];

    final oldestDate = await ref
        .read(transactionRepositoryProvider)
        .getOldestTransactionDate(user.uid);

    if (oldestDate == null)
      return [DateTime(DateTime.now().year, DateTime.now().month)];

    List<DateTime> months = [];
    DateTime currentDate = DateTime(DateTime.now().year, DateTime.now().month);
    DateTime iterator = DateTime(oldestDate.year, oldestDate.month);

    while (iterator.isBefore(currentDate) ||
        iterator.isAtSameMomentAs(currentDate)) {
      months.add(iterator);
      iterator = DateTime(iterator.year, iterator.month + 1);
    }

    return months;
  }
}
