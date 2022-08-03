import 'package:flutter/material.dart';

abstract class DropDownItem {
  Icon text();
}

class DropDown<T extends DropDownItem> extends StatefulWidget {
  State? parent;
  List<T> itens = [];
  String text;
  T value;
  var callback;
  Color color;


  DropDown(this.itens, this.text, this.value, ValueChanged<T> this.callback, this.color);

  @override
  DropDownState createState() {
    return DropDownState();
  }
}

class DropDownState<T extends DropDownItem> extends State<DropDown> {

  @override
  Widget build(BuildContext context) {

    return DropdownButton<DropDownItem>(
      value: widget.value,
      isExpanded: false,
      items: items(),
      hint: Text(widget.text),
      onChanged: (newVal) {
        widget.callback(newVal);
      },
    );
  }

  items() {
    List<DropdownMenuItem<DropDownItem>> list = widget.itens.map<DropdownMenuItem<DropDownItem>>((val) {
      return DropdownMenuItem<DropDownItem>(
        value: val,
        child: val.text(),
      );
    }).toList();

    return list;
  }
}
