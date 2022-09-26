// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AuthFormField extends StatefulWidget {
  AuthFormField({
    Key? key,
    required this.label,
    this.initialValue,
    this.validator,
    this.onChanged,
    this.obscureText = false,
    this.textInputType = TextInputType.name,
    this.padding = 10,
    this.fontSize = 16,
  }) : super(key: key);

  final String label;
  final dynamic initialValue;
  bool obscureText;
  final TextInputType textInputType;
  final double padding;
  final double fontSize;
  final String Function(String?)? validator;
  final Function(String?)? onChanged;
  @override
  State<AuthFormField> createState() => _AuthFormFieldState();
}

class _AuthFormFieldState extends State<AuthFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        initialValue: widget.initialValue,
        validator: widget.validator,
        obscureText: widget.obscureText,
        onChanged: widget.onChanged,
        cursorColor: Colors.grey,
        style: TextStyle(fontSize: widget.fontSize),
        decoration: InputDecoration(
          suffixIcon: widget.textInputType == TextInputType.visiblePassword
              ? IconButton(
                  splashRadius: 1,
                  icon: FaIcon(
                    widget.obscureText
                        ? FontAwesomeIcons.eyeSlash
                        : FontAwesomeIcons.eye,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      widget.obscureText = !widget.obscureText;
                    });
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          hintText: widget.label,
          hintStyle: TextStyle(fontSize: widget.fontSize),
          isDense: true,
          contentPadding: EdgeInsets.only(
            top: widget.padding,
            bottom: widget.padding,
            left: 20,
            right: 20,
          ),
          errorStyle: TextStyle(
            color: Colors.red,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(
              width: 1,
              color: Color(0xFFE3E3E3),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(
              width: 1,
              color: Color(0xFFE3E3E3),
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(
              width: 1,
              color: Colors.red,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(
              width: 1,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
