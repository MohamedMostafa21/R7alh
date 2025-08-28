class PlanModel {
  num? id;
  String? name;
  String? description;
  num? price;
  num? days;
  num? tourGuideId;
  String? tourGuideName;
  String? thumbnailUrl;
  List<PlanPlaces>? planPlaces;

  PlanModel({this.id, this.name, this.description, this.price, this.days, this.tourGuideId, this.tourGuideName, this.thumbnailUrl, this.planPlaces});

  PlanModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    days = json['days'];
    tourGuideId = json['tourGuideId'];
    tourGuideName = json['tourGuideName'];
    thumbnailUrl = json['thumbnailUrl'];
    if (json['planPlaces'] != null) {
      planPlaces = <PlanPlaces>[];
      json['planPlaces'].forEach((v) {
        planPlaces!.add(PlanPlaces.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['days'] = days;
    data['tourGuideId'] = tourGuideId;
    data['tourGuideName'] = tourGuideName;
    data['thumbnailUrl'] = thumbnailUrl;
    if (planPlaces != null) {
      data['planPlaces'] = planPlaces!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PlanPlaces {
  num? id;
  num? planId;
  num? placeId;
  String? placeName;
  String? thumbnailUrl;
  num? order;
  String? duration;
  String? additionalDescription;
  num? specialPrice;

  PlanPlaces(
      {this.id,
      this.planId,
      this.placeId,
      this.placeName,
      this.thumbnailUrl,
      this.order,
      this.duration,
      this.additionalDescription,
      this.specialPrice});

  PlanPlaces.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    planId = json['planId'];
    placeId = json['placeId'];
    placeName = json['placeName'];
    thumbnailUrl = json['thumbnailUrl'];
    order = json['order'];
    duration = json['duration'];
    additionalDescription = json['additionalDescription'];
    specialPrice = json['specialPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['planId'] = planId;
    data['placeId'] = placeId;
    data['placeName'] = placeName;
    data['thumbnailUrl'] = thumbnailUrl;
    data['order'] = order;
    data['duration'] = duration;
    data['additionalDescription'] = additionalDescription;
    data['specialPrice'] = specialPrice;
    return data;
  }
}
