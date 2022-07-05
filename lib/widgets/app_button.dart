import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  String text;
  var onPressed;

  AppButton(this.text, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      child: RaisedButton(
        color: Colors.blue,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
