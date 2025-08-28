class ActivityModel {
  num? id;
  String? name;
  String? description;
  num? price;
  num? placeId;
  String? thumbnailUrl;

  ActivityModel({this.id, this.name, this.description, this.price, this.placeId, this.thumbnailUrl});

  ActivityModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    placeId = json['placeId'];
    thumbnailUrl = json['thumbnailUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['placeId'] = placeId;
    data['thumbnailUrl'] = thumbnailUrl;
    return data;
  }
}
