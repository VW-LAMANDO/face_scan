import 'dart:io';

import 'package:face_scan/model/image_model.dart';
import 'package:face_scan/ui/custom/dialog.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class CameraListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CameraListState();
  }
}

class _CameraListState extends State<CameraListPage> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  List<String> list;
  List<bool> stats;
  List<Checkbox> checkBoxes;
  bool _isAllSelected = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    list = ScopedModel.of<ImageModel>(context).images;

    stats = List<bool>();
    for (int i = 0; i < list.length; i++) {
      stats.add(false);
    }
    checkBoxes = List<Checkbox>();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Theme(
      data: Theme.of(context).copyWith(),
      child: Scaffold(
        key: _globalKey,
        appBar: AppBar(
          title: Text('Camera List'),
          centerTitle: true,
//          actions: <Widget>[
//            RaisedButton(
//              splashColor: Colors.blue,
//              onPressed: () {
//                setState(() {
//                  _selectAll(value: !_isAllSelected);
//                  _isAllSelected = !_isAllSelected;
//                });
//              },
//              child: Text(
//                _isAllSelected ? 'Unselect All' :
//                'Select All',
//                style: TextStyle(
//                  color: Colors.white,
//                ),
//              ),
//              color: Colors.black,
//            )
//          ],
        ),
        body: _makeGrid(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: _showDialog,
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _makeGrid() {
    return Container(
      color: Colors.black,
      child: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 3,
          crossAxisSpacing: 3,
        ),
        children: _getImage(),
      ),
    );
  }

  List<Widget> _getImage() {
    List<Widget> widgets = List<Widget>();
    for (int i = 0; i < list.length; i++) {
      widgets.add(Stack(
        children: <Widget>[
          Container(
            child: Image.file(new File(list[i])),
            alignment: Alignment.center,
          ),
          Container(
            alignment: Alignment.topRight,
            child: Checkbox(
                value: stats[i],
                onChanged: (value) {
                  setState(() {
                    stats[i] = !stats[i];
                  });
                }),
          )
        ],
      ));
    }
    return widgets;
//    return list.map((index) {
//      return Stack(
//        children: <Widget>[
//          Container(
//            child: Image.file(new File(index)),
//            alignment: Alignment.center,
//          ),
//          Container(
//            alignment: Alignment.topRight,
//            child:
//                Checkbox(value: stats, onChanged: (value) {}),
//          )
//        ],
//      );
//    }).toList();
  }

  Checkbox _makeCheckBox(bool value) {
    return Checkbox(
        value: value,
        onChanged: (value) {
          setState(() {
            value = !value;
          });
        });
  }

  void _selectAll({@required bool value}) {
//    checkBoxes.forEach((chechbox){
//      chechbox.onChanged(value);
//    });
//    stats.forEach((element) => element = value);
  }

  bool _checkStatus() {
    bool flag = false;
    for (int i = 0; i < list.length; i++) {
      if (stats[i]) {
        flag = true;
      }
    }
    return flag;
  }

  void _showDialog() {
    if (!_checkStatus()) {
      showMsg(msg: 'No selected items');
      return;
    }

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return CustomDialog(
            title: 'Tips !!!',
            child: Text(
              'Are you sure for delete image?',
              style: TextStyle(color: Colors.black),
            ),
            positiveText: 'Confirm',
            negativeText: 'Cancel',
            onPositivePressEvent: () {
              Navigator.of(context).pop();
              _removeImages();
            },
          );
        }

//      builder: (context) {
//        return AlertDialog(
//          title: Text(
//            'Tips !!!',
//            style: TextStyle(
//                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
//          ),
//          content: Text(
//            'Please double check your choice',
//            style: TextStyle(color: Colors.black),
//          ),
//          actions: <Widget>[
//            FlatButton(
//              color: Colors.white,
//              onPressed: () {
//                Navigator.of(context).pop();
//              },
//              child: Text(
//                'Cancel',
//                style: TextStyle(color: Colors.grey),
//              ),
//            ),
//            FlatButton(
//              color: Colors.white,
//              onPressed: (){
//
//                Navigator.of(context).pop();
//                _removeImages();
//              },
//              child: Text(
//                'Confirm',
//                style: TextStyle(
//                  color: Colors.blue,
//                ),
//              ),
//            )
//          ],
//        );
//      },
        );
  }

  void _removeImages() {

    List<int> tempList = List<int>();
    print('length is ${list.length}');
    for (int i = 0; i < list.length; i++) {
      if (stats[i]) {
        tempList.add(i);
        File(list[i])..deleteSync();
      }
    }
    for(int i = tempList.length - 1; i >= 0; i--){
      ScopedModel.of<ImageModel>(context).removePath(i);
    }
    setState(() {
      list = ScopedModel.of<ImageModel>(context).images;
      for (int i = 0; i < list.length; i++) {
        stats[i] = false;
      }
    });
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
}
