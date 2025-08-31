// Services Page
import 'package:al_tarqea_finance/components/category_pages_base.dart';
import 'package:flutter/material.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      PaymentItem(
        name: 'لعبة',
        price: 25,
        icon: Icons.toys,
        emoji: '🧸',
        color: Colors.pink,
      ),
      PaymentItem(
        name: 'قميص',
        price: 20,
        icon: Icons.checkroom,
        emoji: '👕',
        color: Colors.blue,
      ),
      PaymentItem(
        name: 'أحذية',
        price: 30,
        icon: Icons.directions_walk,
        emoji: '👟',
        color: Colors.indigo,
      ),
      PaymentItem(
        name: 'حقيبة ظهر',
        price: 35,
        icon: Icons.backpack,
        emoji: '🎒',
        color: Colors.deepOrange,
      ),
      PaymentItem(
        name: 'حلاقة شعر',
        price: 10,
        icon: Icons.content_cut,
        emoji: '✂️',
        color: Colors.teal,
      ),
    ];

    return CategoryPageBase(
      title: 'الخدمات',
      items: items,
      primaryColor: Colors.purple,
      backgroundEmoji: '🛍️✨',
    );
  }
}
