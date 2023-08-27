import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextInput extends StatefulWidget {
  final TextEditingController controller;
  String? label;
  String? hint;
  String? errorText;
  void Function() onTap;
  final bool allowClearButton;
  final TextInputType keyboardType;
  final int maxLines;
  final bool obscureText;
  final bool enableSuggestions;
  final TextCapitalization textCapitalization;

  CustomTextInput({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.allowClearButton = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.obscureText = false,
    this.enableSuggestions = false,
    this.textCapitalization = TextCapitalization.none,
    this.onTap = _defaultOnTap,
  });

  static void _defaultOnTap() {}

  @override
  State<CustomTextInput> createState() => _CustomTextInputState();
}

class _CustomTextInputState extends State<CustomTextInput> {
  late final FocusNode _focusNode;
  bool _showClearButton = false;
  bool _showLabel = false;

  @override
  void initState() {
    _focusNode = FocusNode();
    checkForClearButton();
    checkForLabel();
    widget.controller.addListener(() {
      checkForClearButton();
      checkForLabel();
    });

    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  checkForClearButton() {
    final show = widget.allowClearButton && widget.controller.text.isNotEmpty;
    if (_showClearButton != show) {
      setState(() {
        _showClearButton = show;
      });
    }
  }

  checkForLabel() {
    final show = widget.label != null && widget.controller.text.isNotEmpty;
    if (_showLabel != show) {
      setState(() {
        _showLabel = show;
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
                ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 2,
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            autocorrect: false,
            keyboardType: widget.keyboardType,
            maxLines: widget.maxLines,
            obscureText: widget.obscureText,
            enableSuggestions: widget.enableSuggestions,
            textCapitalization: widget.textCapitalization,
            decoration: InputDecoration(
              hintText: widget.hint,
              errorText: widget.errorText,
              label: _showLabel
                  ? Text(
                      widget.label!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    )
                  : null,
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
            onTapOutside: (event) {
              _focusNode.unfocus();
            },
          ),
        ),
      ),
    );
  }
}
