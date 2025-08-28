// class HotelModel {
//   int? id;
//   String? name;
//   String? description;
//   String? city;
//   String? country;
//   String? location;
//   double? latitude;
//   double? longitude;
//   int? startingPrice;
//   double? rate;
//   int? stars;
//   String? thumbnailUrl;
//   List<String>? imageUrls;
//   List<dynamic>? rooms;
//   bool? isFavorited;

//   HotelModel(
//       {this.id,
//       this.name,
//       this.description,
//       this.city,
//       this.country,
//       this.location,
//       this.latitude,
//       this.longitude,
//       this.startingPrice,
//       this.rate,
//       this.stars,
//       this.thumbnailUrl,
//       this.imageUrls,
//       this.rooms,
//       this.isFavorited});

//   HotelModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     description = json['description'];
//     city = json['city'];
//     country = json['country'];
//     location = json['location'];
//     latitude = json['latitude'];
//     longitude = json['longitude'];
//     startingPrice = json['startingPrice'];
//     rate = json['rate'];
//     stars = json['stars'];
//     thumbnailUrl = json['thumbnailUrl'];
//     imageUrls = json['imageUrls'].cast<String>();
//     // if (json['rooms'] != null) {
//     //   rooms = <Null>[];
//     //   json['rooms'].forEach((v) {
//     //     rooms!.add(Null.fromJson(v));
//     //   });
//     // }
//     isFavorited = json['isFavorited'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['name'] = name;
//     data['description'] = description;
//     data['city'] = city;
//     data['country'] = country;
//     data['location'] = location;
//     data['latitude'] = latitude;
//     data['longitude'] = longitude;
//     data['startingPrice'] = startingPrice;
//     data['rate'] = rate;
//     data['stars'] = stars;
//     data['thumbnailUrl'] = thumbnailUrl;
//     data['imageUrls'] = imageUrls;
//     // if (rooms != null) {
//     //   data['rooms'] = rooms!.map((v) => v.toJson()).toList();
//     // }
//     data['isFavorited'] = isFavorited;
//     return data;
//   }
// }
