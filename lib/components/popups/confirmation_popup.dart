import 'package:flutter/material.dart';

class ConfirmationPopup extends StatelessWidget {
  final String title;
  final String message;
  final void Function() onConfirm;
  final void Function()? onCancel;
  final Widget? icon;

  const ConfirmationPopup({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    this.onCancel,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      content: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            if(onCancel != null){
              onCancel!();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.surface,
            foregroundColor: Theme.of(context).colorScheme.onSurface,
          ),
          child: const Text("No"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            foregroundColor: Theme.of(context).colorScheme.onSecondary,
          ),
          child: const Text("Yes"),
        )
      ],
      icon: icon,
      backgroundColor: Theme.of(context).colorScheme.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
