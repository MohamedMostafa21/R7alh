class BookingModel {
  num? id;
  num? userId;
  String? userName;
  num? tourGuideId;
  String? tourGuideName;
  String? bookingDate;
  num? durationHours;
  num? totalAmount;
  String? status;
  String? stripePaymentIntentId;
  String? clientSecret;
  String? createdAt;

  BookingModel(
      {this.id,
      this.userId,
      this.userName,
      this.tourGuideId,
      this.tourGuideName,
      this.bookingDate,
      this.durationHours,
      this.totalAmount,
      this.status,
      this.stripePaymentIntentId,
      this.clientSecret,
      this.createdAt});

  BookingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    userName = json['userName'];
    tourGuideId = json['tourGuideId'];
    tourGuideName = json['tourGuideName'];
    bookingDate = json['bookingDate'];
    durationHours = json['durationHours'];
    totalAmount = json['totalAmount'];
    status = json['status'];
    stripePaymentIntentId = json['stripePaymentIntentId'];
    clientSecret = json['clientSecret'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['userName'] = userName;
    data['tourGuideId'] = tourGuideId;
    data['tourGuideName'] = tourGuideName;
    data['bookingDate'] = bookingDate;
    data['durationHours'] = durationHours;
    data['totalAmount'] = totalAmount;
    data['status'] = status;
    data['stripePaymentIntentId'] = stripePaymentIntentId;
    data['clientSecret'] = clientSecret;
    data['createdAt'] = createdAt;
    return data;
  }
}
