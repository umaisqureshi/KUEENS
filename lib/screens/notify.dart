import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kueens/screens/drawer.dart';
import 'package:kueens/utils/app_colors.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => _scaffoldKey.currentState.openDrawer(),
          icon: Icon(Icons.notes_sharp),
          color: AppColors.primaryColor,
        ),
        title: Text(
          "NOTIFICATION",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0.0,
        actions: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/profile'),
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
        child: ListView.separated(
          itemBuilder: (context, i) {
            return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 60,
                  child: Row(
                    children: [
                      Icon(
                        Icons.collections_bookmark_sharp,
                        color: AppColors.primaryColor,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Cooking & Baking",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text("I need a cooking expert for home")
                        ],
                      )
                    ],
                  ),
                ));
          },
          itemCount: 10,
          separatorBuilder: (BuildContext context, int index) {
            return Divider();
          },
        ),
      ),
    );
  }
}
