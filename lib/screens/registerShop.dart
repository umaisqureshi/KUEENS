import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kueens/geo_firestore/geo_firestore.dart';
import 'package:kueens/repo/settingRepo.dart';
import 'package:kueens/screens/create_privacy_policy.dart';
import 'package:kueens/screens/posts.dart';
import 'package:kueens/utils/app_colors.dart';
import 'package:kueens/utils/firebase_credentials.dart';
import 'package:kueens/widgets/progress-indicator.dart';
import 'dart:io';
import 'package:kueens/model/address.dart' as address;

class RegisterShop extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;

  RegisterShop({this.documentSnapshot});

  @override
  _RegisterShopState createState() => _RegisterShopState();
}

class _RegisterShopState extends State<RegisterShop> {
  final _formKey = GlobalKey<FormState>();
  final shopNameController = TextEditingController();
  final shopDescriptionController = TextEditingController();
  final shopAddressController = TextEditingController();
  final fbController = TextEditingController();
  final instaController = TextEditingController();
  final policyController = TextEditingController();
  final shopOwnerNameController = TextEditingController();
  PrivacyPolicyModel privacy = PrivacyPolicyModel();
  File _imageFile;
  String logoUrl;
  bool isLogoEmpty = false;
  bool pickLogo = true;
  bool loader = false;
  String area;
  address.Address _address;

