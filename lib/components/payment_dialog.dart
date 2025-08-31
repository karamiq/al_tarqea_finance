import 'package:al_tarqea_finance/common_lib.dart';
import 'package:flutter/material.dart';

class PaymentDialog extends StatefulWidget {
  final String itemName;
  final double price;
  final void Function(double) onPayment;

  const PaymentDialog({
    super.key,
    required this.itemName,
    required this.price,
    required this.onPayment,
  });

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  final TextEditingController _amountController = TextEditingController();
  bool _isValidAmount = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _handlePayment() {
    widget.onPayment(widget.price);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Center(
          child: Text(
            'دفع ${widget.itemName}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'السعر: ${widget.price.toStringAsFixed(2)} \$',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'ادخل المبلغ',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                prefixIcon: const Icon(Icons.attach_money),
              ),
              onChanged: (value) {
                setState(() {
                  _isValidAmount = double.tryParse(value) == widget.price;
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: _isValidAmount ? _handlePayment : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange[600],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: const Text('شراء', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
