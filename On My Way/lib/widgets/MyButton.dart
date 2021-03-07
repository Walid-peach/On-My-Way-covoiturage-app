import 'package:covoiturage_app/helper/size_config.dart';
import 'package:flutter/material.dart';

@immutable
class MyButton extends StatelessWidget {
  MyButton(this.name, this.withSize, this.click);
  final String name;
  final double withSize;
  final Function click;

  @override
  Widget build(BuildContext context) {
    new SizeConfig().init(context);
    return GestureDetector(
      onTap: click,
      child: Container(
        height: 45,
        width: SizeConfig.screenWidth / withSize,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue,
              Colors.blue[300],
            ],
          ),
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        child: Center(
          child: Text(
            name.toUpperCase(),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
