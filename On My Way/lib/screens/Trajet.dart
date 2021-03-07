import 'dart:io';

import 'package:covoiturage_app/contollers/PostController.dart';
import 'package:covoiturage_app/contollers/UserSession.dart';
import 'package:covoiturage_app/helper/size_config.dart';
import 'package:covoiturage_app/models/Post.dart';
import 'package:covoiturage_app/models/User.dart';
import 'package:covoiturage_app/models/navItems.dart';
import 'package:covoiturage_app/services/Util.dart';
import 'package:covoiturage_app/widgets/CustomTextField.dart';
import 'package:covoiturage_app/widgets/MyButton.dart';
import 'package:covoiturage_app/widgets/NavigationDrawer.dart';
import 'package:covoiturage_app/widgets/ShowSnackBar.dart';
import 'package:covoiturage_app/widgets/TitledBottomNavigationBar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';

enum TypeClient { Passager, Conducteur }

class Trajet extends StatefulWidget {
  @override
  _TrajetState createState() => _TrajetState();
}

class _TrajetState extends State<Trajet> {
  TypeClient _client = TypeClient.Conducteur;
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _autoValidate = false;
  bool isLoading = false;

  PostController _postController;
  UserSession _userSession;
  var uuid = Uuid();
  String from, to, time, date, price, description;
  int nbrPlaces;
  User currentUser;
  File _image;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _postController = new PostController();
    _userSession = new UserSession();
    _userSession.getCurrentUser().then((user) => currentUser = user);
  }

  TextEditingController _time = new TextEditingController();
  TextEditingController _date = new TextEditingController();

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      _image = image;
      if (_image != null) {
        throw new Exception("Could not pick image from galery");
      }
    });
  }

  Future getImageFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState(() {
      _image = image;
      if (_image != null) {
        throw new Exception("Could not pick image from camera");
      }
    });
  }

  Future<Null> selectedTime(BuildContext context) async {
    final Future<TimeOfDay> selectedTime = showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
    selectedTime.then((value) => {
          _time.text = value.format(context),
          time = value.format(context),
        });
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(new Duration(days: 360)),
      // lastDate:DateTime.now().add(new Duration(days: 360)),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _date.text = DateFormat('yyyy-MM-dd').format(picked);
        date = DateFormat('yyyy-MM-dd').format(picked);
      });
  }

  bool validateForm() {
    if (!_formKey.currentState.validate()) {
      this.setState(() {
        _autoValidate = true;
      });
      return false;
    }
    return true;
  }

  void submitPost() async {
    if (validateForm()) {
      _formKey.currentState.save();
      Post post = getPostFromInputs();
      _postController.setPost(post);
      bool result = false;
      this.setState(() => isLoading = true);
      await _postController.createPost().then((value) => result = value);
      this.setState(() => isLoading = false);
      result == true ? sucessMessage() : problemMessage();
    }
  }

  Set<ScaffoldFeatureController<SnackBar, SnackBarClosedReason>>
      problemMessage() {
    return {
      _globalKey.currentState.showSnackBar(
        SnackBar(
          content: new ShowSnackBar(
            color: Colors.red,
            msg: "Probleme while Creating a new Post",
          ),
        ),
      )
    };
  }

  Set<Future<Set<void>>> sucessMessage() {
    return {
      Future.delayed(new Duration(milliseconds: 5)).then((value) => {
            _globalKey.currentState.showSnackBar(
              SnackBar(
                content: new ShowSnackBar(
                  color: Colors.green,
                  msg: "Post created sucessefully",
                ),
              ),
            ),
            _formKey.currentState.reset(),
          }),
    };
  }

  Post getPostFromInputs() {
    Post post = new Post(
        id: uuid.v1(),
        date: Util.convertToDateTime(date),
        nbrPlaces: nbrPlaces,
        from: from,
        price: price,
        to: to,
        time: Util.convertToTime(time),
        user: currentUser);
    return post;
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
          builder: (context, value, child) => Text(value.items[1].title),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              decoration: new BoxDecoration(),
              child: Form(
                key: _formKey,
                autovalidate: _autoValidate,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: RadioListTile<TypeClient>(
                              // autofocus: true,
                              activeColor: Colors.blueAccent,
                              title: Text("Passager"),
                              value: TypeClient.Passager,
                              groupValue: _client,
                              onChanged: (TypeClient typeClient) =>
                                  this.setState(() {
                                    _client = typeClient;
                                  })),
                        ),
                        Flexible(
                          child: RadioListTile<TypeClient>(
                              activeColor: Colors.blueAccent,
                              title: Text("Conducteur"),
                              value: TypeClient.Conducteur,
                              groupValue: _client,
                              onChanged: (TypeClient typeClient) =>
                                  this.setState(() {
                                    _client = typeClient;
                                  })),
                        ),
                      ],
                    ),
                    new CustomTextField(
                      icon: Icon(Icons.time_to_leave),
                      hint: "From ",
                      validator: (v) {
                        if (v.length == 0) return "* require";
                      },
                      onSaved: (newValue) => from = newValue,
                    ),
                    new CustomTextField(
                      icon: Icon(Icons.assistant_photo),
                      hint: "To ",
                      validator: (v) {
                        if (v.length == 0) return "* require";
                      },
                      onSaved: (newValue) => to = newValue,
                    ),
                    new CustomTextField(
                      textEditingController: _time,
                      read: true,
                      icon: Icon(Icons.access_time),
                      hint: "Time ",
                      tap: () => this.selectedTime(context),
                      validator: (b) {
                        if (b.length == 0) return "* require";
                      },
                    ),
                    new CustomTextField(
                      textEditingController: _date,
                      read: true,
                      icon: Icon(Icons.data_usage),
                      hint: "Date ",
                      tap: () => _selectDate(context),
                      validator: (b) {
                        if (b.length == 0) return "* require";
                      },
                    ),
                    new CustomTextField(
                      onSaved: (val) => nbrPlaces = int.parse(val),
                      icon: Icon(Icons.format_list_numbered),
                      hint: "Number of place ",
                      validator: (b) {
                        if (b.length == 0) return "* require";
                      },
                    ),
                    _client == TypeClient.Passager
                        ? Container()
                        : new CustomTextField(
                            icon: Icon(Icons.monetization_on),
                            hint: "Price ",
                            validator: (v) {
                              if (v.length == 0) return "* require";
                            },
                            onSaved: (newValue) => price = newValue,
                          ),
                    new SizedBox(
                      height: 22,
                    ),
                    MyButton("Post", 2, submitPost),

                    // Wrap(
                    //   spacing: 8.0,
                    //   runSpacing: 10,
                    //   crossAxisAlignment: WrapCrossAlignment.start,
                    //   alignment: WrapAlignment.spaceEvenly,
                    //   children: [
                    //     _image == null
                    //         ? Container(
                    //             width: size.width / 3,
                    //             child: Row(
                    //               children: [
                    //                 new IconButton(
                    //                   icon: new Icon(Icons.add_photo_alternate),
                    //                   onPressed: getImage,
                    //                   color: new Color(0xff203152),
                    //                 ),
                    //                 new IconButton(
                    //                   icon: new Icon(Icons.add_a_photo),
                    //                   onPressed: getImageFromCamera,
                    //                   color: new Color(0xff203152),
                    //                 ),
                    //               ],
                    //             ),
                    //           )
                    //         : Container(
                    //             width: size.width / 3,
                    //             child: Text(
                    //               _image.absolute.path,
                    //               softWrap: true,
                    //               overflow: TextOverflow.ellipsis,
                    //             )),
                    //     // new SizedBox(width: 180,),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            child: isLoading
                ? Container(
                    child: Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor)),
                    ),
                    color: Colors.white.withOpacity(0.8),
                  )
                : Container(),
          ),
        ],
      ),
      bottomNavigationBar: TitledBottomNavigationBar(),
      drawer: NavigationDrawer(),
    );
  }
}
