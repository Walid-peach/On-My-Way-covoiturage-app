import 'package:covoiturage_app/contollers/PostController.dart';
import 'package:covoiturage_app/helper/size_config.dart';
import 'package:covoiturage_app/models/Post.dart';
import 'package:covoiturage_app/models/navItems.dart';
import 'package:covoiturage_app/screens/Profile.dart';
import 'package:covoiturage_app/screens/UpdatePost.dart';
import 'package:covoiturage_app/widgets/NavigationDrawer.dart';
import 'package:covoiturage_app/widgets/SearchField.dart';
import 'package:covoiturage_app/widgets/ShowSnackBar.dart';
import 'package:covoiturage_app/widgets/TitledBottomNavigationBar.dart';
import 'package:covoiturage_app/widgets/animatedRoute.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:covoiturage_app/services/Util.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State<Home> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  final PostController postController = new PostController();
  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  List<Post> filterPosts = new List();
  List<Post> posts = new List();
  bool isLoading = true;
  bool showButtomAppBar = true;

  void getAllPost() {
    postController.getAllPosts().then((value) => {
          posts = value,
          filterPosts = value,
          this.setState(() => isLoading = false),
        });
  }

  @override
  void initState() {
    super.initState();
    this.getAllPost();
  }

/* //  didChangeDependencies
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Firestore.instance.collection("posts").snapshots().listen((result) {
      result.documentChanges.forEach((res) {
        if (res.type == DocumentChangeType.added) {
          print("added");
          print(res.document.data);
        } else if (res.type == DocumentChangeType.modified) {
          print("modified");
          print(res.document.data);
        } else if (res.type == DocumentChangeType.removed) {
          print("removed");
          print(res.document.data);
        }
      });
    });
  }
 */
  _changeStateOfTextField() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filterPosts = posts;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  void delete(Post p) async {
    Navigator.pop(context);
    bool result = false;
    this.setState(() => isLoading = true);
    await postController.deletePost(p).then((value) => result = value);
    this.posts.remove(p);
    this.setState(() => isLoading = false);
    result == true ? succesDeletingPost() : problemDeletingPost();
  }

  Set<ScaffoldFeatureController<SnackBar, SnackBarClosedReason>>
      problemDeletingPost() {
    return {
      _globalKey.currentState.showSnackBar(
        SnackBar(
          content: new ShowSnackBar(
            color: Colors.red,
            msg: "Probleme while deleting your post",
          ),
        ),
      )
    };
  }

  Set<Future<Set<ScaffoldFeatureController<SnackBar, SnackBarClosedReason>>>>
      succesDeletingPost() {
    return {
      Future.delayed(new Duration(milliseconds: 1)).then((value) => {
            _globalKey.currentState.showSnackBar(
              SnackBar(
                content: new ShowSnackBar(
                  color: Colors.green,
                  msg: "Post deleted sucessefully",
                ),
              ),
            ),
          }),
    };
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var titleProvider = Provider.of<NavItems>(context);

    if (_searchText.length > 0) {
      List<Post> tempList = new List();
      for (int i = 0; i < filterPosts.length; i++) {
        if (filterPosts[i].from.toLowerCase().contains(_searchText) ||
            filterPosts[i].to.toLowerCase().contains(_searchText)) {
          tempList.add(filterPosts[i]);
        }
      }
      this.setState(() {
        filterPosts = tempList;
      });
    }
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text(titleProvider.items[0].title),
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => this._globalKey.currentState.openDrawer(),
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
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new SearchField(_filter, _changeStateOfTextField),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filterPosts.length,
                    itemBuilder: (context, index) =>
                        this.buildCardPost(filterPosts[index]),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: TitledBottomNavigationBar(),
      drawer: NavigationDrawer(),
    );
  }

  Widget buildCardPost(Post p) {
    return Card(
      margin: EdgeInsets.only(top: 4),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ClipRRect(
        child: Banner(
          color: p.price == null ? Colors.green : Colors.blue,
          location: BannerLocation.topStart,
          message: p.price == null ? "Demande" : "Offre",
          child: Container(
            margin: EdgeInsets.only(bottom: 4),
            padding: EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(6),
                  bottomLeft: Radius.circular(6)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      isThreeLine: true,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () => Navigator.push(
                              context,
                              SlideRightRoute(
                                page: ProfilePage(user: p.user),
                              ),
                            ),
                            child: Text(
                              p.user.username,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _globalKey.currentState.showBottomSheet(
                                // context: context,
                                // builder:
                                (context) {
                                  return Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              4,
                                      decoration: new BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10.0),
                                            topLeft: Radius.circular(10.0)),
                                        color: Colors.grey,
                                      ),
                                      child: Column(
                                        children: [
                                          ListTile(
                                            onTap: () {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                context,
                                                SizeRoute(
                                                  page: UpdatePost(
                                                    post: p,
                                                  ),
                                                ),
                                              );
                                            },
                                            title: Text(
                                              'update your post',
                                              style: GoogleFonts.getFont(
                                                  'Source Code Pro'),
                                            ),
                                            trailing: Icon(Icons.create),
                                          ),
                                          Divider(
                                            thickness: 1,
                                          ),
                                          ListTile(
                                            onTap: () {
                                              Navigator.pop(context);
                                              _showDialog(p);
                                            },
                                            title: Text(
                                              'delete your post',
                                              style: GoogleFonts.getFont(
                                                  'Source Code Pro'),
                                            ),
                                            trailing: Icon(Icons.delete),
                                          ),
                                        ],
                                      ));
                                },
                              );
                            },
                            child: Text(
                              '...',
                              style: TextStyle(
                                fontSize: 20,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Wrap(
                          alignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              p.from.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87),
                            ),
                            Text("   ---"),
                            Icon(Icons.arrow_right),
                            Text(
                              p.to.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87),
                            ),
                            RichText(
                              text: TextSpan(
                                  text: "Time : ",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                  children: [
                                    TextSpan(
                                      text: Util.convertDateToString(p.date) +
                                          " / " +
                                          Util.convertTimeToString(p.time),
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black),
                                    )
                                  ]),
                            ),
                            SizedBox(
                              width: 50,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: TextSpan(
                                      text: "Places :",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87),
                                      children: [
                                        TextSpan(
                                          text: p.nbrPlaces.toString(),
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black87),
                                        )
                                      ]),
                                ),
                                p.price != null
                                    ? RichText(
                                        text: TextSpan(
                                            text: "Price  :",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black87),
                                            children: [
                                              TextSpan(
                                                text: p.price ?? '',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black87),
                                              )
                                            ]),
                                      )
                                    : Container(),
                              ],
                            )
                          ],
                        ),
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 20,
                        backgroundImage: p.user.profileImg == null
                            ? AssetImage('assets/images/user.png')
                            : NetworkImage(p.user.profileImg),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Divider(
                      height: 5,
                      color: Colors.grey.shade600,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDialog(Post p) {
    final theme = Theme.of(context);
    final dialogTextStyle = theme.textTheme.bodyText1
        .copyWith(color: theme.textTheme.caption.color);
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: Text(
            "Are you sure to delete your post ?",
            style: dialogTextStyle,
          ),
          actions: [
            FlatButton(
              onPressed: () => this.delete(p),
              child: Text("confirme"),
            ),
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("cancel"),
            ),
          ],
        );
      },
    );
  }
}
