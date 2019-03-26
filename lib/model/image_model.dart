import 'package:scoped_model/scoped_model.dart';
class ImageModel extends Model{
  List<String> _imagePath;

  ImageModel.init() {
    if (_imagePath == null) {
      _imagePath = List<String>();
    }
  }

  void addPath(String path){
    _imagePath?.add(path);
    notifyListeners();
  }

  void removePath(int index){
    _imagePath?.removeAt(index);
    notifyListeners();
  }

  void removeLast(){
    _imagePath?.removeLast();
    notifyListeners();
  }


  String get last => _imagePath.last;

  int get length => _imagePath.length;

  List<String> get images => _imagePath;

}

class ImageBean{


  String name;
  String image;

  ImageBean(this.name,this.image);

  ImageBean.fromJson(Map<String, dynamic> json):name = json['name'],
        image = json['image'];

  Map<String, dynamic> toJson() => {
    "name" : name,
    "image" : image,
  };

}
