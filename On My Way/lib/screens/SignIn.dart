import 'dart:io';

import 'package:covoiturage_app/contollers/UserController.dart';
import 'package:covoiturage_app/contollers/UserSession.dart';
import 'package:covoiturage_app/screens/Home.dart';
import 'package:covoiturage_app/screens/SignUp.dart';
import 'package:covoiturage_app/services/Util.dart';
import 'package:covoiturage_app/widgets/CustomTextField.dart';
import 'package:covoiturage_app/widgets/MyButton.dart';
import 'package:covoiturage_app/widgets/ShowSnackBar.dart';
import 'package:covoiturage_app/widgets/animatedRoute.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String _email, _password;
  bool isLoading = false;
  UserSession userSession;
  UserController controller;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _autoValidate = false;

  @override
  void initState() {
    super.initState();
    userSession = new UserSession();
    controller = new UserController();
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

  void signUp() {
    Navigator.push(context, SlideRightRoute(page: SignUp()));
  }

  void signIn() {
    final FormState form = _formKey.currentState;

    if (validateForm()) {
      form.save();
      String hashPassword = Util.hashPass(this._password);
      this.setState(() {
        isLoading = true;
      });
      controller.signIn(_email, hashPassword).then((value) => {
            print("Value retun from signIn methode : $value"),
            if (value == null)
              {
                this.setState(() {
                  isLoading = false;
                }),
                _scaffoldKey.currentState.showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.white,
                    content: new ShowSnackBar(
                      color: Colors.red,
                      msg: "email or password are wrong",
                    ),
                  ),
                ),
              }
            else
              {
                userSession.saveSessionUser(value).then((value) => {
                      print("User saved in sharedRefrences"),
                      this.setState(() {
                        isLoading = false;
                      }),
                      print("User authentified"),
                      sleep(new Duration(milliseconds: 5)),
                      Navigator.push(context, SlideRightRoute(page: Home()))
                    }),
              }
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 2,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        decoration: new BoxDecoration(
                            image: new DecorationImage(
                              image: new ExactAssetImage(
                                  "assets/images/road_cover.png"),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30)),
                            border: Border.all(
                                width: 2,
                                style: BorderStyle.solid,
                                color: Colors.blue[200])),
                      ),
                      Positioned(
                        top: 230,
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
                                  'SIGN IN',
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
                Form(
                  key: _formKey,
                  autovalidate: _autoValidate,
                  child: Column(
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
                              onSaved: (newValue) => {
                                _email = newValue,
                                print("New value in email field $newValue"),
                              },
                            ),
                            // Input("Email", Icons.email, 10, emailController),
                            // InputPassword(passwordController, 32),
                            new CustomTextField(
                              icon: Icon(Icons.vpn_key),
                              hint: "Password",
                              obsecure: true,
                              validator: (v) {
                                if (v.length == 0) return "* require";
                                if (v.length < 2)
                                  return 'Password can\'t be less then 6 characteres  ';
                              },
                              onSaved: (newValue) => _password = newValue,
                            ),
                            forgotPassword,
                            SizedBox(
                              height: 25,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                MyButton("sign in", 3, this.signIn),
                                MyButton("Sign up", 3, this.signUp),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
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

Widget forgotPassword = Align(
  alignment: Alignment.centerRight,
  child: new InkWell(
    child: Padding(
      padding: const EdgeInsets.only(top: 16, right: 32),
      child: Text(
        'Forgot Password ?',
        style: TextStyle(color: Colors.blue[600]),
      ),
    ),
    onTap: () => print("pssword forgot"),
  ),
);
