import 'package:face_scan/model/image_model.dart';
import 'package:face_scan/ui/custom/dialog.dart';
import 'package:face_scan/utils/constaints_util.dart';
import 'package:face_scan/utils/io_utils.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class CameraImagePage extends StatefulWidget {
  final String imagePath;
  final bool isScan;

  CameraImagePage({@required this.imagePath, @required this.isScan, Key key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CameraImagePageState();
  }
}

class _CameraImagePageState extends State<CameraImagePage> {
  TextEditingController _editingController;
  int _count;
  bool _inputError;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _editingController = TextEditingController();
    _count = 0;
    _inputError = false;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _makeBody();
  }

  Widget _getImage() {
    return FadeInImage(
      placeholder: AssetImage('./assets/placeholder.jpg'),
      image: FileImage(
        File(widget.imagePath),
      ),
    );
  }

  Widget _makeBody() {
    return WillPopScope(
      onWillPop: () {
        _popBack();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Camera Image'),
          centerTitle: true,
          actions: <Widget>[
            Icon(
              Icons.share,
            )
          ],
        ),
        body: Stack(
          children: <Widget>[
            Container(
              color: Colors.black,
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: _getImage(),
            ),
            Positioned(
              bottom: CAMERA_IMAGE_MARGIN_BOTTOM,
              left: CAMERA_IMAGE_MARGIN_LEFT,
              child: OutlineButton(
                color: Colors.grey,
                onPressed: _popBack,
                highlightColor: Colors.blue,
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: CAMERA_IMAGE_CIRCLE_RADIUS,
                ),
                shape: CircleBorder(
                    side: BorderSide(color: Colors.black, width: 2)),
              ),
            ),
            Positioned(
              bottom: CAMERA_IMAGE_MARGIN_BOTTOM,
              right: CAMERA_IMAGE_MARGIN_RIGHT,
              child: OutlineButton(
                color: Colors.grey,
                onPressed: _handle,
                highlightColor: Colors.green,
                child: Icon(
                  Icons.done,
                  color: Colors.white,
                  size: CAMERA_IMAGE_CIRCLE_RADIUS,
                ),
                shape: CircleBorder(
                    side: BorderSide(color: Colors.black, width: 2)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _popBack() {
    File file = File(widget.imagePath);
    file.deleteSync();
    ScopedModel.of<ImageModel>(context).removeLast();
    Navigator.of(context).pop();
  }

  Future<void> _handle() async {
    if (_count == 0) {
      if (widget.isScan) {
        await compressImage(widget.imagePath);
      } else {
        await compressImage(widget.imagePath, 270);
      }
    }
    _count++;
    if (_count >= DIALOG_MAX_TIMES) {
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            return CustomDialog(
              title: 'hmmmmmm',
              child: Text('Please don\'t play with me, just get away'),
              negativeText: 'Leave',
              positiveText: 'Leave',
              onPositivePressEvent: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            );
          });
      return;
    }

    if (widget.isScan) {
      await _scan();
      Navigator.of(context).pop();
    } else {
      await _checkIn();
    }

//    Navigator.of(context).pop();
  }

  Future<void> _checkIn() async {
    //io upload
    _showDialog();
  }

  Future<void> _scan() async {
    //dialog input name

    //io upload
  }

  void _showDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, state) {
            return CustomDialog(
              title: 'Please input your name',
              child: TextField(
                controller: _editingController,
                decoration: InputDecoration(
                  errorText: _inputError ? 'Can\'t be empty' : null,
                  icon: Icon(Icons.people),
                  hintText: 'Your Name',
                ),
                maxLength: 15,
                cursorColor: Colors.green,
              ),
              negativeText: 'Cancel',
              positiveText: 'OK',
              onPositivePressEvent: () {
                if (_editingController.text.isEmpty) {
                  state(() {
                    _inputError = true;
                  });
                  return;
                } else {
                  state(() {
                    _inputError = false;
                  });
                }

                DioUtil.get().upload(
                    name: _editingController.text,
                    filePath: widget.imagePath,
                    callback: (count, total) {
                      if (total != -1) {
                        Navigator.of(context).pop();
                      }
                    });
                //IO
              },
            );
          },
        );
      },
    );
  }

  Future<List<int>> compressImage(String path, [int rotate = 90]) async {
    var result = await FlutterImageCompress.compressWithFile(
      path,
      minWidth: IMAGE_MIN_WIDTH,
      minHeight: IMAGE_MIN_HEIGHT,
      quality: IMAGE_QUALITY,
      rotate: rotate,
    );
    print(result.length);

    File file = File(path);
    file.deleteSync();
    writeToFile(result, path);
    return result;
  }

  void writeToFile(List<int> list, String filePath) {
    var file = File(filePath);
    file.writeAsBytes(list, flush: true, mode: FileMode.write);
  }
}
