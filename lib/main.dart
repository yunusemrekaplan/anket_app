import 'package:anket_app/screens/lang_list.dart';
import 'package:anket_app/screens/user_login.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  fireStore.app;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  User user = User();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/": (BuildContext context) => UserLogin(user),
        "langList": (BuildContext context) => LangList(user),
      },
      initialRoute: "/",

    );
  }
}

class SurveyList extends StatefulWidget {
  SurveyList({super.key});

  @override
  State<StatefulWidget> createState() => _SurveyListState();
}

class _SurveyListState extends State {
  _SurveyListState();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("dilanketi").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          return buildBody(context, snapshot.data!.docs);
        }
      },
    );
  }

  Widget buildBody(
      BuildContext context, List<QueryDocumentSnapshot<Object?>> snapshot) {
    return ListView(
      padding: EdgeInsets.only(top: 20.0),
      children:
          snapshot.map<Widget>((data) => buildListItem(context, data)).toList(),
    );
  }

  Widget buildListItem(BuildContext context, QueryDocumentSnapshot data) {
    final row = Anket.fromSnapshot(data);

    return Padding(
      key: ValueKey(row.isim),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(row.isim),
          trailing: Text(row.oy.toString()),
          onTap: () => FirebaseFirestore.instance.runTransaction((transaction) async {
            final freshSnapshot = await transaction.get(row.reference);
            final fresh = Anket.fromSnapshot(freshSnapshot);
            transaction.update(row.reference, {'oy':fresh.oy + 1});
          }),
        ),
      ),
    );
  }
}


class Anket {
  late String isim;
  late int oy;
  late DocumentReference reference;

  Anket.fromMap(Map map, {required this.reference})
      : assert(map['isim'] != null),
        assert(map['oy'] != null),
        isim = map['isim'],
        oy = map['oy'];

  Anket.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String, dynamic>, reference: snapshot.reference);
}
