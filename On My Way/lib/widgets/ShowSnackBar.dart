import 'package:covoiturage_app/helper/size_config.dart';
import 'package:flutter/material.dart';

class ShowSnackBar extends StatelessWidget {
  ShowSnackBar({this.msg, this.color});
  final String msg;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: SizeConfig.screenWidth,
      decoration: new BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Center(
        child: Text(
          msg,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
        ),
      ),
    );
  }
}
