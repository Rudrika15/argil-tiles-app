import 'common_product_model.dart';

class SpcProductModel {
  bool? success;
  String? message;
  List<ProductModel>? data;

  SpcProductModel({this.data, this.message, this.success});
  SpcProductModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <ProductModel>[];
      json['data'].forEach((v) {
        /// here this `true` is for wethere this product is `SPC` product
        /// `true` meaning its a SPC product
        data!.add(new ProductModel.fromJson(v,true));
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
