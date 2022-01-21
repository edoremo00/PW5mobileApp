// ignore_for_file: prefer_const_constructors_in_immutables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:getfitappmobile/core.dart';

class CustomFormField extends StatelessWidget {
  final TextEditingController? controller;
  final bool? autofocus;
  final AutovalidateMode? autovalidateMode;
  final Color? cursorColor;
  final FocusNode? focusNode;
  final bool? obscureText;
  final bool? readOnly;
  void Function(String)? onChanged;
  void Function(String?)? onSaved;
  void Function()? onTap;
  final String? Function(String?)? validator;
  final String? helpertext;
  final Color? enabledBorderColor;
  final Color? focusedBorderColor;
  final String? labelText;
  final String? hintText;
  final Widget? suffixicon;
  final TextInputType? keyboardType;
  final TextAlign? textAlignCenter;

  CustomFormField(
      {Key? key,
      this.helpertext,
      this.controller,
      this.autofocus,
      this.readOnly,
      this.autovalidateMode,
      this.cursorColor,
      this.focusNode,
      this.obscureText,
      this.onChanged,
      this.validator,
      this.enabledBorderColor,
      this.focusedBorderColor,
      this.labelText,
      this.hintText,
      this.onTap,
      this.onSaved,
      this.textAlignCenter,
      this.keyboardType,
      this.suffixicon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      autofocus: autofocus ?? false,
      readOnly: readOnly ?? false,
      autovalidateMode: autovalidateMode,
      controller: controller,
      cursorColor: cursorColor ?? kFirstColor,
      focusNode: focusNode,
      obscureText: obscureText ?? false,
      onChanged: onChanged,
      onSaved: onSaved,
      onTap: onTap,
      textAlign: textAlignCenter ?? TextAlign.start,
      validator: validator,
      decoration: InputDecoration(
        helperText: helpertext,
        helperMaxLines: 3,
        hintText: hintText,
        labelText: labelText,
        labelStyle: const TextStyle(
          color: kLabelColor,
          fontSize: 18,
        ),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
          color: enabledBorderColor ?? kLabelColor,
        )),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
          color: focusedBorderColor ?? Colors.white,
        )),
        suffixIcon: suffixicon,
        //suffixIconColor: kLabelColor,
      ),
    );
  }
}
