import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:kueens/fragments/registerShopFragment.dart';
import 'package:kueens/model/route_argument.dart';
import 'package:kueens/screens/drawer.dart';
import 'package:kueens/utils/app_colors.dart';
import 'package:kueens/utils/firebase_credentials.dart';
import 'package:kueens/widgets/progress-indicator.dart';

enum RouteResult { SUCCEED, ERROR }

class Posts extends StatefulWidget {
  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  final GlobalKey<ScaffoldState> _postScaffoldKey =
      new GlobalKey<ScaffoldState>();
  bool isTap = false;

  getUser() async {
    setState(() {
      isTap = !isTap;
    });
    await FirebaseCredentials()
        .db
        .collection('User')
        .doc(FirebaseCredentials().auth.currentUser.uid)
        .get()
        .then((value) {
      setState(() {
        isTap = !isTap;
      });
      if (value != null && value.data().containsKey('shopData')) {
        Navigator.of(context).pushNamed('/createPost');
      } else {
        _showCupertinoDialog();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _postScaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () => _postScaffoldKey.currentState.openDrawer(),
          child: Icon(
            Icons.notes_sharp,
            color: AppColors.primaryColor,
          ),
        ),
        title: Text(
          "My Posts",
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
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "createPostBtn",
        onPressed: getUser,
        label: isTap
            ? CircularProgressIndicator(
                backgroundColor: Colors.white,
              )
            : Text('Create Post'),
        icon: Icon(Icons.create_outlined),
      ),
      drawer: Drawerr(),
      body: Container(
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseCredentials()
                  .db
                  .collection('OfflinePost')
                  .where('id',
                      isEqualTo: FirebaseCredentials().auth.currentUser.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return ProgressIndicatorWidget();
                } else if (snapshot.data.size == 0) {
                  return Center(
                      child: Text(
                    "Currently you have no Post",
                    style: TextStyle(color: Colors.black),
                  ));
                } else {
                  return AnimationLimiter(
                    child: ListView.builder(
                      itemCount: snapshot.data.size,
                      itemBuilder: (context, i) {
                        var status = snapshot.data.docs[i]
                            .data()['status']
                            .toString()
                            .toUpperCase();
                        Color color = getStatusIndicator(status);
                        return AnimationConfiguration.staggeredList(
                          duration: const Duration(milliseconds: 375),
                          position: i,
                          child: SlideAnimation(
                            verticalOffset: 100.0,
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      elevation: 6.0,
                                      child: Container(
                                          height: 200,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            image: DecorationImage(
                                                image: NetworkImage(snapshot
                                                    .data.docs[i]['images'][0]),
                                                fit: BoxFit.cover),
                                          ),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Color.fromRGBO(
                                                    20, 20, 20, 0.7),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    width: double.infinity,
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: TextButton.icon(
                                                        onPressed: null,
                                                        icon: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  color: color
                                                                      .withOpacity(
                                                                          0.4),
                                                                  blurRadius:
                                                                      40,
                                                                  offset:
                                                                      Offset(0,
                                                                          15)),
                                                              BoxShadow(
                                                                  color: color
                                                                      .withOpacity(
                                                                          0.4),
                                                                  blurRadius:
                                                                      13,
                                                                  offset:
                                                                      Offset(
                                                                          0, 3))
                                                            ],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            100)),
                                                          ),
                                                          child: Icon(
                                                            Icons.circle,
                                                            color: color,
                                                          ),
                                                        ),
                                                        label: Text(
                                                          status,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        )),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 10),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          snapshot.data.docs[i]
                                                              ['title'],
                                                          style: TextStyle(
                                                              fontSize: 25,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        Text(
                                                          snapshot.data.docs[i]
                                                              ['desc'],
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ))),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 1,
                                  top: 60,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      color == Colors.deepOrange
                                          ? ClipOval(
                                              child: Material(
                                                color: Colors
                                                    .deepOrange, // button color
                                                child: InkWell(
                                                  child: SizedBox(
                                                      width: 45,
                                                      height: 45,
                                                      child: Icon(
                                                        Icons.refresh,
                                                        color: Colors.white,
                                                        size: 20,
                                                      )),
                                                  onTap: () =>
                                                      Navigator.pushNamed(
                                                          context, '/editPost',
                                                          arguments: snapshot
                                                              .data.docs[i]
                                                              .data()),
                                                ),
                                              ),
                                            )
                                          : Container(),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      color == Colors.red
                                          ? ClipOval(
                                              child: Material(
                                                color: Colors
                                                    .purple, // button color
                                                child: InkWell(
                                                  child: SizedBox(
                                                      width: 45,
                                                      height: 45,
                                                      child: Icon(
                                                        Icons.edit,
                                                        color: Colors.white,
                                                        size: 20,
                                                      )),
                                                  onTap: () =>
                                                      Navigator.pushNamed(
                                                          context,
                                                          '/editPost',
                                                          arguments:
                                                              RouteArgument(
                                                                  param1: snapshot
                                                                      .data
                                                                      .docs[i]
                                                                      .data(),
                                                                  param2:
                                                                      snapshot
                                                                          .data
                                                                          .docs[
                                                                              i]
                                                                          .id)),
                                                ),
                                              ),
                                            )
                                          : Container(),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      ClipOval(
                                        child: Material(
                                          color: Colors.purple, // button color
                                          child: InkWell(
                                            child: SizedBox(
                                                width: 45,
                                                height: 45,
                                                child: Icon(
                                                  Icons.delete_outline,
                                                  color: Colors.white,
                                                  size: 20,
                                                )),
                                            onTap: () => deletePost(
                                                snapshot.data.docs[i].id,
                                                snapshot.data.docs[i]
                                                    .data()['status']),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              })),
    );
  }

  void deletePost(String id, String status) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Delete'),
          content: Text('Are you sure you want to delete this post'),
          actions: <Widget>[
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
            FlatButton(
              child: Text('yes'),
              onPressed: () async {
                await FirebaseCredentials()
                    .db
                    .collection('OfflinePost')
                    .doc(id)
                    .delete();
                if (status == 'live') {
                  await FirebaseCredentials()
                      .db
                      .collection('Post')
                      .doc(id)
                      .delete();
                }
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _showCupertinoDialog() {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text("Register shop?"),
              content: new Text(
                  "Before create new post you need to register your shop first"),
              actions: <Widget>[
                FlatButton(
                  child: Text('Decline'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text('Accept'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    dynamic result = await Navigator.of(context)
                        .push(RegisterShopFragment(documentSnapshot: null));
                    if (result == RouteResult.SUCCEED.toString()) {
                      Navigator.of(context).pushNamed('/createPost');
                    }
                  },
                )
              ],
            ));
  }

  getStatusIndicator(status) {
    return status == "PENDING"
        ? Colors.amber
        : status == "DECLINED"
            ? Colors.red
            : status == "LIVE"
                ? Colors.green
                : status == 'EXPIRE'
                    ? Colors.deepOrange
                    : Colors.transparent;
  }
}
