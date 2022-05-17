import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kueens/utils/firebase_credentials.dart';

class FirebaseApiProvider {
  Future<List<QueryDocumentSnapshot>> fetchWeeklyOffers(cate) async {
    var weeklyOffers = <QueryDocumentSnapshot>[];
    var post = cate != 'all'
        ? await FirebaseCredentials()
            .db
            .collection('Post')
            .where('offer.offerType', isEqualTo: 0)
            .where('category', isEqualTo: cate)
            .get()
        : await FirebaseCredentials()
            .db
            .collection('Post')
            .where('offer.offerType', isEqualTo: 0)
            .get();
    post.docs.forEach((element) {
      weeklyOffers.add(element);
    });

    return weeklyOffers;
  }

  Future<List<QueryDocumentSnapshot>> fetchShopItem(id) async {
    var shopItem = <QueryDocumentSnapshot>[];
    var post = await FirebaseCredentials()
        .db
        .collection('Post')
        .where('id', isEqualTo: id)
        .get();
    post.docs.forEach((element) {
      shopItem.add(element);
    });

    return shopItem;
  }

  Future<List<QueryDocumentSnapshot>> fetchPopularOffers(cate) async {
    var weeklyOffers = <QueryDocumentSnapshot>[];
    var post = cate != 'all'
        ? await FirebaseCredentials()
            .db
            .collection('Post')
            .where('category', isEqualTo: cate)
            .orderBy('rating', descending: true)
            .get()
        : await FirebaseCredentials()
            .db
            .collection('Post')
            .orderBy('rating')
            .limitToLast(5)
            .get();
    post.docs.forEach((element) {
      var rating = double.parse(element['rating']);
      if (rating >= 3.5) {
        weeklyOffers.add(element);
      }
    });

    return weeklyOffers;
  }

  Future<List<QueryDocumentSnapshot>> fetchSpecialOffers() async {
    var specialOffers = <QueryDocumentSnapshot>[];
    var post = await FirebaseCredentials()
        .db
        .collection('Post')
        .where('offer.offerType', isEqualTo: 2)
        .get();
    post.docs.forEach((element) {
      specialOffers.add(element);
    });

    return specialOffers;
  }

  Future<List<QueryDocumentSnapshot>> fetchCategory(cate) async {
    var category = <QueryDocumentSnapshot>[];
    var post = await FirebaseCredentials()
        .db
        .collection('Post')
        .where('category', isEqualTo: cate)
        .get();
    post.docs.forEach((element) {
      category.add(element);
    });

    return category;
  }
}
