import 'package:flutter/material.dart';
import '../common/router.dart';
import 'package:camera/camera.dart';
class ScanPage extends StatefulWidget {

  final List<CameraDescription> cameras;

  ScanPage({@required this.cameras});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ScanState();
  }
}

class _ScanState extends State<ScanPage> with AutomaticKeepAliveClientMixin {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: InkWell(
                onTap: () {
                  jump2CameraPage(context,cameras : widget.cameras,isFront: true);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.green,
                          offset: Offset(0.5, 0.5),
                          blurRadius: 1,
                          spreadRadius: 1,
                        ),
                      ]),
                  child: Center(
                    child: Text(
                      'Check In',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                )),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                jump2CameraPage(context,cameras:widget.cameras,isFront: false);
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.blue,
                        offset: Offset(0.5, 0.5),
                        blurRadius: 1,
                        spreadRadius: 1,
                      ),
                    ]),
                child: Center(
                  child: Text(
                    'Scan',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;
}
