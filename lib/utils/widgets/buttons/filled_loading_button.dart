import 'package:flutter/material.dart';

class FilledLoadingButton extends StatelessWidget {
  const FilledLoadingButton({
    super.key,
    required this.isLoading,
    required this.child,
    required this.onPressed,
    this.gradient,
    this.borderRadius = 18,
    this.height = 48,
  });

  final bool isLoading;
  final Widget child;
  final VoidCallback onPressed;
  final Gradient? gradient;
  final double borderRadius;
  final double height;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final accentColor = Theme.of(context).colorScheme.secondary;
    final buttonGradient = gradient ??
        LinearGradient(
          colors: [primaryColor, accentColor, Colors.pinkAccent],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        );
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        onPressed: isLoading ? null : onPressed,
        child: Ink(
          decoration: BoxDecoration(
            gradient: buttonGradient,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Container(
            alignment: Alignment.center,
            constraints: BoxConstraints(minHeight: height),
            child: isLoading ? const CircularProgressIndicator(color: Colors.white) : child,
          ),
        ),
      ),
    );
  }
}
