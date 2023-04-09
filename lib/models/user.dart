import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  late int id;
  late String name;
  late String surname;
  late int langId;
  late int softwareFieldId;
  late DocumentReference reference;

  User();

  User.fromMap(Map map, {required this.reference})
      : assert(map['id'] != null),
        assert(map['kullanici_adi'] != null),
        assert(map['kullanici_alan_id'] != null),
        assert(map['kullanici_dil_id'] != null),
        assert(map['kullanici_soyadi'] != null),
        id = map['id'],
        name = map['kullanici_adi'],
        surname = map['kullanici_soyadi'],
        langId = map['kullanici_dil_id'],
        softwareFieldId = map['kullanici_alan_id'];

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String, dynamic>, reference: snapshot.reference);

  Map<String, dynamic> getUserMap() {
    return {
      'id' : id,
      'kullanici_adi' : name,
      'kullanici_alan_id' : softwareFieldId,
      'kullanici_dil_id' : langId,
      'kullanici_soyadi' : surname
   };
  }
}