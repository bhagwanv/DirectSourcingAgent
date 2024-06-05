import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constant.dart';

class CommonTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Function(String)? onChanged;
  final String? helperText;
  final String? labelText;
  final int? maxLines;
  final bool hasError;
  final IconData? prefixIconData;
  final IconData? passwordHideIcon;
  final IconData? passwordShowIcon;
  final TextInputAction? textInputAction;
  final Color? textColor;
  final Color? accentColor;
  final Color fillColor;
  final TextCapitalization? textCapitalization;
  final List<TextInputFormatter>? inputFormatter;
  final bool? enabled;
  final int? maxLength;

  const CommonTextField({
    Key? key,
    required this.controller,
    this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.onChanged,
    this.helperText,
    this.labelText,
    this.hasError = false,
    this.prefixIconData,
    this.passwordHideIcon,
    this.passwordShowIcon,
    this.textInputAction,
    this.textColor,
    this.maxLines = 1,
    this.accentColor,
    this.fillColor = textFiledBackgroundColour,
    this.textCapitalization =  TextCapitalization.none,
    this.inputFormatter,
    this.enabled=true,
    this.maxLength,
  }) : super(key: key);

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  bool _isObscure = false;
  bool _isMaxLength = false;

  @override
  Widget build(BuildContext context) {

    return TextField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
      obscureText: _isObscure,
      onChanged: widget.onChanged,
      textInputAction: widget.textInputAction,
      maxLines: !_isObscure ? widget.maxLines : 1,
      maxLength: !_isMaxLength ? widget.maxLength : 1,
      /*style: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
        color: widget.textColor ?? Colors.black,),*/
      style: GoogleFonts.urbanist(
        fontSize: 16,
        color: widget.textColor ?? Colors.black,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        fillColor: widget.fillColor,
        filled: true,
        hintText: widget.hintText,
        labelText: widget.labelText ?? 'Default Simple TextField', // Use confirmation text as label if provided, else use default label text
        labelStyle: TextStyle(color: widget.accentColor ?? blackSmall), // Set accent color
        helperText: widget.helperText,
        prefixIcon: widget.prefixIconData != null
            ? Icon(widget.prefixIconData, color: widget.accentColor ?? kPrimaryColor) // Set accent color for prefix icon
            : null,
        suffixIcon: widget.obscureText
            ? IconButton(
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
          icon: Icon(_isObscure ? widget.passwordShowIcon ?? Icons.visibility : widget.passwordHideIcon ?? Icons.visibility_off),
          color: widget.accentColor ?? kPrimaryColor,
        )
            : null,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: kPrimaryColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: kPrimaryColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: kPrimaryColor, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        // You can add more customization to the decoration as needed
        // For example, adding icons, labels, etc.
      ),
      inputFormatters: widget.inputFormatter != null ? widget.inputFormatter : null,
      enabled: widget.enabled ,
    );
  }
}
