import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:kueens/fragments/shopInfoModel.dart';
import 'package:kueens/screens/popularMoreDrawerItems.dart';
import 'package:kueens/screens/weeklyMoreDrawerItems.dart';
import 'package:kueens/screens/weeklyMoreItems.dart';
import 'package:kueens/utils/app_colors.dart';
import 'package:kueens/utils/firebase_credentials.dart';
import 'package:url_launcher/url_launcher.dart';

enum DrawerEnums {
  HOME,
  PROFILE,
  WEEKLY_OFFER,
  OFFERS,
  NEW_PRODUCTS,
  POPULAR_PRODUCTS,
  CATEGORIES,
  SEARCH,
  LOGOUT
}

class Drawerr extends StatefulWidget {
  final ValueChanged onClickDrawer;
  const Drawerr({Key key, this.onClickDrawer}) : super(key: key);

  @override
  _DrawerrState createState() => _DrawerrState();
}

class _DrawerrState extends State<Drawerr> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;
    return Drawer(
      child: ListView(
        children: <Widget>[
          GestureDetector(
              onTap: () {},
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).hintColor.withOpacity(0.1),
                ),
                accountName: Text(
                  user.displayName,
                  style: Theme.of(context).textTheme.headline6,
                ),
                accountEmail: Text(
                  user.phoneNumber,
                  style: Theme.of(context).textTheme.caption,
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Theme.of(context).accentColor,
                  backgroundImage: NetworkImage(user.photoURL),
                ),
              )),
          ListTile(
            onTap: () => Navigator.pushNamed(context, '/dashboard'),
            leading: Icon(
              Icons.home,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              'Home',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
            leading: Icon(
              Icons.person,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              'My Profile',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          Divider(
            color: AppColors.primaryColor,
            thickness: 1,
          ),
          ListTile(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => WeeklyMoreDrawerItems()));
            },
            leading: Image.asset(
              'assets/images/broadcast.png',
              height: 18,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              'Weekly Specials',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PopularMoreDrawerItems()));
            },
            leading: Icon(
              Icons.favorite,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              'Popular Products',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          Divider(
            color: AppColors.primaryColor,
            thickness: 1,
          ),
          ListTile(
            onTap: () => Navigator.pushNamed(context, '/category'),
            leading: Icon(
              Icons.star,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              'Category',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          Divider(
            color: AppColors.primaryColor,
            thickness: 1,
          ),
          ListTile(
            onTap: () =>  Navigator.of(context).push(ShopInfoModel(FirebaseAuth.instance.currentUser.uid)),
            leading: Icon(
              Icons.widgets_sharp,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              'About Kueens Castle',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () async {
              var id = "com.falcon.kueensApp";
              await FlutterShare.share(
                  title: "kueen's App",
                  linkUrl: "https://play.google.com/store/apps/details?id=$id",
                  chooserTitle: 'Share with');
          /*    var id = "com.falcon.kueensApp";
             if( Platform.isAndroid){
               try {
                 launch("market://details?id=" + id);
               } on PlatformException catch(e) {
                 launch(");
               } finally {
                 launch("https://play.google.com/store/apps/details?id=" + id);
               }
             }*/
            },
            leading: Icon(
              Icons.share,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              'Share App',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              FirebaseCredentials().auth.signOut();
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false);
            },
            leading: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              'Logout',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
        ],
      ),
    );
  }
}
