import 'package:cloud_firestore/cloud_firestore.dart';

class SoftwareField {
  late int id;
  late String name;
  late int sumVote;
  late DocumentReference reference;

  SoftwareField();

  SoftwareField.fromMap(Map map, {required this.reference})
      : assert(map['alanId'] != null),
        assert(map['name'] != null),
        assert(map['oy_sayisi'] != null),
        id = map['alanId'],
        name = map['name'],
        sumVote = map["oy_sayisi"];

  SoftwareField.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String, dynamic>, reference: snapshot.reference);

  Map<String, dynamic> getUserMap() {
    return {
      'alanId' : id,
      'name' : name,
      'oy_sayisi' : sumVote,
    };
  }
}