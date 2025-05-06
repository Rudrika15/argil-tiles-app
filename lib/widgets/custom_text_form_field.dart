import 'package:argil_tiles/app_const/app_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Custom Text Form Field widget
class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool autocorrect;
  final Color? cursorColor;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final bool readOnly;
  final TextStyle? style;
  final TextAlign textAlign;
  final String? Function(String?)? validator;
  final String? labelText;
  final String? hintText;
  final InputDecoration? decoration;
  final bool enabled;

  const CustomTextFormField({
    super.key,
    required this.controller,
    this.focusNode,
    this.autocorrect = true,
    this.cursorColor,
    this.keyboardType,
    this.obscureText = false,
    this.maxLength,
    this.maxLines = 1,
    this.minLines = 1,
    this.readOnly = false,
    this.style,
    this.textAlign = TextAlign.start,
    required this.validator,
    this.decoration,
    this.enabled = true,
    this.hintText,
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autocorrect: autocorrect,
      controller: controller,
      buildCounter:
          (
            context, {
            required currentLength,
            required isFocused,
            required maxLength,
          }) => null,
      cursorColor: AppColors.brown,
      cursorErrorColor: AppColors.errorColor,
      enabled: enabled,
      decoration:
          decoration ??
          InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 12,
            ),
            border: brownBorder(),
            enabledBorder: brownBorder(),
            focusedBorder: brownBorder(),
            errorBorder: errorBorder(),
            focusedErrorBorder: errorBorder(),
          ),
      focusNode: focusNode,
      keyboardType: keyboardType ?? TextInputType.text,
      obscureText: obscureText,
      onTapOutside: (event) => Navigator.of(context).focusNode.unfocus(),
      maxLength: maxLength,
      maxLines: maxLines,
      minLines: minLines,
      readOnly: readOnly,
      style: style,
      textAlign: textAlign,
      validator: validator,
    );
  }

  OutlineInputBorder brownBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.brown),
      borderRadius: BorderRadius.circular(8.0),
    );
  }

  OutlineInputBorder errorBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.brown),
      borderRadius: BorderRadius.circular(8.0),
    );
  }
}
