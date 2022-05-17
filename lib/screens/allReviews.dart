import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kueens/utils/firebase_credentials.dart';
import 'package:kueens/widgets/reviewItem.dart';

class AllReviews extends StatefulWidget {
  DocumentSnapshot snaps;

  AllReviews({this.snaps});
  @override
  _AllReviewsState createState() => _AllReviewsState();
}

class _AllReviewsState extends State<AllReviews> {

  List<Map<String, dynamic>> list = List();
  List<Map<String, dynamic>> showlist = List();

  reviewData() async {
    FirebaseCredentials()
        .db
        .collection('Post')
        .doc(widget.snaps.id)
        .snapshots()
        .listen((event) {
      if (mounted) {
        setState(() {
          if (event.exists) {
            if(event.data().containsKey('feedback')){
              list.clear();
              showlist.clear();
              event.data()['feedback'].forEach((e) {
                list.add(e);
              });
              for (int i = 0; i < list.length; i++) {
                showlist.add(list[i]);
              }
            }
          }
        });
      }
    });
  }

  @override
  void initState() {
    reviewData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reviews"),
      ),
      body: SingleChildScrollView(
        child: Column(
            children: showlist
                .map((e) => ReviewItemWidget(documentSnapshot: e,))
                .toList()),
      ),
    );
  }
}
