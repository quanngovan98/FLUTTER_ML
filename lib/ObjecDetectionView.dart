import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ml_ki_example/services/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class ObjectDetectionView extends StatefulWidget {
  @override
  _ObjectDetectionViewState createState() => _ObjectDetectionViewState();
}

class _ObjectDetectionViewState extends State<ObjectDetectionView> {
  String _model = Constants.ssd;
  File _imageFile;
  ui.Image _image;
  bool _busy = true;
  List _recognitions;
  double _imageWidth;
  double _imageHeight;

  @override
  void initState() {
    super.initState();
    setState(() {
      _busy = true;
    });
    loadModel().then((val) {
      setState(() {
        _busy = false;
      });
    });
  }

  Future loadModel() async {
    Tflite.close();
    try {
      String res;
      if (_model == Constants.yolo) {
        res = await Tflite.loadModel(
            model: "assets/tflite/yolov2_tiny.tflite",
            labels: "assets/tflite/yolov2_tiny.txt");
      } else if (_model == Constants.ssd) {
        res = await Tflite.loadModel(
            model: "assets/tflite/ssd_mobilenet.tflite",
            labels: "assets/tflite/ssd_mobilenet.txt");
      }
      print(res);
    } on PlatformException {
      print("fail to load model");
    }
  }

  void _getImageAndDetectObjects() async {
    final imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _busy = true;
    });
    if (_model == Constants.yolo) {
      await yolov2Tiny(imageFile);
    } else if (_model == Constants.ssd) {
      await ssdMobilenet(imageFile);
    }
    FileImage(imageFile)
        .resolve(ImageConfiguration())
        .addListener((ImageStreamListener((ImageInfo info, bool _) {
          setState(() {
            _imageWidth = info.image.width.toDouble();
            _imageHeight = info.image.height.toDouble();
          });
        })));
    if (mounted) {
      setState(() {
        _imageFile = imageFile;
        _busy = false;
      });
    }
  }

  List<Widget> renderBoxes(Size screen) {
    if (_recognitions == null) return [];
    if (_imageWidth == null || _imageHeight == null) return [];

    double factorX = screen.width;
    double factorY = _imageHeight / _imageWidth * screen.width;

    Color blue = Colors.red;

    return _recognitions.map((re) {
      return Positioned(
        left: re["rect"]["x"] * factorX,
        top: re["rect"]["y"] * factorY,
        width: re["rect"]["w"] * factorX,
        height: re["rect"]["h"] * factorY,
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
            color: blue,
            width: 3,
          )),
          child: Text(
            "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              background: Paint()..color = blue,
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
      );
    }).toList();
  }

  yolov2Tiny(File imageFile) async {
    var recognitions = await Tflite.detectObjectOnImage(
      path: imageFile.path,
      model: "YOLO",
      threshold: 0.3,
      imageMean: 0.0,
      imageStd: 255.0,
      numResultsPerClass: 1,
    );
    setState(() {
      _recognitions = recognitions;
    });
  }

  ssdMobilenet(File imageFile) async {
    var recognitions = await Tflite.detectObjectOnImage(
      path: imageFile.path,
      numResultsPerClass: 1,
    );
    setState(() {
      _recognitions = recognitions;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    List<Widget> stackChildren = [];

    stackChildren.add(Positioned(
      top: 0.0,
      left: 0.0,
      width: size.width,
      child: _imageFile == null
          ? Text("No Image Selected")
          : Image.file(
              _imageFile,
            ),
    ));

    stackChildren.addAll(renderBoxes(size));

    if (_busy) {
      stackChildren.add(Center(
        child: CircularProgressIndicator(),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("TFLite Demo"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.image),
        tooltip: "Pick Image from gallery",
        onPressed: _getImageAndDetectObjects,
      ),
      body: Stack(
        children: stackChildren,
      ),
    );
  }
}
