import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:math';
import 'package:skripsi/HalamanUtama.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as im;
import 'package:tflite/tflite.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import './clicky_buton.dart';

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

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  CameraController controller;
  bool isCameraReady = false;
  String result = '';
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
    setState(() {
      result = '';
    });

    final path = join(
      // Store the picture in the temp directory.
      // Find the temp directory using the `path_provider` plugin.
      (await getTemporaryDirectory()).path,
      '${DateTime.now()}.png',
    );
    await controller.takePicture(path);

    im.Image image = im.decodeImage(File(path).readAsBytesSync());
    int cropSize = min(image.width, image.height);
    int offsetX = (image.width - min(image.width, image.height)) ~/ 2;
    int offsetY = (image.height - min(image.width, image.height)) ~/ 2;

    im.Image imageSquare =
        im.copyCrop(image, offsetX, offsetY, cropSize, cropSize);

    int imgSize = 224;
    im.Image imageResized = im.copyResize(imageSquare,
        width: imgSize, height: imgSize, interpolation: im.Interpolation.cubic);
    Tflite.runModelOnBinary(
            binary: imageToByteListFloat32(imageResized, imgSize, 127.5, 127.5))
        .then((recognitions) {
      if (recognitions.length > 0) {
        print(recognitions.first);


        // Display new result
        setState(() {
          result = recognitions.first['label'];
          _speak(result);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Stack(
                  children: <Widget>[
                    Image.asset('assets/images/bkgg.jpg',
                        width: size.width,
                        height: size.height,
                        fit: BoxFit.cover),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
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
                    ),
                    Center(
                      child: result.length > 0
                          ? Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .secondaryHeaderColor
                                      .withAlpha(127),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4))),
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(result,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 32.0)),
                              ),
                            )
                          : Container(),
                    )
                  ],
                ),
      ),
    );
  }
}