import 'package:flutter/material.dart';
import 'package:todo_list/utils/datetime_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomDatePicker extends StatefulWidget {
  final String label;
  final DateTime? initialDate;
  final void Function(DateTime?) onDatePicked;

  const CustomDatePicker({
    super.key,
    required this.label,
    this.initialDate,
    required this.onDatePicked,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime? _selectedDate;

  @override
  void initState() {
    if (widget.initialDate != null) {
      setState(() {
        _selectedDate = widget.initialDate;
      });
    }
    super.initState();
  }

  Future _pickDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.initialDate ?? DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(2200),
    );
    if (picked != null) {
      widget.onDatePicked(picked);
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  _removeDate() {
    widget.onDatePicked(null);
    setState(() {
      _selectedDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow,
            blurRadius: 8,
            spreadRadius: -1,
          ),
        ],
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    _pickDate(context);
                  },
                  padding: EdgeInsets.zero,
                  icon: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        Icons.calendar_month_rounded,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.label,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    if (_selectedDate != null)
                      Text(
                        DateTimeUtils.getDateString(_selectedDate!),
                        style: Theme.of(context).textTheme.labelMedium,
                      )
                    else
                      Text(
                        AppLocalizations.of(context)!.noDateSelected,
                        style: Theme.of(context).textTheme.labelMedium,
                      )
                  ],
                )
              ],
            ),
          ),
          if (_selectedDate != null)
            IconButton(
                onPressed: () {
                  _removeDate();
                },
                icon: Icon(
                  Icons.close,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 18,
                ))
        ],
      ),
    );
  }
}
