import 'package:flutter/material.dart';
import 'package:todo_list/utils/datetime_utils.dart';
import 'package:todo_list/utils/localization_utils.dart';

class CustomDateTimePicker extends StatefulWidget {
  final String label;
  final DateTime? initialDate;
  final void Function(DateTime?, TimeOfDay?) onDateTimePicked;

  const CustomDateTimePicker({
    super.key,
    required this.label,
    this.initialDate,
    required this.onDateTimePicked,
  });

  @override
  State<CustomDateTimePicker> createState() => _CustomDateTimePickerState();
}

class _CustomDateTimePickerState extends State<CustomDateTimePicker> {
  DateTime? _selectedDateTime;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    if (widget.initialDate != null) {
      setState(() {
        _selectedDateTime = widget.initialDate;
      });
    }
    super.initState();
  }

  Future _pickDate(BuildContext context) async {
    final picked = await DateTimeUtils.showDateTimePicker(
      context: context,
      initialDateTime: widget.initialDate ?? DateTime.now(),
      firstDateTime: DateTime(1990),
      lastDateTime: DateTime(2200),
    );
    if (picked != null) {
      widget.onDateTimePicked(picked.$1, picked.$2);
      setState(() {
        _selectedDateTime = picked.$1;
        _selectedTime = picked.$2;
      });
    }
  }

  _removeDateTime() {
    widget.onDateTimePicked(null, null);
    setState(() {
      _selectedDateTime = null;
      _selectedTime = null;
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
                    _selectedDateTime != null
                        ? Text(
                            DateTimeUtils.getDateString(_selectedDateTime!),
                            style: Theme.of(context).textTheme.labelMedium,
                          )
                        : Text(
                            strings(context).noDateSelected,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                    if(_selectedTime != null)
                      Text(
                            DateTimeUtils.getTimeString(_selectedDateTime!),
                            style: Theme.of(context).textTheme.labelMedium,
                          )
                  ],
                )
              ],
            ),
          ),
          if (_selectedDateTime != null)
            IconButton(
                onPressed: () {
                  _removeDateTime();
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
