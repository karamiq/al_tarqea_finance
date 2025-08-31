import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImageFormField extends FormField<File?> {
  ProfileImageFormField({
    super.key,
    super.initialValue,
    super.onSaved,
    super.validator,
    this.imageNotifier,
    bool autovalidate = false,
    required Color accentColor,
    required Color primaryColor,
  }) : super(
          autovalidateMode: autovalidate ? AutovalidateMode.always : AutovalidateMode.disabled,
          builder: (FormFieldState<File?> state) {
            return Column(
              children: [
                _AnimatedProfileAvatar(
                  file: state.value,
                  accentColor: accentColor,
                  primaryColor: primaryColor,
                  onPick: (file) {
                    state.didChange(file);
                    if (imageNotifier != null) imageNotifier.value = file;
                  },
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      state.errorText ?? '',
                      style: TextStyle(color: Theme.of(state.context).colorScheme.error, fontSize: 12),
                    ),
                  ),
              ],
            );
          },
        );

  final ValueNotifier<File?>? imageNotifier;
}

class _AnimatedProfileAvatar extends StatefulWidget {
  final File? file;
  final Color accentColor;
  final Color primaryColor;
  final ValueChanged<File?> onPick;
  const _AnimatedProfileAvatar({
    required this.file,
    required this.accentColor,
    required this.primaryColor,
    required this.onPick,
  });

  @override
  State<_AnimatedProfileAvatar> createState() => _AnimatedProfileAvatarState();
}

class _AnimatedProfileAvatarState extends State<_AnimatedProfileAvatar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 180));
    _scaleAnim = Tween<double>(begin: 1, end: 0.92)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    await _controller.forward();
    await _controller.reverse();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Column(
                    children: [
                      Icon(Icons.emoji_emotions, size: 40, color: widget.accentColor),
                      const SizedBox(height: 8),
                      Text(
                        'لنضف لمسة جميلة لصورتك الشخصية!',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: widget.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'اختر صورة مبهجة لملفك الشخصي',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.accentColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 2,
                        ),
                        icon: const Icon(Icons.photo_library, size: 24),
                        label: const Text('المعرض', style: TextStyle(fontSize: 16)),
                        onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 2,
                        ),
                        icon: const Icon(Icons.camera_alt, size: 24),
                        label: const Text('الكاميرا', style: TextStyle(fontSize: 16)),
                        onPressed: () => Navigator.of(context).pop(ImageSource.camera),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'صورتك مرئية لك فقط',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (source == null) return;
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source);
    if (picked != null) {
      widget.onPick(File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final gradient = LinearGradient(
      colors: [widget.primaryColor, widget.accentColor, Colors.pinkAccent, Colors.lightBlueAccent],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    return Center(
      child: GestureDetector(
        onTap: _pickImage,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnim.value,
              child: child,
            );
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: gradient,
              boxShadow: [
                BoxShadow(
                  color: widget.accentColor.withOpacity(0.18),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            padding: const EdgeInsets.all(4),
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  backgroundImage: widget.file != null ? FileImage(widget.file!) : null,
                  child:
                      widget.file == null ? Icon(Icons.person, color: widget.primaryColor, size: 44) : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: widget.primaryColor.withOpacity(0.18),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(6),
                    child: Icon(Icons.camera_alt_rounded, color: widget.primaryColor, size: 22),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
