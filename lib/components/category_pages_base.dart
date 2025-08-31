import 'package:al_tarqea_finance/common_lib.dart';
import 'package:al_tarqea_finance/components/item_card.dart';
import 'package:al_tarqea_finance/components/payment_dialog.dart';
import 'package:al_tarqea_finance/data/repositories/balance_repository.dart';
import 'package:flutter/material.dart';

// --------------------------- Models ---------------------------
class PaymentItem {
  final String name;
  final double price;
  final IconData icon;
  final String emoji;
  final Color color;

  const PaymentItem({
    required this.name,
    required this.price,
    required this.icon,
    required this.emoji,
    required this.color,
  });
}

// --------------------------- Category Page ---------------------------
class CategoryPageBase extends ConsumerStatefulWidget {
  final String title;
  final List<PaymentItem> items;
  final Color primaryColor;
  final String backgroundEmoji;

  const CategoryPageBase({
    super.key,
    required this.title,
    required this.items,
    required this.primaryColor,
    required this.backgroundEmoji,
  });

  @override
  ConsumerState<CategoryPageBase> createState() => _CategoryPageBaseState();
}

class _CategoryPageBaseState extends ConsumerState<CategoryPageBase> with TickerProviderStateMixin {
  late AnimationController _slideController;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
          parent: _slideController,
          curve: Curves.fastEaseInToSlowEaseOut,
          reverseCurve: Curves.fastEaseInToSlowEaseOut)),
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          final item = widget.items[index];
          return ItemCard(
            item: item,
            onPay: () {
              showDialog(
                context: context,
                builder: (context) => PaymentDialog(
                  itemName: item.name,
                  price: item.price,
                  onPayment: (amount) async {
                    await ref.read(balanceRepositoryProvider).setPayment(item.name, amount).whenComplete(() {
                      Utils.showSuccessOverlay(
                        'تم دفع ${amount.toStringAsFixed(2)} \$ لشراء ${item.name} بنجاح ✅',
                      );
                    }).catchError((error) {
                      Utils.showErrorOverlay('فشل الدفع: $error');
                    });
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
