import 'package:al_tarqea_finance/components/category_pages_base.dart';
import 'package:flutter/material.dart';

// Facilities Page
class FacilitiesPage extends StatelessWidget {
  const FacilitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      PaymentItem(
        name: 'إيجار المنزل',
        price: 200,
        icon: Icons.home,
        emoji: '🏠',
        color: Colors.green,
      ),
      PaymentItem(
        name: 'النادي الرياضي',
        price: 100,
        icon: Icons.fitness_center,
        emoji: '💪',
        color: Colors.red,
      ),
      PaymentItem(
        name: 'مقهى الإنترنت',
        price: 30,
        icon: Icons.computer,
        emoji: '💻',
        color: Colors.purple,
      ),
    ];

    return CategoryPageBase(
      title: 'الخدمات العامة',
      items: items,
      primaryColor: Colors.cyan,
      backgroundEmoji: '🏢🏋️',
    );
  }
}
