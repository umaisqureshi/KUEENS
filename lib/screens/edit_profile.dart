import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:kueens/utils/app_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kueens/utils/firebase_credentials.dart';
import 'package:kueens/widgets/progress-indicator.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File _imageFile;
  String imageUrl;
  bool isLogoEmpty = false;
  bool _loader = false;
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final address2Controller = TextEditingController();
  final regionController = TextEditingController();
  final cityController = TextEditingController();
  final countryController = TextEditingController();
  final mailController = TextEditingController();
  final passController = TextEditingController();
  final pincodeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  DocumentSnapshot document;

  Future uploadImage() async {
    var reference = FirebaseStorage.instance
        .ref()
        .child(FirebaseCredentials().auth.currentUser.uid);
    StorageUploadTask uploadTask = reference.putFile(_imageFile);
    return (await uploadTask.onComplete).ref.getDownloadURL();
  }

  Future<void> pickImage() async {
    File file = new File((await ImagePicker().getImage(
      source: ImageSource.gallery,
    )).path);
    setState(() {
      _imageFile = file;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData().then((result) {
      setState(() {
        document = result;
        firstNameController.text = document.data()['firstName'];
        lastNameController.text = document.data()['lastName'];
        mailController.text = document.data()['mail'];
        addressController.text = document.data()['addressLine1'];
        address2Controller.text = document.data()['addressLine2'];
        cityController.text = document.data()['city'];
        countryController.text = document.data()['country'];
        regionController.text = document.data()['state'];
        pincodeController.text = document.data()['pinCode'];
        imageUrl = document.data()['pictureUrl'];
      });
    });
  }

  getUserData() async {
    return await FirebaseCredentials()
        .db
        .collection('User')
        .doc(FirebaseCredentials().auth.currentUser.uid)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, '/profile');
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, '/profile'),
            icon: Icon(
              Icons.arrow_back_outlined,
              color: Colors.white,
            ),
          ),
          bottomOpacity: 0.0,
          elevation: 0.0,
          title: Text(
            "Edit Profile",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
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
                                : imageUrl != null && imageUrl != 'default'
                                ? Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                            )
                                : Icon(Icons.person,size: 50,))),
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
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: firstNameController,
                    validator: (input) {
                      if (input.isEmpty)
                        return "Required Field";
                      else
                        return null;
                    },
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 1),
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
                        hintText: "First Name*"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: lastNameController,
                    validator: (input) {
                      if (input.isEmpty)
                        return "Required Field";
                      else
                        return null;
                    },
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 1),
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
                        prefixIcon: Icon(Icons.person),
                        hintText: "Last Name*"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: mailController,
                    validator: (input) {
                      if (input.isEmpty)
                        return null;
                      else
                        return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 1),
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
                        prefixIcon: Icon(Icons.email),
                        hintText: "Email"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: addressController,
                    validator: (input) {
                      if (input.isEmpty)
                        return "Required Field";
                      else
                        return null;
                    },
                    keyboardType: TextInputType.streetAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 1),
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
                        prefixIcon: Icon(Icons.location_on_rounded),
                        hintText: "Address Line 1*"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: address2Controller,
                    validator: (input) {
                      if (input.isEmpty)
                        return "Required Field";
                      else
                        return null;
                    },
                    keyboardType: TextInputType.streetAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 1),
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
                        prefixIcon: Icon(Icons.location_on_rounded),
                        hintText: "Address Line 2*"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: cityController,
                          validator: (input) {
                            if (input.isEmpty)
                              return "Required Field";
                            else
                              return null;
                          },
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              contentPadding:
                              EdgeInsets.symmetric(vertical: 1),
                              border: new OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              fillColor: Colors.grey[300],
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(10.0)),
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(10.0)),
                                borderSide:
                                BorderSide(color: Colors.transparent),
                              ),
                              prefixIcon: Icon(Icons.countertops_rounded),
/*
                                    suffixIcon: IconButton(icon: Icon(Icons.keyboard_arrow_down_sharp),onPressed: (){
                                      chooseCountry();
                                    },),
*/
                              hintText: "City*"),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: pincodeController,
                          validator: (input) {
                            if (input.isEmpty)
                              return "Required Field";
                            else
                              return null;
                          },
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          textCapitalization:
                          TextCapitalization.sentences,
                          decoration: InputDecoration(
                              contentPadding:
                              EdgeInsets.symmetric(vertical: 1),
                              border: new OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              fillColor: Colors.grey[300],
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(10.0)),
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(10.0)),
                                borderSide:
                                BorderSide(color: Colors.transparent),
                              ),
                              prefixIcon: Icon(Icons.fiber_pin),
                              hintText: "Pincode*"),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: regionController,
                    validator: (input) {
                      if (input.isEmpty)
                        return "Required Field";
                      else
                        return null;
                    },
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 1),
                        border: new OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(20),
                        ),
                        fillColor: Colors.grey[300],
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(10.0)),
                          borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(10.0)),
                          borderSide: BorderSide(
                              color: Colors.transparent),
                        ),
                        prefixIcon: Icon(Icons.location_city),
                        hintText: "State*"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: countryController,
                    validator: (input) {
                      if (input.isEmpty)
                        return "Required Field";
                      else
                        return null;
                    },
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 1),
                        border: new OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(20),
                        ),
                        fillColor: Colors.grey[300],
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(10.0)),
                          borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(10.0)),
                          borderSide: BorderSide(
                              color: Colors.transparent),
                        ),
                        prefixIcon:
                        Icon(Icons.countertops_rounded),
                        hintText: "Country*"),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                ],
              ),
            ),
            _loader
                ? ProgressIndicatorWidget()
                : Padding(
              padding: const EdgeInsets.all(6.0),
              child: ButtonTheme(
                  height: 40,
                  minWidth: 250,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),  primary: AppColors.primaryColor,),
                    onPressed: () async {

                      if (_imageFile != null) {
                        imageUrl = await uploadImage();
                      }
                      update(imageUrl);
                    },
                    child: Text(
                      "Update",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
            )

          ],
        ),
      ),
    );
  }

  Future<void> update(String imageUrl) async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _loader = true;
      });
      try {
        await FirebaseCredentials()
            .db
            .collection('User')
            .doc(FirebaseCredentials().auth.currentUser.uid)
            .update({
          'firstName': firstNameController.text,
          'lastName': lastNameController.text,
          'mail': mailController.text ?? "",
          'addressLine1': addressController.text,
          'addressLine2': address2Controller.text,
          'city': cityController.text,
          'country': countryController.text,
          'state': regionController.text,
          'pinCode': pincodeController.text,
          'pictureUrl': imageUrl
        });
        User user = FirebaseCredentials().auth.currentUser;
        await user.updateProfile(
            displayName:
                '${firstNameController.text} ${lastNameController.text}',
            photoURL: imageUrl);
        setState(() {
          _loader = false;
        });
      } catch (e) {}
    }
  }
}

