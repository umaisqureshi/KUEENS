import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String address, category, desc, geoHash, id, price, productId, title;
  List<String> imagesUrl, videoUrl, tags;
  GeoPoint coordinates;
  bool inStock;
  int rating;
  Map<String, dynamic> offer;

  PostModel(
      {this.videoUrl,
      this.price,
      this.address,
      this.id,
      this.title,
      this.category,
      this.coordinates,
      this.desc,
      this.geoHash,
      this.imagesUrl,
      this.inStock,
      this.offer,
      this.productId,
      this.rating,
      this.tags});

  // PostModel.fromAPI(Map<String, dynamic> jsonObject) {
  //   this.tags = jsonObject['tags'] ?? '';
  //   this.created_date = jsonObject['created_date'] ?? '';
  //   this..issue_details = jsonObject['issue_details'] ?? '';
  //   this.booking_id = jsonObject['booking_id'] ?? '';
  //   this.status = jsonObject['status'] ?? '';
  //   this.id = jsonObject['id'] ?? '';
  //   this.service_name = jsonObject['service_name'] ?? '';
  // }
}
