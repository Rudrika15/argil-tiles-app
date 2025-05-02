class ProductInquiryModel {
  String? subject;
  String? productName;
  String? name;
  String? email;
  String? phone;
  String? message;
  String? details;
  int? id;

  ProductInquiryModel({
    this.subject,
    this.name,
    this.productName,
    this.email,
    this.phone,
    this.message,
    this.details,
    this.id,
    required bool requestSample,
  });

  ProductInquiryModel.fromJson(Map<String, dynamic> json) {
    subject = json['subject'];
    productName = json['productname'];
    name = json['name'];
    email = json['email'];
    phone = json['contactno'];
    message = json['message'];
    details = json['details'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subject'] = subject;
    data['productname'] = productName;
    data['name'] = name;
    data['email'] = email;
    data['contactno'] = phone;
    data['message'] = message;
    data['details'] = details;
    data['id'] = id;
    return data;
  }
}
