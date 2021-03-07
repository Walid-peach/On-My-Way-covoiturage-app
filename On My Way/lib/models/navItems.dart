import 'package:covoiturage_app/screens/Friends.dart';
import 'package:covoiturage_app/screens/Home.dart';
import 'package:covoiturage_app/screens/Trajet.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class Item {
  final int id;
  final String title;
  final IconData icon;
  final Widget destination;
  Item(this.id, this.title, this.icon, this.destination);
}

class NavItems extends ChangeNotifier {
  int selectedIndex = 0;
  int lastIndex = 0;
  void chnageNavIndex({int index}) {
    if (index != null) {
      lastIndex = selectedIndex;
      selectedIndex = index;
    }
    // if any changes made it notify widgets that use the value
    notifyListeners();
  }

  List<Item> items = [
    new Item(0, 'Home', Icons.home, Home()),
    new Item(1, 'Trajet', Icons.add_circle_outline, Trajet()),
    new Item(2, 'Friends', Icons.group, Friends()),
  ];
}
