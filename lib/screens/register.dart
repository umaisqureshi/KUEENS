import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:kueens/model/country_model.dart';
import 'package:kueens/model/region_model.dart';
import 'package:kueens/model/route_argument.dart';
import 'package:kueens/screens/codeVerification.dart';
import 'package:kueens/utils/app_colors.dart';
import 'package:kueens/utils/firebase_credentials.dart';
import 'package:kueens/widgets/progress-indicator.dart';
import 'package:restcountries/restcountries.dart';
import 'package:smart_select/smart_select.dart';
import 'package:kueens/model/user.dart';

class Register extends StatefulWidget {
  final RouteArgument routeArgument;

  Register({this.routeArgument});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  var api = RestCountries.setup('b572c343f4faa8a6e6ae270253c04faf');
  bool isLoading = false;
  String currentRegion;
  String completeNumber;
  List<S2Choice<CountryModel>> countryList;
  List<S2Choice<RegionModel>> regionList;
  CountryModel _selectedCountryValue =
      CountryModel(name: "Afghanistan", code: "af");
  RegionModel _selectedRegionValue = RegionModel(country: "", region: "");
  final _formKey = GlobalKey<FormState>();
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
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Welcome!",
                    style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 30,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Create your account",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Form(
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
                          onChanged: (value) {
                            widget.routeArgument.param2.firstName =
                                firstNameController.text;
                          },
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.emailAddress,
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
                          onChanged: (value) {
                            widget.routeArgument.param2.lastName = lastNameController.text;
                          },
                          textCapitalization: TextCapitalization.sentences,
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
                          onChanged: (value) {
                            widget.routeArgument.param2.email = mailController.text;
                          },
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
                          onChanged: (value) {
                            widget.routeArgument.param2.addressLine1 =
                                addressController.text;
                          },
                          textCapitalization: TextCapitalization.sentences,
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
                          onChanged: (value) {
                            widget.routeArgument.param2.addressLine2 =
                                address2Controller.text;
                          },
                          textCapitalization: TextCapitalization.sentences,
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
                                onChanged: (value) {
                                  widget.routeArgument.param2.city = cityController.text;
                                },
                                textCapitalization:
                                    TextCapitalization.sentences,
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
                                onChanged: (value) {
                                  widget.routeArgument.param2.pincode =
                                      pincodeController.text;
                                },
                                keyboardType: TextInputType.text,
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
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 0.0, right: 8.0),
                            child: regionList == null
                                ? TextFormField(
                                    controller: regionController,
                                    validator: (input) {
                                      if (input.isEmpty)
                                        return "Required Field";
                                      else
                                        return null;
                                    },
                                    onChanged: (value) {
                                      widget.routeArgument.param2.state =
                                          regionController.text;
                                    },
                                    textCapitalization:
                                        TextCapitalization.sentences,
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
                                  )
                                : chooseRegion(),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 0.0, right: 8.0),
                            child: countryList == null
                                ? TextFormField(
                                    controller: countryController,
                                    validator: (input) {
                                      if (input.isEmpty)
                                        return "Required Field";
                                      else
                                        return null;
                                    },
                                    onChanged: (value) {
                                      widget.routeArgument.param2.country =
                                          countryController.text;
                                    },
                                    textCapitalization:
                                        TextCapitalization.sentences,
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
                                  )
                                : chooseCountry(),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: isLoading
                      ? ProgressIndicatorWidget()
                      : MaterialButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 5,
                                  offset: Offset(0, 4),
                                ),
                              ],
                              gradient: LinearGradient(
                                begin: Alignment.centerRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  Color(0xff7D2C91),
                                  Colors.deepPurple,
                                ],
                              ),
                            ),
                            child: Text(
                              "Sign Up",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              updateFirebase(
                                  uid: widget.routeArgument.param1,
                                  userData: widget.routeArgument.param2);
                            }
                            //String verificationId = await phoneVerification(user.contact);
                            //user.verificationId = verificationId;
                            /*Navigator.push(context, MaterialPageRoute(builder: (context){
                              return CodeVerification(user: user,verificationId: verificationId,);
                            }));*/
                            //signUp();
                          },
                        ),
                ),
                /*Align(
                  alignment: Alignment.bottomCenter,
                  child: Text.rich(
                    TextSpan(
                        text: "Already have an account? ",
                        children: <TextSpan>[
                          TextSpan(
                            text: "Login ",
                            style: TextStyle(
                              color: AppColors.primaryColor,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.pop(context),
                          ),
                        ]),
                    textAlign: TextAlign.center,
                  ),
                ),*/
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  updateFirebase({uid, UserData userData}) async {
    User user = FirebaseCredentials().auth.currentUser;
    await user.updateProfile(
        displayName: '${userData.firstName} ${userData.lastName}',
        photoURL: 'default');
    await FirebaseCredentials().db.collection('User').doc(uid).set({
      'firstName': userData.firstName,
      'lastName': userData.lastName,
      'mail': userData.email ?? "",
      'contact': userData.contact,
      'addressLine1': userData.addressLine1,
      'addressLine2': userData.addressLine2,
      'city': userData.city,
      'country': userData.country,
      'state': userData.state,
      'pinCode':pincodeController.text,
      'pictureUrl': 'default',
//          'shopData': null,
      'interest': []
    }, SetOptions(merge: true)).then((ref) {
      setState(() {
        isLoading = false;
      });
      Navigator.pushReplacementNamed(context, '/chooseCategory');
    });
  }

  Future<String> phoneVerification(phoneNumber) async {
    final completer = Completer<String>();
    try {
      await FirebaseCredentials().auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          timeout: const Duration(seconds: 5),
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            /*Navigator.push(context, MaterialPageRoute(builder: (context){
                  return CodeVerification(user: user,);
                }));*/
          },
          verificationFailed: (FirebaseAuthException authException) {
            completer.completeError(
                'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
          },
          codeSent: (String verificationId, [int forceResendingToken]) async {
            completer.complete(verificationId);
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            completer.complete(verificationId);
          });
    } catch (e) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 3),
        content: Text(
            "Failed to Verify Phone Number: ${e is FirebaseException ? e.message : e}"),
      ));
    }
    return completer.future;
  }

  void signUp() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      await FirebaseCredentials()
          .auth
          .createUserWithEmailAndPassword(
              email: mailController.text, password: passController.text)
          .then((value) async {
        User user = FirebaseCredentials().auth.currentUser;
        await user.updateProfile(
            displayName:
                '${firstNameController.text} ${lastNameController.text}',
            photoURL: 'default');
        await FirebaseCredentials()
            .db
            .collection('User')
            .doc(value.user.uid)
            .set({
          'firstName': firstNameController.text,
          'lastName': lastNameController.text,
          'mail': mailController.text ?? "",
          'contact': widget.routeArgument.param2.contact,
          'addressLine1': addressController.text,
          'addressLine2': address2Controller.text,
          'city': cityController.text,
          'country': countryController.text,
          'state': regionController.text,
          'pinCode':pincodeController.text,
          'pictureUrl': 'default',
//          'shopData': null,
          'interest': []
        }, SetOptions(merge: true)).then((ref) {
          Navigator.of(context).pushReplacementNamed('/chooseCategory');
        });
      });
    }
  }

  getRegionList(currentRegion) {
    SchedulerBinding.instance.addPersistentFrameCallback((timeStamp) async {
      await api
          .getRegions(
        countryCode: currentRegion,
      )
          .then((value) {
        setState(() {
          // _selectedRegionValue = RegionModel(country: value[0].country, region: value[0].region );
          regionList = value
              .map((e) => S2Choice<RegionModel>(
                  value: RegionModel(country: e.country, region: e.region),
                  title: e.region))
              .toList();
        });
      });
    });
  }

  chooseRegion() {
    return SmartSelect<RegionModel>.single(
      title: 'Choose Region',
      value: _selectedRegionValue,
      choiceItems: regionList,
      onChange: (state) => setState(() {
        _selectedRegionValue = RegionModel(
            country: state.value.country, region: state.value.region);
      }),
      modalType: S2ModalType.bottomSheet,
      tileBuilder: (context, state) {
        return S2Tile.fromState(
          state,
          hideValue: true,
          leading: Icon(Icons.location_city),
          trailing: Icon(Icons.keyboard_arrow_up),
          padding: EdgeInsets.all(2.0),
          dense: true,
          title: Transform.translate(
              offset: Offset(-16, 0),
              child: Text(
                _selectedRegionValue.region,
                style: TextStyle(fontSize: 16.0),
              )),
        );
      },
    );
  }

  chooseCountry() {
    return SmartSelect<CountryModel>.single(
      title: 'Choose Country',
      value: _selectedCountryValue,
      choiceItems: countryList,
      onChange: (state) => setState(() {
        _selectedCountryValue =
            CountryModel(name: state.value.name, code: state.value.code);
        currentRegion = state.value.code;
        getRegionList(state.value.code);
      }),
      modalType: S2ModalType.bottomSheet,
      tileBuilder: (context, state) {
        return S2Tile.fromState(
          state,
          hideValue: true,
          leading: Icon(Icons.location_city),
          trailing: Icon(Icons.keyboard_arrow_up),
          padding: EdgeInsets.all(2.0),
          dense: true,
          title: Transform.translate(
              offset: Offset(-16, 0),
              child: Text(
                _selectedCountryValue.name,
                style: TextStyle(fontSize: 16.0),
              )),
        );
      },
    );
  }
}
