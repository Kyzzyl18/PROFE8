import 'package:flutter/material.dart';

enum ButtonType { elevated, outlined, text }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonType type;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final IconData? icon;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.elevated,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case ButtonType.elevated:
        return ElevatedButton.icon(
          onPressed: onPressed,
          icon: icon != null
              ? Icon(icon, color: textColor ?? Colors.white)
              : null,
          label: Text(
            text,
            style: TextStyle(
              color: textColor ?? Colors.white,
              fontFamily: 'Roboto',
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        );
      case ButtonType.outlined:
        return OutlinedButton.icon(
          onPressed: onPressed,
          icon: icon != null
              ? Icon(icon, color: textColor ?? Theme.of(context).primaryColor)
              : null,
          label: Text(
            text,
            style: TextStyle(
              color: textColor ?? Theme.of(context).primaryColor,
              fontFamily: 'Roboto',
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(
                color: borderColor ?? Theme.of(context).primaryColor),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        );
      case ButtonType.text:
        return TextButton.icon(
          onPressed: onPressed,
          icon: icon != null
              ? Icon(icon, color: textColor ?? Theme.of(context).primaryColor)
              : null,
          label: Text(
            text,
            style: TextStyle(
              color: textColor ?? Theme.of(context).primaryColor,
              fontFamily: 'Roboto',
            ),
          ),
        );
    }
  }
}
