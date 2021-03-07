import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covoiturage_app/screens/FullPhoto.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

/* class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  var date = new DateFormat.yMd().format(new DateTime.now());
  bool enableButton = false;
  TextEditingController textEditingController;
  ScrollController scrollController;
  var messages = List<Message>();
  File _image;
  bool isLoading;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      if (_image != null) {
        messages.add(Message.fromMessage(img: _image));
      }
      Future.delayed(Duration(milliseconds: 100), () {
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            curve: Curves.ease, duration: Duration(milliseconds: 500));
      });
    });
  }

  Future getImageFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
      if (_image != null) {
        messages.add(Message.fromMessage(img: _image));
      }
      Future.delayed(Duration(milliseconds: 100), () {
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            curve: Curves.ease, duration: Duration(milliseconds: 50));
      });
    });
  }

  @override
  void initState() {
    messages.add(new Message(type: 1, msg: "Bonjour Mr Mohamed"));
    messages.add(new Message(type: 1, msg: "Bonjour Monsieur"));
    messages.add(new Message(
        type: 1,
        msg: "Vous avez une mission trés urgent à l'adresse mentionnné !"));
    messages.add(new Message(type: 1, msg: "D'accord!"));

    textEditingController = TextEditingController();
    scrollController = ScrollController();

    Future.delayed(Duration(milliseconds: 100), () {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          curve: Curves.ease, duration: Duration(milliseconds: 500));
    });
    isLoading = false;
    super.initState();
  }

  void handleSendMessage() {
    var text = textEditingController.value.text;

    textEditingController.clear();
    setState(() {
      messages.add(new Message(type: 1, msg: text));
      enableButton = false;
    });

    Future.delayed(Duration(milliseconds: 100), () {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          curve: Curves.ease, duration: Duration(milliseconds: 500));
    });
  }

  void choiceAction(String choice) {
    if (choice == "Settings") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(),
        ),
      );
    } else if (choice == "contact") {
      print('Subscribe');
    }
  }

  @override
  Widget build(BuildContext context) {
    var textInput = Container(
      child: Row(
        children: <Widget>[
          new IconButton(
            icon: new Icon(Icons.image),
            onPressed: getImage,
            color: new Color(0xff203152),
          ),
          enableButton
              ? Container()
              : new IconButton(
                  icon: new Icon(Icons.camera_alt),
                  onPressed: getImageFromCamera,
                  color: new Color(0xff203152),
                ),
          Expanded(
            child: Container(
              child: TextField(
                maxLines: null,
                onChanged: (text) {
                  setState(() {
                    enableButton = text.isNotEmpty;
                  });
                },
                style: TextStyle(color: new Color(0xff203152), fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: new Color(0xffaeaeae)),
                ),
              ),
            ),
          ),
          enableButton
              ? IconButton(
                  color: Theme.of(context).Color(0xff203152),
                  icon: Icon(
                    Icons.send,
                  ),
                  disabledColor: Colors.grey,
                  onPressed: handleSendMessage,
                )
              : IconButton(
                  color: Colors.blue,
                  icon: Icon(
                    Icons.send,
                  ),
                  disabledColor: Colors.grey,
                  onPressed: null,
                ),
        ],
      ),
      width: MediaQuery.of(context).size.width, //double.infinity,
      decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Colors.white),
    );
    String img = "assets/images/user.png";
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          ),
          title: ListTile(
            title: Text(
              "Abdelouahed",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
              ),
            ),
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 20,
              backgroundImage: AssetImage(img),
            ),
          ),
          actions: [
            PopupMenuButton<String>(
              onSelected: choiceAction,
              itemBuilder: (BuildContext context) {
                return {"Profil", "contact"}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        backgroundColor: Color.fromRGBO(240, 248, 255, 0.9),
        body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 9,
                child: ListView.builder(
                    itemCount: messages.length,
                    controller: scrollController,
                    itemBuilder: (_, int index) {
                      bool reverse = false;
                      if (index % 2 == 0) {
                        reverse = true;
                      }

                      var bodyMessage = Flexible(
                        child: Container(
                            padding: EdgeInsets.all(8.0),
                            margin: EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Flexible(
                                    child: Container(
                                  child: messages[index].type == 1
                                      ? Text(messages[index].msg)
                                      : Image.file(messages[index].img),
                                )),
                                SizedBox(
                                  width: 8.0,
                                  height: 20.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(top: 16.0),
                                      child: Text(
                                        date,
                                        style: TextStyle(
                                            fontSize: 10.0, color: Colors.grey),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      );

                      var avaterA = Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, bottom: 8.0, right: 8.0),
                        child: CircleAvatar(
                          child: Text("A"),
                        ),
                      );
                      var avaterB = Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, bottom: 8.0, right: 8.0),
                        child: CircleAvatar(
                          child: Text("B"),
                          backgroundColor: Colors.red,
                        ),
                      );

                      if (reverse) {
                        return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [bodyMessage, avaterA]);
                      } else {
                        return Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [avaterB, bodyMessage]);
                      }
                    }),
              ),
              Expanded(
                flex: enableButton ? 2 : 1,
                child: textInput,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Message {
  int type;
  String msg;
  File img;

  Message({this.type, this.msg});

  Message.fromMessage({this.img});
}
 */

