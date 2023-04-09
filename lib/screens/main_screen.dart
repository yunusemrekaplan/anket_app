import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hangi Yazılım Dilini Kullanıyorsun"),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
      ),
    );
  }
}