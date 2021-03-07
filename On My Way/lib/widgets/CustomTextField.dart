import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField(
      {this.icon,
      this.hint,
      this.obsecure = false,
      this.read = false,
      this.validator,
      this.onSaved,
      this.tap,
      this.textEditingController,
      this.initialValue});
  final FormFieldSetter<String> onSaved;
  final Function tap;
  final Icon icon;
  final String hint;
  final bool obsecure;
  final FormFieldValidator<String> validator;
  final TextEditingController textEditingController;
  final bool read;
  final String initialValue;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 5),
      child: TextFormField(
        initialValue: this.initialValue,
        readOnly: read,
        controller: this.textEditingController,
        onSaved: onSaved,
        validator: validator,
        autofocus: true,
        obscureText: obsecure,
        onTap: tap,
        style: TextStyle(
          fontSize: 15,
          color: Theme.of(context).primaryColor,
        ),
        decoration: InputDecoration(
            hintStyle: TextStyle(fontSize: 15, color: Colors.blue),
            hintText: hint,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 3,
              ),
            ),
            prefixIcon: Padding(
              child: IconTheme(
                data: IconThemeData(color: Theme.of(context).primaryColor),
                child: icon,
              ),
              padding: EdgeInsets.only(left: 30, right: 10),
            )),
      ),
    );
  }
}
