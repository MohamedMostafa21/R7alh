class TourGuidModel {
  num? id;
  num? userId;
  String? firstName;
  String? lastName;
  String? bio;
  num? yearsOfExperience;
  List<String>? languages;
  num? hourlyRate;
  String? city;
  bool? isAvailable;
  String? profilePictureUrl;
  num? stars;
  bool? isFavorited;

  TourGuidModel(
      {this.id,
      this.userId,
      this.firstName,
      this.lastName,
      this.bio,
      this.yearsOfExperience,
      this.languages,
      this.hourlyRate,
      this.city,
      this.isAvailable,
      this.profilePictureUrl,
      this.stars,
      this.isFavorited});

  TourGuidModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    bio = json['bio'];
    yearsOfExperience = json['yearsOfExperience'];
    languages = json['languages'].cast<String>();
    hourlyRate = json['hourlyRate'];
    city = json['city'];
    isAvailable = json['isAvailable'];
    profilePictureUrl = json['profilePictureUrl'];
    stars = json['stars'];
    isFavorited = json['isFavorited'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['bio'] = bio;
    data['yearsOfExperience'] = yearsOfExperience;
    data['languages'] = languages;
    data['hourlyRate'] = hourlyRate;
    data['city'] = city;
    data['isAvailable'] = isAvailable;
    data['profilePictureUrl'] = profilePictureUrl;
    data['stars'] = stars;
    data['isFavorited'] = isFavorited;
    return data;
  }
}
