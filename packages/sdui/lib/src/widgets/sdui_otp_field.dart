import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sdui/src/models/widget_config.dart';
import 'package:sdui/src/models/theme_tokens.dart';
import 'package:sdui/src/core/workflow_controller.dart';

class SduiOtpField extends StatefulWidget {
  final WidgetConfig config;
  final ThemeTokens themeTokens;
  final SduiWorkflowController controller;

  const SduiOtpField({
    super.key,
    required this.config,
    required this.themeTokens,
    required this.controller,
  });

  @override
  State<SduiOtpField> createState() => _SduiOtpFieldState();
}

class _SduiOtpFieldState extends State<SduiOtpField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  int _length = 6;

  @override
  void initState() {
    super.initState();

    final properties = widget.config.properties ?? <String, dynamic>{};
    _length = properties['length'] as int? ?? 6;

    _controllers = List.generate(_length, (index) => TextEditingController());
    _focusNodes = List.generate(_length, (index) => FocusNode());

    // Set initial value if exists
    final fieldId = widget.config.id;
    if (fieldId != null) {
      final initialValue = widget.controller.getFieldValue(fieldId);
      if (initialValue != null && initialValue.length <= _length) {
        for (int i = 0; i < initialValue.length; i++) {
          _controllers[i].text = initialValue[i];
        }
      }
    }

    // Add listeners
    for (int i = 0; i < _length; i++) {
      _controllers[i].addListener(() => _onTextChanged(i));
      _focusNodes[i].addListener(() => _onFocusChanged(i));
    }
  }

  @override
  void dispose() {
    for (int i = 0; i < _length; i++) {
      _controllers[i].dispose();
      _focusNodes[i].dispose();
    }
    super.dispose();
  }

  void _onTextChanged(int index) {
    final text = _controllers[index].text;

    if (text.length == 1) {
      // Move to next field
      if (index < _length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // Last field, remove focus
        _focusNodes[index].unfocus();
      }
    } else if (text.isEmpty && index > 0) {
      // Move to previous field if current is empty
      _focusNodes[index - 1].requestFocus();
    }

    _updateFieldValue();
  }

  void _onFocusChanged(int index) {
    if (!_focusNodes[index].hasFocus) {
      // Validate when field loses focus
      _validateField();
    }
  }

  void _updateFieldValue() {
    final fieldId = widget.config.id;
    if (fieldId != null) {
      final value = _controllers.map((controller) => controller.text).join();
      widget.controller.updateField(fieldId, value);
    }
  }

  void _validateField() {
    final fieldId = widget.config.id;
    if (fieldId != null && widget.config.validators != null) {
      widget.controller.validateField(fieldId, widget.config.validators);
    }
  }

  @override
  Widget build(BuildContext context) {
    final properties = widget.config.properties ?? <String, dynamic>{};
    final semanticLabel = properties['semanticLabel'] as String?;
    final semanticHint = properties['semanticHint'] as String?;

    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, child) {
        final fieldId = widget.config.id;
        final errorText = fieldId != null
            ? widget.controller.getFieldError(fieldId)
            : null;

        return Semantics(
          label: semanticLabel ?? widget.config.label ?? 'OTP input field',
          hint: semanticHint ?? 'Enter $_length digit verification code',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.config.label != null) ...[
                Semantics(
                  label: '${widget.config.label} field label',
                  child: Text(
                    widget.config.label!,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: widget.themeTokens.getTextColor(),
                      fontFamily: widget.themeTokens.getFontFamily(),
                    ),
                  ),
                ),
                SizedBox(height: widget.themeTokens.getSpaceSm()),
              ],
              Semantics(
                label: 'OTP input boxes',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    _length,
                    (index) => _buildOtpBox(index, errorText != null),
                  ),
                ),
              ),
              if (errorText != null) ...[
                SizedBox(height: widget.themeTokens.getSpaceSm()),
                Semantics(
                  liveRegion: true,
                  label: 'Error: $errorText',
                  child: Text(
                    errorText,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildOtpBox(int index, bool hasError) {
    return Container(
      width: 50,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(
          color: hasError
              ? Colors.red
              : _focusNodes[index].hasFocus
              ? widget.themeTokens.getPrimaryColor()
              : Colors.grey[300]!,
          width: _focusNodes[index].hasFocus ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(widget.themeTokens.getRadiusMd()),
      ),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: widget.themeTokens.getTextColor(),
          fontFamily: widget.themeTokens.getFontFamily(),
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: (value) {
          if (value.length > 1) {
            // Handle paste operation
            _handlePaste(value, index);
          } else {
            // Handle single character input - trigger auto-focus
            _onTextChanged(index);
          }
        },
      ),
    );
  }

  void _handlePaste(String pastedText, int startIndex) {
    // Handle pasting multiple digits
    final digits = pastedText.replaceAll(RegExp(r'[^0-9]'), '');

    for (int i = 0; i < digits.length && (startIndex + i) < _length; i++) {
      _controllers[startIndex + i].text = digits[i];
    }

    // Focus on the next empty field or last field
    final nextIndex = (startIndex + digits.length).clamp(0, _length - 1);
    _focusNodes[nextIndex].requestFocus();

    _updateFieldValue();
  }
}
