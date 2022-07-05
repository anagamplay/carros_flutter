import 'package:flutter/material.dart';

Future push(BuildContext context, Widget page) async {
  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
    return page;
  }));
}