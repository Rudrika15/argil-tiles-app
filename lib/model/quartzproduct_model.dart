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
