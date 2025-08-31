import 'dart:io';
import 'package:flutter/material.dart';

class ProfileImageSelector extends StatelessWidget {
  final File? imageFile;
  final VoidCallback onTap;
  final Color accentColor;
  final Color primaryColor;
  final double radius;

  const ProfileImageSelector({
    super.key,
    required this.imageFile,
    required this.onTap,
    required this.accentColor,
    required this.primaryColor,
    this.radius = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Center(
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: radius,
              backgroundColor: accentColor.withOpacity(0.15),
              backgroundImage: imageFile != null ? FileImage(imageFile!) : null,
              child: imageFile == null
                  ? Icon(Icons.person, size: 48, color: primaryColor.withOpacity(0.7))
                  : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  decoration: BoxDecoration(
                    color: accentColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
