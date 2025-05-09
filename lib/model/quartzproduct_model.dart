// class QuartzproductModel {
//   int? id;
//   String? name;
//   String? sizes;
//   String? thicknesses;
//   String? finishType;
//   String? stock;
//   String? primarycolors;
//   String? bookmatch;
//   String? mainImg;
//   String? subImg1;
//   String? status;

//   QuartzproductModel({
//     this.id,
//     this.name,
//     this.sizes,
//     this.thicknesses,
//     this.finishType,
//     this.stock,
//     this.primarycolors,
//     this.bookmatch,
//     this.mainImg,
//     this.subImg1,
//     this.status,

//   });

//   QuartzproductModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     sizes = json['sizes'];
//     thicknesses = json['thicknesses'];
//     finishType = json['finishType'];
//     stock = json['stock'];
//     primarycolors = json['primarycolors'];
//     bookmatch = json['bookmatch'];
//     mainImg = json['mainImg'];
//     subImg1 = json['subImg1'];
//     status = json['status'];
//   }

//   String get image => 'null';

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['name'] = name;
//     data['sizes'] = sizes;
//     data['thicknesses'] = thicknesses;
//     data['finishType'] = finishType;
//     data['stock'] = stock;
//     data['primarycolors'] = primarycolors;
//     data['bookmatch'] = bookmatch;
//     data['mainImg'] = mainImg;
//     data['status'] = status;
//     return data;
//   }
// }
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
        data!.add(new ProductModel.fromJson(v));
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
