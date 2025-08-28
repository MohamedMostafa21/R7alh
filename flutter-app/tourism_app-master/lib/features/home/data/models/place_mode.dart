class PlaceModel {
  int? id;
  String? name;
  String? description;
  String? type;
  String? city;
  String? country;
  String? location;
  num? latitude;
  num? longitude;
  num? averagePrice;
  num? stars;
  String? thumbnailUrl;
  List<String>? imageUrls;
  String? thumbnail;
  List<String>? images;
  dynamic activities;
  bool? isFavorited;

  PlaceModel(
      {this.id,
      this.name,
      this.description,
      this.type,
      this.city,
      this.country,
      this.location,
      this.latitude,
      this.longitude,
      this.averagePrice,
      this.stars,
      this.thumbnailUrl,
      this.imageUrls,
      this.thumbnail,
      this.images,
      this.activities,
      this.isFavorited});

  PlaceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    type = json['type'];
    city = json['city'];
    country = json['country'];
    location = json['location'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    averagePrice = json['averagePrice'];
    stars = json['stars'];
    thumbnailUrl = json['thumbnailUrl'];
    imageUrls = json['imageUrls'].cast<String>();
    thumbnail = json['thumbnail'];
    images = json['images'];
    activities = json['activities'];
    isFavorited = json['isFavorited'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['type'] = type;
    data['city'] = city;
    data['country'] = country;
    data['location'] = location;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['averagePrice'] = averagePrice;
    data['stars'] = stars;
    data['thumbnailUrl'] = thumbnailUrl;
    data['imageUrls'] = imageUrls;
    data['thumbnail'] = thumbnail;
    data['images'] = images;
    data['activities'] = activities;
    data['isFavorited'] = isFavorited;
    return data;
  }
}
