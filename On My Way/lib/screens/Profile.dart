import 'package:covoiturage_app/models/User.dart';
import 'package:covoiturage_app/services/Util.dart';
import 'package:covoiturage_app/widgets/NavigationDrawer.dart';
import 'package:covoiturage_app/widgets/StarDisplay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  ProfilePage({this.user});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String image;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.user != null)
      this.setState(() {
        isLoading = false;
      });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: new BoxDecoration(
          color: Colors.blue.withOpacity(0.12),
        ),
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 16.0),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(18.0),
                  margin: EdgeInsets.only(top: 15.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          widget.user.username,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        leading: widget.user == null
                            ? Image(image: AssetImage(image))
                            : CircleAvatar(
                                backgroundImage:
                                    NetworkImage(widget.user.profileImg),
                                radius: 30,
                              ),
                      ),
                      /*   SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Text("Posts"),
                                Text("0"),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Text("Comments"),
                                Text("0"),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Text("Favourites"),
                                Text("0"),
                              ],
                            ),
                          ),
                        ],
                      ), */
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                Divider(
                  thickness: 2,
                ),
                SizedBox(height: 20.0),
                Column(
                  children: <Widget>[
                    _buildCardWidget(widget.user.email, Icons.email),
                    _buildCardWidget(widget.user.city, Icons.location_city),
                    _buildCardWidget(
                        Util.convertDateToString(widget.user.birthDay),
                        Icons.calendar_today),
                    Card(
                      margin: EdgeInsets.all(10),
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        title: new StarDisplay(
                          value: widget.user.rank.toInt(),
                        ),
                        leading: Icon(
                          Icons.star,
                          color: Colors.blue[300],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: NavigationDrawer(),
    );
  }

  Widget _buildCardWidget(dynamic title, IconData icon) {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        title: Text(
          title,
          style: GoogleFonts.getFont(
            'Source Code Pro',
            textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
                fontSize: 13),
          ),
        ),
        leading: Icon(
          icon,
          color: Colors.blue[300],
        ),
      ),
    );
  }
}
