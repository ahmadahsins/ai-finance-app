import 'package:finance_ai_app/src/features/auth/data/auth_repository.dart';
import 'package:finance_ai_app/src/features/dashboard/domain/transaction_summary.dart';
import 'package:finance_ai_app/src/features/transactions/data/transaction_repository.dart';
import 'package:finance_ai_app/src/features/transactions/domain/transaction_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dashboard_controller.g.dart';

@riverpod
Stream<List<TransactionModel>> dashboardTransactions(Ref ref) {
  final user = ref.read(authStateChangesProvider).value;
  if (user == null) return Stream.value([]);

  return ref.watch(transactionRepositoryProvider).watchTransactions(user.uid);
}

@riverpod
AsyncValue<TransactionSummary> transactionSummary(Ref ref) {
  final transactionsAsync = ref.watch(dashboardTransactionsProvider);

  return transactionsAsync.whenData((transactions) {
    double income = 0;
    double expense = 0;

    for (var tx in transactions) {
      if (tx.type == TransactionType.income) {
        income += tx.amount;
      } else {
        expense += tx.amount;
      }
    }

    return TransactionSummary(
      totalBalance: income - expense,
      totalIncome: income,
      totalExpense: expense,
    );
  });
}

@riverpod
AsyncValue<List<TransactionModel>> recentTransactions(Ref ref) {
  return ref
      .watch(dashboardTransactionsProvider)
      .whenData((transactions) => transactions.take(5).toList());
}
