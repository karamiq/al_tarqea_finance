import 'package:al_tarqea_finance/data/shared_preference/preferences.dart';
import 'package:al_tarqea_finance/src/entry_point.dart';
import 'package:al_tarqea_finance/src/facilities/facilities_page.dart';
import 'package:al_tarqea_finance/src/grocery/grocery_page.dart';
import 'package:al_tarqea_finance/src/services/Services_page.dart';
import 'package:al_tarqea_finance/src/utility_bills/utility_bills_page.dart';
import 'package:flutter/material.dart';
import 'package:al_tarqea_finance/pages/login_page.dart';
import 'package:al_tarqea_finance/pages/register_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Provider<GoRouter> routerProvider = Provider((ref) => router);

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

// GoRouter configuration
final router = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: RoutesDocument.utilityBills,
  navigatorKey: _rootNavigatorKey,
  redirect: (context, state) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final authenticationRaw = sharedPreferences.getString(Preferences.authentication);

    final path = state.fullPath ?? '';

    if (path.contains(RoutesDocument.login) || path.contains(RoutesDocument.register)) {
      return null;
    }
    if (authenticationRaw == null) {
      return RoutesDocument.register;
    }
    return null;
  },
  routes: [
    GoRoute(
      path: RoutesDocument.register,
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: RoutesDocument.login,
      builder: (context, state) => const LoginPage(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return EntryPoint(child: child);
      },
      routes: <RouteBase>[
        GoRoute(path: RoutesDocument.utilityBills, builder: (context, state) => const UtilityBillsPage()),
        GoRoute(path: RoutesDocument.facilities, builder: (context, state) => const FacilitiesPage()),
        GoRoute(path: RoutesDocument.grocery, builder: (context, state) => const GroceryPage()),
        GoRoute(path: RoutesDocument.services, builder: (context, state) => const ServicesPage()),
      ],
    ),
  ],
);

class RoutesDocument {
  const RoutesDocument._();
  static const String login = '/login';
  static const String register = '/register';

  static const String services = '/services';
  static const String facilities = '/facilities';
  static const String grocery = '/grocery';
  static const String utilityBills = '/utility-bills';

  // // Product
  // static String productDetails(String id) => 'product-details/$id';
}

  // final encodedItemId = getEncodedComponent(item.id);
  // context.push(
  //     "${RoutesDocument.pharmacyHome}/${RoutesDocument.productDetails(encodedItemId)}");
