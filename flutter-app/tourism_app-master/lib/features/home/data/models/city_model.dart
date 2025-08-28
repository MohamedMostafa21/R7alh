class CityModel {
  int? id;
  String? name;
  String? country;
  String? description;
  int? latitude;
  int? longitude;
  String? thumbnailUrl;
  List<String>? imageUrls;

  CityModel({this.id, this.name, this.country, this.description, this.latitude, this.longitude, this.thumbnailUrl, this.imageUrls});

  CityModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    country = json['country'];
    description = json['description'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    thumbnailUrl = json['thumbnailUrl'];
    imageUrls = json['imageUrls'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['country'] = country;
    data['description'] = description;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['thumbnailUrl'] = thumbnailUrl;
    data['imageUrls'] = imageUrls;
    return data;
  }
}
