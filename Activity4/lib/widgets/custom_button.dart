import 'package:flutter/material.dart';

enum ButtonType { elevated, outlined }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonType type;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final Color? borderColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.elevated,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return type == ButtonType.elevated
        ? ElevatedButton.icon(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  backgroundColor ?? Theme.of(context).primaryColor,
              foregroundColor: textColor ?? Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            icon: icon != null ? Icon(icon) : const SizedBox(),
            label: Text(text),
          )
        : OutlinedButton.icon(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: textColor ?? Theme.of(context).primaryColor,
              side:
                  borderColor != null ? BorderSide(color: borderColor!) : null,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            icon: icon != null ? Icon(icon) : const SizedBox(),
            label: Text(text),
          );
  }
}
