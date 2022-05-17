import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:kueens/model/route_argument.dart';
import 'package:kueens/utils/app_colors.dart';
import 'package:kueens/utils/firebase_credentials.dart';
import 'package:kueens/utils/helper.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopInfo extends StatefulWidget {
  final id;

  ShopInfo({this.id});

  @override
  _ShopInfoState createState() => _ShopInfoState();
}

String problem = '';

class _ShopInfoState extends State<ShopInfo> {
  createUrl(DocumentSnapshot documentSnapshot) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
          shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable),
      uriPrefix: 'https://kueensforwoman.page.link',
      link: Uri.parse('https://kueen-e5906.web.app?id=${widget.id}'),
      androidParameters: AndroidParameters(
        packageName: "com.falcon.kueensApp",
      ),
      iosParameters: IosParameters(
        bundleId: "com.falcon.kueensApp",
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: documentSnapshot["shopData"]["shopName"],
        imageUrl: Uri.parse(documentSnapshot["shopData"]["shopLogo"]),
      ),
    );
    await parameters.buildShortLink().then((ShortDynamicLink value) async {
      if (value != null) {
        await FlutterShare.share(
            title: documentSnapshot["shopData"]["shopName"],
            linkUrl: value.shortUrl.toString(),
            chooserTitle: 'Share with');
      }
    });
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.id);
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
          future:
              FirebaseCredentials().db.collection('User').doc(widget.id).get(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            return Scaffold(
              appBar: AppBar(
                title: Text('About'),
                actions: [
                  snapshot.hasData && snapshot.data.data().containsKey("shopData")?IconButton(
                    onPressed: () {
                      createUrl(snapshot.data);
                    },
                    icon: Icon(
                      Icons.share,
                      color: Colors.white,
                    ),
                  ):Container(),
                ],
              ),
              body: snapshot.hasData
                  ?snapshot.data.data().containsKey("shopData")? About(documentSnapshot: snapshot.data)
                  : Center(
                      child: Text("No castle registered."),
                    ):Center(child: CircularProgressIndicator(),),
            );
          }),
    );
  }
}

