import 'package:covoiturage_app/helper/size_config.dart';
import 'package:flutter/material.dart';

class InputPassword extends StatefulWidget {
  InputPassword(this.editPasswordController, this.margin);
  bool shwoPassword = true;
  double margin;
  TextEditingController editPasswordController;
  @override
  _InputPasswordState createState() => _InputPasswordState();
}

class _InputPasswordState extends State<InputPassword> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: SizeConfig.screenWidth / 1.2,
        height: 45,
        margin: EdgeInsets.only(top: widget.margin),
        padding: EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]),
        child: TextField(
          controller: widget.editPasswordController,
          obscureText: widget.shwoPassword,
          keyboardType: TextInputType.visiblePassword,
          autocorrect: true,
          style: TextStyle(
            color: Colors.blue,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            icon: Icon(
              Icons.vpn_key,
              color: Colors.blue[600],
            ),
            suffixIcon: IconButton(
              icon: (this.widget.shwoPassword == true)
                  ? Icon(
                      Icons.visibility_off,
                      color: Colors.blue[600],
                    )
                  : Icon(
                      Icons.visibility,
                      color: Colors.blue[600],
                    ),
              onPressed: () => {
                this.setState(() => widget.shwoPassword = !widget.shwoPassword)
              },
            ),
            hintText: 'Password',
            hintStyle: TextStyle(color: Colors.blue),
          ),
        ));
  }
}
