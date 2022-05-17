import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:kueens/utils/app_colors.dart';
import 'package:kueens/utils/route_generator.dart';
import 'package:firebase_core/firebase_core.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(new MyApp());
}

const assetImage = AssetImage('assets/images/whiteLogo.png');
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
  FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    precacheImage(assetImage, context);
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Kueen's",
        theme: ThemeData(
         primarySwatch: AppColors.generateMaterialColor(),
          fontFamily: 'Varela',
        ),
        navigatorObservers: <NavigatorObserver>[observer],
        initialRoute: '/splash',
        onGenerateRoute: RouteGenerator.generateRoute);
  }

}
