import 'package:finance_ai_app/src/features/auth/data/auth_repository.dart';
import 'package:finance_ai_app/src/features/transactions/data/transaction_repository.dart';
import 'package:finance_ai_app/src/features/transactions/domain/transaction_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'transaction_controller.g.dart';

@riverpod
class TransactionController extends _$TransactionController {
  @override
  FutureOr<void> build() {}

  Future<void> addTransaction({
    required double amount,
    required TransactionType type,
    required String category,
    required String description,
    required DateTime date,
  }) async {
    state = const AsyncLoading();

    // get current user
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) {
      state = AsyncError('User not logged in', StackTrace.current);
      return;
    }

    // make TransactionModel object
    final newTransaction = TransactionModel(
      id: const Uuid().v4(),
      amount: amount,
      type: type,
      category: category,
      description: description,
      date: date,
    );

    // add transaction to firestore
    state = await AsyncValue.guard(
      () => ref
          .read(transactionRepositoryProvider)
          .addTransaction(uid: user.uid, transaction: newTransaction),
    );
  }
}
