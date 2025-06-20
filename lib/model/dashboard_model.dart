import 'package:intl/intl.dart';

class DashboardModel {
  bool? status;
  String? message;
  DashboardModelData? data;

  DashboardModel({this.status, this.message, this.data});

  DashboardModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data =
        json['data'] != null
            ? new DashboardModelData.fromJson(json['data'])
            : null;
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

class DashboardModelData {
  int? inquiryCount;
  int? contactCount;
  List<InquiryData>? inquiryData;
  List<ContactData>? contactData;

  DashboardModelData({
    this.inquiryCount,
    this.contactCount,
    this.inquiryData,
    this.contactData,
  });

  DashboardModelData.fromJson(Map<String, dynamic> json) {
    inquiryCount = json['inquiryCount'];
    contactCount = json['contactCount'];
    if (json['inquiryData'] != null) {
      inquiryData = <InquiryData>[];
      json['inquiryData'].forEach((v) {
        inquiryData!.add(new InquiryData.fromJson(v));
      });
    }
    if (json['contactData'] != null) {
      contactData = <ContactData>[];
      json['contactData'].forEach((v) {
        contactData!.add(new ContactData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['inquiryCount'] = this.inquiryCount;
    data['contactCount'] = this.contactCount;
    if (this.inquiryData != null) {
      data['inquiryData'] = this.inquiryData!.map((v) => v.toJson()).toList();
    }
    if (this.contactData != null) {
      data['contactData'] = this.contactData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class InquiryData {
  int? id;
  String? subject;
  String? name;
  String? email;
  String? phone;
  String? message;
  String? details;
  String? createdAt;

  InquiryData({
    this.id,
    this.subject,
    this.name,
    this.email,
    this.phone,
    this.message,
    this.details,
  });

  InquiryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subject = json['subject'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    message = json['message'];
    details = json['details'];
    createdAt = formatCreatedAt(json['created_at']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subject'] = this.subject;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['message'] = this.message;
    data['details'] = this.details;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class ContactData {
  int? id;
  String? name;
  String? email;
  String? contactno;
  String? message;
  String? createdAt;
  ContactData({this.id, this.name, this.email, this.contactno, this.message});

  ContactData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    contactno = json['contactno'];
    message = json['message'];
    createdAt = formatCreatedAt(json['created_at']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['contactno'] = this.contactno;
    data['message'] = this.message;
    data['created_at'] = this.createdAt;
    return data;
  }
}

String formatCreatedAt(String createdAt) {
  try {
    final dateTime = DateTime.parse(createdAt);
    final formatter = DateFormat(
      'MMMM d, y \'at\' h:mm a',
    ); // e.g., June 18, 2025 at 2:30 PM
    return formatter.format(dateTime);
  } catch (e) {
    return 'Invalid date';
  }
}
