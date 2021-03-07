import 'package:covoiturage_app/models/Message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covoiturage_app/models/User.dart';

class MessageController {
  final db = Firestore.instance;
  Message _message;
  MessageController({Message message}) : _message = message;
  set(Message msg) => this._message = msg;

  Future<void> addMessage(String chatRoomId, chatMessageData) {
    db
        .collection("chatRoom")
        .document(chatRoomId)
        .collection("chats")
        .add(chatMessageData)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<List<User>> getUserChats(String itIsMyName) async {
    return await db
        .collection("chatRoom")
        .where('users', arrayContains: itIsMyName)
        .snapshots()
        .forEach(
            (element) => element.documents.map((e) => User.fromJson(e.data)));
  }

  Future<bool> addChatRoom(chatRoom, chatRoomId) {
    db
        .collection("chatRoom")
        .document(chatRoomId)
        .setData(chatRoom)
        .catchError((e) {
      print(e);
    });
  }
}
