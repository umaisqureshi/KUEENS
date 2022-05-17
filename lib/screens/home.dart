import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kueens/blocs/postBloc.dart';
import 'package:kueens/widgets/CardWidget.dart';
import 'package:kueens/screens/drawer.dart';
import 'package:kueens/utils/app_colors.dart';
import 'package:kueens/widgets/categoryCardWIdget.dart';
import 'package:kueens/widgets/popularWidget.dart';
import 'package:kueens/widgets/progress-indicator.dart';
import 'package:kueens/widgets/specialOfferCardWIdget.dart';

class Home extends StatefulWidget {
  final String category;

  Home({this.category});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKeyHome =
      new GlobalKey<ScaffoldState>();
  bool isPopular = false;
  bool isOffer = false;
  Duration _duration = Duration(seconds: 5);

  @override
  void initState() {
    super.initState();
    if (mounted) {
      Future.delayed(_duration, () {
        setState(() {
          isPopular = !isPopular;
          isOffer = !isOffer;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bloc.fetchAllPosts(widget.category);
    bloc.fetchAllPopularPosts(widget.category);
    bloc.fetchAllCategory(widget.category);
    return Scaffold(
        key: _scaffoldKeyHome,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () {
              _scaffoldKeyHome.currentState.openDrawer();
            },
            child: Icon(
              Icons.notes_sharp,
              color: AppColors.primaryColor,
            ),
          ),
          title: Text(
            widget.category,
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0.0,
          actions: [
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
        drawer: Drawerr(),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blueGrey[300],
                        ),
                        padding: EdgeInsets.all(15),
                        width: MediaQuery.of(context).size.width - 20,
                        child: ListTile(
                          contentPadding: EdgeInsets.all(0.0),
                          leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.favorite,
                                color: Colors.black,
                              )),
                          title: Text("What\'s your Style?",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            "Kueen'\s provide you unique recommendation, tailored just for you. Tap on some heart icons below so Kueen'\s know what you like.",
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  //Weekly Offers

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Weekly Offers",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w800),
                        ),
                        OutlineButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/weeklyList',
                                arguments: widget.category);
                          },
                          shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Text(
                            "See More",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: StreamBuilder(
                        stream: bloc.allPosts,
                        builder: (context,
                            AsyncSnapshot<List<QueryDocumentSnapshot>>
                                snapshot) {
                          return snapshot.hasData
                              ? snapshot.data.isEmpty
                                  ? Center(
                                      child: AnimatedSwitcher(
                                      duration: Duration(seconds: 1),
                                      child: isOffer
                                          ? TextButton.icon(
                                              onPressed: null,
                                              icon: Icon(Icons.find_in_page),
                                              label: Text('Not Found'))
                                          : CircularProgressIndicator(),
                                    ))
                                  : Container(
                                      height: snapshot.data.isEmpty ? 0 : 250,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (context, i) {
                                          return CardWidget(
                                              snaps: snapshot.data[i]);
                                        },
                                      ),
                                    )
                              : Center(child: ProgressIndicatorWidget());
                        }),
                  ),

                  // Popular Items

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Popular",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w800),
                        ),
                        OutlineButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/popularList',
                                arguments: widget.category);
                          },
                          shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Text(
                            "See More",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: StreamBuilder(
                        stream: bloc.allPopularPosts,
                        builder: (context,
                            AsyncSnapshot<List<QueryDocumentSnapshot>>
                                snapshot) {
                          return snapshot.hasData
                              ? snapshot.data.isEmpty
                                  ? Center(
                                      child: AnimatedSwitcher(
                                      duration: Duration(seconds: 1),
                                      child: isPopular
                                          ? TextButton.icon(
                                              onPressed: null,
                                              icon: Icon(Icons.find_in_page),
                                              label: Text('Not Found'))
                                          : CircularProgressIndicator(),
                                    ))
                                  : Container(
                                      height: snapshot.data.isEmpty ? 0 : 250,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (context, i) {
                                          return PopularWidget(
                                            snaps: snapshot.data[i],
                                          );
                                        },
                                      ),
                                    )
                              : Center(child: CircularProgressIndicator());
                        }),
                  ),

                  //Cokking and Baking

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.category,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w800),
                        ),
                        OutlineButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/categoryList',
                                arguments: widget.category);
                          },
                          shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Text(
                            "See More",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: StreamBuilder(
                        stream: bloc.allCategory,
                        builder: (context,
                            AsyncSnapshot<List<QueryDocumentSnapshot>>
                                snapshot) {
                          return snapshot.hasData
                              ? Container(
                                  height: snapshot.data.isEmpty ? 0 : 280,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, i) {
                                      return CategoryCardWidget(
                                          documentSnapshot: snapshot.data[i]);
                                    },
                                  ),
                                )
                              : Center(child: ProgressIndicatorWidget());
                        }),
                  ),

                  /*    //Faction Jewellery
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Faction Jewellery",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w800),
                        ),
                        OutlineButton(
                          onPressed: () {},
                          shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Text(
                            "See More",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: StreamBuilder(
                      stream: bloc.allCategory2,
                      builder: (context, AsyncSnapshot<List<QueryDocumentSnapshot>>
                      snapshot) {
                        return Container(
                          height: 280,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, i) {
                              return CategoryCardWidget(documentSnapshot: snapshot.data[i]);
                            },
                          ),
                        );
                      }
                    ),
                  ),
*/
                  //special offer

                  SpecialOfferCardWidget(
                    category: widget.category,
                  ),
                ]),
          ),
        ));
  }
}
