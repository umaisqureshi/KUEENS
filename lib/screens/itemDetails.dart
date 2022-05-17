import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kueens/fragments/shopInfoModel.dart';
import 'package:kueens/utils/app_colors.dart';
import 'package:kueens/utils/firebase_credentials.dart';
import 'package:kueens/utils/helper.dart';
import 'package:kueens/widgets/detailCardWidget.dart';
import 'package:kueens/widgets/moreItemsWidget.dart';
import 'package:kueens/widgets/similarItemWidget.dart';
import 'package:kueens/widgets/sliderWidget.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

extension ListUtil<T> on List<T> {
  num sumBy(num f(T element)) {
    num sum = 0;
    for (var item in this) {
      sum += f(item);
    }
    return sum;
  }
}

String selectedProblem;

class ItemDetail extends StatefulWidget {
  final DocumentSnapshot snaps;

  ItemDetail({this.snaps});

  @override
  _ItemDetailState createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  String selectedProblem = '';
  var rating = 0.0;
  bool isFav = false;
  var reviews;
  bool giveReview = false;
  bool isUpdate = false;
  final reviewController = TextEditingController();
  var newRating = '0';
  List<double> sum = new List<double>();
  String shopLogo = 'default';
  String shopName = "default";
  String ownerName = "default";
  String shopDesc = "default";

  var shopItem = <QueryDocumentSnapshot>[];
  var shopItemSemilar = <QueryDocumentSnapshot>[];

  @override
  void initState() {
    super.initState();
    reviewDataSize();
    getShop();
    fetchShopItem(widget.snaps.data()['id']);
    fetchShop(widget.snaps.data()['category']);
  }

  reviewDataSize() async {
    setState(() {
      newRating = widget.snaps.data()['rating'];
    });
    FirebaseCredentials()
        .db
        .collection('Post')
        .doc(widget.snaps.id)
        .snapshots()
        .listen((event) {
      if (mounted) {
        setState(() {
          if (event.exists) {
            if (event.data().containsKey('feedback')) {
              event.data()['feedback'].forEach((e) {
                sum.add(double.parse(e['rating']));
              });
              sum.forEach((element) {
                print(element.toString());
              });
              var avgRating = sum.sumBy((num) => num) ?? 0.0;
              var reviewSize = sum.length ?? 0;
              print('$avgRating $reviewSize');
              newRating = ((avgRating) / (reviewSize > 0 ? reviewSize : 1))
                  .toStringAsFixed(1);
              print((newRating).toString());
              sum.clear();
              FirebaseCredentials()
                  .db
                  .collection('Post')
                  .doc(widget.snaps.id)
                  .update({'rating': newRating});
            }
          }
        });
      }
    });
  }

  getShop() async {
    FirebaseCredentials()
        .db
        .collection('User')
        .doc(widget.snaps.data()['id'])
        .get()
        .then((value) {
      if (value.data().containsKey('shopData')) {
        setState(() {
          shopLogo = value.data()['shopData']['shopLogo'];
          shopName = value.data()['shopData']['shopName'];
          ownerName = value.data()['shopData']['shopOwnerName'];
          shopDesc = value.data()['shopData']['shopDesc'];
        });
      }
    });
  }

  Future<List<QueryDocumentSnapshot>> fetchShopItem(id) async {
    var post = await FirebaseCredentials()
        .db
        .collection('Post')
        .where('id', isEqualTo: id)
        .get();
    post.docs.forEach((element) {
      shopItem.add(element);
      setState(() {});
    });
    return shopItem;
  }

