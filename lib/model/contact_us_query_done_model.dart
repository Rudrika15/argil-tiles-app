class ContactUsQueryDone {
  bool? status;
  String? message;
  Data? data;

  ContactUsQueryDone({this.status, this.message, this.data});

  ContactUsQueryDone.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? subject;
  String? name;
  String? email;
  String? phone;
  String? message;
  String? details;
  int? id;

  Data({
    this.subject,
    this.name,
    this.email,
    this.phone,
    this.message,
    this.details,
    this.id,
  });

  Data.fromJson(Map<String, dynamic> json) {
    subject = json['subject'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    message = json['message'];
    details = json['details'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subject'] = this.subject;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['message'] = this.message;
    data['details'] = this.details;
    data['id'] = this.id;
    return data;
  }
}
