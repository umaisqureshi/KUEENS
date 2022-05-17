import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:kueens/model/route_argument.dart';
import 'package:kueens/screens/register.dart';
import 'package:kueens/subDialog/generic_shadow_button.dart';
import 'package:kueens/utils/firebase_credentials.dart';
import 'package:kueens/widgets/pinCodeFields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kueens/model/user.dart';

//import 'package:mapoot/controller/countryCode_controller.dart';
//import 'package:mvc_pattern/mvc_pattern.dart';
//import 'package:mapoot/models/Country.dart';
//import '../BlockButtonWidget.dart';
//import 'package:mapoot/models/route_argument.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class CodeVerification extends StatefulWidget {
  final RouteArgument routeArgument;

  CodeVerification({this.routeArgument});

  @override
  _CodeVerificationState createState() => _CodeVerificationState();
}

class _CodeVerificationState extends State<CodeVerification> {
  bool isLoading = false;
  TextEditingController _controller1 = TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPreferences prefs;

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  sendTokenToServer(bool status, User user) async {
    await firebaseMessaging.getToken().then((value) {
      FirebaseCredentials()
          .db
          .collection('token')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .set({
        'token': value,
      }, SetOptions(merge: true)).then((value) {
        if (status) {

          Navigator.of(context).pushNamedAndRemoveUntil(
              '/dashboard', (Route<dynamic> route) => false,
              arguments: 0);
        } else {
          //register
          Navigator.of(context).pushReplacementNamed('/register',
              arguments: RouteArgument(
                  param1: user.uid, param2: widget.routeArgument.param2));
        }
      });
    });
  }

  checkDoc(id) async {
    var a = await FirebaseFirestore.instance.collection('User').doc(id).get();
    if (a.exists) {
      return true;
    }
    if (!a.exists) {
      return false;
    }
  }

  void signInWithPhoneNumber(verificationId, code) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: code,
      );
      User firebaseUser = (await FirebaseCredentials()
              .auth
              .signInWithCredential(credential)
              .catchError((e) {
        print(e);
      }))
          .user;
      setState(() {
        isLoading = false;
      });
      if (firebaseUser != null) {
        bool status = await checkDoc(firebaseUser.uid);
        sendTokenToServer(status, firebaseUser);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 3),
        content: Text(
            "Failed to Verify Phone Number: ${e is FirebaseException ? e.message : e}"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: kToolbarHeight,
                        child: Icon(Icons.arrow_back_rounded),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  "Enter code received",
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .merge(TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  "We sent you a 6-digit code.",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              PinCodeTextField(
                length: 6,
                controller: _controller1,
                onChanged: (value) {},
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isLoading
                      ? CircularProgressIndicator()
                      : GenericBShadowButton(
                          buttonText: 'Continue',
                          onPressed: () {
                            if (_controller1.text.isEmpty) {
                            } else {
                              setState(() {
                                isLoading = true;
                              });
                              signInWithPhoneNumber(widget.routeArgument.param1,
                                  _controller1.text);
                            }
                          },
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
