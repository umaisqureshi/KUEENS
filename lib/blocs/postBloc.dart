import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kueens/repo/apiRepo.dart';
import 'package:rxdart/rxdart.dart';

class PostBlock {
  final _repo = ApiRepo();
  final _postFetcher = PublishSubject<List<QueryDocumentSnapshot>>();
  final _popularPostFetcher = PublishSubject<List<QueryDocumentSnapshot>>();
  final _specialPostFetcher = PublishSubject<List<QueryDocumentSnapshot>>();
  final _categoryFetcher = PublishSubject<List<QueryDocumentSnapshot>>();
  final _categoryFetcher2 = PublishSubject<List<QueryDocumentSnapshot>>();
  final _shopItemFetcher = PublishSubject<List<QueryDocumentSnapshot>>();


  Stream<List<QueryDocumentSnapshot>> get allPosts => _postFetcher.stream;
  Stream<List<QueryDocumentSnapshot>> get allShopItem => _shopItemFetcher.stream;
  Stream<List<QueryDocumentSnapshot>> get allPopularPosts => _popularPostFetcher.stream;
  Stream<List<QueryDocumentSnapshot>> get allSpecialPosts => _specialPostFetcher.stream;
  Stream<List<QueryDocumentSnapshot>> get allCategory => _categoryFetcher.stream;
  Stream<List<QueryDocumentSnapshot>> get allCategory2 => _categoryFetcher2
      .stream;

  fetchAllPosts(cate) async {
    List<QueryDocumentSnapshot> items = await _repo.getAllWeeklyOffers(cate);
    _postFetcher.sink.add(items);
  }

  fetchShopItem(id) async {
    List<QueryDocumentSnapshot> items = await _repo.getAllShopItem(id);
    _shopItemFetcher.sink.add(items);
  }

  fetchAllCategory(cate) async {
    List<QueryDocumentSnapshot> items = await _repo.getCategory(cate);
    _categoryFetcher.sink.add(items);
  }

  fetchAllCategory2(category) async {
    List<QueryDocumentSnapshot> items = await _repo.getCategory2(category);
    _categoryFetcher2.sink.add(items);
  }

  fetchAllPopularPosts(cate) async {
    List<QueryDocumentSnapshot> items = await _repo.getAllPopularOffers(cate);
    _popularPostFetcher.sink.add(items);
  }

  fetchAllSpecialPosts() async {
    List<QueryDocumentSnapshot> items = await _repo.getAllSpecialOffers();
    _specialPostFetcher.sink.add(items);
  }

  dispose() {
    _postFetcher.close();
    _shopItemFetcher.close();
    _popularPostFetcher.close();
    _specialPostFetcher.close();
    _categoryFetcher.close();
    _categoryFetcher2.close();

  }
}

final bloc = PostBlock();
