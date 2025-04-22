class ProductInquiryModel {
  String? subject;
  String? name;
  String? email;
  String? phone;
  String? message;
  String? details;
  int? id;

  ProductInquiryModel(
      {this.subject,
      this.name,
      this.email,
      this.phone,
      this.message,
      this.details,
      this.id, required bool requestSample});

  ProductInquiryModel.fromJson(Map<String, dynamic> json) {
    subject = json['subject'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    message = json['message'];
    details = json['details'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subject'] =  subject;
    data['name'] =  name;
    data['email'] =  email;
    data['phone'] =  phone;
    data['message'] =  message;
    data['details'] =  details;
    data['id'] =  id;
    return data;
  }
}
