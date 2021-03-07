import 'package:covoiturage_app/models/navItems.dart';
import 'package:covoiturage_app/screens/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() { 
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NavItems>.value(
      value: NavItems(),
      child: MaterialApp(
        title: 'Covoiturage',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
