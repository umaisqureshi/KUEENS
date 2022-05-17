import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:kueens/blocs/postBloc.dart';
import 'package:kueens/utils/app_colors.dart';
import 'package:kueens/utils/firebase_credentials.dart';
import 'package:kueens/widgets/progress-indicator.dart';

class WeeklyMoreDrawerItems extends StatefulWidget {

  @override
  _WeeklyMoreDrawerItemsState createState() => _WeeklyMoreDrawerItemsState();
}

class _WeeklyMoreDrawerItemsState extends State<WeeklyMoreDrawerItems> {
  @override
  Widget build(BuildContext context) {
    bloc.fetchAllPosts('all');
    return WillPopScope(
      onWillPop: (){
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: true,
          leading: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(
                Icons.arrow_back,
                color: AppColors.primaryColor,
              )),
          title: Text(
            "Weekly Special",
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0.0,
          actions: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                  child: Container(
                    height: 10,
                    width: 35,
                    decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(30)),
                    child: Icon(Icons.person),
                  ),
                ))
          ],
        ),
        body: Container(
            height: double.infinity,
            width: double.infinity,
            child: StreamBuilder(
              stream: bloc.allPosts,
              builder: (context,
                  AsyncSnapshot<List<QueryDocumentSnapshot>>
                  snapshot) {
                return snapshot.hasData?AnimationLimiter(
                    child: new GridView.builder(
                        itemCount: snapshot.data.length,
                        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                        itemBuilder: (BuildContext context, int index) {
                          return AnimationConfiguration.staggeredGrid(
                              position: 10,
                              columnCount: 2,
                              child: ScaleAnimation(
                                child: WeeklyItems(documentSnapshot: snapshot.data[index],)
                              ));
                        })) : ProgressIndicatorWidget();
                ;
              }
            )),
      ),
    );
  }
}
class WeeklyItems extends StatefulWidget {
 final DocumentSnapshot documentSnapshot;
  WeeklyItems({this.documentSnapshot});
  @override
  _WeeklyItemsState createState() => _WeeklyItemsState();
}

class _WeeklyItemsState extends State<WeeklyItems> {
  bool isFav = false;
  @override
  void initState() {
    super.initState();
    FirebaseCredentials().db.collection("User").doc(FirebaseCredentials().auth.currentUser.uid).collection('Fav').doc(widget.documentSnapshot.data()['productId']).get().then((value){
      if(value.exists){
        setState(() {
          isFav = value.data()['isFav'];
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: EdgeInsets.only(
          left: 10, right: 10, top: 10, bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(
                0, 1), // changes position of shadow
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        child: Material(
          child: Stack(
            children: [
              InkWell(
                onTap: (){
                  Navigator.of(context)
                      .pushNamed('/itemDetail', arguments: widget.documentSnapshot);
                },
                child: ShaderMask(
                  shaderCallback: (rect) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black
                      ],
                    ).createShader(Rect.fromLTRB(
                        0,
                        rect.width - 50,
                        0,
                        rect.height - 20));
                  },
                  blendMode: BlendMode.darken,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                         widget.documentSnapshot.data()['offer']['image'],),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: (){
                      setState(() {
                        isFav = !isFav;
                      });
                      FirebaseCredentials().db.collection("User").doc(FirebaseCredentials().auth.currentUser.uid).collection('Fav').doc(widget.documentSnapshot.data()['productId']).set({'isFav':isFav},SetOptions(merge: true)).then((value) {
                      });
                    },
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5,right: 5),
                        child: CircleAvatar(
                          backgroundColor: Colors.grey.withOpacity(0.9),
                          child: Icon(
                            isFav ?Icons.favorite :Icons.favorite_border,
                            color: isFav ? Colors.red : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      widget.documentSnapshot.data()['title'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      widget.documentSnapshot.data()['desc'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12),
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


