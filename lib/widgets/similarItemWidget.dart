import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kueens/utils/helper.dart';

class SimilarItemsWidget extends StatefulWidget {
  final QueryDocumentSnapshot queryDocumentSnapshot;
  SimilarItemsWidget({this.queryDocumentSnapshot});

  @override
  _SimilarItemsWidgetState createState() => _SimilarItemsWidgetState();
}

class _SimilarItemsWidgetState extends State<SimilarItemsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
        height: 150,
        margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
        child: Container(
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
                  ).createShader(
                      Rect.fromLTRB(0, rect.width - 50, 0, rect.height - 20));
                },
                blendMode: BlendMode.darken,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          widget.queryDocumentSnapshot.data().containsKey('shopData')? widget.queryDocumentSnapshot.data()['shopData']['shopLogo']:''),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5, right: 5),
                      child: Container(
                        width: 30,
                        height: 30,
                        child: CircleAvatar(
                          backgroundColor: Colors.grey.withOpacity(0.9),
                          child: Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      widget.queryDocumentSnapshot['shopData']['shopName'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
