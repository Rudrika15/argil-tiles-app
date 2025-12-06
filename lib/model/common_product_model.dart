import 'package:argil_tiles/utils/shared_preference/shared_prefrence.dart';

class ProductModel {
  int? id;
  String? names;
  String? thicknesses;
  String? primarycolors;
  String? edges;
  String? clicktype;
  String? shadeVariation;
  String? backingType;
  String? style;
  String? wearLayer;
  String? bookmatch;
  String? mainImg;
  String? subImg1;
  String? subImg2;
  String? subImg3;
  String? subImg4;
  String? subImg5;
  String? status;
  String? image;
  String? navigateUrl;
  String? imageUrl;
  bool? isFavorite;
  String? finishType;
  String? sizes;
  late final bool isSpcProduct;

  /// new key added on 2025-12-06
  String? stock;

  ProductModel({
    this.id,
    this.names,
    this.thicknesses,
    this.primarycolors,
    this.edges,
    this.clicktype,
    this.shadeVariation,
    this.backingType,
    this.style,
    this.wearLayer,
    this.bookmatch,
    this.mainImg,
    this.subImg1,
    this.subImg2,
    this.subImg3,
    this.subImg4,
    this.subImg5,
    this.status,
    this.image,
    this.navigateUrl,
    this.imageUrl,
    this.isFavorite,
    this.finishType,
    this.sizes,
    required this.isSpcProduct,
    this.stock,
  });

  ProductModel.fromJson(Map<String, dynamic> json, bool? isSpc) {
    id = json['id'];
    names = json['names'] == null ? json['name'] : json['names'];
    thicknesses = json['thicknesses'];
    primarycolors = json['primarycolors'];
    edges = json['edges'];
    clicktype = json['clicktype'];
    shadeVariation = json['shadeVariation'];
    backingType = json['backingType'];
    style = json['style'];
    wearLayer = json['wearLayer'];
    bookmatch = json['bookmatch'];
    mainImg = json['mainImg'];
    subImg1 = json['subImg1'];
    subImg2 = json['subImg2'];
    subImg3 = json['subImg3'];
    subImg4 = json['subImg4'];
    subImg5 = json['subImg5'];
    status = json['status'];
    image = json['image'];
    imageUrl = json['imageURL'];
    navigateUrl = json['navigate_url'];
    finishType = json['finishType'];
    sizes = json['sizes'];
    stock = json['stock'];

    /// init isSpcProduct from either directly with `isSpc` or from json itself
    isSpcProduct = isSpc ?? json['isSpc'];
  }

  /// get which product is favorite
  void getIsFavorite({
    required String key,
    required Function()? setState,
  }) async {
    isFavorite = await SharedPrefs.getBool(key: key);
    setState;
  }

  List<String> get availableImages {
    return [mainImg, subImg1, subImg2, subImg3, subImg4, subImg5]
        .where((image) => image != null && image.isNotEmpty)
        .cast<String>()
        .toList();
  }

  String? getImageByIndex({required int index}) {
    return availableImages[index];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['names'] = this.names;
    data['thicknesses'] = this.thicknesses;
    data['primarycolors'] = this.primarycolors;
    data['edges'] = this.edges;
    data['clicktype'] = this.clicktype;
    data['shadeVariation'] = this.shadeVariation;
    data['backingType'] = this.backingType;
    data['style'] = this.style;
    data['wearLayer'] = this.wearLayer;
    data['bookmatch'] = this.bookmatch;
    data['mainImg'] = this.mainImg;
    data['subImg1'] = this.subImg1;
    data['subImg2'] = this.subImg2;
    data['subImg3'] = this.subImg3;
    data['subImg4'] = this.subImg4;
    data['subImg5'] = this.subImg5;
    data['status'] = this.status;
    data['image'] = this.image;
    data['imageURL'] = this.imageUrl;
    data['navigate_url'] = this.navigateUrl;
    data['finishType'] = this.finishType;
    data['sizes'] = this.sizes;

    /// will save the isSpc for `FavouriteProducts`
    data['isSpc'] = this.isSpcProduct;
    data['stock'] = this.stock;
    return data;
  }
}


/// product model schema as of 2025-12-06
// {
//         "id": 27,
//         "name": "201-MINERAL WHITE",
//         "slug": "201-mineral-white",
//         "sizes": "3200 X 6400 MM",
//         "thicknesses": "20 X 30 MM",
//         "finishType": "GLOSSY",
//         "stock": "NEW",
//         "primarycolors": "White",
//         "bookmatch": "NA",
//         "mainImg": "1765002062359445565.jpg",
//         "subImg1": null,
//         "subImg2": null,
//         "subImg3": null,
//         "subImg4": null,
//         "subImg5": null,
//         "status": "Active",
//         "created_at": "2025-12-06T06:21:02.000000Z",
//         "updated_at": "2025-12-06T06:21:02.000000Z"
//       }