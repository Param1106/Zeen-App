import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  static Firestore _firestore = Firestore.instance;
  AuthItem currUser;

  set setCurrUser(AuthItem user) {
    currUser = user;
  }

  static Future<List<dynamic>> getListOfCred() async {
    DocumentSnapshot creds = await _firestore.collection('login').document('credentials').get();
    List<dynamic> users = creds.data['listOfCredentials'].map((e) =>
      AuthItem(
        name: e['u_name'],
        pass: e['u_pass'],
      )
    ).toList();
    return users;
  }

//  Future<bool> authStatus() async {
//    final SharedPreferences prefs = await SharedPreferences.getInstance();
//    var authenticated = prefs.containsKey(key);
//  }

  Future<bool> authenticate() async {
    List<dynamic> users = await  getListOfCred();
    var flag = 0;
    if (currUser != null) {
      users.forEach((obj) {
        if (flag != 1) {
          if(obj.name == currUser.name)
            if(obj.pass == currUser.pass) {
              flag = 1;
            }
        }
      });
    }
    return flag == 1;
  }

}

class AuthItem {
  final String name;
  final String pass;

  AuthItem({this.name, this.pass});
}



//TODO: Check credentials saved in shared preference
//TODO: Navigate accordingly