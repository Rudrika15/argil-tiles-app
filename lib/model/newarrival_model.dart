import 'common_product_model.dart';

class NewArrivalModel {
  bool? success;
  String? message;
  String? url;
  List<ProductModel>? data;

  NewArrivalModel({this.data, this.message, this.success});
  NewArrivalModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    url = json['url'];
    if (json['data'] != null) {
      data = <ProductModel>[];
      json['data'].forEach((v) {
        data!.add(new ProductModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['url'] = this.url;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
