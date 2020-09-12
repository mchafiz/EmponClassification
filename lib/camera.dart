import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'dart:math';
import 'package:skripsi/fromimage.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as im;
import 'package:tflite/tflite.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'informasi/Informasi1.dart';
import 'clicky_buton.dart';
import 'informasi/Informasi2.dart';
import 'informasi/Informasi3.dart';
import 'informasi/Informasi4.dart';

Future<List<CameraDescription>> getAvailableCameras() async {
  List<CameraDescription> cameras = await availableCameras();
  return cameras;
}

Uint8List imageToByteListFloat32(
    im.Image image, int inputSize, double mean, double std) {
  Float32List convertedBytes = Float32List(1 * inputSize * inputSize * 3);
  // print("ini adalah convertedbytes" + convertedBytes.toString());
  Float32List buffer = Float32List.view(convertedBytes.buffer);

  int pixelIndex = 0;
  for (int i = 0; i < inputSize; i++) {
    for (int j = 0; j < inputSize; j++) {
      int pixel = image.getPixel(j, i);
      buffer[pixelIndex++] = (im.getRed(pixel) - mean) / std;
      buffer[pixelIndex++] = (im.getGreen(pixel) - mean) / std;
      buffer[pixelIndex++] = (im.getBlue(pixel) - mean) / std;
      // print('iniadalahpixel' + pixel.toString());
    }

    // print('ini adalah std' + std.toString());
  }
  return convertedBytes.buffer.asUint8List();
}

class Camera extends StatefulWidget {
  final String path;

