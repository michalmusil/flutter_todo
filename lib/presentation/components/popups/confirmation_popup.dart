import 'package:flutter/material.dart';
import 'package:todo_list/presentation/components/misc/rounded_push_button.dart';
import 'package:todo_list/utils/localization_utils.dart';

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
        RoundedPushButton(
          text: strings(context).no,
          backgroundColor: Theme.of(context).colorScheme.surface,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          onClick: () {
            Navigator.pop(context);
            if (onCancel != null) {
              onCancel!();
            }
          },
        ),
        RoundedPushButton(
          text: strings(context).yes,
          onClick: () {
            Navigator.pop(context);
            onConfirm();
          },
        ),
      ],
      icon: icon,
      backgroundColor: Theme.of(context).colorScheme.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
