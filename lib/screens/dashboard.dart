import 'dart:async';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kueens/screens/categories.dart';
import 'package:kueens/screens/search2.dart';
import 'package:kueens/utils/appData.dart';
import 'package:kueens/utils/app_colors.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'posts.dart';
import 'map.dart';

class Dashboard extends StatefulWidget {
  final int index;

  Dashboard({this.index});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex;
  PageController _pageController;
  PurchaserInfo _purchaserInfo;

  Future<void> initPlatformState() async {
    appData.isPro = false;

    await Purchases.setDebugLogsEnabled(true);
    await Purchases.setup("YudPAtJdrtQXVnPtcIfyKLTqVvhTIcqc");

    PurchaserInfo purchaserInfo;
    try {
      purchaserInfo = await Purchases.getPurchaserInfo();
      print(purchaserInfo.toString());
      if (purchaserInfo.entitlements.all['pro'] != null) {
        appData.isPro = purchaserInfo.entitlements.all['pro'].isActive;
        print('LASOHE MAOSHE is user pro? ${appData.isPro}');
      } else {
        appData.isPro = false;
      }
    } on PlatformException catch (e) {
      print(e);
    }
    print('#### is user pro? ${appData.isPro}');
  }

  @override
  void initState() {
    initPlatformState();
    super.initState();
    _currentIndex = widget.index;
    _pageController = PageController();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            Categories(),
            Posts(),
            Search2(),
            Map(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        itemCornerRadius: 15,
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              activeColor: AppColors.primaryColor,
              title: Text(
                'Home',
                style: TextStyle(color: AppColors.primaryColor),
              ),
              icon: Icon(Icons.home)),
          BottomNavyBarItem(
              activeColor: AppColors.primaryColor,
              title: Text(
                'Post',
                style: TextStyle(color: AppColors.primaryColor),
              ),
              icon: Icon(Icons.note_add)),
          BottomNavyBarItem(
              activeColor: AppColors.primaryColor,
              title: Text(
                'Search',
                style: TextStyle(color: AppColors.primaryColor),
              ),
              icon: Icon(Icons.search_sharp)),
          BottomNavyBarItem(
              activeColor: AppColors.primaryColor,
              title: Text(
                'Map',
                style: TextStyle(color: AppColors.primaryColor),
              ),
              icon: Icon(Icons.map)),
        ],
      ),
    );
  }
}
