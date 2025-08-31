import 'package:al_tarqea_finance/common_lib.dart';
import 'package:al_tarqea_finance/components/balance_indicator.dart';
import 'package:al_tarqea_finance/data/providers/authentication_provider.dart';
import 'package:flutter/material.dart';

class EntryPoint extends StatefulHookConsumerWidget {
  const EntryPoint({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EntryPodoubleState();
}

class _EntryPodoubleState extends ConsumerState<EntryPoint> {
  int timesAvatarTaped = 0;
  @override
  Widget build(BuildContext context) {
    final user = ref.read(authenticationProvider);
    final pages = [
      RoutesDocument.utilityBills,
      RoutesDocument.facilities,
      RoutesDocument.grocery,
      RoutesDocument.services,
    ];

    final titles = [
      'الفواتير',
      'الخدمات العامة',
      'المواد الغذائية',
      'الخدمات',
    ];
    final colors = [
      const Color(0xFF6C5CE7), // utilityBills
      const Color(0xFF00B894), // facilities
      const Color(0xFFFFB300), // grocery
      const Color(0xFF0984E3), // services
    ];
    final emojis = [
      '💡',
      '🏠',
      '🛒',
      '🧩',
    ];

    int getSelectedIndex() {
      final String location = GoRouterState.of(context).fullPath!;
      return pages.indexOf(location);
    }

    final selectedIndex = getSelectedIndex();
    final currentTitle = selectedIndex >= 0 ? titles[selectedIndex] : '';
    final currentColor = selectedIndex >= 0 ? colors[selectedIndex] : colors[0];
    final currentEmoji = selectedIndex >= 0 ? emojis[selectedIndex] : '';

    void onItemTapped(int index) {
      GoRouter.of(context).go(pages[index]);
    }

    final primaryColor = Theme.of(context).colorScheme.primary;
    final accentColor = Theme.of(context).colorScheme.secondary;
    final bgGradient = LinearGradient(
      colors: [primaryColor, accentColor, Colors.pinkAccent, Colors.lightBlueAccent],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              toolbarHeight: 100,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('مرحبا بك في الترقية للتمويل',
                          style: TextStyle(fontSize: 16, color: Colors.white70)),
                      const Gap(4),
                      Text('${user?.firstName} ${user?.lastName}',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      timesAvatarTaped += 1;
                      if (timesAvatarTaped == 10) {
                        ref.read(authenticationProvider.notifier).logout();
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: bgGradient,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(user!.profileImageUrl),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              automaticallyImplyLeading: false,
              centerTitle: true,
              backgroundColor: currentColor,
              elevation: 0,
            ),
            Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                gradient: LinearGradient(
                  colors: [currentColor, currentColor.withOpacity(0.85), currentColor.withOpacity(0.5)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                  child: Text("$currentEmoji $currentTitle",
                      style: const TextStyle(fontSize: 30, color: Colors.white))),
            ),
            BalanceIndicator(primaryColor: currentColor),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFF8F9FE),
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: NavigationBar(
            animationDuration: const Duration(milliseconds: 300),
            selectedIndex: selectedIndex,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            indicatorColor: currentColor.withOpacity(0.2),
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            height: 75,
            destinations: [
              NavigationDestination(
                icon: Icon(Icons.electrical_services_outlined, size: 24),
                selectedIcon: Icon(
                  Icons.electrical_services,
                  color: currentColor,
                  size: 28,
                ),
                label: 'الفواتير',
                tooltip: 'ادفع الفواتير مثل الكهرباء والماء',
              ),
              NavigationDestination(
                icon: Icon(Icons.home_work_outlined, size: 24),
                selectedIcon: Icon(
                  Icons.home_work,
                  color: currentColor,
                  size: 28,
                ),
                label: 'الخدمات العامة',
                tooltip: 'ادفع الخدمات العامة مثل الإيجار والگيم',
              ),
              NavigationDestination(
                icon: Icon(Icons.shopping_cart_outlined, size: 24),
                selectedIcon: Icon(
                  color: currentColor,
                  Icons.shopping_cart,
                  size: 28,
                ),
                label: 'المواد الغذائية',
                tooltip: 'اشتري مواد غذائية وأغراض بيت',
              ),
              NavigationDestination(
                icon: Icon(Icons.miscellaneous_services_outlined, size: 24),
                selectedIcon: Icon(
                  Icons.miscellaneous_services,
                  color: currentColor,
                  size: 28,
                ),
                label: 'الخدمات',
                tooltip: 'ادفع لخدمات مثل العاب وملابس',
              ),
            ],
            onDestinationSelected: onItemTapped,
          ),
        ),
      ),
    );
  }
}
// Color palette for the app

// Base model for items
