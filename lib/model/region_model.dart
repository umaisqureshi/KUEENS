import 'dart:convert';

List<RegionModel> regionModelFromJson(str) => List<RegionModel>.from(json.decode(str).map((x) => RegionModel.fromJson(x)));

String regionModelToJson(List<RegionModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RegionModel {
  RegionModel({
    this.region,
    this.country,
  });

  String region;
  String country;

  factory RegionModel.fromJson(Map<String, dynamic> json) => RegionModel(
    region: json["region"],
    country: json["country"],
  );

  Map<String, dynamic> toJson() => {
    "region": region,
    "country": country,
  };
}