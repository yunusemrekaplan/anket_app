import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart';

class UserService {
  static List<User> users = <User>[];

  static final UserService _singleton = UserService._internal();

  factory UserService() {
    return _singleton;
  }

  UserService._internal();

  static void addToUser(User user) async {
    users.add(user);
    await FirebaseFirestore.instance.collection("kullanicilar").add(user.getUserMap());
  }

  static void removeFromUsers(User user) {
    users.remove(user);
  }

  static List<User> getUsers() {
    getDbUsers();
    return users;
  }

  static void getDbUsers() async {
    List<QueryDocumentSnapshot<Map<String, dynamic>>>? list;
    User user;
    await FirebaseFirestore.instance.collection("kullanicilar").get().then((value) {
      list = value.docs;
    });
    for(int i = 0; i < list!.length; i++) {
      user = User.fromSnapshot(list![i]);
      users.add(user);
    }
  }
}