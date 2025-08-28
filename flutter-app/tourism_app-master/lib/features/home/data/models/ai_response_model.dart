class AiResonseModel {
  String? name;
  String? predictedCaption;

  AiResonseModel({this.name, this.predictedCaption});

  AiResonseModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    predictedCaption = json['predicted_caption'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['predicted_caption'] = predictedCaption;
    return data;
  }
}
