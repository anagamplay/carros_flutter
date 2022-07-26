import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  String text;
  var boxColor;
  var onPressed;

  bool showProgress;

  AppButton(this.text, {this.onPressed, this.showProgress = false, this.boxColor,});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: boxColor),
        child: showProgress
          ? Center(child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
            )
          : Text(
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
