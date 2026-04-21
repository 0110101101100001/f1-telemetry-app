import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;

  const CustomButton({
    super.key, 
    required this.label, 
    required this.onPressed, 
    this.isLoading = false
  });

  static const Color f1Red = Color(0xFFE10600);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: f1Red,
        foregroundColor: Colors.white,
        disabledBackgroundColor: Colors.grey[900],
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
        shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
        ),
        elevation: 8,
        shadowColor: f1Red.withOpacity(0.5),
      ),
      onPressed: isLoading ? null : onPressed,
      child: isLoading 
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.w900, 
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, size: 22),
            ],
          ),
    );
  }
}