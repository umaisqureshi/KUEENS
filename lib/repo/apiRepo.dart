import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:kueens/repo/api.dart';

class ApiRepo {

  final firebaseApiProvider = FirebaseApiProvider();

  Future<List<QueryDocumentSnapshot>> getAllWeeklyOffers(cate) => firebaseApiProvider.fetchWeeklyOffers(cate);
  Future<List<QueryDocumentSnapshot>> getAllShopItem(id) => firebaseApiProvider.fetchShopItem(id);

  Future<List<QueryDocumentSnapshot>> getAllPopularOffers(cate) => firebaseApiProvider.fetchPopularOffers(cate);
  Future<List<QueryDocumentSnapshot>> getAllSpecialOffers() => firebaseApiProvider.fetchSpecialOffers();
  Future<List<QueryDocumentSnapshot>> getCategory(cate) => firebaseApiProvider.fetchCategory(cate);
  Future<List<QueryDocumentSnapshot>> getCategory2(cate) => firebaseApiProvider.fetchCategory(cate);


}