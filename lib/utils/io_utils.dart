import 'dart:io';
import 'dart:convert';
import 'package:face_scan/model/image_model.dart';
import 'package:face_scan/utils/constaints_util.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission/permission.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:dio/dio.dart';

Future<void> initPath(BuildContext context) async {
  await Permission.requestPermissions([PermissionName.Storage]);
  Directory dir = await getExternalStorageDirectory();
  String dirPath = '${dir.path}/$CAMERA_STORE_DIR_PATH';
  Directory directory = Directory(dirPath);
  if (!await directory.exists()) {
    await Directory(dirPath).create(recursive: true);
  }
  Stream<FileSystemEntity> stream = directory.list(recursive: false);
  await for (FileSystemEntity entity in stream) {
    ScopedModel.of<ImageModel>(context).addPath(entity.path);
    print(entity.path);
  }
}

Future<String> getPath() async{
  Directory dir = await getExternalStorageDirectory();
  String dirPath = '${dir.path}/$CAMERA_STORE_DIR_PATH';
  return dirPath;
}

String convertBase64(String path){

  String base64String = base64Encode(File(path).readAsBytesSync());
  return base64String;
}


class DioUtil{

  Dio _dio;
  DioUtil(){
    _dio = Dio();
    _dio.options.baseUrl = DIO_OPTIONS_BASEURL;
    _dio.options.connectTimeout = DIO_OPTIONS_CONNECT_TIMEOUT;
    _dio.options.receiveTimeout = DIO_OPTIONS_RECEIVE_TIMEOUT;
  }

  static DioUtil instance = DioUtil();
  factory DioUtil.get() => instance;


  DioUtil configuration({@required bool proxyEnable, @required String proxy}){
    DefaultHttpClientAdapter adapter = DefaultHttpClientAdapter();
    adapter.onHttpClientCreate = (client) {
      if (client == null) {
        client = HttpClient(context: SecurityContext());
      }

      client.findProxy = (uri) => 'PROXY $proxy';
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
//        print('cert :${cert.pem}, host : $host');
        return true;
      };
    };
    _dio.httpClientAdapter = adapter;
    return this;
  }

  DioUtil addInterceptors(Interceptor interceptor){
    _dio.interceptors.add(interceptor);
    return this;
  }


  void upload({@required String name,@required String filePath,@required ProgressCallback callback}){

    File file = File(filePath);

    if(! file.existsSync()){
       return;
    }
    String base64Value = base64Encode(file.readAsBytesSync());

//    String str = jsonEncode(object)

    _dio.post('/image_upload',
        data: ImageBean(name, base64Value),
      onReceiveProgress:callback,
    );
  }

}

