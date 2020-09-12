import 'dart:io';
import 'dart:math';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:tflite/tflite.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'informasi/Informasi1.dart';
import 'informasi/Informasi2.dart';
import 'informasi/Informasi3.dart';
import 'informasi/Informasi4.dart';

class FromImage extends StatefulWidget {
  FromImage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class Tensorflow {
  Tensorflow({this.model, this.labels});
  final String model;
  final String labels;

  loadModel() async {
    Tflite.close();
    String res;
    res = await Tflite.loadModel(
      model: this.model,
      labels: this.labels,
    );
    print(res);
    return true;
  }

  Future<List> predictImage(File image) async {
    if (image == null) return [];

    var recognitions = await Tflite.runModelOnImage(
        path: image.path,
        imageMean: 0.0,
        imageStd: 255.0,
        numResults: 2,
        threshold: 0.2,
        asynch: true);
    return recognitions;
  }
}

class _MyHomePageState extends State<FromImage> {
  Tensorflow tensor =
      new Tensorflow(model: "assets/Empon.tflite", labels: "assets/Empon.txt");
  File _image;
  List _recognitions = [];
  String confidence;
  String result;
  String error;
  var percent;
  String confidence1 = '';
  FlutterTts flutterTts = FlutterTts();
  Future _speak(String result, String confidence1) async {
    // print(await flutterTts.getVoices);
    // print(await flutterTts.getLanguages);
    await flutterTts.setPitch(1);
    await flutterTts.setLanguage("id-ID");
    await flutterTts.setVoice("id-id-x-dfz#male_2-local");

    if (result == "JAHE") {
      await flutterTts.speak(
          "Hasil klasifikasi adalah Eumpon jahe, dengan tingkat Probabilitas " +
              confidence1 +
              "persen.");
    } else if (result == "LENGKUAS") {
      await flutterTts.speak(
          "Hasil klasifikasi adalah Eumpon lengkuas, dengan tingkat Probabilitas " +
              confidence1 +
              "persen.");
    } else if (result == "KUNYIT") {
      await flutterTts.speak(
          "Hasil klasifikasi adalah Eumpon kunyit, dengan tingkat Probabilitas " +
              confidence1 +
              "persen. ");
    } else if (result == "KENCUR") {
      await flutterTts.speak(
          "Hasil klasifikasi adalah Eumpon kencur, dengan tingkat Probabilitas " +
              confidence1 +
              "persen.");
    } else if (result == "UNDEFINED") {
      await flutterTts.speak(
          "mohon maaf, sepertinya obyek Eumpon tidak terdeteksi, silahkan coba gambar lainya.");
    }
  }

  final GlobalKey<ScaffoldState> _errorKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    tensor.loadModel();
  }

  selectFromImagePicker() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() {
      _image = image;
    });
    List recognitions = await tensor.predictImage(image);

    setState(() {
      try {
        _recognitions = recognitions;
        result = recognitions.first['label'];
        print(result);

        confidence = recognitions.first['confidence'].toString();
        var percent = double.parse(confidence) * 100;
        confidence1 = percent.toStringAsFixed(0);
        print(confidence1);
      } catch (e) {}
      error = 'Gambar Tidak Dapat Diklasifikasi';
      if (_recognitions.length == 0) {
        confidence1 = '';
      } else {
        confidence = recognitions.first['confidence'].toString();
        var percent = double.parse(confidence) * 100;
        confidence1 = percent.toStringAsFixed(0);
        _speak(result.toUpperCase(), confidence1);
        print(confidence1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Colors.yellowAccent, Colors.red])),
            ),
            _image == null
                ? Padding(
                    padding: const EdgeInsets.only(
                        top: 30.0, left: 40, right: 40, bottom: 320),
                    child: Center(
                      child: Container(
                        height: 300,
                        width: 600,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(color: Colors.white, width: 8)),
                        child: Container(
                            child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Silahkan pilih foto pada gallery dengan menekan tombol dibawah',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )),
                      ),
                    ))
                : Padding(
                    padding: const EdgeInsets.only(
                        top: 30.0, left: 40, right: 40, bottom: 320),
                    child: Center(
                      child: Container(
                        height: 300,
                        width: 600,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(color: Colors.white, width: 8)),
                        child: Container(
                            child: Center(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.file(_image)),
                        )),
                      ),
                    )),
            Padding(
              padding: const EdgeInsets.only(
                top: 190.0,
              ),
              child: Center(
                child: _recognitions.length > 0
                    ? InkWell(
                        onTap: () async {},
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.yellow,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4))),
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(result.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.black, fontSize: 32.0)),
                          ),
                        ),
                      )
                    : Container(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 310.0),
              child: Center(
                  child: Container(
                decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.all(Radius.circular(4))),
                child: Padding(
                    padding: EdgeInsets.all(8),
                    child: _recognitions.length > 0
                        ? Text("Tingkat Probabilitas :" + confidence1 + " %",
                            style:
                                TextStyle(color: Colors.black, fontSize: 25.0))
                        : Text("Tingkat Probabilitas : 0%",
                            style: TextStyle(
                                color: Colors.black, fontSize: 25.0))),
              )),
            ),

            Padding(
                padding: const EdgeInsets.only(top: 625.0, left: 145.0),
                child: Container(
                    height: 80,
                    width: 80,
                    child: FittedBox(
                        child: FloatingActionButton(
                      heroTag: null,
                      backgroundColor: Colors.red,
                      child: Icon(
                        Icons.image,
                        color: Colors.white,
                      ),
                      onPressed: selectFromImagePicker,
                    )))),

            Padding(
              padding: const EdgeInsets.only(
                top: 190.0,
              ),
              child: Center(
                child: _recognitions.length == 0
                    ? InkWell(
                        onTap: () async {},
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.yellow,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4))),
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(error ?? 'HASIL KLASIFIKASI',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 25.0)),
                          ),
                        ),
                      )
                    : Container(),
              ),
            ),
            //inipunyainformasi
            _recognitions.length > 0
                ? Padding(
                    padding: const EdgeInsets.only(top: 425.0),
                    child: Center(
                        child: InkWell(
                      onTap: () {
                        if (result == "jahe") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Info1(),
                            ),
                          );
                        } else if (result == "kencur") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Info2(),
                            ),
                          );
                        } else if (result == "kunyit") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Info3(),
                            ),
                          );
                        } else if (result == "lengkuas") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Info4(),
                            ),
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text((() {
                            if (result == "undefined") {
                              return "Obyek empon tidak terdeteksi";
                            } else {
                              return "Klik disini untuk melihat informasi dari " +
                                  result;
                            }
                          })(),
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15.0)),
                        ),
                      ),
                    )),
                  )
                : Container()
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.orangeAccent,
      //   child: Icon(Icons.image),
      //   onPressed: selectFromImagePicker,
      // ),
    );
  }
}
