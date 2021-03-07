import 'dart:io';

import 'package:covoiturage_app/models/Post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covoiturage_app/models/User.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PostController {
  final db = Firestore.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  Post _post;

  PostController({Post post}) {
    _post = post;
    this.initNotification();
  }
  void setPost(Post p) => _post = p;

  void initNotification() {
    var android = new AndroidInitializationSettings('app_icon');
    var ios = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: null);
  }

  /*    Future onSelectNotification(String payload) async {
    // Navigator
    //     .push(context, MaterialPageRoute(builder: (context) => new Home()));
    showDialog(
      context: context,
      builder: (_) {
        return new AlertDialog(
          title: Text("PayLoad"),
          content: Text("Payload : $payload"),
        );
      },
    );
  } */

  Future _showNotificationWithDefaultSound(Post post) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'post_id',
        'post change',
        'notification for notify users about new posts',
        importance: Importance.Max,
        priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'New post added',
      post.user.username + " add new post",
      platformChannelSpecifics,
      payload: "post",
    );
  }

  Future<bool> createPost() async {
    bool returnVal = false;
    // if (desc != null)
    //   await this.uploadFile(desc).then((value) => _post.imgDesc = value);

    await db
        .collection("posts")
        .document(_post.id)
        .setData(_post.toJson())
        .then((value) => {
              returnVal = true,
              this._showNotificationWithDefaultSound(_post),
            })
        .catchError((onError) => {
              print("Error while add new post : ${onError.toString()}"),
              returnVal = false,
            });
    return returnVal;
  }

  Future<bool> updatePost() async {
    bool returnVal = false;
    await db
        .collection("posts")
        .document(_post.id)
        .updateData(_post.toJson())
        .then((value) => returnVal = true)
        .catchError((onError) => {
              print("Error while update  post ${_post.id} : ${onError.code}"),
              returnVal = false,
            });
    return returnVal;
  }

  Future<bool> deletePost(Post p) async {
    bool returnVal = false;
    await db
        .collection("posts")
        .document(p.id)
        .delete()
        .then((value) => returnVal = true)
        .catchError((onError) => {
              print("Error while delete  post ${_post.id}  : ${onError.code}"),
              returnVal = false,
            });
    return returnVal;
  }

  Future<List<Post>> getAllPosts() async {
    List<Post> posts = new List();
    await db
        .collection("posts")
        .getDocuments()
        .then((value) =>
            posts = value.documents.map((p) => Post.fromJson(p.data)).toList())
        .catchError(
          (onError) =>
              print("Error while delete  post ${_post.id}  : ${onError.code}"),
        );
    return posts;
  }

  Future<List<Post>> getAllPostsUer(User user) async {
    List<Post> posts = new List();
    await db
        .collection("posts")
        .where("user.id", isEqualTo: user.id)
        .getDocuments()
        .then((value) =>
            posts = value.documents.map((p) => Post.fromJson(p.data)).toList())
        .catchError(
          (onError) =>
              print("Error while delete  post ${_post.id}  : ${onError.code}"),
        );
    return posts;
  }

  // Future<void> lisenToDb() {
  //   db.collection("posts").snapshots().listen((result) {
  //     result.documentChanges.forEach((res) {
  //       if (res.type == DocumentChangeType.added) {
  //         print("added");
  //         print(res.document.data);
  //       } else if (res.type == DocumentChangeType.modified) {
  //         print("modified");
  //         print(res.document.data);
  //       } else if (res.type == DocumentChangeType.removed) {
  //         print("removed");
  //         print(res.document.data);
  //       }
  //     });
  //   });
  // }

  Future<String> uploadFile(File avatarImageFile) async {
    String imgPath;
    if (avatarImageFile != null) {
      String fileName = _post.id;
      StorageReference reference =
          FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = reference.putFile(avatarImageFile);
      StorageTaskSnapshot storageTaskSnapshot;
      await uploadTask.onComplete.then((value) async {
        if (value.error == null) {
          storageTaskSnapshot = value;
          await storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
            imgPath = downloadUrl.toString();
          }, onError: (err) {
            print("Error ${avatarImageFile.path}");
          });
        } else {
          print("Error ${avatarImageFile.path} is not img");
        }
      }, onError: (err) {
        print("Error : ${err.toString()}");
      });
    }
    return imgPath;
  }
}
