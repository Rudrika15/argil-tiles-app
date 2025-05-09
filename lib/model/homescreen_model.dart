// class HomescreenModel {
//   int? id;
//   String? title;
//   String? sliderimg;

//   HomescreenModel({this.id, this.title, this.sliderimg});

//   HomescreenModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     title = json['title'];
//     sliderimg = json['sliderimg'];
//   }

//   String get image => 'null';

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['title'] = title;
//     data['sliderimg'] = sliderimg;
//     return data;
//   }
// }
class HomeSliderModel {
  bool? success;
  List<HomeSliderModelData>? data;
  String? message;

  HomeSliderModel({this.success, this.data, this.message});

  HomeSliderModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <HomeSliderModelData>[];
      json['data'].forEach((v) {
        data!.add(new HomeSliderModelData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class HomeSliderModelData {
  int? id;
  String? title;
  String? sliderimg;

  HomeSliderModelData({this.id, this.title, this.sliderimg});

  HomeSliderModelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    sliderimg = json['sliderimg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['sliderimg'] = this.sliderimg;
    return data;
  }
}
