import 'dart:async';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:kueens/model/route_argument.dart';
import 'package:kueens/model/user.dart';
import 'package:kueens/screens/codeVerification.dart';
import 'package:kueens/utils/app_colors.dart';
import 'package:kueens/utils/firebase_credentials.dart';
import 'package:kueens/widgets/progress-indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final _formKey = GlobalKey<FormState>();
  final mailController = TextEditingController();
  final passController = TextEditingController();
  final phoneController = TextEditingController();
  SharedPreferences prefs;
  bool status = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String completePhoneNumber;
  UserData user = UserData();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadPref();
  }

  loadPref() async{
    prefs = await SharedPreferences.getInstance();
  }

  Future<String> phoneVerification(phoneNumber) async {
    final completer = Completer<String>();

    try {
      await FirebaseCredentials().auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          timeout: const Duration(seconds: 30),
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {},
          verificationFailed: (FirebaseAuthException authException) {
            completer.completeError('Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
          },
          codeSent: (String verificationId, [int forceResendingToken]) async {
            completer.complete(verificationId);
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            completer.complete(verificationId);
          });
    } catch (e) {
      completer.completeError("Failed to Verify Phone Number: ${e is FirebaseException? e.message:e}");
    }
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // mainAxisSize: MainAxisSize.max,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Spacer(),
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
                    "Sign in to continue",
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
                        SizedBox(
                          height: 10,
                        ),
                        IntlPhoneField(
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 1),
                              border: new OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              fillColor: Colors.grey[300],
                              filled: true,
                              errorStyle: TextStyle(color: Colors.red),
                              errorBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(
                                    color: Colors.red, width: 2),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                                borderSide:
                                BorderSide(color: Colors.red),
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
                              prefixIcon: Icon(Icons.phone),
                              hintText: "Phone Number*"),
                          keyboardType: TextInputType.number,
                          validator: (input) {
                            if (input.isEmpty)
                              return "Required Field";
                            else
                              return null;
                          },
                          initialCountryCode: 'IN',
                          controller: phoneController,
                          onChanged: (phone){
                            completePhoneNumber = phone.completeNumber;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                        "Continue",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      if(_formKey.currentState.validate()){
                        setState(() {
                          isLoading=true;
                        });
                        print("Complete Phone number : $completePhoneNumber}" );
                        await phoneVerification(completePhoneNumber).then((value) {
                          user.verificationId = value;
                          user.contact = completePhoneNumber;
                          setState(() {
                            isLoading = false;
                          });
                          Navigator.of(context).pushNamed('/code_verification', arguments: RouteArgument(param1: value, param2: user),);
                        }).catchError((error){
                          setState(() {
                            isLoading = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error), duration: Duration(days: 1),));
                        });

                        //Navigator.pushNamed(context, '/code_verification', arguments: verificationId);
                      }
                      //loginUser();
                    },
                  ),
                ),
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

  void loginUser() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        status = true;
      });
      try {
        await FirebaseCredentials()
            .auth
            .signInWithEmailAndPassword(
                email: mailController.text, password: passController.text)
            .then((value) async {
              await prefs.setString('id', value.user.uid);

          Navigator.of(context).pushReplacementNamed('/dashboard');
        });
      } catch (e) {
        setState(() {
          status = false;
        });
      }
    }
  }
}
