import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kueens/utils/firebase_credentials.dart';

class PopularWidget extends StatefulWidget {
  final DocumentSnapshot snaps;

  PopularWidget({this.snaps});

  @override
  _PopularWidgetState createState() => _PopularWidgetState();
}

class _PopularWidgetState extends State<PopularWidget> {
  bool isFav = false;

  @override
  void initState() {
    super.initState();
    FirebaseCredentials()
        .db
        .collection("User")
        .doc(FirebaseCredentials().auth.currentUser.uid)
        .collection('Fav')
        .doc(widget.snaps.data()['productId'])
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
      width: 150,
      margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        child:
            /*CachedNetworkImage(
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
            colorBlendMode: BlendMode.darken,
            color: Colors.black.withOpacity(0.6),
            imageUrl:
                "https://images.hgmsites.net/lrg/uber-driver-photo-by-uber_100537825_l.jpg",
            placeholder: (context, url) => Image.asset(
              'assets/images/loading.gif',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 150,
            ),
            errorWidget: (context, url, error) => Image.asset(
              'assets/images/loading.gif',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 150,
            ),
          ),*/
            Material(
          child: Stack(
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed('/itemDetail', arguments: widget.snaps);
                },
                child: ShaderMask(
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
                          widget.snaps.data()['images'][0],
                        ),
                        fit: BoxFit.cover,
                      ),
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
                          .doc(widget.snaps.data()['productId'])
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
                      widget.snaps.data()['title'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      widget.snaps.data()['desc'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
