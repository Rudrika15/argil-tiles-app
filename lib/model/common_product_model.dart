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


  ProductModel(
      {this.id,
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
     });

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    names = json['names'];
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
    return data;
  }
}
