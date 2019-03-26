import 'package:face_scan/model/image_model.dart';
import 'package:face_scan/ui/home_page.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:scoped_model/scoped_model.dart';

List<CameraDescription> cameras;

Future<void> main() async {
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModel<ImageModel>(
      model: ImageModel.init(),
      child: MaterialApp(
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
//        primarySwatch: Colors.blue,
          primaryColor: Colors.black,
        ),
        home: HomePage(
          cameras: cameras,
        ),
      ),
    );
  }
}
