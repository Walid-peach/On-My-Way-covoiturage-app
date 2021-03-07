import 'package:covoiturage_app/helper/size_config.dart';
import 'package:covoiturage_app/models/navItems.dart';
import 'package:covoiturage_app/widgets/animatedRoute.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TitledBottomNavigationBar extends StatelessWidget {
  TitledBottomNavigationBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double defaultSize = SizeConfig.defaultSize;

    return Consumer<NavItems>(
      builder: (context, navItems, child) => WillPopScope(
        onWillPop: () async {
          navItems.chnageNavIndex(index: navItems.lastIndex);
          return true;
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: defaultSize * 3), //30
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: Offset(0, -7),
                blurRadius: 30,
                color: Color(0xFF4B1A39).withOpacity(0.2),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                navItems.items.length,
                (index) => buildIconNavBarItem(
                  isActive: (navItems.selectedIndex == index) ? true : false,
                  icon: navItems.items[index].icon,
                  press: () {
                    navItems.chnageNavIndex(index: index);
                    Navigator.push(
                      context,
                      SlideRightRoute(page: navItems.items[index].destination),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

IconButton buildIconNavBarItem(
    {IconData icon, Function press, bool isActive = false}) {
  return IconButton(
    icon: Icon(
      icon,
      // color: isActive ? Color(0xFF84AB5C) : Color(0xFFD1D4D4),
      color: isActive ? Colors.blue[200] : Color(0xFFD1D4D4),
      size: 22,
    ),
    onPressed: press,
  );
}
