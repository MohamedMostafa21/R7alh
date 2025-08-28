class EventModel {
  List<EventData>? data;

  EventModel({this.data});

  EventModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <EventData>[];
      json['data'].forEach((v) {
        data!.add(EventData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EventData {
  int? id;
  String? name;
  String? description;
  String? startDate;
  String? endDate;
  String? city;
  String? location;
  num? latitude;
  num? longitude;
  num? price;
  String? thumbnailUrl;

  EventData(
      {this.id,
      this.name,
      this.description,
      this.startDate,
      this.endDate,
      this.city,
      this.location,
      this.latitude,
      this.longitude,
      this.price,
      this.thumbnailUrl});

  EventData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    city = json['city'];
    location = json['location'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    price = json['price'];
    thumbnailUrl = json['thumbnailUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['city'] = city;
    data['location'] = location;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['price'] = price;
    data['thumbnailUrl'] = thumbnailUrl;
    return data;
  }
}
