import 'package:covoiturage_app/widgets/NavigationDrawer.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(5),
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Container(
              width: double.maxFinite,
              decoration: new BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.grey[350],
                    Colors.grey[200],
                    Colors.white,
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 1.5,
                          child: ListTile(
                            title: Text(
                              "walid",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w300,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 20,
                              backgroundImage:
                                  AssetImage("assets/images/user.png"),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: Icon(
                            Icons.notifications,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 200,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 50, right: 25),
                      child: Text(
                        "walid send a messge",
                        softWrap: true,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 50, right: 50),
                      child: Divider(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      drawer: NavigationDrawer(),
    );
  }
}
