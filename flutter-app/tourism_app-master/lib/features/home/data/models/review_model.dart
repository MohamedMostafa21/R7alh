class ReviewModel {
  List<ReviewData>? data;
  Pagination? pagination;

  ReviewModel({this.data, this.pagination});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ReviewData>[];
      json['data'].forEach((v) {
        data!.add(ReviewData.fromJson(v));
      });
    }
    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}

class ReviewData {
  int? id;
  int? userId;
  String? userName;
  String? profilePictureUrl;
  int? rating;
  String? comment;
  String? createdAt;
  num? placeId;
  String? placeName;
  int? tourGuideId;
  String? tourGuideName;
  num? hotelId;
  String? hotelName;
  num? restaurantId;
  String? restaurantName;
  num? planId;
  String? planName;

  ReviewData(
      {this.id,
      this.userId,
      this.userName,
      this.profilePictureUrl,
      this.rating,
      this.comment,
      this.createdAt,
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

  ReviewData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    userName = json['userName'];
    profilePictureUrl = json['profilePictureUrl'];
    rating = json['rating'];
    comment = json['comment'];
    createdAt = json['createdAt'];
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
    data['profilePictureUrl'] = profilePictureUrl;
    data['rating'] = rating;
    data['comment'] = comment;
    data['createdAt'] = createdAt;
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

class Pagination {
  int? totalItems;
  int? totalPages;
  int? currentPage;
  int? pageSize;

  Pagination({this.totalItems, this.totalPages, this.currentPage, this.pageSize});

  Pagination.fromJson(Map<String, dynamic> json) {
    totalItems = json['totalItems'];
    totalPages = json['totalPages'];
    currentPage = json['currentPage'];
    pageSize = json['pageSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalItems'] = totalItems;
    data['totalPages'] = totalPages;
    data['currentPage'] = currentPage;
    data['pageSize'] = pageSize;
    return data;
  }
}
