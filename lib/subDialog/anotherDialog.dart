import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/scheduler.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'subscriptionDealCard.dart';
import 'constant.dart';
import 'generic_shadow_button.dart';
import 'package:kueens/utils/appData.dart';

class AnotherDialog extends StatefulWidget {
  static const String mySearchDialogScreenDialog = "AnotherDialog";

  @override
  _AnotherDialogState createState() => _AnotherDialogState();
}

class _AnotherDialogState extends State<AnotherDialog> {

  PurchaserInfo _purchaserInfo;

  Offerings _offerings;
  bool silver = false;
  bool platinum = false;
  bool gold = false;
  int _currentPos = 0;
  bool somethingSelected = false;

  List<String> listPaths = [
    "assets/images/SILVER.png",
    "assets/images/PLATINUM.png",
    "assets/images/GOLD.png",
  ];

  List<String> planList = [
    "Silver",
    "Platinum",
    "Gold",
  ];

  List<String> duration = [
    "Unlock All Benefits \n Advertise your Home Based Business \n Only for 000 for 1 month",
    "Unlock All Benefits \n Advertise your Home Based Business \n Only for 000 for 6 months",
    "Unlock All Benefits \n Advertise your Home Based Business \n Only for 000 for 12 months",
  ];

  Future<void> fetchData() async {
    PurchaserInfo purchaserInfo;
    try {
      purchaserInfo = await Purchases.getPurchaserInfo();
    } catch (e) {
      print(e);
    }
    Offerings offerings;
    try {
      offerings = await Purchases.getOfferings();
      print("Offerings : ${offerings.all.length}");
    }  catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      _purchaserInfo = purchaserInfo;
      _offerings = offerings;
    });
    duration = [
      "Unlock All Benefits \n Advertise your Home Based Business \n Only for ${_offerings.getOffering("default").monthly.product.currencyCode} ${_offerings.getOffering("default").monthly.product.price.toStringAsFixed(0)} for 1 month",
      "Unlock All Benefits \n Advertise your Home Based Business \n Only for ${_offerings.getOffering("default").sixMonth.product.currencyCode} ${_offerings.getOffering("default").sixMonth.product.price.toStringAsFixed(0)} for 6 months",
      "Unlock All Benefits \n Advertise your Home Based Business \n Only for ${_offerings.getOffering("default").annual.product.currencyCode} ${_offerings.getOffering("default").annual.product.price.toStringAsFixed(0)} for 12 months",
    ];
  }

  showInSnackBar(String message){
    final snackBar = SnackBar(content: Text(message),);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    // TODO: implement initState
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      PurchaserInfo purchaserInfo;
      try {
        purchaserInfo = await Purchases.getPurchaserInfo();
      } catch (e) {
        print(e);
      }
      Offerings offerings;
      try {
        offerings = await Purchases.getOfferings();
        print("Offerings : ${offerings.all.length}");
      }  catch (e) {
        print(e);
      }
      //if (!mounted) return;
      setState(() {
        _purchaserInfo = purchaserInfo;
        _offerings = offerings;
      });
      duration = [
        "Unlock All Benefits \n Advertise your Home Based Business \n Only for ${_offerings.getOffering("default").monthly.product.currencyCode} ${_offerings.getOffering("default").monthly.product.price.toStringAsFixed(0)} for 1 month",
        "Unlock All Benefits \n Advertise your Home Based Business \n Only for ${_offerings.getOffering("default").sixMonth.product.currencyCode} ${_offerings.getOffering("default").sixMonth.product.price.toStringAsFixed(0)} for 6 months",
        "Unlock All Benefits \n Advertise your Home Based Business \n Only for ${_offerings.getOffering("default").annual.product.currencyCode} ${_offerings.getOffering("default").annual.product.price.toStringAsFixed(0)} for 12 months",
      ];
    });
    //fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            child: Container(
              width: double.infinity,
              child: Column(
                children: [
                  Container(
                    height: 350,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color(0xff7D2C91),
                          Colors.deepPurple,
                        ],
                      ),
                    ),
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CarouselSlider.builder(
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return Container(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Image.asset(listPaths[index],
                                      width: 180, height: 180),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "${planList[index]}",
                                    style: dialogTitle.copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "${duration[index]}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          options: CarouselOptions(
                              autoPlay: false,
                              pageSnapping: true,
                              height: 300,
                              viewportFraction: 1.4,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _currentPos = index;
                                });
                              }),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: listPaths.map((url) {
                            int index = listPaths.indexOf(url);
                            return Container(
                              width: 8.0,
                              height: 8.0,
                              margin: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 2.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentPos == index
                                    ? Color.fromRGBO(255, 255, 255, 0.9)
                                    : Color.fromRGBO(255, 255, 255, 0.4),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 230,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    silver = true;
                                    platinum = false;
                                    gold = false;
                                  });
                                },
                                child: SubscriptionDealCard(
                                  duration: "1",
                                  price: _offerings!=null ? "${_offerings.getOffering("default").monthly.product.currencyCode} ${_offerings.getOffering("default").monthly.product.price.toStringAsFixed(0)}" : "",
                                  isVisible: silver,
                                  plan: "Silver",
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    silver = false;
                                    platinum = true;
                                    gold = false;
                                  });
                                },
                                child: SubscriptionDealCard(
                                  duration: "6",
                                  price: _offerings != null ? "${_offerings.getOffering("default").sixMonth.product.currencyCode} ${_offerings.getOffering("default").sixMonth.product.price.toStringAsFixed(0)}" : "",
                                  isVisible: platinum,
                                  plan: "Platinum",
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    silver = false;
                                    platinum = false;
                                    gold = true;
                                  });
                                },
                                child: SubscriptionDealCard(
                                  duration: "12",
                                  price: _offerings!=null ? "${_offerings.getOffering("default").annual.product.currencyCode} ${_offerings.getOffering("default").annual.product.price.toStringAsFixed(0)}" : "",
                                  plan: "Gold",
                                  isVisible: gold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GenericBShadowButton(
                          buttonText: "Continue",
                          onPressed: () async {
                            if (silver || platinum || gold) {
                              Map<String, dynamic> mapName = Map();
                              mapName = silver
                                  ? {
                                      'price': '${_offerings.getOffering("default").monthly.product.currencyCode} ${_offerings.getOffering("default").annual.product.price.toStringAsFixed(0)}',
                                      'time': '1 month',
                                      'name': 'Silver'
                                    }
                                  : platinum
                                      ? {
                                          'price': '${_offerings.getOffering("default").sixMonth.product.currencyCode} ${_offerings.getOffering("default").annual.product.price.toStringAsFixed(0)}',
                                          'time': '6 months',
                                          'name': 'Platinum'
                                        }
                                      : gold
                                          ? {
                                              'price': '${_offerings.getOffering("default").annual.product.currencyCode} ${_offerings.getOffering("default").annual.product.price.toStringAsFixed(0)}',
                                              'time': '12 months',
                                              'name': 'Gold'
                                            }
                                          : null;
                              if(silver){
                                _purchaserInfo = await Purchases.purchasePackage(_offerings.getOffering('default').monthly);
                                if(_purchaserInfo.entitlements.active.isNotEmpty){
                                  User user = FirebaseAuth.instance.currentUser;
                                  mapName['user_id'] = user.uid;
                                  mapName['user_name'] = user.displayName;
                                  mapName['user_picture'] = user.photoURL;
                                  mapName['timeStamp'] = FieldValue.serverTimestamp();
                                  await FirebaseFirestore.instance
                                      .collection('paymentHistory')
                                      .doc()
                                      .set(mapName, SetOptions(merge: true));
                                  appData.isPro = _purchaserInfo.entitlements.all['pro'].isActive;
                                  Navigator.of(context).pop(true);
                                }
                                else{
                                  showInSnackBar("Purchase Not Made");
                                }
                              }
                              else if(platinum){
                                print("Package Identifier ::::::::::::::: ${_offerings.getOffering('default').sixMonth.identifier}");
                                _purchaserInfo = await Purchases.purchasePackage(_offerings.getOffering('default').sixMonth);
                                if(_purchaserInfo.entitlements.active.isNotEmpty){
                                  User user = FirebaseAuth.instance.currentUser;
                                  mapName['user_id'] = user.uid;
                                  mapName['user_name'] = user.displayName;
                                  mapName['user_picture'] = user.photoURL;
                                  mapName['timeStamp'] = FieldValue.serverTimestamp();
                                  await FirebaseFirestore.instance
                                      .collection('paymentHistory')
                                      .doc()
                                      .set(mapName, SetOptions(merge: true));
                                  appData.isPro = _purchaserInfo.entitlements.all['pro'].isActive;
                                  Navigator.of(context).pop(true);
                                }
                                else{
                                  showInSnackBar("Purchase Not Made");
                                }
                              }
                              else if(gold){
                                _purchaserInfo = await Purchases.purchasePackage(_offerings.getOffering('default').annual);
                                if(_purchaserInfo.entitlements.active.isNotEmpty){
                                  User user = FirebaseAuth.instance.currentUser;
                                  mapName['user_id'] = user.uid;
                                  mapName['user_name'] = user.displayName;
                                  mapName['user_picture'] = user.photoURL;
                                  mapName['timeStamp'] = FieldValue.serverTimestamp();
                                  await FirebaseFirestore.instance
                                      .collection('paymentHistory')
                                      .doc()
                                      .set(mapName, SetOptions(merge: true));
                                  appData.isPro = _purchaserInfo.entitlements.all['pro'].isActive;
                                  Navigator.of(context).pop(true);
                                }
                                else{
                                  showInSnackBar("Purchase Not Made");
                                }
                              }
                            } else {
                              Navigator.of(context).pop(false);
                            }
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column buildCarousalCard({String imagePath, String title, String period}) {
    return Column(
      children: [
        CircleAvatar(
          backgroundImage: AssetImage(imagePath),
          radius: 50,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          title,
          style: dialogTitle,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "For $period months",
          style: dialogTitle,
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "Get 5 Free Super Likes a day & more",
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}
