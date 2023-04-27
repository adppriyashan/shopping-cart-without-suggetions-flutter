import 'package:flutter/material.dart';

class CustomTextArea extends StatefulWidget {
  Color background_color;
  String hint_text;
  Color hint_text_color;
  double maxlines;
  TextEditingController controller;

  CustomTextArea({
    Key? key,
    required this.background_color,
    required this.hint_text,
    required this.hint_text_color,
    required this.maxlines,
    required this.controller
  }) : super(key: key);

  @override
  State<CustomTextArea> createState() => _CustomTextAreaState(
      background_color: background_color,
      hint_text: hint_text,
      hint_text_color: hint_text_color,
      maxlines: maxlines,
      controller : controller);
}

class _CustomTextAreaState extends State<CustomTextArea> {
  Color background_color;
  String hint_text;
  Color hint_text_color;
  double maxlines;
  TextEditingController controller;

  _CustomTextAreaState({
    required this.background_color,
    required this.hint_text,
    required this.hint_text_color,
    required this.maxlines,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        color: background_color,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 20.0, right: 10.0),
          child: TextField(
            controller: controller,
            maxLines: 5,
            decoration: InputDecoration.collapsed(
                hintText: hint_text,
                hintStyle: TextStyle(
                    fontFamily: 'Raleway-SemiBold', color: hint_text_color)),
          ),
        ));
  }
}
