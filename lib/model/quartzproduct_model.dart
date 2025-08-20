import 'common_product_model.dart';

class QuartzProductModel {
  bool? success;
  String? message;
  List<ProductModel>? data;

  QuartzProductModel({this.data, this.message, this.success});
  QuartzProductModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <ProductModel>[];
      json['data'].forEach((v) {
        /// here this `false` is for wethere this product is `SPC` product
        /// `false` meaning its not a SPC product
        data!.add(new ProductModel.fromJson(v,false));
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
