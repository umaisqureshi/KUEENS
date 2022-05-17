import 'dart:async';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kueens/fragments/shopInfoModel.dart';
import 'package:kueens/model/homeModel.dart';
import 'package:kueens/utils/app_colors.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:kueens/utils/appData.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'create_privacy_policy.dart';
import 'drawer.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  bool status = false, check = false;

  List<HomeModel> icon = [
    HomeModel(
        icon: 'assets/images/cb.png',
        text: "Cooking and Baking",
        id: 'Cooking & Baking'),
    HomeModel(
        icon: 'assets/images/hb.png',
        text: "Home Boutique",
        id: 'Home Boutique'),
    HomeModel(
        icon: 'assets/images/skt.png',
        text: "Stitching",
        id: 'Stitching/ Knitting/ Tailoring'),
    HomeModel(
        icon: 'assets/images/fj.png',
        text: "Fashion Jewellers",
        id: 'Fashion Jewellers'),
    HomeModel(
        icon: 'assets/images/ap.png',
        text: "Artist & Painters",
        id: 'Artist & Painters'),
    HomeModel(
        icon: 'assets/images/hdf.png',
        text: "Home Decors & Furnishing",
        id: 'Home Decor & Furnishing'),
    HomeModel(icon: 'assets/images/gc.png', text: "Grocers", id: 'Grocers'),
    HomeModel(
        icon: 'assets/images/fv.png',
        text: "Fruits & Vegetables",
        id: 'Fruits & Vegetables'),
    HomeModel(
        icon: 'assets/images/hha.png',
        text: "HouseHold Appliances",
        id: 'HouseHold Appliances'),
    HomeModel(
        icon: 'assets/images/ccdh.png',
        text: "Child Care",
        id: 'Child Care & Domestic Help'),
    HomeModel(
        icon: 'assets/images/gth.png',
        text: "Gardening Tips & Help",
        id: 'Gardening Tips & Help'),
    HomeModel(
        icon: 'assets/images/ht.png', text: "Home Tutors", id: 'Home Tutors'),
    HomeModel(
        icon: 'assets/images/ps.png',
        text: "Pet Supply/ Care",
        id: 'Pet Supply/ Care'),
    HomeModel(icon: 'assets/images/other.png', text: "Other", id: 'Other'),
  ];
  TextEditingController editingController = TextEditingController();

  final duplicateItems = List<String>.generate(10000, (i) => "Item $i");
  var items = List<String>();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    initDynamicLinks();
    items.addAll(duplicateItems);
  }

  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;
      if (deepLink != null) {
        print("onLink${deepLink.queryParameters["id"]}");
        Navigator.of(context)
            .push(ShopInfoModel(deepLink.queryParameters["id"]));
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    await FirebaseDynamicLinks.instance.getInitialLink().then((value) {
      final Uri deepLink = value?.link;
      if (deepLink != null) {
        print("initialLink${deepLink.queryParameters["id"]}");
        Navigator.of(context)
            .push(ShopInfoModel(deepLink.queryParameters["id"]));
      }
    }).catchError((error) {
      print('initialLinkError $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () {
              _scaffoldKey.currentState.openDrawer();
            },
            child: Icon(
              Icons.notes_sharp,
              color: AppColors.primaryColor,
            ),
          ),
          title: Text(
            "Categories",
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
        drawer: Drawerr(
            // onClickDrawer: (event){
            //   if(_scaffoldKey.currentState.isDrawerOpen){
            //     Navigator.pop(context);
            //   }
            // },
            ),
        body: Container(
          child: ListView(
            shrinkWrap: true,
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Container(
                  child: AnimationLimiter(
                    child: GridView.count(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        crossAxisCount: 3,
                        crossAxisSpacing: 5.0,
                        mainAxisSpacing: 5.0,
                        childAspectRatio: 0.9,
                        children: icon.map((e) {
                          return AnimationConfiguration.staggeredGrid(
                            duration: Duration(milliseconds: 370),
                            position: 10,
                            columnCount: 3,
                            child: ScaleAnimation(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/home',
                                      arguments: e.id);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 3),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    elevation: 4.0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey,
                                                offset: Offset(0.0, 1.0),
                                                blurRadius: 2)
                                          ],
                                          color: AppColors.primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      height: 100,
                                      width: 100,
                                      child: Container(
                                        margin: EdgeInsets.only(top: 8),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                                bottomRight:
                                                    Radius.circular(10),
                                                bottomLeft:
                                                    Radius.circular(10))),
                                        child: Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Image.asset(
                                                e.icon,
                                                height: 50,
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                child: Text(
                                                  e.text,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Theme.of(context)
                                                          .hintColor
                                                          .withOpacity(0.9)),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList()),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void filterSearchResults(String query) {
    List<String> dummySearchList = List<String>();
    dummySearchList.addAll(duplicateItems);
    if (query.isNotEmpty) {
      List<String> dummyListData = List<String>();
      dummySearchList.forEach((item) {
        if (item.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(duplicateItems);
      });
    }
  }
}
