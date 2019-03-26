import 'package:camera/camera.dart';
import 'package:face_scan/ui/camera/camera_image_page.dart';
import 'package:face_scan/ui/camera/camera_list_page.dart';
import 'package:face_scan/ui/camera/camera_page.dart';
import 'package:flutter/material.dart';

void jump2CameraPage(BuildContext context,
    {@required List<CameraDescription> cameras, bool isFront}) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
    return CameraPage(
      cameras: cameras,
      isFront: isFront,
    );
  }));
}

void jump2CameraImagePage(
  BuildContext context, {
  @required String imagePath,
  @required bool isScan,
}) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
    return CameraImagePage(
      imagePath: imagePath,
      isScan: isScan,
    );
  }));
}

void jump2CameraListPage(
  BuildContext context,
) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
    return CameraListPage();
  }));
}
