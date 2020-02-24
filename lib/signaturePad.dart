import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'constants.dart';
import 'modelClasses.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SignaturePainter extends CustomPainter {
  Paint _paint;
  SignaturePainter(this.points, this._paint);
  final List<Offset> points;
  List<Offset> offsetPoints = List();

  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null)
        canvas.drawLine(points[i], points[i + 1], _paint);
      if (points[i] != null && points[i + 1] == null) {
        offsetPoints.clear();
        offsetPoints.add(points[i]);
        offsetPoints.add(Offset(points[i].dx + 0.1, points[i].dy + 0.1));
        canvas.drawPoints(ui.PointMode.points, offsetPoints, _paint);
      }
    }
  }

  bool shouldRepaint(SignaturePainter other) => other.points != points;
}

class Signature extends StatefulWidget {
  final Team team;
  final Map<String, dynamic> resultMap;
  Signature(this.team, this.resultMap);
  SignatureState createState() => new SignatureState();
}

class SignatureState extends State<Signature> implements ClearScreen {
  List<Offset> _points = <Offset>[];
  Paint backgroundPaint, foregroundPaint;
  GlobalKey globalKey = GlobalKey();
  SignaturePainter signaturePainter;
  StorageReference storageReference;

  @override
  void initState() {
    backgroundPaint = new Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    super.initState();
  }

  Widget build(BuildContext context) {
    signaturePainter = SignaturePainter(_points, backgroundPaint);
    return Scaffold(
      body: Container(
        decoration: appGradient,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            GestureDetector(
              onPanUpdate: (DragUpdateDetails details) {
                RenderBox referenceBox = context.findRenderObject();
                Offset localPosition =
                    referenceBox.globalToLocal(details.globalPosition);
                setState(() {
                  _points = new List.from(_points)..add(localPosition);
                });
              },
              onPanEnd: (DragEndDetails details) => _points.add(null),
              onPanStart: (details) {
                setState(() {
                  RenderBox referenceBox = context.findRenderObject();
                  Offset localPosition =
                      referenceBox.globalToLocal(details.globalPosition);
                  _points = List.from(_points)..add(localPosition);
                });
              },
            ),
            CustomPaint(
              painter: signaturePainter,
            ),
            Positioned(
              bottom: 0.0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Button("Proceed", Alignment.bottomLeft, this, 0),
                        Button("Redo", Alignment.bottomRight, this, 1),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void clearScreen() {
    setState(() {
      _points.clear();
    });
  }

  @override
  void performProceedTapAction() async {
    ProgressBar progressBar = ProgressBar();
    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas canvas = new Canvas(recorder);
    try {
      showDialog(context: context, builder: (con) => progressBar);
      signaturePainter.paint(canvas, Size.infinite);
      ui.Picture p = recorder.endRecording();
      ui.Image image = await p.toImage(
          MediaQuery.of(context).size.width.toInt(),
          MediaQuery.of(context).size.height.toInt());
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      print(byteData.buffer.asUint8List());
      var external = await getExternalStorageDirectory();
      String path = external.path;
      File file =
          File("$path/image-${DateTime.now().millisecondsSinceEpoch}.png");
      await file.writeAsBytes(byteData.buffer.asUint8List());
      storageReference = FirebaseStorage.instance
          .ref()
          .child(DateTime.now().millisecondsSinceEpoch.toString());
      StorageUploadTask uploadTask = storageReference.putFile(file);
      final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
      final String url = (await downloadUrl.ref.getDownloadURL());
      print('URL Is $url');
      var id = DateTime.now().millisecondsSinceEpoch.toString();
      Map<String, dynamic> rMap = new Map();
      List<Map<String, dynamic>> qRList = new List();
      print(widget.resultMap);
      widget.resultMap.forEach((k, v) {
        Map<String, double> map = new Map();
        map[k] = v;
        qRList.add(map);
        print("Printing list /./.$qRList");
      });
      rMap['resultList'] = qRList;
      rMap["tid"] = widget.team.tid;
      rMap['teamName'] = widget.team.teamName;
      rMap["resultId"] = id;
      rMap['level'] = widget.team.level;
      rMap['url'] = url;
      await Firestore.instance.collection("results").document(id).setData(rMap);
      Navigator.of(context, rootNavigator: true).pop(true);
      Navigator.of(context).pop();
    } catch (exception) {
      print(exception);
      Fluttertoast.showToast(
          msg: "Something went wrong,try resubmitting",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.blueGrey.shade500,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}

abstract class ClearScreen {
  void clearScreen();
  void performProceedTapAction();
}

class Button extends StatelessWidget {
  final String buttonText;
  final Alignment alignment;
  final ClearScreen mListener;
  final flag;
  const Button(this.buttonText, this.alignment, this.mListener, this.flag);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width / 2,
        child: Card(
          elevation: 10,
          color: Color.fromARGB(255, 149, 208, 158),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: InkWell(
            onTap: () {
              if (flag == 1) {
                mListener.clearScreen();
              } else if (flag == 0) {
                mListener.performProceedTapAction();
              }
            },
            child: Center(
                child: Text(
              buttonText,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  fontSize: 20),
            )),
          ),
        ),
      ),
    );
  }
}

class ProgressBar extends StatefulWidget {
  const ProgressBar();
  _ProgressBarState createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
            height: 100,
            width: 100,
            child: Center(
                child: Container(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator()))));
  }
}
