import 'package:flutter/material.dart';
import 'package:kueens/screens/allReviews.dart';
import 'package:kueens/screens/categories.dart';
import 'package:kueens/screens/categoryMoreItems.dart';
import 'package:kueens/screens/chat.dart';
import 'package:kueens/screens/chooseCategory.dart';
import 'package:kueens/screens/codeVerification.dart';
import 'package:kueens/screens/createPost.dart';
import 'package:kueens/screens/create_privacy_policy.dart';
import 'package:kueens/screens/editPost.dart';
import 'package:kueens/screens/itemDetails.dart';
import 'package:kueens/screens/popularMoreItems.dart';
import 'package:kueens/screens/posts.dart';
import 'package:kueens/screens/dashboard.dart';
import 'package:kueens/screens/edit_profile.dart';
import 'package:kueens/screens/login.dart';
import 'package:kueens/screens/profile.dart';
import 'package:kueens/screens/register.dart';
import 'package:kueens/screens/specialOfferList.dart';
import 'package:kueens/screens/splash.dart';
import 'package:kueens/screens/home.dart';
import 'package:kueens/screens/weeklyMoreItems.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    switch (settings.name) {
      case '/splash':
        return MaterialPageRoute(builder: (_) => Splash());
      case '/login':
        return MaterialPageRoute(builder: (_) => Login());
      case '/dashboard':
        return MaterialPageRoute(builder: (_) => Dashboard(index: args,));
      case '/home':
        return MaterialPageRoute(builder: (_) => Home(category: args,));
      case '/register':
        return MaterialPageRoute(builder: (_) => Register(routeArgument: args,));
      case '/code_verification':
        return MaterialPageRoute(builder: (_) => CodeVerification(routeArgument: args,));
      case '/profile':
        return MaterialPageRoute(builder: (_) => Profile());
      case '/edit_profile':
        return MaterialPageRoute(builder: (_) => EditProfile());
      case '/chooseCategory':
        return MaterialPageRoute(builder: (_) => ChooseCategory());
      case '/posts':
        return MaterialPageRoute(builder: (_) => Posts());
      case '/createPost':
        return MaterialPageRoute(builder: (_) => CreatePost());
      case '/editPost':
        return MaterialPageRoute(builder: (_) => EditPost(map: args,));
      case '/itemDetail':
        return MaterialPageRoute(
            builder: (_) => ItemDetail(
                  snaps: args,
                ));
      case '/category':
        return MaterialPageRoute(builder: (_) => Categories());
      case '/chat':
        return MaterialPageRoute(
            builder: (_) => Chat(
                  routeArgument: args,
                ));
      case '/weeklyList':
        return MaterialPageRoute(builder: (_) => WeeklyMoreItems(category: args,));
      case '/specialOfferList':
        return MaterialPageRoute(builder: (_) => SpecialOfferMoreItems(category: args,));
      case '/popularList':
        return MaterialPageRoute(builder: (_) => PopularMoreItems(category: args,));
      case '/categoryList':
        return MaterialPageRoute(builder: (_) => CategoryMoreItems(category: args,));
      case '/privacyPolicy':
        return MaterialPageRoute(builder: (_) => CreatePrivacyPolicy(snap: args,));
      case '/allReviews':
        return MaterialPageRoute(builder: (_) => AllReviews(snaps: args,));
      // case '/order':
      //   return MaterialPageRoute(
      //       builder: (_) => Order(routeArgumentModel: args));
      // case '/coupen':
      //   return MaterialPageRoute(builder: (_) => Coupen());
      // case '/payment':
      //   return MaterialPageRoute(builder: (_) => Payment());
      // case '/forgot':
      //   return MaterialPageRoute(builder: (_) => Forgot());
      // case '/book':
      //   return MaterialPageRoute(
      //       builder: (_) => Book(
      //             routeArgumentModel: args,
      //           ));
      // case '/settings':
      //   return MaterialPageRoute(builder: (_) => Settings());
      // case '/personalInfo':
      //   return MaterialPageRoute(
      //       builder: (_) => PersonalInfo(
      //             routeArgumentModel: args,
      //           ));
      default:
        return null;
      // If there is no such named route in the switch statement, e.g. /third
      //return MaterialPageRoute(builder: (_) => PagesTestWidget(currentTab: 1));
    }
  }
}
