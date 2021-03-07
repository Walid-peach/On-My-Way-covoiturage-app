import 'package:covoiturage_app/contollers/UserSession.dart';
import 'package:covoiturage_app/models/User.dart';
import 'package:covoiturage_app/screens/Profile.dart';
import 'package:covoiturage_app/widgets/NavigationDrawer.dart';
import 'package:covoiturage_app/widgets/animatedRoute.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _lights = false;
  bool _sendNotification = false;
  UserSession userSession;
  User user;
  @override
  void initState() {
    super.initState();
    userSession = new UserSession();
    userSession
        .getCurrentUser()
        .then((value) => this.setState(() => user = value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.90),
      appBar: PreferredSize(
        child: AppBar(),
        preferredSize: Size.fromHeight(40),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 20),
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Container(
                height: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(6),
                      bottomLeft: Radius.circular(6)),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ListTile(
                        title: Text(user == null ? '' : user.username),
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 30,
                          backgroundImage: user == null
                              ? AssetImage("assets/images/user.png")
                              : NetworkImage(user.profileImg),
                        ),
                      ),
                      Divider(thickness: 1),
                      FlatButton(
                          onPressed: () => Navigator.push(
                                context,
                                SlideRightRoute(page: ProfilePage(user: user)),
                              ),
                          child: Text("Show profil"))
                    ]),
              ),
            ),
            Align(
              child: Text(
                "GENERAL SETTINGS".toUpperCase(),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
              ),
              alignment: Alignment.center,
            ),
            Card(
              margin: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 20),
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(6),
                      bottomLeft: Radius.circular(6)),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ListTile(
                        title: Text("Edit Profile"),
                        leading: Icon(Icons.person),
                        trailing: IconButton(
                            icon: Icon(Icons.arrow_forward_ios),
                            onPressed: null),
                      ),
                      Divider(),
                      ListTile(
                        title: Text("Change Password"),
                        leading: Icon(Icons.vpn_key),
                        trailing: IconButton(
                            icon: Icon(Icons.arrow_forward_ios),
                            onPressed: null),
                      ),
                      Divider(),
                      SwitchListTile(
                        title: Text("Notification"),
                        value: _sendNotification,
                        onChanged: (bool value) {
                          setState(() {
                            _sendNotification = value;
                          });
                        },
                        secondary: const Icon(Icons.notifications),
                      ),
                      Divider(),
                      SwitchListTile(
                        title: Text("Dark mode"),
                        value: _lights,
                        onChanged: (bool value) {
                          setState(() {
                            _lights = value;
                          });
                        },
                        secondary: const Icon(Icons.brightness_2),
                      ),
                      Divider(),
                      ListTile(
                        title: Text("Help"),
                        leading: Icon(Icons.help),
                        trailing: IconButton(
                            icon: Icon(Icons.arrow_forward_ios),
                            onPressed: null),
                      ),
                    ]),
              ),
            ),
          ],
        ),
      ),
      drawer: NavigationDrawer(),
    );
  }
}
