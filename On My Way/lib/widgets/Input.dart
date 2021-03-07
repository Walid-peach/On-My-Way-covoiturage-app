import 'package:flutter/material.dart';

class Input extends StatefulWidget {
  Input(this.hint, this.iconType, this.margin, this.controller,
      {this.tap, this.disable});
  final String hint;
  final TextEditingController controller;
  final IconData iconType;
  final double margin;
  final Function tap;
  bool disable;

  @override
  _InputState createState() => _InputState();
}

class _InputState extends State<Input> {
  @override
  Widget build(BuildContext context) {
    this.widget.disable =
        this.widget.disable == null ? false : this.widget.disable;
    return Container(
      // width: this.widget.sizeWidth,
      width: MediaQuery.of(context).size.width / 1.2,
      height: 45,
      margin: EdgeInsets.only(top: widget.margin),
      padding: EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]),
      child: TextFormField(
        validator: (input) => input.isEmpty ? "*Required" : null,
        readOnly: this.widget.disable,
        onTap: this.widget.tap,
        controller: widget.controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(
            widget.iconType,
            color: Colors.blue[600],
          ),
          hintText: widget.hint,
          hintStyle: TextStyle(color: Colors.blue),
          errorStyle: TextStyle(color: Colors.red),
        ),
        style: TextStyle(color: Colors.blue[700]),
      ),
    );
  }
}
