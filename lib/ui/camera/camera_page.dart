import 'package:face_scan/common/router.dart';
import 'package:face_scan/model/image_model.dart';
import 'package:face_scan/ui/custom/circle.dart';
import 'package:face_scan/utils/io_utils.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:scoped_model/scoped_model.dart';

class CameraPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  bool isFront;

  CameraPage({@required this.cameras, this.isFront});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CamereState();
  }
}

class _CamereState extends State<CameraPage> {
  CameraController _controller;
  bool _isRear;
  bool _hasFrontAndRear;
  String dirPath;
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.isFront) {
      _initCameraController(widget.cameras[1]);
    } else {
      _initCameraController(widget.cameras[0]);
    }

    _isRear = true;
    if (widget.cameras.length >= 1) {
      _hasFrontAndRear = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _makeBody();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _initCameraController(CameraDescription description) async {
    if (_controller != null) {
      await _controller.dispose();
    }
    _controller = CameraController(description, ResolutionPreset.medium);
    _controller.initialize().then((_) {
      setState(() {});
    });
  }

  void _switchCamera() {
    if (_hasFrontAndRear) {
      if (_isRear) {
        _initCameraController(widget.cameras[1]);
        _isRear = false;
      } else {
        _initCameraController(widget.cameras[0]);
        _isRear = true;
      }
    }
  }

  String timeStamp() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  Future<String> _takePicture() async {
    if (!_controller.value.isInitialized) {
      return null;
    }
    String fileName = '${timeStamp()}.jpg';
    String dirPath = await getPath();
    final String filePath = '$dirPath/$fileName';
    if (_controller.value.isTakingPicture) {
      return null;
    }
    try {
      await _controller.takePicture(filePath);
//      showMsg(msg: fileName);
      ScopedModel.of<ImageModel>(context).addPath(filePath);
      jump2CameraImagePage(context, imagePath: filePath,isScan: !widget.isFront);
      setState(() {});
    } on CameraException catch (e) {
      print(e);
      return null;
    }
    return filePath;
  }

  void showMsg({@required String msg}) {
    _globalKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Colors.green[600],
      content: Text(
        msg,
        style: TextStyle(),
      ),
      action: SnackBarAction(
        label: 'Cancel',
        onPressed: _globalKey.currentState.hideCurrentSnackBar,
      ),
    ));
  }

  Widget _makeBody() {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text("Camera"),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: _makeSubBody(),
            ),
            Expanded(
              child: Container(
                color: Colors.black,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Center(
                        child: _hasFrontAndRear
                            ? OutlineButton(
                                onPressed: _switchCamera,
                                child: Icon(
                                  _isRear
                                      ? Icons.camera_front
                                      : Icons.camera_rear,
                                  color: Colors.white,
                                ),
                                highlightColor: Colors.green,
                                borderSide: BorderSide(
                                  width: 0,
                                ),
                                shape: CircleBorder(
                                    side: BorderSide(
                                        color: Colors.black, width: 2)),
                              )
                            : Container(),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: OutlineButton(
                          onPressed: _takePicture,
                          highlightColor: Colors.blue,
                          child: Icon(
                            Icons.camera,
                            color: Colors.white,
                            size: 40,
                          ),
                          shape: CircleBorder(
                              side: BorderSide(color: Colors.black, width: 2)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: widget.isFront
                          ? Container()
                          : Container(
                              width: 50,
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.all(10),
                              child: _getThumbPic(),
                            ),
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

  Widget _makeSubBody() {
    if (widget.cameras.isEmpty) {
      return Container(
        color: Colors.black,
        child: Center(
          child: Text(
            'No Camera Found',
            style: TextStyle(
              color: Colors.red,
              fontSize: 20,
            ),
          ),
        ),
      );
    } else if (!_controller.value.isInitialized) {
      return Container(
        color: Colors.black,
        child: Center(
          child: Text(
            'Loading,please wait',
            style: TextStyle(
              color: Colors.red,
              fontSize: 20,
            ),
          ),
        ),
      );
    } else {
      return Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.black87,
            ),
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: CameraPreview(_controller),
            ),
          ),
          Center(
            child: CirclePaint(
              size: Size(MediaQuery.of(context).size.height / 3,
                  MediaQuery.of(context).size.height / 3),
            ),
          ),
        ],
      );
    }
  }

  Widget _getThumbPic() {
    int length = ScopedModel.of<ImageModel>(
      context,
    ).length;
    return length > 0
        ? _getImage()
        : Container(
            alignment: Alignment.center,
            child: Text(
              'No Picture',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          );
  }

  Widget _getImage() {
    return InkWell(
      onTap: () {
        jump2CameraListPage(context);
      },
      child: FadeInImage(
          placeholder: AssetImage('./assets/black.jpg'),
          image: FileImage(File(
              ScopedModel.of<ImageModel>(context, rebuildOnChange: true)
                  .last))),
    );
  }
}