  Future<List<QueryDocumentSnapshot>> fetchShop(category) async {
    print('cats $category');
    var post = await FirebaseCredentials()
        .db
        .collection('User')
        .where('interest', arrayContains: [category]).get();
    post.docs.forEach((element) {
      shopItemSemilar.add(element);
      setState(() {});
    });
    return shopItemSemilar;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                    backgroundColor: AppColors.primaryColor,
                    child: shopLogo != 'default'
                        ? Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      shopLogo,
                                    ))))
                        : FlutterLogo()),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.snaps.data()['title'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(
                        height: 3.0,
                      ),
                      /*Text(
                        "12,126 Views",
                        style: TextStyle(color: Theme.of(context).hintColor),
                      )*/
                    ],
                  ),
                ),
                Flexible(child: Container()),
                Center(
                  child: Row(
                    children: Helper.getStarsList(double.parse(newRating)),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Container(
              height: 250,
              color: Colors.grey,
              child: SliderWidget(widget.snaps.data()['images'], isFav),
            ),
          ),
          DetailCardWidget(
            snaps: widget.snaps,
          ),
          Container(
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
            child: giveReview
                ? Center(
                    child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: 'Thanks for your Feedback',
                          style: TextStyle(color: Colors.black, fontSize: 20),
                          children: [
                            TextSpan(
                                text: ' (update)',
                                style:
                                    TextStyle(fontSize: 20, color: Colors.blue),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    setState(() {
                                      giveReview = false;
                                      isUpdate = true;
                                    });
                                  })
                          ]),
                    ])),
                  ))
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Text(
                            "Rate my Product",
                            style: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontSize: 12),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          maxLines: 3,
                          controller: reviewController,
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(left: 16, top: 15),
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
                              hintText: "Your Review"),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: SmoothStarRating(
                              allowHalfRating: true,
                              onRated: (v) {
                                setState(() {
                                  rating = v;
                                });
                              },
                              starCount: 5,
                              rating: rating,
                              size: 40.0,
                              isReadOnly: false,
                              filledIconData: Icons.star,
                              halfFilledIconData: Icons.star_half,
                              color: Color(0xFFFFB24D),
                              borderColor: Color(0xFFFFB24D),
                              spacing: 0.0),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: OutlineButton(
                            shape: StadiumBorder(),
                            textColor: AppColors.primaryColor,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Submit'),
                            ),
                            borderSide: BorderSide(
                                color: AppColors.primaryColor,
                                style: BorderStyle.solid,
                                width: 1),
                            onPressed: () {
                              if (rating > 0.0) {
                                User user =
                                    FirebaseCredentials().auth.currentUser;
                                FirebaseCredentials()
                                    .db
                                    .collection('Post')
                                    .doc(widget.snaps.id)
                                    .update({
                                  'feedback': FieldValue.arrayUnion([
                                    {
                                      'name': user.displayName,
                                      'userImg': user.photoURL,
                                      'userId': user.uid,
                                      'rating': rating.toStringAsFixed(1),
                                      'review': reviewController.text,
                                      'time':
                                          DateTime.now().millisecondsSinceEpoch
                                    }
                                  ])
                                },).then((value) {
                                  setState(() {
                                    giveReview = true;
                                  });
                                });
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      child: dialogContent(context, widget.snaps.id),
                                    );
                                  });
                            },
                            child: Text(
                              "REPORT THIS AD",
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    )),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text(
              'More Items from this Kueens Castle',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          MoreItemsWidget(shopItem: shopItem),
          Container(
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Made by ${ownerName}'),
                    SizedBox(
                      height: 5,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: CachedNetworkImage(
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                        imageUrl: shopLogo,
                        placeholder: (context, url) => Image.asset(
                          'assets/images/loading.gif',
                          fit: BoxFit.cover,
                          height: 100,
                          width: 100,
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/images/loading.gif',
                          fit: BoxFit.cover,
                          height: 100,
                          width: 100,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      shopName,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Text(
                        shopDesc,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    OutlineButton(
                      shape: StadiumBorder(),
                      textColor: AppColors.primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('View Kueens Castle'),
                      ),
                      borderSide: BorderSide(
                          color: AppColors.primaryColor,
                          style: BorderStyle.solid,
                          width: 1),
                      onPressed: () {
                        Navigator.of(context)
                            .push(ShopInfoModel(widget.snaps.data()['id']));
                      },
                    )
                  ],
                )),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text(
              'Similar Kueens Castle',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
          ),
          Container(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: shopItemSemilar
                    .map((e) => SimilarItemsWidget(queryDocumentSnapshot: e))
                    .toList(),
              ),
            ),
          )
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
          Expanded(child: Text(
            '${model.title}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15,
            ),
          ),)

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
            'Item Report',
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
                onTap: ()async{
                  DocumentReference reportIt = FirebaseFirestore.instance.collection("ReportedAds").doc();
                  final snackBar = SnackBar(
                    content: Text("We'll be taking care of it as soon as possible.", style: TextStyle(color: Colors.white),),
                    padding: EdgeInsets.all(16.0),
                    elevation: 6,
                    duration: Duration(seconds: 3),
                    action: SnackBarAction(
                      label: 'Undo',
                      textColor: Colors.white,
                      onPressed: () async{
                        FirebaseFirestore.instance.collection("ReportedAds").doc(reportIt.id).delete();
                      },
                    ),
                  );
                  reportIt.set({
                    "id" : reportIt.id,
                    "postId" : postId,
                    "comment" : comment.text,
                    "problem" : selectedProblem,
                  }, SetOptions(merge: true)).then((value){
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
    sampleData.add(CustomRowModel(title: "Duplicate Advertisement", selected: false));
    sampleData
        .add(CustomRowModel(title: "Product Already Sold", selected: false));
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
                      selectedProblem = sampleData[index].title;
                    });
                  },
                  child: new CustomRow(sampleData[index]),
                );
              },
            ),
          );
  }
}
