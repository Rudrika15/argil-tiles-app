import 'common_product_model.dart';

class NewarrivalModel {
  bool? status;
  String? type;
  String? url;
  List<ProductModel>? data;

  var image;

  NewarrivalModel({this.status, this.type, this.data,this.url,});

  NewarrivalModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    url = json['url'];
    type = json['type'];
    if (json['data'] != null) {
      data = <ProductModel>[];
      json['data'].forEach((v) {
        data!.add( ProductModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['type'] = type;
     data['url'] = url;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

