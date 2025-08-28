class FavoriteModel {
  int? id;
  int? userId;
  String? userName;
  int? placeId;
  String? placeName;
  num? tourGuideId;
  String? tourGuideName;
  num? hotelId;
  String? hotelName;
  num? restaurantId;
  String? restaurantName;
  num? planId;
  String? planName;

  FavoriteModel(
      {this.id,
      this.userId,
      this.userName,
      this.placeId,
      this.placeName,
      this.tourGuideId,
      this.tourGuideName,
      this.hotelId,
      this.hotelName,
      this.restaurantId,
      this.restaurantName,
      this.planId,
      this.planName});

  FavoriteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    userName = json['userName'];
    placeId = json['placeId'];
    placeName = json['placeName'];
    tourGuideId = json['tourGuideId'];
    tourGuideName = json['tourGuideName'];
    hotelId = json['hotelId'];
    hotelName = json['hotelName'];
    restaurantId = json['restaurantId'];
    restaurantName = json['restaurantName'];
    planId = json['planId'];
    planName = json['planName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['userName'] = userName;
    data['placeId'] = placeId;
    data['placeName'] = placeName;
    data['tourGuideId'] = tourGuideId;
    data['tourGuideName'] = tourGuideName;
    data['hotelId'] = hotelId;
    data['hotelName'] = hotelName;
    data['restaurantId'] = restaurantId;
    data['restaurantName'] = restaurantName;
    data['planId'] = planId;
    data['planName'] = planName;
    return data;
  }
}
