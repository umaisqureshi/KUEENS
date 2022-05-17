import 'dart:io';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kueens/fragments/registerShopFragment.dart';
import 'package:kueens/fragments/shopInfoModel.dart';
import 'package:kueens/utils/app_colors.dart';
import 'package:kueens/utils/firebase_credentials.dart';
import 'package:kueens/widgets/progress-indicator.dart';
class PostCountStatus{
  int total;
  int declined;
  int pending;
  int live;
  PostCountStatus.name({this.total = 0, this.declined = 0, this.pending = 0, this.live = 0});
}
class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  PostCountStatus _postCountStatus = PostCountStatus.name();
  @override
  void initState() {
    super.initState();
    if(mounted){
      getPostsCount();
    }
  }
 getPostsCount() async {
   FirebaseCredentials()
        .db
        .collection('OfflinePost')
        .where('id', isEqualTo:FirebaseCredentials().auth.currentUser.uid)
        .snapshots().listen((event) {
      var total = event.docs.length;
      var declined =   event.docs.where((element) => element.data()['status'] == 'declined').length;
      var pending =   event.docs.where((element) => element.data()['status'] == 'pending').length;
      var live =   event.docs.where((element) => element.data()['status'] == 'live').length;
      _postCountStatus =   PostCountStatus.name(total: total, declined: declined, pending: pending, live: live);
    });
   setState(() {});
  }
  var top = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder(
          future: FirebaseCredentials()
            .db
            .collection('User')
            .doc(FirebaseCredentials().auth.currentUser.uid)
            .get(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            return snapshot.hasData?
            NestedScrollView(
              scrollDirection: Axis.vertical,
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScroll) {
                return <Widget>[
                  SliverAppBar(
                    leading: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back_outlined,
                        color: Colors.white,
                      ),
                    ),
                    expandedHeight: MediaQuery.of(context).size.height/1.8,
                    pinned: true,
                    stretch: true,
                    flexibleSpace: Material(
                      elevation: 4.0,
                      color: AppColors.primaryColor,
                      child: LayoutBuilder(
                        builder: (BuildContext context, BoxConstraints constraints){
                          top = constraints.biggest.height;
                          print(top);
                          return FlexibleSpaceBar(
                            collapseMode: CollapseMode.pin,
                            title: AnimatedOpacity(
                              duration: Duration(milliseconds: 300),
                              opacity: top < 100.0 ? 1.0 : 0.0,
                              child: Text(
                                '${snapshot.data
                                    .data()['firstName']} '
                                    '${snapshot.data
                                    .data()['lastName']}',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,shadows: [ Shadow(
                                  color: Colors.grey.shade900,
                                  blurRadius: 2,
                                ),]),
                              ),
                            ),
                            centerTitle: true,
                            background: snapshot.data != null
                                ? Container(
                              color: AppColors.primaryColor,
                              child:  Column(
                                children: [
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Container(
                                    height: 150,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.white, width: 5),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.8),
                                          spreadRadius: 1,
                                          blurRadius: 1,
                                          offset: Offset(0,
                                              1), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(70),
                                      child: snapshot.data
                                          .data()['pictureUrl'] !=
                                          'default'
                                          ? Image.network(
                                        snapshot.data
                                            .data()['pictureUrl'],
                                        fit: BoxFit.cover,
                                      )
                                          : Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: Icon(Icons.person,size: 50,),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width: double.infinity,
                                    color: Colors.purple[600],
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${snapshot.data
                                                .data()['firstName']} '
                                                '${snapshot.data
                                                .data()['lastName']}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Colors.white,shadows: [ Shadow(
                                              color: Colors.grey.shade900,
                                              offset: Offset(0.0, 2),
                                              blurRadius: 2,
                                            ),]),
                                          ),
                                          InkWell(onTap: (){
                                            Navigator.pushReplacementNamed(
                                              context,
                                              '/edit_profile',
                                            );
                                          },child:  Row(
                                            children: [
                                              Icon(
                                                Icons.edit,
                                                color: Colors.white,
                                              ),
                                              Text('Edit Profile', style: TextStyle(color: Colors.white),)
                                            ],
                                          ),),
                                        ],),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Text(
                                            '• Interest',
                                            style: TextStyle(
                                                fontSize: 12, color: Colors.white,fontWeight: FontWeight.bold),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(left: 6.0),
                                          child: Text(
                                            snapshot.data
                                                .data()['interest']
                                                .join("\n")
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 11, color: Colors.white),
                                            maxLines: 15,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],),
                                    Container(color: Colors.white,width: 1,height: 70,),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Text(
                                            '• Total Posts',
                                            style: TextStyle(
                                                fontSize: 12, color: Colors.white,fontWeight: FontWeight.bold),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Container(
                                          child: Text('${_postCountStatus.total} Posts',
                                            style: TextStyle(
                                                fontSize: 11, color: Colors.white),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(height: 10,),
                                        Container(
                                          child: Text(
                                            '• Declined Posts',
                                            style: TextStyle(
                                                fontSize: 12, color: Colors.white,fontWeight: FontWeight.bold),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Container(
                                          child: Text('${_postCountStatus.declined} Posts',
                                            style: TextStyle(
                                                fontSize: 11, color: Colors.white),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],),
                                    Container(color: Colors.white,width: 1,height: 70,),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Text(
                                            '• Pending Posts',
                                            style: TextStyle(
                                                fontSize: 12, color: Colors.white,fontWeight: FontWeight.bold),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Container(
                                          child: Text('${_postCountStatus.pending} Posts',
                                            style: TextStyle(
                                                fontSize: 11, color: Colors.white),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(height: 10,),
                                        Container(
                                          child: Text(
                                            '• Live Posts',
                                            style: TextStyle(
                                                fontSize: 12, color: Colors.white,fontWeight: FontWeight.bold),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Container(
                                          child: Text('${_postCountStatus.live} Posts',
                                            style: TextStyle(
                                                fontSize: 11, color: Colors.white),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],),

                                  ],),
                                ],
                              ),
                            )
                                : Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ];
              },
              body: snapshot.data != null
                  ? ListView(
                      shrinkWrap: true,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          child: Material(
                            elevation: 4.0,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              height: 60,
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Phone",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    snapshot.data.data()['contact'],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          child: Material(
                            elevation: 4.0,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              height: 60,
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Email",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    snapshot.data.data()['mail'],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          child: Material(
                            elevation: 4.0,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              height: 60,
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Location",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('${snapshot.data.data()['city']},'),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(snapshot.data.data()['country'])
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        snapshot.data.data().containsKey("shopData")
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Material(
                                      borderRadius: BorderRadius.circular(20),
                                      elevation: 4,
                                      child: Container(
                                        height: 200,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Colors.white,
                                          image: DecorationImage(image: NetworkImage(snapshot.data
                                              .data()['shopData']
                                          ['shopLogo'],),fit: BoxFit.cover,colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken))
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            ListTile(
                                              title:  Text(
                                                snapshot.data
                                                    .data()['shopData']
                                                ['shopName'],
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              subtitle:  Text(
                                                snapshot.data
                                                    .data()['shopData']
                                                ['shopDesc'],
                                                style: TextStyle(
                                                  color: Colors.white54,
                                                  fontSize: 15,
                                                ),
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              trailing: TextButton.icon(onPressed: (){
                                                Navigator.of(context).push(RegisterShopFragment(
                                                    documentSnapshot: snapshot.data));
                                              }, icon: Icon(Icons.edit,color: Colors.white,), label: Text('Edit', style: TextStyle(color: Colors.white),)),
                                            ),
                                           IconButton(icon: Icon(Icons.arrow_forward_ios,color: Colors.white,), onPressed: (){
                                             Navigator.of(context).push(
                                                 ShopInfoModel(
                                                     snapshot.data.id));
                                           })

                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                        snapshot.data.data().containsKey('shopData')?Container():InkWell(
                          onTap: () {
                            Navigator.of(context).push(RegisterShopFragment(
                                documentSnapshot:
                                snapshot.data.data().containsKey('shopData')
                                        ? snapshot.data
                                        : null));
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                top: 10.0, bottom: 10.0, left: 20, right: 20),
                            height: 50,
                            decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                border:
                                    Border.all(color: Theme.of(context).hintColor),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0))),
                            child: Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Register Your Kueens Account",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(RegisterShopFragment(
                                          documentSnapshot: null));
                                    },
                                    child: Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          child: ButtonTheme(
                              height: 50,
                              minWidth: MediaQuery.of(context).size.width / 3,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)),
                                onPressed: () async {
                                  FirebaseCredentials().auth.signOut();
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, '/login', (route) => false);
                                },
                                color: Colors.red,
                                child: Text(
                                  "Log Out",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                        ),
                      ],
                    )
                  : ProgressIndicatorWidget(),
            ):Center(child: CircularProgressIndicator(),);
          }
        ),
      ),
    );
  }
}

class HeaderBehevior extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0.0, size.height - 330);
    path.lineTo(size.width, size.height - 330);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
