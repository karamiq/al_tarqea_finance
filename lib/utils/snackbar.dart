import 'package:al_tarqea_finance/common_lib.dart';
import 'package:al_tarqea_finance/theme/app_theme.dart';
import 'package:al_tarqea_finance/utils/widgets/overlay_banner.dart';
import 'package:flutter/material.dart';

class Utils {
  static final overlayKey = GlobalKey<OverlayState>();
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static OverlayEntry? currentOverlayEntry;

  static void showSuccessOverlay(String text) {
    final overlay = overlayKey.currentState;
    if (overlay == null) return;

    try {
      if (currentOverlayEntry?.mounted ?? false) {
        currentOverlayEntry?.remove();
      }
    } catch (_) {}
    currentOverlayEntry = null;

    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => OverlayBanner(
        text: text,
        successColor: Colors.green.shade500.withOpacity(.9),
        successIcon: Icons.check_circle,
        overlayEntry: overlayEntry,
      ),
    );
    currentOverlayEntry = overlayEntry;
    overlay.insert(overlayEntry);
  }

  static void showErrorOverlay(String text) {
    final overlay = overlayKey.currentState;
    if (overlay == null) return;

    try {
      if (currentOverlayEntry?.mounted ?? false) {
        currentOverlayEntry?.remove();
      }
    } catch (_) {}
    currentOverlayEntry = null;

    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => OverlayBanner(
        text: text,
        successColor: Colors.red.withOpacity(.9),
        successIcon: Icons.error,
        overlayEntry: overlayEntry,
      ),
    );
    currentOverlayEntry = overlayEntry;
    overlay.insert(overlayEntry);
  }

  static void showErrorSnackBar(String? text) {
    if (text == null) return;
    SnackBar snackBar = SnackBar(
      content: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: colorSchemeNotifier.value.error,
      shape: RoundedRectangleBorder(borderRadius: BorderSize.extraSmallRadius),
    );
    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static void showSuccessSnackBar(String? text) {
    if (text == null) return;
    SnackBar snackBar = SnackBar(
      content: Text(text),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.green,
      shape: RoundedRectangleBorder(borderRadius: BorderSize.extraSmallRadius),
    );
    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static void showNotificatonSnackBar(String? title) {
    if (title == null) return;
    SnackBar snackBar = SnackBar(
      content: Text(title),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderSize.extraSmallRadius),
    );
    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}

extension SnackBarX on BuildContext {
  void showSnackBar(String text) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
        backgroundColor: theme.colorScheme.error,
      ),
    );
  }

  void showSuccessSnackBar(String text) {
    // final theme = Theme.of(this);

    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void showErrorSnackBar(String text) {
    final theme = Theme.of(this);

    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: TextStyle(
            color: theme.colorScheme.onError,
          ),
        ),
        backgroundColor: theme.colorScheme.error,
      ),
    );
  }
}
