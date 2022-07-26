import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  String text;
  var backgroundColor;
  var onPressed;

  bool showProgress;

  AppButton(this.text, {this.onPressed, this.showProgress = false, this.backgroundColor,});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: backgroundColor,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        child: Text(
              text,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
        onPressed: onPressed,
      ),
    );
  }
}
