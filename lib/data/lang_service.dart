import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/lang.dart';

class LangService {
  static List<Lang> langs = <Lang>[];

  static final LangService _singleton = LangService._internal();

  factory LangService() {
    return _singleton;
  }

  LangService._internal();

  static void addVoteToLang(Lang lang) {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      final freshSnapshot = await transaction.get(lang.reference);
      final fresh = Lang.fromSnapshot(freshSnapshot);
      transaction.update(lang.reference, {'oy_sayisi':fresh.sumVote + 1});
    });
  }

  static void addToLang(Lang lang) {
    langs.add(lang);
  }

  static void removeFromLangs(Lang lang) {
    langs.remove(lang);
  }

  static List<Lang> getUsers() {
    getDbUsers();
    return langs;
  }

  static void getDbUsers() async {
    List<QueryDocumentSnapshot<Map<String, dynamic>>>? list;
    Lang lang;
    await FirebaseFirestore.instance.collection("yazilimdilleri").get().then((value) {
      list = value.docs;
    });
    for(int i = 0; i < list!.length; i++) {
      lang = Lang.fromSnapshot(list![i]);
      langs.add(lang);
    }
  }
}