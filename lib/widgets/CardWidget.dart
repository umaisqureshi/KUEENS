import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:kueens/utils/app_colors.dart';
import 'package:kueens/utils/firebase_credentials.dart';
import 'package:kueens/utils/helper.dart';

class CardWidget extends StatefulWidget {
  final DocumentSnapshot snaps;

  CardWidget({this.snaps});

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {


  bool isFav = false;
  String rating = '0.0';

  CountdownTimerController controller;
  int endTime;

  Future<void> onEnd() async {
    await FirebaseFirestore.instance.collection('Post').doc(widget.snaps.id).delete().then((value) async {
     await FirebaseFirestore.instance.collection('OfflinePost').doc(widget.snaps.id).update({'status':'expire'});
    });
  }

  @override
  void initState() {
    super.initState();
    endTime = widget.snaps.data().containsKey("timestamp") ? widget.snaps.data()['timestamp'] : 0;
    controller = CountdownTimerController(endTime: endTime, onEnd: onEnd);
    FirebaseCredentials()
        .db
        .collection("User")
        .doc(FirebaseCredentials().auth.currentUser.uid)
        .collection('Fav')
        .doc(widget.snaps.data()['productId'])
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          isFav = value.data()['isFav'];
        });
      }
    });
    setState(() {
      rating = widget.snaps.data()['rating'].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 290,
      margin: EdgeInsets.only(left: 10, right: 10, top: 0.0, bottom: 15),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Image of the card
          Stack(
            fit: StackFit.loose,
            alignment: AlignmentDirectional.topStart,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.only(
                   topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed('/itemDetail', arguments: widget.snaps);
                  },
                  child: CachedNetworkImage(
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    imageUrl: widget.snaps.data()['offer']['image'],
                    placeholder: (context, url) => Image.asset(
                      'assets/images/loading.gif',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 150,
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/images/loading.gif',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 150,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.snaps.data().containsKey("timestamp") ?Container(
                    margin: EdgeInsets.only(top: 10.0),
                    padding: EdgeInsets.all(4.0),
                    color: Colors.purple,
                    child: CountdownTimer(
                      controller: controller,
                      endTime: endTime,
                      widgetBuilder: (_, CurrentRemainingTime time) {
                        if (time == null) {
                          return Text('00:00:00:00',style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w300),);
                        }
                        return Text(
                            '${time.days??"00"}:${time.hours??"00"}:${time.min??"00"}:${time.sec??"00"}',style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w300),);
                      },
                    ),
                  ):Container(),

                  widget.snaps.data().containsKey('offer') ?Container(
                    margin: EdgeInsets.only(top: 5.0),
                    padding: EdgeInsets.all(4.0),
                    color: Colors.purple,
                    child: Text(
                      "Discount ${widget.snaps.data()['offer']['discount']}",
                      style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w400),
                    ),
                  ):Container(),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.snaps.data()['title'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      Text(
                        widget.snaps.data()['desc'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.caption,
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: Helper.getStarsList(double.parse(rating)),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 15),
                InkWell(
                  onTap: () {
                    setState(() {
                      isFav = !isFav;
                    });
                    FirebaseCredentials()
                        .db
                        .collection("User")
                        .doc(FirebaseCredentials().auth.currentUser.uid)
                        .collection('Fav')
                        .doc(widget.snaps.data()['productId'])
                        .set({'isFav': isFav}, SetOptions(merge: true)).then(
                            (value) {});
                  },
                  child: CircleAvatar(
                      backgroundColor:
                          isFav ? Colors.grey : AppColors.primaryColor,
                      child: Icon(
                        Icons.favorite,
                        color: isFav ? Colors.red : Colors.white,
                      )),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
