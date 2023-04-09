// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:anket_app/data/software_field_service.dart';
import 'package:anket_app/models/software_field.dart';
import 'package:anket_app/models/user.dart';
import 'package:anket_app/validations/user_validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/user_service.dart';

class UserLogin extends StatefulWidget {
  late User user;
  UserLogin(this.user);


  @override
  State<StatefulWidget> createState() => _UserLoginState(user);
}

class _UserLoginState extends State with UserValidationMixin {
  User user = User();
  SoftwareField softwareField = SoftwareField();

  _UserLoginState(this.user);

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isChecked = false;
  String text = "Bir alan seçmek zorundasınız!";
  List<User> users = <User>[];
  List<SoftwareField> softwareFields = <SoftwareField>[];

  @override
  void initState() {
    getUsers();
    getDbSoftwareFields();
    print(softwareFields.length);
    super.initState();
  }

  void getDbSoftwareFields() {
    softwareFields = SoftwareFieldService.getSoftwareFields();
  }

  void getUsers() async {
    users = UserService.getUsers();
  }

  var formKey = GlobalKey<FormState>();
  String softwareFieldTxt = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Giriş Yapınız"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        margin: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              buildTextField("name"),
              buildTextField("surname"),
              /*
              const SizedBox(
                height: 30.0,
              ),

              Row(
                mainAxisSize: MainAxisSize.max,
                children: const [
                  Text("Hangi yazılım alanı ile ilgileniyorsunuz?", style: TextStyle(fontSize: 18.0),),
                ],
              ),
               */
              const SizedBox(
                height: 15.0,
              ),
              buildTextButtons(),
              const SizedBox(
                height: 15.0,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Seçilen alan: $text", style: TextStyle(fontSize: 18.0),),
                  ),
                ],
              ),
              buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField buildTextField(String process) {
    String labelTxt = process == "name" ? "Ad" : "Soyad";
    String hintTxt = process == "name" ? "Yunus Emre" : "Kaplan";

    return TextFormField(
      decoration: InputDecoration(
        labelText: labelTxt,
        hintText: hintTxt,
      ),
      validator: validateFirstOrLastName,
      onSaved: (String? value) {
        if (process == "name") {
          user.name = value!;
        } else {
          user.surname = value!;
        }
      },
    );
  }

  Column buildTextButtons() {
    return Column(
      children: [
        buildFieldRow(1),
        buildFieldRow(2),
        buildFieldRow(3),
        buildFieldRow(4),
        buildFieldRow(5),
        buildFieldRow(6),
      ],
    );
  }

  Row buildFieldRow(int s) {
    switch(s) {
      case 1:
        softwareFieldTxt = "Web Geliştirme";
        user.softwareFieldId = s;
        break;
      case 2:
        softwareFieldTxt = "Mobil Geliştirme";
        user.softwareFieldId = s;
        break;
      case 3:
        softwareFieldTxt = "Oyun Geliştirme";
        user.softwareFieldId = s;
        break;
      case 4:
        softwareFieldTxt = "Gömülü Sistemler";
        user.softwareFieldId = s;
        break;
      case 5:
        softwareFieldTxt = "Veri Bilimi";
        user.softwareFieldId = s;
        break;
      case 6:
        softwareFieldTxt = "Siber Güvenlik";
        user.softwareFieldId = s;
        break;
    }
    String val = softwareFieldTxt;
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        TextButton(
          key: ValueKey(val),
          child: Text(softwareFieldTxt, style: TextStyle(fontSize: 18),),
          onPressed: (){
            isChecked = true;
            setState(() {
              text = val;
            });
          },
        ),
      ],
    );
  }

  ElevatedButton buildSaveButton() {
    return ElevatedButton(
      child: const Text("Ankete Git"),
      onPressed: () {
          if(formKey.currentState!.validate()) {
            if(isChecked) {
              for(int i=0; i<softwareFields.length; i++) {
                if(softwareFields[i].name == softwareFieldTxt) {
                  SoftwareFieldService.addVoteToSoftwareField(softwareFields[i]);
                  break;
                }
              }
              formKey.currentState!.save();
              onSave();
              Navigator.pushNamed(context, "langList");
            } else {
              setState(() {
                softwareFieldTxt = "Alan seçmek zorunludur!";
              });
            }
          }
      },
    );
  }

  void onSave() {
    user.id = users.length + 1;
  }

}

enum field {
  pazar;
}