import 'dart:io';
import 'dart:typed_data';
import 'dart:math';
import 'package:skripsi/fromimage.dart';
import 'package:skripsi/slider/slider.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as im;
import 'package:tflite/tflite.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'clicky_buton.dart';


Future<List<CameraDescription>> getAvailableCameras() async {
  List<CameraDescription> cameras = await availableCameras();
  return cameras;
}

Uint8List imageToByteListFloat32(
    im.Image image, int inputSize, double mean, double std) {
  Float32List convertedBytes = Float32List(1 * inputSize * inputSize * 3);
  Float32List buffer = Float32List.view(convertedBytes.buffer);
  int pixelIndex = 0;
  for (int i = 0; i < inputSize; i++) {
    for (int j = 0; j < inputSize; j++) {
      int pixel = image.getPixel(j, i);
      buffer[pixelIndex++] = (im.getRed(pixel) - mean) / std;
      buffer[pixelIndex++] = (im.getGreen(pixel) - mean) / std;
      buffer[pixelIndex++] = (im.getBlue(pixel) - mean) / std;
    }
  }
  return convertedBytes.buffer.asUint8List();
}

class DetectorCamera extends StatefulWidget {
  final String path;

  const DetectorCamera({Key key, this.path,}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<DetectorCamera> {
  CameraController controller;
  bool isCameraReady = false;
  bool shouldshow = false;
  bool isImageReady = false;
  String result = '';
  String confidence = '';
  String akurasi = '';
  bool _enabled = false;

  FlutterTts flutterTts = FlutterTts();
  void activateDetector() {
    getAvailableCameras().then((cameras) {
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

  Future _speak(String result) async {
    print(await flutterTts.getVoices);
    print(await flutterTts.getLanguages);
    await flutterTts.setPitch(1);
    await flutterTts.setLanguage("id-ID");
    if (result == "blimbing") {
      await flutterTts.speak(
          "ini adalah pohon belimbing. tanaman ini bisa dijadikan obat anti kangker dan meredakan diabetes");
    } else if (result == "duren") {
      await flutterTts.speak(
          "ini adalah tanaman duren, tanaman ini bisa dijadikan obat anti jomblo");
    } else if (result == "pepaya") {
      await flutterTts.speak(
          "ini adalah pohon buah pepaya. anda bisa memakan buahnya untuk menjadi awet muda");
    } else if (result == "kamboja") {
      await flutterTts.speak(
          "ini adalah tanaman kamboja, tanaman ini sangat unik dan berantakan.");
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
          print(num.parse(confidence));
          
        });
        // Display new result
        if (!mounted) return;
        setState(() {
          result = recognitions.first['label'];
          _speak(result);
        });
      }
    });
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Apakah Kamu ingin keluar dari aplikasi klasifikasi?"),
              actions: <Widget>[
                FlatButton(
                  child: Text("No"),
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
    var _onpressed;
     if(_enabled){
       _onpressed;
     }
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 25, 25, 27),
        body: Center(
            child: isCameraReady
                ? Stack(
                  //background dan controller kamera
                    children: <Widget>[
                      Container(
            decoration: BoxDecoration(color: const Color(0xff999999)),
          ),
                      // Image.asset('assets/images/bkgg.jpg',
                      //     width: size.width,
                      //     height: size.height,
                      //     fit: BoxFit.cover),
                      Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.orangeAccent, width: 2),
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
                      Padding(padding: const EdgeInsets.only(top: 625.0, left: 80.0),
                      child: Container(
                            height: 80,
                            width: 80,
                            child: FittedBox(
                                child:  FloatingActionButton(
                                      heroTag: null,
                                      backgroundColor: Colors.orangeAccent,
                                      child: SpinKitFadingCircle(color: Colors.yellowAccent, size: 45.0),
                                      onPressed: null,
                                    ))
                            ),
                      ),
                      

                      //floatingbuttoncamera0
                      Padding(
                        padding: const EdgeInsets.only(top: 625.0, left: 80.0),
                        child: Container(
                            height: 80,
                            width: 80,
                            child: FittedBox(
                                child: Opacity(
                                    opacity: shouldshow ? 0 : 1,
                                    child: FloatingActionButton(
                                      heroTag: null,
                                      backgroundColor: Colors.orangeAccent,
                                      child: Icon(Icons.camera_alt),
                                      onPressed: () {
                                        shouldshow = true;
                                       _enabled = true;
                                        isCameraReady
                                            ? captureImage()
                                            : activateDetector();
                                      },
                                    ))))
                      ),

                      //floatingbuttoncamera
                      Padding(
                        padding: const EdgeInsets.only(top: 625.0, left: 80.0),
                        child: result.length != 0 && result.length >= 0 ? Container(
                            height: 80,
                            width: 80,
                            child: FittedBox(
                                child: FloatingActionButton(
                                      heroTag: null,
                                      backgroundColor: Colors.orangeAccent,
                                      child: Icon(Icons.camera_alt),
                                      onPressed: () {
                                        isCameraReady
                                            ? captureImage()
                                            : activateDetector();
                                          
                                      },
                                    ))):Container()
                      ),

                      //inipunyasiapa
                      Padding(
                        padding: const EdgeInsets.only(top: 160.0),
                        child: Center(
                          child: result.length > 0
                              ? InkWell(
                                  onTap: () async {
                                    try {
                                      final path = join(
                                        (await getTemporaryDirectory()).path,
                                        '${DateTime.now()}.png',
                                      );

                                      await controller.takePicture(path);

                                     
                                    } catch (e) {
                                      print(e);
                                    }
                                  },
                                  
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.yellow,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4))),
                                    child: Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text(result,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 32.0)),
                                    ),
                                  ),
                                )
                              : Container(),
                        ),
                      ),

                    
                      //inipunyaconfidence
                      Padding(
                        padding: const EdgeInsets.only(top: 300.0),
                        child: Center(
                          child: confidence.length > 0
                              ? Container(
                                  decoration: BoxDecoration(
                                      color: Colors.yellow,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4))),
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text("Confidence " + confidence,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20.0)),
                                  ),
                                )
                              : Container(),
                        ),
                      ),
                      
                      Padding(
                          padding:
                              const EdgeInsets.only(top: 625.0, left: 200.0),
                          child: Container(
                              height: 80,
                              width: 80,
                              child: FittedBox(
                                  child: FloatingActionButton(
                                backgroundColor: Colors.orangeAccent,
                                child: Icon(Icons.image),
                                onPressed: () {
                                 
                                },
                              ))))
                    ],
                  )
                : Container(
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
                                child: Image.asset('assets/images/logo.png',
                                    width: size.width * 0.9, fit: BoxFit.fill),
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                  
                                    top: 0.0, left: 32.0, right: 32.0),
                                child: Text('Empon-empon(Rimpang)',
                                    style: TextStyle(
                                        color: Colors.yellow,
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.bold))),
                                        Padding(
                                padding: EdgeInsets.only(
                                    top: 0.0, left: 32.0, right: 32.0),
                                child: Text('Classification',
                                    style: TextStyle(
                                        color: Colors.yellow,
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.bold))),
                            Padding(
                                padding:
                                    EdgeInsets.only(left: 32.0, right: 32.0),
                                child: Text('Tekan tombol dibawah untuk klasifikasi!',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.0,
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
                                            "Let's Gooo!",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          color: Colors.yellow,
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
      ),
    );
  }
}
