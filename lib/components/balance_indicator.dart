import 'package:al_tarqea_finance/data/repositories/balance_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BalanceIndicator extends ConsumerWidget {
  const BalanceIndicator({
    super.key,
    required this.primaryColor,
  });

  final Color primaryColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balanceStream = ref.watch(balanceRepositoryProvider).balanceStream();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor.withOpacity(.5),
            primaryColor.withOpacity(1),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: StreamBuilder<double>(
        stream: balanceStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text(
              'خطأ في تحميل الرصيد',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            );
          }

          final balance = snapshot.data ?? 0.0;

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.account_balance_wallet, color: Colors.white, size: 30),
              const SizedBox(width: 10),
              Text(
                'الرصيد: ${balance.toStringAsFixed(2)} \$',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
