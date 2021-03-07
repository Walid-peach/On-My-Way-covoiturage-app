import 'dart:io';

import 'package:covoiturage_app/contollers/UserSession.dart';
import 'package:covoiturage_app/models/User.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserSession session = new UserSession();
  User _user;
  UserController({User user}) : _user = user;

  Future signIn(String email, String password) async {
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                this.getUser(value.user.uid),
                print("val from Sign In $value"),
              })
          // .timeout(new Duration(seconds: 60))
          .catchError(
            (onError) =>
                print("Error while sign in to app :${onError.message}"),
          );
      return _user;
    } catch (e) {
      print("Error while sign in to app :${e.message}");
      return null;
    }
  }

  Future<bool> signUp(File avatarImageFile) async {
    bool returnVal = false;
    try {
      //create a user from email and password
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: _user.email, password: _user.password);
      _user.setId(result.user.uid);
      UserUpdateInfo userUpdateInfo;
      StorageReference reference =
          FirebaseStorage.instance.ref().child(result.user.uid);
      StorageUploadTask uploadTask = reference.putFile(avatarImageFile);
      StorageTaskSnapshot storageTaskSnapshot;
      uploadTask.onComplete.then((value) => {
            storageTaskSnapshot = value,
            storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) => {
                  _user.profileImg = downloadUrl.toString(),
                  userUpdateInfo = new UserUpdateInfo(),
                  userUpdateInfo.displayName = _user.username,
                  userUpdateInfo.photoUrl = _user.profileImg,
                  print("User before sign up : ${_user.toString()}"),
                  result.user.updateProfile(userUpdateInfo).then((value) => {
                        //add user to Firebase FireStore
                        Firestore.instance
                            .collection("users")
                            .document(_user.id)
                            .setData(_user.toJson())
                            .then((value) => {
                                  returnVal = true,
                                })
                            .catchError((onError) => {
                                  print(
                                      "Error while add new user to document : ${onError.code}"),
                                  returnVal = false,
                                }),
                        print("User after sign up : ${_user.toString()}")
                      })
                }),
          });
      returnVal = true;
    } catch (e) {
      print("Error while sign up to app :${e.message}");
      returnVal = false;
    }
    return returnVal;
  }

  Future<bool> signOut() async {
    try {
      await _auth.signOut();
      print("Success log out");
      return true;
    } catch (err) {
      print("Error while user sign out  : ${err.message}");
      return false;
    }
  }

  Future getUser(String uid) async {
    await Firestore.instance
        .collection("users")
        .document(uid)
        .get()
        .then((value) => {
              _user = User.fromJson(value.data),
            })
        .catchError((onError) =>
            print("Error while getting information of user  : $onError"));
  }

  Future<bool> isLogin() async {
    bool returnVal = false;
    await session.checkEmailAndPass().then((user) => this.getUser(user.id));
    _user != null ? returnVal = true : returnVal = false;
    return returnVal;
  }

  Future<List<User>> getUsers() async {
    List<User> users = new List();
    User currentUser = await session.getCurrentUser();
    await Firestore.instance
        .collection("users")
        .getDocuments()
        .then(
          (value) => users = value.documents
              .map((e) => User.fromJson(e.data))
              .toList()
              .where((element) => element.id != currentUser.id)
              .toList(),
        )
        .catchError((onError) => print(
            "Error while getting all users from db ${onError.toString()}"));
    return users;
  }
}
