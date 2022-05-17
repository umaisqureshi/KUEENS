import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kueens/main.dart';
import 'package:kueens/repo/settingRepo.dart' as settRepo;
import 'package:kueens/utils/appData.dart';
import 'package:kueens/utils/app_colors.dart';
import 'package:kueens/utils/firebase_credentials.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  bool isLocationFetch = true;
  var _visible = true;
  AnimationController animationController;
  Animation<double> animation;
  final assetsAudioPlayer = AssetsAudioPlayer();
  Animation<Offset> _offsetAnimation;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigateToNextScreen);
  }

  Future onSelectNotification(String payload) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Ok"))
            ],
          );
        });
  //  return Future.
  }

  showNotification(map) async {
    var android = AndroidNotificationDetails(
      'K',
      'Kueens ',
      'Post Status',
      priority: Priority.high,
      importance: Importance.max,
    );
    var iOS = IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(
        0, map['notification']['title'], map['notification']['body'], platform,
        payload: '');
  }

  void configureFirebase(FirebaseMessaging _firebaseMessaging) {
    try {
      _firebaseMessaging.configure(
        onMessage: notificationOnMessage,
        onLaunch: notificationOnLaunch,
        onResume: notificationOnResume,
      );
    } catch (e) {
      print(e);
      print('Error Config Firebase!!!');
    }
  }

  Future notificationOnResume(Map<String, dynamic> message) async {
    await Future.delayed(Duration(seconds: 4));
    onSelectNotification("");
  }

  Future notificationOnLaunch(Map<String, dynamic> message) async {
    await Future.delayed(Duration(seconds: 4));
    onSelectNotification("");
  }

  Future notificationOnMessage(Map<String, dynamic> message) async {
    showNotification(message);
  }

  navigateToNextScreen() {
    setState(() {
      isLocationFetch = false;
    });
    assetsAudioPlayer.stop();
    if (FirebaseCredentials().auth.currentUser == null) {
      Navigator.of(context).pushReplacementNamed('/login');
    } else {
      Navigator.of(context).pushReplacementNamed('/dashboard', arguments: 0);
    }
  }



  @override
  void initState() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    var initializationSettingsIOs = IOSInitializationSettings();

    var initSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOs);

    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: onSelectNotification);

    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    configureFirebase(firebaseMessaging);
    super.initState();
   /* assetsAudioPlayer
        .open(
          Audio("assets/audio/logoaudio.mp3"),
        )
        .then((value) => assetsAudioPlayer.play());*/
    animationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 800));
    animation =
        new CurvedAnimation(parent: animationController, curve: Curves.easeOut);
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.elasticIn,
    ));
    animation.addListener(() => this.setState(() {}));
    animationController.forward();
    setState(() {
      _visible = !_visible;
    });

    try {
      settRepo.setCurrentLocation().then((_address) async {
        startTime();
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission denied');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
          /*  new Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(bottom: 30.0),
                    child: SlideTransition(
                      position: _offsetAnimation,
                      child: new Image.asset(
                        'assets/images/tagline.png',
                        height: animation.value * 20,
                        fit: BoxFit.scaleDown,
                      ),
                    ))
              ],
            ),*/
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    /*boxShadow: [
                      BoxShadow(color: Colors.pink.withOpacity(0.4), blurRadius: 40, offset: Offset.zero,spreadRadius: 0.0),
                    ],*/
                    borderRadius: BorderRadius.all(Radius.circular(30)),

                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      decoration: BoxDecoration(
                        /*boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 2.0,
                            offset: Offset(7.0, 7.0), ),
                        ],*/
                        borderRadius: BorderRadius.all(Radius.circular(40)),

                      ),
                      child: Image(
                        image: AssetImage("assets/images/splashLogo.jpeg"),
                        width: animation.value * 250,
                        height: animation.value*250,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
