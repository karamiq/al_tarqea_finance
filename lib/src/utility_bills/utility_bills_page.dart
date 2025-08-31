import 'package:al_tarqea_finance/components/category_pages_base.dart';
import 'package:flutter/material.dart';

// Utility Bills Page
class UtilityBillsPage extends StatefulWidget {
  const UtilityBillsPage({
    super.key,
  });

  @override
  State<UtilityBillsPage> createState() => _UtilityBillsPageState();
}

class _UtilityBillsPageState extends State<UtilityBillsPage> {
  var currentBalance = 1000;
  final items = [
    PaymentItem(
      name: 'الكهرباء',
      price: 80,
      icon: Icons.lightbulb,
      emoji: '💡',
      color: Colors.yellow,
    ),
    PaymentItem(
      name: 'الإنترنت',
      price: 50,
      icon: Icons.wifi,
      emoji: '🌐',
      color: Colors.blue,
    ),
    PaymentItem(
      name: 'الماء',
      price: 30,
      icon: Icons.water_drop,
      emoji: '💧',
      color: Colors.lightBlue,
    ),
    PaymentItem(
      name: 'النفط',
      price: 60,
      icon: Icons.local_gas_station,
      emoji: '⛽',
      color: Colors.brown,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CategoryPageBase(
      title: 'الفواتير',
      items: items,
      primaryColor: Colors.teal,
      backgroundEmoji: '💡📡',
    );
  }
}
