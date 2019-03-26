import 'package:face_scan/ui/book_page.dart';
import 'package:face_scan/ui/mine_page.dart';
import 'package:face_scan/ui/scan_page.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../utils/io_utils.dart';
class HomePage extends StatefulWidget {

  final List<CameraDescription> cameras;

  HomePage({@required this.cameras});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeState();
  }
}

class _HomeState extends State<HomePage> with SingleTickerProviderStateMixin{
  TabController _controller;
  List<String> _list = ['Scan', 'Book', 'Mine'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TabController(length: _list.length, vsync: this);
    initPath(context);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text('Face Scan'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.share,
                color: Colors.white,
              ),
            )
          ],
        ),
        body:_buildBody(),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  Widget _buildBody() {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: TabBarView(
              controller: _controller,
              children: <Widget>[
                ScanPage(cameras:widget.cameras),
                BookPage(),
                MinePage(),
              ],
            ),
            flex: 8,
          ),
          Expanded(
            child: Container(
                decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0, -1),
                        blurRadius: 5,
                        spreadRadius: 5),
                  ],
                  color: Colors.black,
                ),
                child: Theme(
                  child: TabBar(
                    indicatorColor: Colors.black,
                    controller: _controller,
                    tabs: <Tab>[
                      Tab(
                        icon: Icon(Icons.camera),
                        text: 'Scan',
                      ),
                      Tab(
                        icon: Icon(Icons.dialpad),
                        text: 'Book',
                      ),
                      Tab(
                        icon: Icon(Icons.people),
                        text: 'Mine',
                      ),
                    ],
                  ),
                  data: Theme.of(context).copyWith(),
                )),
          )
        ],
      ),
    );
  }

}
