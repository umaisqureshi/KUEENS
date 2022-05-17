import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kueens/utils/app_colors.dart';
import 'package:kueens/utils/firebase_credentials.dart';
import 'package:kueens/utils/helper.dart';
import 'package:kueens/widgets/reviewItem.dart';
extension ListUtils<T> on List<T> {
  num sum(num f(T element)) {
    num sum = 0;
    for(var item in this) {
      sum += f(item);
    }
    return sum;
  }
}
class DetailCardWidget extends StatefulWidget {
  final DocumentSnapshot snaps;

  DetailCardWidget({this.snaps});

  @override
  _DetailCardWidgetState createState() => _DetailCardWidgetState();
}

class _DetailCardWidgetState extends State<DetailCardWidget> {
  List<Map<String, dynamic>> list = List();
  List<Map<String, dynamic>> showlist = List();

  var newRating = '0';
  int limit = 5;

  @override
  void initState() {
    super.initState();
    reviewData();
  }

  reviewData() async {
    setState(() {
      newRating = widget.snaps.data()['rating'];
    });
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
            newRating = event.data()['rating'];
            event.data()['feedback'].forEach((e) {
              list.add(e);
            });
            limit = list.length > 5 ? 5 : list.length;
            for (int i = 0; i < limit; i++) {
              showlist.add(list[i]);
            }
          }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              widget.snaps.data()['desc'],
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Visibility(
                    visible: widget.snaps.data()['inStock'],
                    child: Icon(Icons.done)),
                Text(
                  widget.snaps.data()['inStock'] ? 'inStock' : 'Out of Stock',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: widget.snaps.data()['inStock']
                          ? Colors.black
                          : Colors.red),
                )
              ],
            ),
            Divider(
              indent: 3.0,
              endIndent: 3.0,
            ),
            Row(
              children: [
                Text('Reviews'),
                SizedBox(
                  width: 10,
                ),
                Row(
                  children: Helper.getStarsList(double.parse(newRating)),
                ),
                Text('(${list.length??0})')
              ],
            ),
             Column(
                children: showlist
                    .map((e) => ReviewItemWidget(documentSnapshot: e,))
                    .toList()),
            OutlineButton(
              shape: StadiumBorder(),
              textColor: AppColors.primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('View more'),
              ),
              borderSide: BorderSide(
                  color: AppColors.primaryColor,
                  style: BorderStyle.solid,
                  width: 1),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed('/allReviews', arguments: widget.snaps);
              },
            )
          ],
        ),
      ),
    );
  }
}
