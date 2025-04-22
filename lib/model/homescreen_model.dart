class HomescreenModel {
  int? id;
  String? title;
  String? sliderimg;

  HomescreenModel({this.id, this.title, this.sliderimg});

  HomescreenModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    sliderimg = json['sliderimg'];
  }

  String get image => 'null';

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['sliderimg'] = sliderimg;
    return data;
  }
}
