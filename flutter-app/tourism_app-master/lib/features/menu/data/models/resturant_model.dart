class ResturantsModel {
  num? id;
  String? name;
  String? description;
  String? city;
  String? country;
  String? location;
  num? latitude;
  num? longitude;
  String? cuisine;
  num? averagePrice;
  num? stars;
  String? thumbnailUrl;
  List<String>? imageUrls;
  List<Meals>? meals;
  bool? isFavorited;

  ResturantsModel(
      {this.id,
      this.name,
      this.description,
      this.city,
      this.country,
      this.location,
      this.latitude,
      this.longitude,
      this.cuisine,
      this.averagePrice,
      this.stars,
      this.thumbnailUrl,
      this.imageUrls,
      this.meals,
      this.isFavorited});

  ResturantsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    city = json['city'];
    country = json['country'];
    location = json['location'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    cuisine = json['cuisine'];
    averagePrice = json['averagePrice'];
    stars = json['stars'];
    thumbnailUrl = json['thumbnailUrl'];
    imageUrls = json['imageUrls'].cast<String>();
    if (json['meals'] != null) {
      meals = <Meals>[];
      json['meals'].forEach((v) {
        meals!.add(Meals.fromJson(v));
      });
    }
    isFavorited = json['isFavorited'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['city'] = city;
    data['country'] = country;
    data['location'] = location;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['cuisine'] = cuisine;
    data['averagePrice'] = averagePrice;
    data['stars'] = stars;
    data['thumbnailUrl'] = thumbnailUrl;
    data['imageUrls'] = imageUrls;
    if (meals != null) {
      data['meals'] = meals!.map((v) => v.toJson()).toList();
    }
    data['isFavorited'] = isFavorited;
    return data;
  }
}

class Meals {
  num? id;
  num? restaurantId;
  String? name;
  num? price;
  String? description;
  String? thumbnailUrl;
  List<String>? imageUrls;

  Meals({this.id, this.restaurantId, this.name, this.price, this.description, this.thumbnailUrl, this.imageUrls});

  Meals.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    restaurantId = json['restaurantId'];
    name = json['name'];
    price = json['price'];
    description = json['description'];
    thumbnailUrl = json['thumbnailUrl'];
    imageUrls = json['imageUrls'] != null ? List<String>.from(json['imageUrls']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['restaurantId'] = restaurantId;
    data['name'] = name;
    data['price'] = price;
    data['description'] = description;
    data['thumbnailUrl'] = thumbnailUrl;
    data['imageUrls'] = imageUrls;
    return data;
  }
}
