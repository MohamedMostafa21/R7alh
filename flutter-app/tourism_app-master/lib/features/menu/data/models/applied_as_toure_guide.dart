class AppliedAsTourguideModel {
  num? id;
  num? userId;
  String? userName;
  String? email;
  String? bio;
  num? yearsOfExperience;
  List<String>? languages;
  num? hourlyRate;
  String? cvUrl;
  String? profilePictureUrl;
  num? status;
  String? adminComment;
  String? submittedAt;
  String? reviewedAt;

  AppliedAsTourguideModel(
      {this.id,
      this.userId,
      this.userName,
      this.email,
      this.bio,
      this.yearsOfExperience,
      this.languages,
      this.hourlyRate,
      this.cvUrl,
      this.profilePictureUrl,
      this.status,
      this.adminComment,
      this.submittedAt,
      this.reviewedAt});

  AppliedAsTourguideModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    userName = json['userName'];
    email = json['email'];
    bio = json['bio'];
    yearsOfExperience = json['yearsOfExperience'];
    languages = json['languages'].cast<String>();
    hourlyRate = json['hourlyRate'];
    cvUrl = json['cvUrl'];
    profilePictureUrl = json['profilePictureUrl'];
    status = json['status'];
    adminComment = json['adminComment'];
    submittedAt = json['submittedAt'];
    reviewedAt = json['reviewedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['userName'] = userName;
    data['email'] = email;
    data['bio'] = bio;
    data['yearsOfExperience'] = yearsOfExperience;
    data['languages'] = languages;
    data['hourlyRate'] = hourlyRate;
    data['cvUrl'] = cvUrl;
    data['profilePictureUrl'] = profilePictureUrl;
    data['status'] = status;
    data['adminComment'] = adminComment;
    data['submittedAt'] = submittedAt;
    data['reviewedAt'] = reviewedAt;
    return data;
  }
}
