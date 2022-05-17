import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kueens/blocs/postBloc.dart';
import 'package:kueens/utils/firebase_credentials.dart';
import 'package:kueens/widgets/progress-indicator.dart';

class MoreItemsWidget extends StatefulWidget {
  final List<QueryDocumentSnapshot> shopItem;
  MoreItemsWidget({this.shopItem});

  @override
  _MoreItemsWidgetState createState() => _MoreItemsWidgetState();
}

class _MoreItemsWidgetState extends State<MoreItemsWidget> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
        child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: widget.shopItem.length > 5 ?5:widget.shopItem.length,
    itemBuilder: (context, i) {
    return widget.shopItem.isNotEmpty?ShopItems(data: widget.shopItem[i]):ProgressIndicatorWidget();
    },
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
    ));
  }
}

class ShopItems extends StatefulWidget {
 final QueryDocumentSnapshot data;
  ShopItems({this.data});

  @override
  _ShopItemsState createState() => _ShopItemsState();
}

class _ShopItemsState extends State<ShopItems> {
  bool isFav = false;

  @override
  void initState() {
    super.initState();
    FirebaseCredentials()
        .db
        .collection("User")
        .doc(FirebaseCredentials().auth.currentUser.uid)
        .collection('Fav')
        .doc(widget.data.data()['productId'])
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          isFav = value.data()['isFav'];
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Stack(
        children: [
          ShaderMask(
            shaderCallback: (rect) {
              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black],
              ).createShader(Rect.fromLTRB(
                  0, rect.width - 50, 0, rect.height - 20));
            },
            blendMode: BlendMode.darken,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.data.data()['images'][0]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    isFav = !isFav;
                  });
                  FirebaseCredentials()
                      .db
                      .collection("User")
                      .doc(FirebaseCredentials().auth.currentUser.uid)
                      .collection('Fav')
                      .doc(widget.data.data()['productId'])
                      .set({'isFav': isFav}, SetOptions(merge: true)).then(
                          (value) {});
                },
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5, right: 5),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey.withOpacity(0.9),
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.red : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              ListTile(
                title: Text(
                 widget.data.data()['title'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  widget.data.data()['desc'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

