import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sdui/src/models/widget_config.dart';
import 'package:sdui/src/models/theme_tokens.dart';
import 'package:sdui/src/core/workflow_controller.dart';

class SduiTextField extends StatefulWidget {
  final WidgetConfig config;
  final ThemeTokens themeTokens;
  final SduiWorkflowController controller;

  const SduiTextField({
    super.key,
    required this.config,
    required this.themeTokens,
    required this.controller,
  });

  @override
  State<SduiTextField> createState() => _SduiTextFieldState();
}

class _SduiTextFieldState extends State<SduiTextField> {
  late TextEditingController _textController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _focusNode = FocusNode();

    // Set initial value if exists
    final fieldId = widget.config.id;
    if (fieldId != null) {
      final initialValue = widget.controller.getFieldValue(fieldId);
      if (initialValue != null) {
        _textController.text = initialValue;
      }
    }

    // Listen to controller changes
    _textController.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final fieldId = widget.config.id;
    if (fieldId != null) {
      widget.controller.updateField(fieldId, _textController.text);
    }
  }

  void _onFocusChanged() {
    if (!_focusNode.hasFocus) {
      // Validate when field loses focus
      final fieldId = widget.config.id;
      if (fieldId != null && widget.config.validators != null) {
        widget.controller.validateField(fieldId, widget.config.validators);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> properties =
        widget.config.properties ?? <String, dynamic>{};
    final hint = properties['hint'] as String?;
    final keyboard = properties['keyboard'] as String?;
    final maxLength = properties['maxLength'] as int?;
    final obscureText = properties['obscureText'] as bool? ?? false;

    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, child) {
        final String? fieldId = widget.config.id;
        final String? errorText = fieldId != null
            ? widget.controller.getFieldError(fieldId)
            : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.config.label != null) ...[
              Text(
                widget.config.label!,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: widget.themeTokens.getTextColor(),
                  fontFamily: widget.themeTokens.getFontFamily(),
                ),
              ),
              SizedBox(height: widget.themeTokens.getSpaceSm()),
            ],
            TextField(
              controller: _textController,
              focusNode: _focusNode,
              keyboardType: _getKeyboardType(keyboard),
              inputFormatters: _getInputFormatters(keyboard, maxLength),
              obscureText: obscureText,
              maxLength: maxLength,
              decoration: InputDecoration(
                hintText: hint,
                errorText: errorText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    widget.themeTokens.getRadiusMd(),
                  ),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    widget.themeTokens.getRadiusMd(),
                  ),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    widget.themeTokens.getRadiusMd(),
                  ),
                  borderSide: BorderSide(
                    color: widget.themeTokens.getPrimaryColor(),
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    widget.themeTokens.getRadiusMd(),
                  ),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    widget.themeTokens.getRadiusMd(),
                  ),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                contentPadding: EdgeInsets.all(widget.themeTokens.getSpaceMd()),
                counterText: '', // Hide character counter
              ),
              style: TextStyle(
                color: widget.themeTokens.getTextColor(),
                fontFamily: widget.themeTokens.getFontFamily(),
              ),
            ),
          ],
        );
      },
    );
  }

  TextInputType _getKeyboardType(String? keyboard) {
    switch (keyboard?.toLowerCase()) {
      case 'phone':
        return TextInputType.phone;
      case 'email':
        return TextInputType.emailAddress;
      case 'number':
        return TextInputType.number;
      case 'url':
        return TextInputType.url;
      case 'multiline':
        return TextInputType.multiline;
      default:
        return TextInputType.text;
    }
  }

  List<TextInputFormatter> _getInputFormatters(
    String? keyboard,
    int? maxLength,
  ) {
    final formatters = <TextInputFormatter>[];

    if (maxLength != null) {
      formatters.add(LengthLimitingTextInputFormatter(maxLength));
    }

    switch (keyboard?.toLowerCase()) {
      case 'phone':
        formatters.add(
          FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-\s()]')),
        );
        break;
      case 'number':
        formatters.add(FilteringTextInputFormatter.digitsOnly);
        break;
    }

    return formatters;
  }
}