  const Camera({
    Key key,
    this.path,
  }) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Camera> {
  CameraController controller;
  bool isCameraReady = false;
  bool shouldshow = false;
  bool isImageReady = false;
  String result = '';
  String confidence = '';
  var percent;
  String confidence1 = '';
  String akurasi = '';
  bool _enabled = false;

  FlutterTts flutterTts = FlutterTts();
  void activateDetector() {
    getAvailableCameras().then((cameras) {
      // print('ini adalah camera' + cameras.toString());
      Tflite.loadModel(
              model: "assets/Empon.tflite",
              labels: "assets/Empon.txt",
              numThreads: 1)
          .then((_) {
        controller = CameraController(cameras[0], ResolutionPreset.medium);
        controller.initialize().then((_) {
          if (!mounted) return;
          setState(() {
            isCameraReady = true;
          });
        });
      });
    });
  }

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
              "persen. ");
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
              "persen");
    } else if (result == "UNDEFINED") {
      await flutterTts.speak(
          "mohon maaf, sepertinya objek Eumpon tidak terdeteksi, silahkan coba kembali.");
    }
  }

  Future<void> captureImage() async {
    // Clear previous result
    if (!mounted) return;
    setState(() {
      result = '';
      confidence = '';
    });

    final path = join(
      // Store the picture in the temp directory.
      // Find the temp directory using the `path_provider` plugin.
      (await getTemporaryDirectory()).path,
      '${DateTime.now()}.png',
    );
    if (!mounted) return;
    await controller.takePicture(path);

    if (!mounted) return;
    im.Image image = im.decodeImage(File(path).readAsBytesSync());
    int cropSize = min(image.width, image.height);
    int offsetX = (image.width - min(image.width, image.height)) ~/ 2;
    int offsetY = (image.height - min(image.width, image.height)) ~/ 2;

    im.Image imageSquare =
        im.copyCrop(image, offsetX, offsetY, cropSize, cropSize);

    int imgSize = 224;
    im.Image imageResized = im.copyResize(imageSquare,
        width: imgSize, height: imgSize, interpolation: im.Interpolation.cubic);

    if (!mounted) return;
    Tflite.runModelOnBinary(
            binary: imageToByteListFloat32(imageResized, imgSize, 127.5, 127.5))
        .then((recognitions) {
      if (recognitions.length > 0) {
        print(recognitions.first);
        setState(() {
          confidence = recognitions.first['confidence'].toString();
          var percent = double.parse(confidence) * 100;
          confidence1 = percent.toStringAsFixed(0);
          print(confidence1);
          final start = DateTime.now();
          final startmilli = DateTime.now().millisecond;
          result = recognitions.first['label'];
          _speak(result.toUpperCase(), confidence1);
          final lastprossestime = DateTime.now();
          final lastprosesstimemilli = DateTime.now().millisecond;
          var waktu = lastprosesstimemilli - startmilli;
          print(start);
          print(lastprossestime);
          print(startmilli);
          print(lastprosesstimemilli);
          print(waktu);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
          child: isCameraReady
              ? Stack(
                  //background dan controller kamera
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [Colors.yellowAccent, Colors.red])),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red, width: 10),
                        ),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: ClipRect(
                            child: Transform.scale(
                              scale: 1 / controller.value.aspectRatio,
                              child: Center(
                                child: AspectRatio(
                                  aspectRatio: controller.value.aspectRatio,
                                  child: CameraPreview(controller),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    //floatbuttonloading
                    Padding(
                      padding: const EdgeInsets.only(top: 625.0, left: 145.0),
                      child: Container(
                          height: 80,
                          width: 80,
                          child: FittedBox(
                              child: FloatingActionButton(
                            heroTag: null,
                            backgroundColor: Colors.yellowAccent,
                            child: SpinKitFadingCircle(
                                color: Colors.red, size: 45.0),
                            onPressed: null,
                          ))),
                    ),

                    //floatingbuttoncamera0
                    Padding(
                        padding: const EdgeInsets.only(top: 625.0, left: 145.0),
                        child: Container(
                            height: 80,
                            width: 80,
                            child: FittedBox(
                                child: Opacity(
                                    opacity: shouldshow ? 0 : 1,
                                    child: FloatingActionButton(
                                      heroTag: null,
                                      backgroundColor: Colors.red,
                                      child: Icon(Icons.camera_alt,
                                          color: Colors.white),
                                      onPressed: () {
                                        shouldshow = true;
                                        _enabled = true;

                                        isCameraReady
                                            ? captureImage()
                                            : activateDetector();
                                      },
                                    ))))),

                    //floatingbuttoncamera
                    Padding(
                        padding: const EdgeInsets.only(top: 625.0, left: 145.0),
                        child: result.length != 0 && result.length >= 0
                            ? Container(
                                height: 80,
                                width: 80,
                                child: FittedBox(
                                    child: FloatingActionButton(
                                  heroTag: null,
                                  backgroundColor: Colors.red,
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    isCameraReady
                                        ? captureImage()
                                        : activateDetector();
                                  },
                                )))
                            : Container()),

                    //inipunyaresult
                    Padding(
                      padding: const EdgeInsets.only(top: 160.0),
                      child: Center(
                          child: Container(
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Container(
                            height: 60,
                            child: Column(
                              children: <Widget>[
                                Text("Hasil Klasifikasi",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 25.0)),
                                result.length > 0
                                    ? Text(result.toUpperCase(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.yellow,
                                            fontSize: 25.0))
                                    : Text(
                                        "____",
                                        style: TextStyle(
                                            color: Colors.yellow,
                                            fontWeight: FontWeight.bold),
                                      )
                              ],
                            ),
                          ),
                        ),
                      )),
                    ),

                    //inipunyapercent
                    Padding(
                      padding: const EdgeInsets.only(top: 320.0),
                      child: Center(
                          child: Container(
                        decoration: BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        child: Padding(
                            padding: EdgeInsets.all(8),
                            child: result.length > 0
                                ? Text(
                                    "Tingkat Probabilitas: " +
                                        confidence1 +
                                        "%",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 25.0))
                                : Text("Tingkat Probabilitas: 0%",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 25.0))),
                      )),
                    ),

                    //inipunyainformasi
                    result.length > 0
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
                                } else if (result == "undefined") {}
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.purple,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4))),
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
                )
              : Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [Colors.yellowAccent, Colors.red])),
                  child: Stack(
                    children: <Widget>[
                      // Image.asset('assets/images/bkg.jpg',
                      //     width: size.width,
                      //     height: size.height,
                      //     fit: BoxFit.cover),

                      Center(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 50.0),
                              child: Container(
                                height: 300,
                                width: 300,
                                child: Image.asset('images/photo_school.png',
                                    width: size.width * 0.9, fit: BoxFit.fill),
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: 0.0, left: 32.0, right: 32.0),
                                child: Text('Arahkan Kamera ke obyek yang',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold))),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: 0.0, left: 32.0, right: 32.0),
                                child: Text('ingin diklasifikasi lalu tekan',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold))),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: 0.0, left: 32.0, right: 32.0),
                                child: Text('tombol icon kamera',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold))),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20.0, left: 32.0, right: 32.0),
                              child: isCameraReady
                                  ? Container()
                                  : Padding(
                                      padding: EdgeInsets.only(
                                          top: 20.0, left: 32.0, right: 32.0),
                                      child: Transform.scale(
                                        scale: 0.6,
                                        child: ClickyButton(
                                          child: Text(
                                            "Oke Let's Gooo!",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          color: Colors.red,
                                          onPressed: () {
                                            isCameraReady
                                                ? captureImage()
                                                : activateDetector();
                                          },
                                        ),
                                      )),
                            ),
                          ],
                        ),
                      )
                    ],
                  ))),
    );
  }
}
