import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomInput extends StatefulWidget {
  final TextEditingController controller;
  String? hint;
  String? errorText;
  void Function() onTap;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool enableSuggestions;
  final TextCapitalization textCapitalization;

  CustomInput({
    super.key,
    required this.controller,
    this.hint,
    this.errorText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.enableSuggestions = false,
    this.textCapitalization = TextCapitalization.none,
    this.onTap = _defaultOnTap,
  });

  static void _defaultOnTap() {}

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  bool _showClearButton = false;

  @override
  void initState() {
    checkForClearButton();
    widget.controller.addListener(() {
      checkForClearButton();
    });
    super.initState();
  }

  void checkForClearButton(){
    final show = widget.controller.text.isNotEmpty;
    if(_showClearButton != show){
      setState(() {
        _showClearButton = show;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow,
                blurRadius: 5,
                spreadRadius: -2,
              ),
            ],
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.surface,
            border: widget.errorText == null
                ? null
                : Border.all(
                    color: Theme.of(context).colorScheme.error,
                  )),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: TextField(
            controller: widget.controller,
            autocorrect: false,
            keyboardType: widget.keyboardType,
            obscureText: widget.obscureText,
            enableSuggestions: widget.enableSuggestions,
            textCapitalization: widget.textCapitalization,
            decoration: InputDecoration(
              hintText: widget.hint,
              errorText: widget.errorText,
              border: InputBorder.none,
              suffixIcon: !_showClearButton
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.close),
                      color: Theme.of(context).colorScheme.onSurface,
                      onPressed: () {
                        widget.controller.text = "";
                      },
                    ),
            ),
            onTap: widget.onTap,
          ),
        ),
      ),
    );
  }
}
