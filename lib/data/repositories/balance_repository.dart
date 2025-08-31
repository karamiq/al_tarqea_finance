import 'package:al_tarqea_finance/data/providers/authentication_provider.dart';
import 'package:al_tarqea_finance/data/services/clients/_clients.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'balance_repository.g.dart';

@riverpod
BalanceRepository balanceRepository(Ref ref) {
  return BalanceRepository(ref);
}

class BalanceRepository {
  final Ref ref;
  BalanceRepository(this.ref);
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final query = FirebaseFirestore.instance.collection('balances');

  Future<void> setBalance(double value, {required String userId}) async {
    await query.doc(userId).set({'balance': value});
  }

  Future<void> setPayment(String itemName, double amount) async {
    final userId = ref.read(authenticationProvider)?.uid;
    final docRef = query.doc(userId);
    await firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        throw ("مستند الرصيد غير موجود!");
      }
      final currentBalance = snapshot.get('balance') as num;
      final newBalance = currentBalance - amount;
      if (newBalance < 0) {
        throw ("الرصيد غير كافٍ لإتمام العملية");
      }
      storePaymentRecord(itemName, amount);
      transaction.update(docRef, {'balance': newBalance});
    });
  }

  Stream<double> balanceStream() {
    final userId = ref.read(authenticationProvider)?.uid;
    return query.doc(userId).snapshots().map((doc) {
      final data = doc.data();
      if (data == null) return 0.0;
      final balance = data['balance'];
      if (balance is int) return balance.toDouble();
      if (balance is double) return balance;
      return 0.0;
    });
  }

  Future<void> storePaymentRecord(String itemName, double amount) async {
    final userId = ref.read(authenticationProvider)?.uid;
    final paymentsRef = firestore.collection('payments');

    await paymentsRef.add({
      'userId': userId,
      'itemName': itemName,
      'amount': amount,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
