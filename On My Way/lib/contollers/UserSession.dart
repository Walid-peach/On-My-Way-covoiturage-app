import 'package:covoiturage_app/models/User.dart';
import 'package:covoiturage_app/services/Util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  Future<void> saveSessionUser(User user) async {
    await SharedPreferences.getInstance().then((_preferences) => {
          _preferences.setString("id", user.id ?? '0'),
          _preferences.setString("email", user.email ?? ''),
          _preferences.setString("username", user.username ?? ''),
          _preferences.setString("city", user.city ?? ''),
          _preferences.setString(
              "birthDay", Util.convertDateToString(user.birthDay) ?? ''),
          _preferences.setString("password", user.password ?? ''),
          _preferences.setString("profileImg", user.profileImg ?? ''),
          _preferences.setDouble("rank", user.rank ?? 0),
        });
  }

  Future<bool> destroySession() async {
    bool returnValue = false;
    await SharedPreferences.getInstance().then((_preferences) =>
        _preferences.clear().then((value) => {returnValue = value}));
    return returnValue;
  }

  Future<User> getCurrentUser() async {
    User currentUser;
    await SharedPreferences.getInstance().then((_preferences) => {
          currentUser = new User(
            id: _preferences.getString("id") ?? '0',
            email: _preferences.getString("email") ?? '',
            username: _preferences.getString("username") ?? '',
            city: _preferences.getString("city") ?? '',
            birthDay: Util.convertToDateTime(
              _preferences.getString("birthDay"),
            ),
            profileImg: _preferences.getString("profileImg") ?? '',
            rank: _preferences.getDouble("rank") ?? '',
          ),
          print(
              "Current User from sharedReferences : ${currentUser.toString()}"),
        });
    return currentUser;
  }

  Future<User> checkEmailAndPass() async {
    User currentUser;
    await SharedPreferences.getInstance().then((_preferences) => {
          currentUser = new User(
              id: _preferences.getString("id") ?? '0',
              email: _preferences.getString("email") ?? '',
              password: _preferences.getString("password") ?? ''),
          print(
              "checkEmailAndPass user: ${currentUser.toString()}"),
        });
    return currentUser;
  }
}
