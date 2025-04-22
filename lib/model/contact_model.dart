class ContactModel {
  String? name;
  String? email;
  String? contactno;
  String? message;
  int? id;

  ContactModel(
      {this.name,
      this.email,
      this.contactno,
      this.message,
      this.id});

  ContactModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    contactno = json['contactno'];
    message = json['message'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] =  name;
    data['email'] =  email;
    data['contactno'] =  contactno;
    data['message'] =  message;
    data['id'] =  id;
    return data;
  }
}
