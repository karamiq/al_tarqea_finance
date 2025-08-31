import 'package:al_tarqea_finance/components/category_pages_base.dart';
import 'package:flutter/material.dart';

// Grocery Page
class GroceryPage extends StatelessWidget {
  const GroceryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      PaymentItem(name: 'تفاحة', price: 5, icon: Icons.apple, emoji: '🍎', color: Colors.red),
      PaymentItem(name: 'موز', price: 4, icon: Icons.food_bank, emoji: '🍌', color: Colors.yellow),
      PaymentItem(name: 'جزر', price: 3, icon: Icons.agriculture, emoji: '🥕', color: Colors.orange),
      PaymentItem(name: 'طماطم', price: 3, icon: Icons.agriculture, emoji: '🍅', color: Colors.red),
      PaymentItem(name: 'خيار', price: 3, icon: Icons.agriculture, emoji: '🥒', color: Colors.green),
      PaymentItem(name: 'برتقال', price: 4, icon: Icons.circle, emoji: '🍊', color: Colors.orange),
      PaymentItem(name: 'عنب', price: 6, icon: Icons.circle, emoji: '🍇', color: Colors.purple),
      PaymentItem(name: 'خبز', price: 2, icon: Icons.bakery_dining, emoji: '🍞', color: Colors.brown),
      PaymentItem(name: 'حليب', price: 3, icon: Icons.local_drink, emoji: '🥛', color: Colors.blue),
      PaymentItem(name: 'جبن', price: 5, icon: Icons.food_bank, emoji: '🧀', color: Colors.yellow),
    ];

    return CategoryPageBase(
      title: 'المواد الغذائية',
      items: items,
      primaryColor: Colors.green,
      backgroundEmoji: '🛒🥬',
    );
  }
}
