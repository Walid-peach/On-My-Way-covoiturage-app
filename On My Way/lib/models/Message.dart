import 'dart:convert';

import 'package:covoiturage_app/models/User.dart';
import 'package:covoiturage_app/services/Util.dart';
import 'package:flutter/material.dart';

class Message {
  String _id;
  int type;
  String content;
  TimeOfDay ofDay;
  User from;
  User to;

  String get id => _id;
  Message({String id, this.type, this.content, this.from, this.to, this.ofDay})
      : _id = id;

  factory Message.fromRawJson(String str) => Message.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["id"] == null ? null : json["id"],
        type: json["type"] == null ? null : json["type"],
        content: json["content"] == null ? null : json["content"],
        ofDay: json["ofDay"] == null ? null : Util.convertToTime(json["ofDay"]),
        from: json["from"] == null ? null : User.fromJson(json["from"]),
        to: json["to"] == null ? null : User.fromJson(json["to"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "type": type == null ? null : type,
        "content": content == null ? null : content,
        "ofDay": ofDay == null ? null : ofDay,
        "from": from == null ? null : from.toJson(),
        "to": to == null ? null : to.toJson(),
      };
}
