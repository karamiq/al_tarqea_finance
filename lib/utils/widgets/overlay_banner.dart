import 'package:flutter/material.dart';

class OverlayBanner extends StatefulWidget {
  const OverlayBanner({
    super.key,
    required this.text,
    required this.successColor,
    required this.successIcon,
    required this.overlayEntry,
    this.totalDuration = 3.0, // seconds
  });

  final Color successColor;
  final IconData successIcon;
  final OverlayEntry? overlayEntry;
  final String text;
  final double totalDuration;

  @override
  State<OverlayBanner> createState() => _OverlayBannerState();
}

class _OverlayBannerState extends State<OverlayBanner> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;
  double value = 0;
  final double tickDuration = 0.016;

  @override
  void initState() {
    super.initState();

    // Slide down animation
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    animation = Tween<double>(begin: -100, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();

    // Start the progress timer
    _startTimer();
  }

  void _startTimer() async {
    final increment = tickDuration / widget.totalDuration;

    await Future.doWhile(() async {
      await Future.delayed(Duration(milliseconds: (tickDuration * 1000).round()));
      if (!mounted) return false;

      setState(() {
        value += increment;
        if (value > 1) value = 1;
      });

      return value < 1;
    });

    // Small delay before removing
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted && widget.overlayEntry != null && widget.overlayEntry!.mounted) {
      _controller.reverse().then((_) => widget.overlayEntry?.remove());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          top: animation.value,
          left: 16,
          right: 16,
          child: SafeArea(
            child: Material(
              elevation: 6,
              borderRadius: BorderRadius.circular(8),
              color: widget.successColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(widget.successIcon, color: Colors.white),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.text,
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (widget.overlayEntry != null) {
                              _controller.reverse().then((_) {
                                widget.overlayEntry?.remove();
                                // Cannot set widget.overlayEntry to null because it's final
                              });
                            }
                          },
                          icon: const Icon(Icons.close, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      minHeight: 2,
                      value: value,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      backgroundColor: Colors.white.withOpacity(0.3),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
