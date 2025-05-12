class NewArrivalModel {
  bool? success;
  NewArrivalModelData? data;
  String? message;

  NewArrivalModel({this.success, this.data, this.message});

  NewArrivalModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new NewArrivalModelData.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class NewArrivalModelData {
  int? id;
  String? image;
  String? navigateUrl;
  String? createdAt;
  String? updatedAt;

  NewArrivalModelData({this.id, this.image, this.navigateUrl, this.createdAt, this.updatedAt});

  NewArrivalModelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    navigateUrl = json['navigate_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['navigate_url'] = this.navigateUrl;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
