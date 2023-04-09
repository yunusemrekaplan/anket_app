import 'package:cloud_firestore/cloud_firestore.dart';

class Lang {
  late int id;
  late String name;
  late int sumVote;
  late DocumentReference reference;
  /*
  Lang.fromSnapshot(QueryDocumentSnapshot<Object?> data) {
    id = data['id'];
    name = data['dil_adi'];
    sumVote = data['oy_sayisi'];
  }
  */


  Lang.fromMap(Map map, {required this.reference})
      : assert(map['id'] != null),
        assert(map['dil_adi'] != null),
        assert(map['oy_sayisi'] != null),
        id = map['id'],
        name = map['dil_adi'],
        sumVote = map['oy_sayisi'];

  Lang.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String, dynamic>, reference: snapshot.reference);

  Map<String, dynamic> getLangMap() {
    return {
      'id' : id,
      'dil_adi' : name,
      'oy_sayisi' : sumVote,
    };
  }

}