import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kueens/utils/app_colors.dart';
import 'package:kueens/utils/firebase_credentials.dart';

class ChooseCategory extends StatefulWidget {
  @override
  _ChooseCategoryState createState() => _ChooseCategoryState();
}

class _ChooseCategoryState extends State<ChooseCategory> {
  DocumentSnapshot interest;
  List<String> chozen = [];

  bool status = false;

  Map<String, bool> values = {
    'Cooking & Baking': false,
    'Home Boutique': false,
    'Stitching/ Knitting/ Tailoring': false,
    'Make-Up/Hair/Henna Artist': false,
    'Fashion Jewellers': false,
    'Artist & Painters': false,
    'Home Decor & Furnishing': false,
    'Grocers': false,
    'Fruits & Vegetables': false,
    'HouseHold Appliances': false,
    'Child Care & Domestic Help': false,
    'Gardening Tips & Help': false,
    'Home Tutors': false,
    'Pet Supply/ Care': false,
    'Other': false,
  };

  @override
  void initState() {
    super.initState();
    syncData();
  }

  syncData() async {
    getUserInterest().then((result) {
      setState(() {
        interest = result;
        status = result.data()['interest'].isNotEmpty;
      });
    });
  }

  Future<DocumentSnapshot> getUserInterest() async {
    return await FirebaseCredentials()
        .db
        .collection('User')
        .doc(FirebaseCredentials().auth.currentUser.uid)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Choose Category"),
          elevation: 0.0,
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: IconButton(
                icon: Icon(Icons.add),
                onPressed: () => dialog(),
              ),
            )
          ],
        ),
        floatingActionButton: status
            ? FloatingActionButton(
                onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                    '/dashboard', (Route<dynamic> route) => false,
                    arguments: 0),
                child: Icon(Icons.navigate_next),
              )
            : Container(),
        body: Container(
            child: status
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Wrap(
                              direction: Axis.horizontal,
                              alignment: WrapAlignment.start,
                              crossAxisAlignment: WrapCrossAlignment.start,
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children: List.generate(
                                  interest.data()['interest'].length,
                                  (index) => Chip(
                                        labelPadding: EdgeInsets.all(5.0),
                                        label: Text(
                                          interest.data()['interest'][index],
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        backgroundColor: AppColors.primaryColor,
                                        elevation: 6.0,
                                        shadowColor: Colors.grey[60],
                                        padding: EdgeInsets.all(6.0),
                                      ))))
                    ],
                  )
                : Center(
                    child: Text("Choose your Favourite Categories",
                        style: TextStyle(
                          fontSize: 12,
                        )))),
      ),
    );
  }

  void dialog() {
    showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
            child: Align(
              alignment: Alignment.center,
              child: Material(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: MediaQuery.of(context).size.height / 1.5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            "Categories",
                            style: TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 22),
                          )),
                      Container(
                        height: MediaQuery.of(context).size.height / 1.99,
                        child: ListView(
                          shrinkWrap: true,
                          children: values.keys.map((String key) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: new CheckboxListTile(
                                title: Text(key),
                                value: values[key],
                                onChanged: (bool value) {
                                  setState(() {
                                    values[key] = value;
                                    if (value == true) {
                                      chozen.add(key);
                                    } else {
                                      chozen.remove(key);
                                    }
                                  });
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          FirebaseCredentials()
                              .db
                              .collection('User')
                              .doc(FirebaseCredentials().auth.currentUser.uid)
                              .update({'interest': chozen});
                          syncData();
                          Navigator.pop(context);
                        },
                        child: Container(
                            width: double.infinity,
                            height: 45,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                            ),
                            child: Center(
                              child: Text(
                                "Done",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            )),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
              Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
    );
  }
}
