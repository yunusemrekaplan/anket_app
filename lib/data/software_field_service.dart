import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/software_field.dart';

class SoftwareFieldService {
  static List<SoftwareField> softwareFields = <SoftwareField>[];

  static final SoftwareFieldService _singleton = SoftwareFieldService._internal();

  factory SoftwareFieldService() {
    return _singleton;
  }

  SoftwareFieldService._internal();

  static void addVoteToSoftwareField(SoftwareField softwareField) {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      final freshSnapshot = await transaction.get(softwareField.reference);
      final fresh = SoftwareField.fromSnapshot(freshSnapshot);
      transaction.update(softwareField.reference, {'oy_sayisi':fresh.sumVote + 1});
    });
  }

  static void addToSoftwareField(SoftwareField softwareField) {
    softwareFields.add(softwareField);
  }

  static void removeFromSoftwareField(SoftwareField softwareField) {
    softwareFields.remove(softwareField);
  }

  static List<SoftwareField> getSoftwareFields() {
    getDbSoftwareFields();
    return softwareFields;
  }

  static void getDbSoftwareFields() async {
    List<QueryDocumentSnapshot<Map<String, dynamic>>>? list;
    SoftwareField softwareField;
    await FirebaseFirestore.instance.collection("yazilimalani").get().then((value) {
      list = value.docs;
    });
    for(int i = 0; i < list!.length; i++) {
      softwareField = SoftwareField.fromSnapshot(list![i]);
      softwareFields.add(softwareField);
    }
  }
}