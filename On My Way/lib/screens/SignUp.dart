import 'dart:io';

import 'package:covoiturage_app/contollers/UserController.dart';
import 'package:covoiturage_app/models/User.dart';
import 'package:covoiturage_app/services/Util.dart';
import 'package:covoiturage_app/widgets/CustomTextField.dart';
import 'package:covoiturage_app/widgets/MyButton.dart';
import 'package:covoiturage_app/widgets/ShowSnackBar.dart';
import 'package:covoiturage_app/widgets/animatedRoute.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:getflutter/getflutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'SignIn.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _autoValidate = false;
  TextEditingController birthDayController;
  String email, username, password, city, birthday;

  File _image;
  bool disable = false;
  bool isLoading = false;
  DateTime selectedDate = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900, 1),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        birthDayController.text = DateFormat('yyyy-MM-dd').format(picked);
        birthday = DateFormat('yyyy-MM-dd').format(picked);
      });
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      this._image = image;
    });
  }

  @override
  void initState() {
    super.initState();
    birthDayController = new TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    birthDayController.dispose();
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

  void submit() async {
    if (validateForm()) {
      _formKey.currentState.save();
      User user = new User(
        email: this.email.trim(),
        city: this.city,
        birthDay: Util.convertToDateTime(birthDayController.text),
        username: this.username,
        password: Util.hashPass(this.password),
      );
      print("Image selected : ${_image.path}");
      UserController controller = new UserController(user: user);
      this.setState(() {
        isLoading = true;
      });
      bool result = false;
      await controller.signUp(this._image).then((value) => result = value);
      this.setState(() {
        isLoading = false;
      });
      result == true
          ? {
              _scaffoldKey.currentState.showSnackBar(
                SnackBar(
                  content: new ShowSnackBar(
                    color: Colors.green,
                    msg: "User sign up sucessefully",
                  ),
                ),
              ),
              sleep(new Duration(milliseconds: 5)),
              Navigator.pushReplacement(context, ScaleRoute(page: SignIn())),
            }
          : {
              _scaffoldKey.currentState.showSnackBar(
                SnackBar(
                  content: new ShowSnackBar(
                    color: Colors.red,
                    msg: "Probleme while sign up",
                  ),
                ),
              )
            };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 2.5,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height / 3,
                          decoration: new BoxDecoration(
                            color: Colors.blue[350],
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue[400],
                                Colors.blue[300],
                                Colors.blue[200],
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 60,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 2,
                                height: 100,
                                decoration: new BoxDecoration(
                                  border: Border.all(color: Colors.blue),
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: _image == null
                                    ? new FlatButton(
                                        onPressed: this.getImage,
                                        child: Icon(
                                          Icons.add_photo_alternate,
                                          color: Colors.blue[500],
                                          size: 30,
                                        ),
                                      )
                                    : GFImageOverlay(
                                        boxFit: BoxFit.cover,
                                        shape: BoxShape.circle,
                                        image: Image.file(_image).image,
                                      ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 180,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 2,
                                height: 60,
                                decoration: new BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                  border: Border.all(color: Colors.blue),
                                  color: Colors.white,
                                ),
                                child: new FlatButton(
                                  onPressed: null,
                                  child: Text(
                                    'SIGN UP',
                                    style: TextStyle(
                                        fontSize: 30.0, color: Colors.blue),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: <Widget>[
                            new CustomTextField(
                              icon: Icon(Icons.email),
                              hint: "Email",
                              validator: (v) {
                                Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+'
                                    r'(\.[^<>()[\]\\.,;:\s@\"]+)*)|'
                                    r'(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.'
                                    r'[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)'
                                    r'+[a-zA-Z]{2,}))$';
                                RegExp regex = new RegExp(pattern);
                                if (v.length == 0) return "* require";
                                if (!regex.hasMatch(v))
                                  return 'Enter Valid Email';
                              },
                              onSaved: (newValue) => email = newValue,
                            ),
                            new CustomTextField(
                              icon: Icon(Icons.perm_identity),
                              hint: "Username",
                              validator: (v) {
                                // Pattern pattern = r'(^[A-Za-z0-9]+$)';
                                // RegExp regex = new RegExp(pattern);
                                if (v.length == 0) return "* require";
                                // if (!regex.hasMatch(v))
                                //   return 'Enter Valid username (just characteres and numbers)';
                              },
                              onSaved: (newValue) => username = newValue,
                            ),
                            new CustomTextField(
                              icon: Icon(Icons.vpn_key),
                              hint: "Password",
                              obsecure: true,
                              validator: (v) {
                                if (v.length == 0) return "* require";
                                if (v.length < 6)
                                  return 'Password can\'t be less then 6 characteres  ';
                              },
                              onSaved: (newValue) => password = newValue,
                            ),
                            new CustomTextField(
                              icon: Icon(Icons.place),
                              hint: "City",
                              validator: (v) {
                                if (v.length == 0) return "* require";
                              },
                              onSaved: (newValue) => city = newValue,
                            ),
                            new CustomTextField(
                              textEditingController: birthDayController,
                              read: true,
                              icon: Icon(Icons.calendar_today),
                              hint: "Birth day",
                              tap: () => _selectDate(context),
                              validator: (b) {
                                if (b.length == 0) return "* require";
                              },
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            MyButton("Sign up", 2, () => submit()),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
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
    );
  }
}
