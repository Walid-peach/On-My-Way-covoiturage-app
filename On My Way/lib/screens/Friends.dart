import 'package:covoiturage_app/contollers/UserController.dart';
import 'package:covoiturage_app/helper/size_config.dart';
import 'package:covoiturage_app/models/User.dart';
import 'package:covoiturage_app/models/navItems.dart';
import 'package:covoiturage_app/screens/Messages.dart';
import 'package:covoiturage_app/widgets/NavigationDrawer.dart';
import 'package:covoiturage_app/widgets/StarDisplay.dart';
import 'package:covoiturage_app/widgets/TitledBottomNavigationBar.dart';
import 'package:covoiturage_app/widgets/animatedRoute.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Friends extends StatefulWidget {
  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  List<User> users = new List();
  UserController _userController;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _userController = new UserController();
    _userController.getUsers().then(
          (value) => this.setState(() => {users = value, isLoading = false}),
        );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => this._globalKey.currentState.openDrawer(),
        ),
        centerTitle: true,
        title: Consumer<NavItems>(
          builder: (context, value, child) => Text(value.items[2].title),
        ),
      ),
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor)),
              ),
              color: Colors.white.withOpacity(0.8),
            )
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return Container(
                  width: double.maxFinite,
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: ListTile(
                                title: Text(
                                  users[index].username,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                subtitle: StarDisplay(
                                    value: users[index].rank.toInt()),
                                leading: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 20,
                                    backgroundImage: users[index] == null
                                        ? AssetImage("assets/images/user.png")
                                        : NetworkImage(
                                            users[index].profileImg)),
                              ),
                            ),
                            Spacer(
                              flex: 2,
                            ),
                            Center(
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 35,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.message,
                                    color: Colors.blue[200],
                                  ),
                                  onPressed: () => Navigator.push(
                                    context,
                                    SlideRightRoute(
                                      page: Chat(
                                        peerId: users[index].id,
                                        peerAvatar: users[index].profileImg,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 150,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 50),
                          child: Divider(
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: TitledBottomNavigationBar(),
      drawer: NavigationDrawer(),
    );
  }
}