  Future<void> pickImage() async {
    File file = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      _imageFile = file;
    });
  }

  Future uploadImage() async {
    var reference = FirebaseStorage.instance
        .ref()
        .child(FirebaseCredentials().auth.currentUser.uid.toString() + "Shop");
    StorageUploadTask uploadTask = reference.putFile(_imageFile);
    return await (await uploadTask.onComplete).ref.getDownloadURL();
  }

  @override
  void initState() {
    super.initState();
    DocumentSnapshot documentSnapshot = widget.documentSnapshot;
    setState(() {
      if (documentSnapshot != null) {
        logoUrl = documentSnapshot.data()['shopData']['shopLogo'];
        shopNameController.text =
            documentSnapshot.data()['shopData']['shopName'];
        shopDescriptionController.text =
            documentSnapshot.data()['shopData']['shopDesc'];
        fbController.text = documentSnapshot.data()['shopData']['shopFbPage'];
        instaController.text =
            documentSnapshot.data()['shopData']['shopInstaPage'];
        policyController.text =
            documentSnapshot.data()['shopData']['policyPage'];
      }
    });
    getCIty();
  }

  getCIty() async {
    getCurrentLocation().then((address.Address value) async {
      setState(() {
        _address = value;
      });
      final coordinates = new Coordinates(value.latitude, value.longitude);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      setState(() {
        area = '${first.subLocality ?? ''} ${first.locality ?? ''}';
        shopAddressController.text = area;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(
        "Register Your Kueens Castle!",
        style: TextStyle(
          fontSize: 16,
            color: Colors.white),
      ),centerTitle: true,),
      body: Container(
        child: AnimationLimiter(
          child: AnimationConfiguration.staggeredList(
              duration: Duration(milliseconds: 370),
              position: 10,
              child: ScaleAnimation(
                child: ListView(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            Container(
                                height: 150,
                                width: 150,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: isLogoEmpty?Colors.red:Colors.white, width: 5),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.8),
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: _imageFile != null
                                        ? Image.file(_imageFile)
                                        : logoUrl != null
                                            ? Image.network(
                                                logoUrl,
                                                fit: BoxFit.cover,
                                              )
                                            : Icon(Icons.person))),
                            Transform.translate(
                              offset: Offset(0.0,-18.0),
                              child: Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    shape: BoxShape.circle),
                                child: InkWell(
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                    onTap: () => pickImage()),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: shopNameController,
                              validator: (input) {
                                if (input.isEmpty)
                                  return "Required Field";
                                else
                                  return null;
                              },
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 1),
                                  fillColor: Colors.grey[300],
                                  filled: true,
                                  border: new OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(
                                        color: Colors.transparent, width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                  ),
                                  prefixIcon: Icon(Icons.shopping_bag_outlined),
                                  hintText: "Kueens Castle Name"),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: shopDescriptionController,
                              validator: (input) {
                                if (input.isEmpty)
                                  return "Required Field";
                                else
                                  return null;
                              },
                              maxLines: 4,
                              decoration: InputDecoration(
                                border: new OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                fillColor: Colors.grey[300],
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(
                                      color: Colors.transparent, width: 2),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                prefixIcon: Icon(Icons.description_outlined),
                                hintText: "Kueens Castle Description",
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: shopAddressController,
                              validator: (input) {
                                if (input.isEmpty)
                                  return "Required Field";
                                else
                                  return null;
                              },
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 1),
                                  fillColor: Colors.grey[300],
                                  filled: true,
                                  border: new OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(
                                        color: Colors.transparent, width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                  ),
                                  prefixIcon: Icon(Icons.location_pin),
                                  hintText: "Address"),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: shopOwnerNameController
                                ..text = FirebaseCredentials()
                                    .auth
                                    .currentUser
                                    .displayName,
                              validator: (input) {
                                if (input.isEmpty)
                                  return "Required Field";
                                else
                                  return null;
                              },
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 1),
                                  fillColor: Colors.grey[300],
                                  filled: true,
                                  border: new OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(
                                        color: Colors.transparent, width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                  ),
                                  prefixIcon: Icon(Icons.person),
                                  hintText: "Owner Name"),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: fbController,
                              validator: (input) {
                                if (input.isEmpty)
                                  return "Required Field";
                                else
                                  return null;
                              },
                              keyboardType: TextInputType.url,
                              decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 1),
                                  fillColor: Colors.grey[300],
                                  filled: true,
                                  border: new OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(
                                        color: Colors.transparent, width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                  ),
                                  prefixIcon: Image.asset(
                                    'assets/images/facebook.png',
                                    color: Colors.grey,
                                  ),
                                  hintText: "Facebook Page Link"),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: instaController,
                              validator: (input) {
                                if (input.isEmpty)
                                  return "Required Field";
                                else
                                  return null;
                              },
                              keyboardType: TextInputType.url,
                              decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 1),
                                  fillColor: Colors.grey[300],
                                  filled: true,
                                  border: new OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(
                                        color: Colors.transparent, width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                  ),
                                  prefixIcon: Image.asset(
                                      'assets/images/instagram.png',
                                      color: Colors.grey),
                                  hintText: "Instagram Page Link"),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: policyController,
                              validator: (input) {
                                if (input.isEmpty)
                                  return "Required Field";
                                else
                                  return null;
                              },
                              keyboardType: TextInputType.text,
                              onTap: () async {
                                var res = await Navigator.of(context).pushNamed(
                                    '/privacyPolicy',
                                    arguments: widget.documentSnapshot);
                                setState(() {
                                  if (res != null) {
                                    policyController..text = 'Done';
                                  }
                                  privacy = res;
                                });
                              },
                              readOnly: true,
                              decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 1),
                                  fillColor: Colors.grey[300],
                                  filled: true,
                                  border: new OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(
                                        color: Colors.transparent, width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                  ),
                                  prefixIcon: Icon(Icons.security),
                                  hintText:
                                      "Kueens Castle Privacy Policy Link"),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: loader
                                  ? ProgressIndicatorWidget()
                                  : ButtonTheme(
                                      minWidth:
                                          MediaQuery.of(context).size.width,
                                      height: 45,
                                      child: RaisedButton(
                                        onPressed: () async {
                                          setState(() {
                                            loader = true;
                                          });
                                          registerShop();
                                        },
                                        child: Text(
                                          "Done",
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.white,
                                          ),
                                        ),
                                        color: AppColors.primaryColor,
                                        elevation: 10.0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(25.0),
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  void registerShop() async {
    if (_formKey.currentState.validate()) {
      if (_imageFile != null || logoUrl != null) {
        setState(() {
          isLogoEmpty = false;
        });
        logoUrl = logoUrl != null ? logoUrl : await uploadImage();
        var shop = Map();
        shop['shopName'] = shopNameController.text;
        shop['shopDesc'] = shopDescriptionController.text;
        shop['shopAddress'] = shopAddressController.text;
        shop['shopFbPage'] = fbController.text;
        shop['shopInstaPage'] = instaController.text;
        shop['policyPage'] = policyController.text;
        shop['shopOwnerName'] = shopOwnerNameController.text;
        shop['shopLogo'] = logoUrl;
        if (privacy != null) {
          shop['privacy'] = privacy.policy;
          shop['accept'] = privacy.accept;
          shop['notAccept'] = privacy.notAccept;
          shop['privacyDetails'] = privacy.details;
          shop['updateAt'] = privacy.updateAt;
        }

        await FirebaseCredentials()
            .db
            .collection('User')
            .doc(FirebaseCredentials().auth.currentUser.uid)
            .update({'shopData': shop}).then((value) {
          GeoFirestore geoFirestore =
              GeoFirestore(FirebaseCredentials().db.collection('User'));
          geoFirestore
              .setLocation(FirebaseCredentials().auth.currentUser.uid,
                  GeoPoint(_address.latitude, _address.longitude))
              .then((value) {
            setState(() {
              setState(() {
                loader = false;
              });
              Navigator.of(context).pop(RouteResult.SUCCEED.toString());
            });
          });
        });
      }else{
        setState(() {
          isLogoEmpty = true;
        });
      }
    }
    setState(() {
      loader = false;
    });
  }
}
