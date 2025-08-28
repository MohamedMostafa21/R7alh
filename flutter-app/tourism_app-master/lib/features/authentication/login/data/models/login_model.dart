class LoginModel {
  String? token;
  String? expiration;
  User? user;

  LoginModel({this.token, this.expiration, this.user});

  LoginModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    expiration = json['expiration'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['expiration'] = expiration;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? firstName;
  String? lastName;
  int? gender;
  String? email;
  String? profilePictureUrl;
  List<String>? roles;

  User({this.id, this.firstName, this.lastName, this.gender, this.email, this.profilePictureUrl, this.roles});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    gender = json['gender'];
    email = json['email'];
    profilePictureUrl = json['profilePictureUrl'];
    roles = json['roles'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['gender'] = gender;
    data['email'] = email;
    data['profilePictureUrl'] = profilePictureUrl;
    data['roles'] = roles;
    return data;
  }
}
