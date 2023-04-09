import 'package:anket_app/data/lang_service.dart';
import 'package:anket_app/data/user_service.dart';
import 'package:anket_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/lang.dart';
import 'package:flutter/cupertino.dart';

class LangList extends StatefulWidget {
  late User user;


  LangList(this.user);


  @override
  State<StatefulWidget> createState() => _LangListState(user);
}

class _LangListState extends State {
  late User user;
  late Lang lang;
  bool isTapped = true;
  int numVote = 1;

  _LangListState(this.user);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yazılım Dilleri"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: buildLangList(),
          ),
          buildSaveButton(),
        ],
      ),
    );
  }

  StreamBuilder<QuerySnapshot> buildLangList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("yazilimdilleri").snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) {
          return LinearProgressIndicator();
        }
        switch(snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Text("Yükleniyor...");
          default:
            return buildBody(context, snapshot.data!.docs);
        }
      },
    );
  }

  ListView buildBody(BuildContext context, List<QueryDocumentSnapshot<Object?>> snapshot) {
    return ListView(
      padding: EdgeInsets.only(top: 20.0),
      children: snapshot.map<Widget>((data) => buildListItem(context, data)).toList(),
    );
  }

  Widget buildListItem(BuildContext context, QueryDocumentSnapshot<Object?> data) {
    final lang = Lang.fromSnapshot(data);
    return Padding(
      key: ValueKey(lang.id),
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(lang.name),
          subtitle: Text(lang.sumVote.toString()),
          onTap: () {
            if(isTapped) {
              user.langId = lang.id;
              isTapped = false;
              LangService.addVoteToLang(lang);
            }
          },
        ),
      ),
    );
  }

  ElevatedButton buildSaveButton() {
    return ElevatedButton(
      child: Text("Seçimi Kaydet"),
      onPressed: () {
        UserService.addToUser(user);
        Navigator.popAndPushNamed(context, "/");
      },
    );
  }



}