import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_ai_app/src/features/transactions/domain/transaction_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transaction_repository.g.dart';

class TransactionRepository {
  final FirebaseFirestore _firestore;

  TransactionRepository(this._firestore);

  CollectionReference<Map<String, dynamic>> _userTransactions(String uid) {
    return _firestore.collection('users').doc(uid).collection('transactions');
  }

  // add new transaction
  Future<void> addTransaction({
    required String uid,
    required TransactionModel transaction,
  }) async {
    await _userTransactions(uid).doc(transaction.id).set(transaction.toJson());
  }

  // stream list of transactions
  Stream<List<TransactionModel>> watchTransactions(String uid) {
    return _userTransactions(uid)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => TransactionModel.fromJson(doc.data()))
              .toList(),
        );
  }

  // delete transaction
  Future<void> deleteTransaction({
    required String uid,
    required String transactionId,
  }) async {
    await _userTransactions(uid).doc(transactionId).delete();
  }
}

@Riverpod(keepAlive: true)
TransactionRepository transactionRepository(Ref ref) {
  return TransactionRepository(FirebaseFirestore.instance);
}
