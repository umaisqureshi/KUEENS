import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kueens/utils/app_colors.dart';

import 'ReadMoreText.dart';

class ReviewItemWidget extends StatefulWidget {
  final Map<String, dynamic> documentSnapshot;

  ReviewItemWidget({this.documentSnapshot});

  @override
  _ReviewItemWidgetState createState() => _ReviewItemWidgetState();
}

class _ReviewItemWidgetState extends State<ReviewItemWidget> {
  final int SECOND_MILLIS = 1000;
  final int MINUTE_MILLIS = 60 * 1000;
  final int HOUR_MILLIS = 60 * 60 * 1000;
  final int DAY_MILLIS = 24 * 60 * 60 * 1000;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.8),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: ListTile(
          leading: CircleAvatar(
              backgroundImage: NetworkImage(widget.documentSnapshot['userImg']??"https://www.clipartmax.com/png/middle/223-2236392_female-headshot-placeholder-female-profile-icon-png.png")),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.documentSnapshot['name']),

            ],
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            ReadMoreText(
              widget.documentSnapshot['review'],
              trimLines: 3,
              colorClickableText:  Color(0xff7D2C91),
              trimMode: TrimMode.Line,
              trimCollapsedText: '...Read More',
              trimExpandedText: 'Less',
            ),
            Text(
              getTimeAgo(widget.documentSnapshot['time']),
              style: TextStyle(fontSize: 12),
            ),
          ],),
        ));
  }

  String getTimeAgo(time) {
    if (time < 1000000000000) {
      time *= 1000;
    }
    var now = DateTime.now().millisecondsSinceEpoch;
    if (time > now || time <= 0) {
      return null;
    }
    int diff = now - time;
    if (diff < MINUTE_MILLIS) {
      return "just now";
    } else if (diff < 2 * MINUTE_MILLIS) {
      return "a minute ago";
    } else if (diff < 50 * MINUTE_MILLIS) {
      return "${(diff / MINUTE_MILLIS).toStringAsFixed(0)} minutes ago";
    } else if (diff < 90 * MINUTE_MILLIS) {
      return "an hour ago";
    } else if (diff < 24 * HOUR_MILLIS) {
      return "${(diff / HOUR_MILLIS).toStringAsFixed(0)} hours ago";
    } else if (diff < 48 * HOUR_MILLIS) {
      return "yesterday";
    } else {
      return "${(diff / DAY_MILLIS).toStringAsFixed(0)} days ago";
    }
  }
}