class About extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;

  About({this.documentSnapshot});

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {

  String instaLink;
  String facebookLink;

  showInSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: 80.0,
                      height: 80.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                widget.documentSnapshot.data()['shopData']
                                        ['shopLogo'] ??
                                    "https://img.lovepik.com/element/40024/5565.png_860.png",
                              )))),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.documentSnapshot.data()['shopData']
                                ['shopName'],
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            '*' +
                                    widget.documentSnapshot
                                        .data()['interest']
                                        .join("\n*")
                                        .toString() ??
                                "",
                            style: TextStyle(fontSize: 11, color: Colors.black),
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.location_pin,
                                size: 15,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(child:  Text(
                                widget.documentSnapshot.data()['shopData']
                                ['shopAddress'] ??
                                    "",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ))

                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                widget.documentSnapshot.id !=
                        FirebaseAuth.instance.currentUser.uid
                    ? Column(
                        children: [
                          OutlineButton(
                            shape: StadiumBorder(),
                            textColor: AppColors.primaryColor,
                            hoverColor: AppColors.primaryColor,
                            highlightedBorderColor: AppColors.primaryColor,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 15),
                              child: Text('Contact'),
                            ),
                            borderSide: BorderSide(
                                color: AppColors.primaryColor,
                                style: BorderStyle.solid,
                                width: 2),
                            onPressed: () {
                              User user =
                                  FirebaseCredentials().auth.currentUser;
                              Navigator.of(context).pushNamed('/chat',
                                  arguments: RouteArgument(
                                      param1:
                                          widget.documentSnapshot.data()['id'],
                                      param2: widget.documentSnapshot
                                              .data()['pictureUrl'] ??
                                          'default',
                                      param3: widget.documentSnapshot
                                              .data()['firstName'] ??
                                          'User'));
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      child: dialogContent(
                                          context, widget.documentSnapshot.id),
                                    );
                                  });
                            },
                            child: Text(
                              "Report this Kueen's Castle",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Container(
              margin: EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.8),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Text(
                          'About Kueens Castle',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Text(
                          widget.documentSnapshot.data()['shopData']
                                  ['shopOwnerName'] ??
                              "",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5, bottom: 15),
                        child: Text(
                          widget.documentSnapshot.data()['shopData']
                                  ['shopDesc'] ??
                              "",
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Divider(),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Text(
                          "Privacy Policy",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 0.0),
                              child: Text(widget.documentSnapshot
                                  .data()['shopData']['privacy']),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Divider(),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Return and Exchange',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Text('I gladly accept Return or Exchange',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Text(widget.documentSnapshot
                                  .data()['shopData']['accept']),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Text('I don\'t accept Return or Exchange',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Text(widget.documentSnapshot
                                  .data()['shopData']['notAccept']),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Text('Return and Exchange details',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Text(widget.documentSnapshot
                                  .data()['shopData']['privacyDetails']),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        child: Text(
                          'Around the web',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          child: InkWell(
                            onTap: ()async{
                              instaLink = widget.documentSnapshot.data()['shopData']
                              ['shopFbPage'];
                              String username = instaLink.split('/').last;
                              await canLaunch("https://www.facebook.com/$username") ? await launch("https://www.facebook.com/$username") : showInSnackBar('Could not launch https://www.facebook.com/$username');
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/icons/facebook.png",
                                  width: 35,
                                  height: 35,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  widget.documentSnapshot.data()['shopData']
                                          ['shopFbPage'] ??
                                      "",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          )),
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          child: InkWell(
                            onTap: ()async{
                              instaLink = widget.documentSnapshot.data()['shopData']
                              ['shopInstaPage'];
                              String username = instaLink.split('/').last;
                              await canLaunch("https://www.instagram.com/$username") ? await launch("https://www.instagram.com/$username") : showInSnackBar('Could not launch https://www.instagram.com/$username') ;
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/icons/instagram.png",
                                  width: 35,
                                  height: 35,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  widget.documentSnapshot.data()['shopData']
                                          ['shopInstaPage'] ??
                                      "",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          )),
                      Divider(),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        child: Text(
                          'Owner and Shop Member',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(
                                  widget.documentSnapshot
                                          .data()['pictureUrl'] ??
                                      "",
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.documentSnapshot.data()['shopData']
                                            ['shopOwnerName'] ??
                                        "",
                                  ),
                                  Text('owner')
                                ],
                              )
                            ],
                          )),
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomRowModel {
  bool selected;
  String title;

  CustomRowModel({this.selected, this.title});
}

class CustomRow extends StatelessWidget {
  final CustomRowModel model;

  CustomRow(this.model);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 8.0, right: 8.0, top: 3.0, bottom: 3.0),
      child: Row(
        children: <Widget>[
// I have used my own CustomText class to customise TextWidget.
          this.model.selected
              ? Icon(
                  Icons.radio_button_checked,
                  color: Colors.deepPurple,
                )
              : Icon(Icons.radio_button_unchecked),
          SizedBox(
            width: 10,
          ),
          Text(
            '${model.title}',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

dialogContent(BuildContext context, postId) {
  TextEditingController comment = TextEditingController();
  return Container(
    padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            margin: EdgeInsets.all(5.0),
            alignment: Alignment.topRight,
            child: Icon(
              Icons.close,
              color: Colors.grey,
              size: 20.0,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
          color: Colors.white,
          child: Text(
            "Report  Kueen's Castle",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Flexible(
          child: new MyDialogContent(), //Custom ListView
        ),
        Container(
          height: 50,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: TextField(
              controller: comment,
              cursorColor: Colors.deepPurple,
              cursorHeight: 25,
              enabled: true,
              decoration: InputDecoration(
                hintText: "Comment (Optional)",
                hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurple, width: 1),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurple, width: 1),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0, left: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              InkWell(
                child: Text(
                  'Send',
                  style: TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                onTap: () async {
                  DocumentReference reportIt = FirebaseFirestore.instance
                      .collection("ReportedCastles")
                      .doc();
                  final snackBar = SnackBar(
                    content: Text(
                      "We'll be taking care of it as soon as possible.",
                      style: TextStyle(color: Colors.white),
                    ),
                    padding: EdgeInsets.all(16.0),
                    elevation: 6,
                    duration: Duration(seconds: 3),
                    action: SnackBarAction(
                      label: 'Undo',
                      textColor: Colors.white,
                      onPressed: () async {
                        FirebaseFirestore.instance
                            .collection("ReportedCastles")
                            .doc(reportIt.id)
                            .delete();
                      },
                    ),
                  );
                  reportIt.set({
                    "id": reportIt.id,
                    "postId": postId,
                    "comment": comment.text,
                    "problem": problem,
                  }, SetOptions(merge: true)).then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.of(context).pop();
                  });
                },
              )
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    ),
  );
}

class MyDialogContent extends StatefulWidget {
  MyDialogContent();

  @override
  _MyDialogContentState createState() => new _MyDialogContentState();
}

class _MyDialogContentState extends State<MyDialogContent> {
  List<CustomRowModel> sampleData = new List<CustomRowModel>();

  @override
  void initState() {
    super.initState();
    sampleData.add(CustomRowModel(title: "Offensive Content", selected: false));
    sampleData.add(CustomRowModel(title: "Fraud", selected: false));
    sampleData.add(
        CustomRowModel(title: "Spam / Misleading Content", selected: false));
    sampleData.add(CustomRowModel(title: "Infringement", selected: false));
    sampleData.add(CustomRowModel(
        title: "Sexually Explicit Image or Content", selected: false));
    sampleData.add(
        CustomRowModel(title: "Hateful / Abusive Content", selected: false));
    sampleData.add(CustomRowModel(title: "Other", selected: false));
  }

  @override
  Widget build(BuildContext context) {
    return sampleData.length == 0
        ? Container()
        : Container(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: sampleData.length,
              itemBuilder: (BuildContext context, int index) {
                return new InkWell(
                  //highlightColor: Colors.red,
                  //splashColor: Colors.blueAccent,
                  onTap: () {
                    setState(() {
                      sampleData.forEach((element) => element.selected = false);
                      sampleData[index].selected = true;
                      problem = sampleData[index].title;
                    });
                  },
                  child: new CustomRow(sampleData[index]),
                );
              },
            ),
          );
  }
}
