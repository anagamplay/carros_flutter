import 'package:flutter/material.dart';

class AppText extends StatelessWidget {

  String label;
  String? hint;
  bool password;
  TextEditingController? controller;
  FormFieldValidator<String>? validator;
  TextInputType? keyboardType;
  TextInputAction? textInputAction;
  FocusNode? focusNode;
  FocusNode? nextFocus;
  IconData? icon;
  bool autofocus;

  AppText(
    this.label,
    this.hint, {
    this.password = false,
    this.controller,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.focusNode,
    this.nextFocus,
    this.icon,
    this.autofocus = false,
  });

  FocusNode? get _focusSenha => null;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: password,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      focusNode: focusNode,
      autofocus: autofocus,
      onFieldSubmitted: (String text) {
        if (nextFocus != null) {
          FocusScope.of(context).requestFocus(_focusSenha);
        }
      },
      style: TextStyle(
        fontSize: 16,
        height: 1,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.grey,
          ),
          hintText: hint,
          ),
    );
  }
}
