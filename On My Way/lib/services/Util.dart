
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class Util {
  static TimeOfDay convertToTime(String time) {
    return TimeOfDay(
        hour: int.parse(time.split(":")[0]),
        minute: int.parse(time.split(":")[1]));
  }

  static String convertTimeToString(TimeOfDay timeOfDay) {
    return "${timeOfDay.hour}:${timeOfDay.minute}";
  }

  static DateTime convertToDateTime(String birthDay) {
    return DateTime.parse(birthDay);
  }

  static String convertDateToString(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static String hashPass(String password) {
    var key = utf8.encode("pass@word/user*APP");
    var bytePass = utf8.encode(password);
    var hmacSha256 = new Hmac(sha256, key);
    var hashPass = hmacSha256.convert(bytePass);
    return hashPass.toString();
  }
}
