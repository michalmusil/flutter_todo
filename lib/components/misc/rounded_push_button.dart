import 'package:flutter/material.dart';

class RoundedPushButton extends StatelessWidget {
  final String text;
  final void Function() onClick;
  final bool expand;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const RoundedPushButton({
    super.key,
    required this.text,
    required this.onClick,
    this.expand = false,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor:
            backgroundColor ?? Theme.of(context).colorScheme.secondary,
        foregroundColor:
            foregroundColor ?? Theme.of(context).colorScheme.onSecondary,
        shadowColor: Theme.of(context).colorScheme.shadow,
      ),
      onPressed: onClick,
      child: expand
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null)
                  Icon(
                    icon,
                    color: foregroundColor ??
                        Theme.of(context).colorScheme.onSecondary,
                  ),
                if (icon != null)
                  const SizedBox(
                    width: 5,
                  ),
                Text(text)
              ],
            )
          : IntrinsicWidth(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (icon != null)
                    Icon(
                      icon,
                      color: foregroundColor ??
                          Theme.of(context).colorScheme.onSecondary,
                    ),
                  if (icon != null)
                    const SizedBox(
                      width: 5,
                    ),
                  Text(text)
                ],
              ),
            ),
    );
  }
}
