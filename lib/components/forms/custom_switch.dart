import 'package:flutter/material.dart';

class CustomSwitch extends StatefulWidget {
  bool value;
  final String label;
  final void Function(bool) onCheckChanged;

  CustomSwitch({
    super.key,
    required this.value,
    required this.onCheckChanged,
    required this.label,
  });

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow,
            blurRadius: 5,
            spreadRadius: -2,
          ),
        ],
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 1,
          horizontal: 10,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                widget.label,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Switch(
              value: widget.value,
              onChanged: widget.onCheckChanged,
              activeColor: Theme.of(context).colorScheme.primary,
              activeTrackColor: Theme.of(context).colorScheme.secondary,
            )
          ],
        ),
      ),
    );
  }
}