class Chat extends StatelessWidget {
  final String peerId;
  final String peerAvatar;

  Chat({Key key, @required this.peerId, @required this.peerAvatar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          'CHAT',
          style:
              TextStyle(color: Color(0xff203152), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: new ChatScreen(
        peerId: peerId,
        peerAvatar: peerAvatar,
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String peerId;
  final String peerAvatar;

  ChatScreen({Key key, @required this.peerId, @required this.peerAvatar})
      : super(key: key);

  @override
  State createState() =>
      new ChatScreenState(peerId: peerId, peerAvatar: peerAvatar);
}

class ChatScreenState extends State<ChatScreen> {
  ChatScreenState({Key key, @required this.peerId, @required this.peerAvatar});

  String peerId;
  String peerAvatar;
  String id;

  var listMessage;
  String groupChatId;
  SharedPreferences prefs;

  File imageFile;
  bool isLoading;
  bool isShowSticker;
  String imageUrl;

  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();
  final FocusNode focusNode = new FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);

    groupChatId = '';

    isLoading = false;
    isShowSticker = false;
    imageUrl = '';

    readLocal();
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
      });
    }
  }

  readLocal() async {
    prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id') ?? '';
    if (id.hashCode <= peerId.hashCode) {
      groupChatId = '$id-$peerId';
    } else {
      groupChatId = '$peerId-$id';
    }

    Firestore.instance
        .collection('users')
        .document(id)
        .updateData({'chattingWith': peerId});

    setState(() {});
  }

  Future getImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });
      uploadFile();
    }
  }

  void getSticker() {
    // Hide keyboard when sticker appear
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, 1);
      });
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: 'This file is not an image');
    });
  }

  void onSendMessage(String content, int type) {
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      textEditingController.clear();

      var documentReference = Firestore.instance
          .collection('messages')
          .document(groupChatId)
          .collection(groupChatId)
          .document(DateTime.now().millisecondsSinceEpoch.toString());

      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            'idFrom': id,
            'idTo': peerId,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'type': type
          },
        );
      });
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    if (document['idFrom'] == id) {
      // Right (my message)
      return Row(
        children: <Widget>[
          document['type'] == 0
              // Text
              ? Container(
                  child: Text(
                    document['content'],
                    style: TextStyle(color: Color(0xff203152)),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(
                      color: Color(0xffE8E8E8),
                      borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(
                      bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                      right: 10.0),
                )
              :
              /*  : document['type'] == 1
                  // Image
                  ?  */
              Container(
                  child: FlatButton(
                    child: Material(
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xfff5a623)),
                          ),
                          width: 200.0,
                          height: 200.0,
                          padding: EdgeInsets.all(70.0),
                          decoration: BoxDecoration(
                            color: Color(0xffE8E8E8),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Material(
                          child: Image.asset(
                            'images/img_not_available.jpeg',
                            width: 200.0,
                            height: 200.0,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                          clipBehavior: Clip.hardEdge,
                        ),
                        imageUrl: document['content'],
                        width: 200.0,
                        height: 200.0,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      clipBehavior: Clip.hardEdge,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  FullPhoto(url: document['content'])));
                    },
                    padding: EdgeInsets.all(0),
                  ),
                  margin: EdgeInsets.only(
                      bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                      right: 10.0),
                )
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                isLastMessageLeft(index)
                    ? Material(
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            child: CircularProgressIndicator(
                              strokeWidth: 1.0,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xfff5a623)),
                            ),
                            width: 35.0,
                            height: 35.0,
                            padding: EdgeInsets.all(10.0),
                          ),
                          imageUrl: peerAvatar,
                          width: 35.0,
                          height: 35.0,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(18.0),
                        ),
                        clipBehavior: Clip.hardEdge,
                      )
                    : Container(width: 35.0),
                document['type'] == 0
                    ? Container(
                        child: Text(
                          document['content'],
                          style: TextStyle(color: Colors.white),
                        ),
                        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                        width: 200.0,
                        decoration: BoxDecoration(
                            color: Color(0xff203152),
                            borderRadius: BorderRadius.circular(8.0)),
                        margin: EdgeInsets.only(left: 10.0),
                      )
                    : Container(
                        child: FlatButton(
                          child: Material(
                            child: CachedNetworkImage(
                              placeholder: (context, url) => Container(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xfff5a623)),
                                ),
                                width: 200.0,
                                height: 200.0,
                                padding: EdgeInsets.all(70.0),
                                decoration: BoxDecoration(
                                  color: Color(0xffE8E8E8),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Material(
                                child: Image.asset(
                                  'images/img_not_available.jpeg',
                                  width: 200.0,
                                  height: 200.0,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                                clipBehavior: Clip.hardEdge,
                              ),
                              imageUrl: document['content'],
                              width: 200.0,
                              height: 200.0,
                              fit: BoxFit.cover,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            clipBehavior: Clip.hardEdge,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        FullPhoto(url: document['content'])));
                          },
                          padding: EdgeInsets.all(0),
                        ),
                        margin: EdgeInsets.only(left: 10.0),
                      ),
              ],
            ),
            // Time
            isLastMessageLeft(index)
                ? Container(
                    child: Text(
                      DateFormat('dd MMM kk:mm').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              int.parse(document['timestamp']))),
                      style: TextStyle(
                          color: Color(0xffaeaeae),
                          fontSize: 12.0,
                          fontStyle: FontStyle.italic),
                    ),
                    margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
                  )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] == id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] != id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      Firestore.instance
          .collection('users')
          .document(id)
          .updateData({'chattingWith': null});
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              // List of messages
              buildListMessage(),
              // Input content
              buildInput(),
            ],
          ),

          // Loading
          buildLoading()
        ],
      ),
      onWillPop: onBackPress,
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xfff5a623))),
              ),
              color: Colors.white.withOpacity(0.8),
            )
          : Container(),
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: new Icon(Icons.image),
                onPressed: getImage,
                color: Color(0xff203152),
              ),
            ),
            color: Colors.white,
          ),
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: new Icon(Icons.face),
                onPressed: getSticker,
                color: Color(0xff203152),
              ),
            ),
            color: Colors.white,
          ),

          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(color: Color(0xff203152), fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: Color(0xffaeaeae)),
                ),
                focusNode: focusNode,
              ),
            ),
          ),

          // Button send message
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text, 0),
                color: Color(0xff203152),
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: new BoxDecoration(
          border: new Border(
              top: new BorderSide(color: Color(0xffE8E8E8), width: 0.5)),
          color: Colors.white),
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: groupChatId == ''
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xfff5a623))))
          : StreamBuilder(
              stream: Firestore.instance
                  .collection('messages')
                  .document(groupChatId)
                  .collection(groupChatId)
                  .orderBy('timestamp', descending: true)
                  .limit(20)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xfff5a623))));
                } else {
                  listMessage = snapshot.data.documents;
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) =>
                        buildItem(index, snapshot.data.documents[index]),
                    itemCount: snapshot.data.documents.length,
                    reverse: true,
                    controller: listScrollController,
                  );
                }
              },
            ),
    );
  }
}
