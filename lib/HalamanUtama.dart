import 'dart:io';

import 'package:skripsi/ButtonUtama/HalKameraButton.dart';
import 'package:skripsi/ButtonUtama/HalImageButton.dart';
import 'package:flutter/material.dart';
import 'ButtonUtama/ExitButton.dart';

class HalamanUtama extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HalamanUtama> {
  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                "Apakah Kamu ingin keluar dari aplikasi ?",
                style: TextStyle(color: Colors.red),
              ),
              backgroundColor: Colors.yellowAccent,
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    "No",
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
                FlatButton(
                  child: Text("Yes"),
                  onPressed: () => exit(0),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.teal,
        body: Container(
            child: Stack(
          children: <Widget>[
            // Image.asset('assets/images/bkg.jpg',
            //     width: size.width, height: size.height, fit: BoxFit.cover),
                Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [Colors.red, Colors.yellow])),
                    ),
            Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 120.0),
                    child: Container(
                      height: 200,
                      width: 200,
                      child: Image.asset('assets/images/title.png',
                          width: size.width * 0.9, fit: BoxFit.fill),
                    ),
                  ),
                  Padding(
                      padding:
                          EdgeInsets.only(top: 0.0, left: 32.0, right: 32.0),
                      child: Text('Empon',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold))),
                  Padding(
                      padding:
                          EdgeInsets.only(top: 0.0, left: 32.0, right: 32.0),
                      child: Text('Classification',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold))),
                  Padding(
                      padding:
                          EdgeInsets.only(top: 25.0, left: 32.0, right: 32.0),
                      child: HalKameraButton(),
                      ),
                  Padding(
                      padding:
                          EdgeInsets.only(top: 40.0, left: 32.0, right: 32.0),
                      child: HalImageButton(),
                      ),

                  Padding(
                    padding: const EdgeInsets.only(top: 40.0, left: 32.0, right: 32.0),
                    child: ExitButton(),
                  )
                ],
              ),
            )
          ],
        )));
  }
}
