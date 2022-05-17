import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kueens/geo_firestore/geo_firestore.dart';
import 'package:kueens/model/address.dart';
import 'package:kueens/model/discountModel.dart';
import 'package:kueens/model/priceDropDownItemModel.dart';
import 'package:kueens/model/videoModel.dart';
import 'package:kueens/repo/settingRepo.dart';
import 'package:kueens/fragments/crearePostFragment.dart';
import 'package:kueens/fragments/trimmerModel.dart';
import 'package:kueens/subDialog/anotherDialog.dart';
import 'package:kueens/utils/app_colors.dart';
import 'package:kueens/utils/firebase_credentials.dart';
import 'package:kueens/widgets/progress-indicator.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:smart_select/smart_select.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:video_trimmer/video_trimmer.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:kueens/utils/appData.dart';

class CreatePost extends StatefulWidget {
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final constant = 1000;
  final secondsInWeek = 604800;

  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();
  final tagController = TextEditingController();
  FocusNode myFocusNode = FocusNode();

  String offerController = 'Create new offer';
  DiscountModel discountModel;
  PersistentBottomSheetController bottomController;
  var uuid = Uuid();
  var pid;
  List<Asset> images = [];
  List<VideoModel> videoList = [];
  List<String> videoUrl = [];
  int videoIndex = 0;
  String _error = 'No Error Detected';

  bool _loader = false;
  String posterUrl = '';
  String videoResult;
  var initialPrice = '50';
  String _selectedCategoryValue = 'C&B';
  String _selectedCategoryTitle = 'Cooking & Baking';

  List<S2Choice<String>> chooseCategories = [
    S2Choice<String>(value: 'C&B', title: 'Cooking & Baking'),
    S2Choice<String>(value: 'HB', title: 'Home Boutique'),
    S2Choice<String>(value: 'SKT', title: 'Stitching/ Knitting/ Tailoring'),
    S2Choice<String>(value: 'FJ', title: 'Fashion Jewellers'),
    S2Choice<String>(value: 'MHH', title: 'Make-Up/Hair/Henna Artist'),
    S2Choice<String>(value: 'A&P', title: 'Artist & Painters'),
    S2Choice<String>(value: 'HF', title: 'Home Decor & Furnishing'),
    S2Choice<String>(value: 'G', title: 'Grocers'),
    S2Choice<String>(value: 'F&V', title: 'Fruits & Vegetables'),
    S2Choice<String>(value: 'HA', title: 'HouseHold Appliances'),
    S2Choice<String>(value: 'C&D', title: 'Child Care & Domestic Help'),
    S2Choice<String>(value: 'G&H', title: 'Gardening Tips & Help'),
    S2Choice<String>(value: 'HT', title: 'Home Tutors'),
    S2Choice<String>(value: 'PC', title: 'Pet Supply/ Care'),
    S2Choice<String>(value: 'O', title: 'Other')
  ];
  int _selectedId = 0;
  double _selectedRadius = 10;
  List<PriceDropDownItemModel> price = [];
  List<File> _files;
  List<String> urls = [];
  int index = 0;
  DocumentSnapshot interest;
  Address address;
  bool isImageListEmpty = false;
  List<String> selected = [];

  bool weeklySpecial = false;
  bool newArrivals = false;

  ImagePicker imagePicker = new ImagePicker();
  Trimmer trimmer = new Trimmer();
  String token = '';

  @override
  void initState() {
    super.initState();
    price.add(PriceDropDownItemModel(
        price: 'Other price',
        color: Colors.black,
        textStyle: FontWeight.normal));
    price.add(PriceDropDownItemModel(
        price: '50', color: Colors.black, textStyle: FontWeight.normal));
    price.add(PriceDropDownItemModel(
        price: '100', color: Colors.black, textStyle: FontWeight.normal));
    price.add(PriceDropDownItemModel(
        price: '150', color: Colors.black, textStyle: FontWeight.normal));
    price.add(PriceDropDownItemModel(
        price: '250', color: Colors.black, textStyle: FontWeight.normal));
    price.add(PriceDropDownItemModel(
        price: '300', color: Colors.black, textStyle: FontWeight.normal));
    pid = uuid.v1();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        location();
        getToken().then((value) => setState(() => token = value));

        myFocusNode.addListener(() async {
          print("Focus: " + myFocusNode.hasFocus.toString());
          if (myFocusNode.hasFocus) {
            await Future.delayed(Duration(milliseconds: 500));
            _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: Duration(milliseconds: 500),
                curve: Curves.ease);
          }
        });
      }
    });
  }

  Future<String> getToken() async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('token').doc('admin').get();
    return snapshot.data()['token'];
  }

  location() async {
    await getCurrentLocation().then((value) async {
      if (value.isUnknown()) {
        await setCurrentLocation().then((value) {
          setState(() {
            this.address = value;
          });
        });
      } else {
        setState(() {
          this.address = value;
        });
      }
    });
  }

  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Post"),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: AnimationLimiter(
            child: AnimationConfiguration.staggeredList(
              duration: Duration(milliseconds: 370),
              position: 10,
              child: ScaleAnimation(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Text(
                            "Name",
                            style: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontSize: 12),
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        TextFormField(
                          controller: titleController,
                          validator: (input) {
                            if (input.isEmpty)
                              return "Required Field";
                            else
                              return null;
                          },
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(left: 16, top: 10),
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
                              hintText: "Enter product name"),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Text(
                                "Choose Category",
                                style: TextStyle(
                                    color: Theme.of(context).hintColor,
                                    fontSize: 12),
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: chooseCategory(),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Text(
                                "Set Price",
                                style: TextStyle(
                                    color: Theme.of(context).hintColor,
                                    fontSize: 12),
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Container(
                              /* width:
                                      (MediaQuery.of(context).size.width - 20) /
                                          2.5,*/
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    isExpanded: true,
                                    value: initialPrice,
                                    onChanged: (newValue) async {
                                      if (newValue == 'Other price') {
                                        TextEditingController c =
                                            TextEditingController();
                                        var result = await showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                title: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Text("What's your Price"),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: 10),
                                                      child: TextField(
                                                        controller: c
                                                          ..text = '',
                                                        keyboardType:
                                                            TextInputType.phone,
                                                        decoration:
                                                            InputDecoration(
                                                                contentPadding:
                                                                    EdgeInsets.only(
                                                                        left:
                                                                            16,
                                                                        top:
                                                                            10),
                                                                fillColor:
                                                                    Colors.grey[
                                                                        300],
                                                                filled: true,
                                                                border:
                                                                    new OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                ),
                                                                enabledBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              10.0)),
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .transparent,
                                                                      width: 2),
                                                                ),
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              10.0)),
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              Colors.transparent),
                                                                ),
                                                                hintText:
                                                                    "Enter product price"),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10),
                                                      child: ButtonTheme(
                                                        minWidth: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2,
                                                        height: 45,
                                                        child: RaisedButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop(c.text
                                                                    .trim());
                                                          },
                                                          child: Text(
                                                            "Done",
                                                            style: TextStyle(
                                                              fontSize: 17,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          color: AppColors
                                                              .primaryColor,
                                                          elevation: 10.0,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                new BorderRadius
                                                                        .circular(
                                                                    25.0),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });
                                        setState(() {
                                          if (result == '' || result == null) {
                                            initialPrice = '50';
                                          } else {
                                            if (price.length > 6) {
                                              price.removeAt(6);
                                            }
                                            if (!(price
                                                    .where((element) =>
                                                        element.price == result)
                                                    .length >
                                                0)) {
                                              price.add(PriceDropDownItemModel(
                                                  price: result,
                                                  color: AppColors.primaryColor,
                                                  textStyle: FontWeight.bold));
                                            }
                                            initialPrice = result;
                                          }
                                        });
                                      } else {
                                        setState(() {
                                          initialPrice = newValue;
                                        });
                                      }
                                    },
                                    items: price.map((location) {
                                      return DropdownMenuItem<String>(
                                        child: new Text(
                                          location.price,
                                          style: TextStyle(
                                              color: location.color,
                                              fontWeight: location.textStyle),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        value: location.price,
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Text(
                            "Make an Offer",
                            style: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontSize: 12),
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        GestureDetector(
                          onTap: () async {
                            var result = await Navigator.of(context)
                                .push(CreatePostFragment(discountModel: null));
                            setState(() {
                              this.discountModel = result;
                              print('${discountModel.offerType}');
                            });
                          },
                          child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[300],
                              ),
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    offerController,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Icon(Icons.arrow_drop_down,
                                      color: Theme.of(context).hintColor)
                                ],
                              )),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Text(
                            "Description",
                            style: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontSize: 12),
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        TextFormField(
                          controller: descController,
                          validator: (input) {
                            if (input.isEmpty)
                              return "Required Field";
                            else
                              return null;
                          },
                          maxLines: 10,
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
                              hintText:
                                  "Enter details about your Product / Services"),
                        ),
                        SizedBox(height: 15),
                        Container(
                          height: 120,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: isImageListEmpty
                                    ? Theme.of(context).errorColor
                                    : Colors.grey[300]),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: loadAssets,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 5),
                                  child: Container(
                                    height: 120,
                                    width: 90,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10))),
                                    child: Center(
                                      child: Icon(
                                          Icons.add_photo_alternate_outlined),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(child: buildGridView()),
                            ],
                          ),
                        ),
                        Visibility(
                            visible: isImageListEmpty,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'At least image is required',
                                style: TextStyle(
                                    fontSize: 12.5,
                                    color: Theme.of(context).errorColor),
                              ),
                            )),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          height: 120,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () async {
                                  PickedFile videoFile = await imagePicker
                                      .getVideo(source: ImageSource.gallery);
                                  if (videoFile != null) {
                                    await trimmer.loadVideo(
                                        videoFile: File(videoFile.path));
                                    videoResult = await Navigator.of(context)
                                        .push(TrimmerModel(trimmer));
                                    final uint8list =
                                        await VideoThumbnail.thumbnailData(
                                      video: videoResult,
                                      imageFormat: ImageFormat.JPEG,
                                      maxHeight: 300,
                                      maxWidth: 300,
                                      // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
                                      quality: 30,
                                    );
                                    setState(() {
                                      videoList.add(VideoModel(
                                          path: videoResult,
                                          thumbnail: uint8list,
                                          isFile: false));
                                    });
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(right: 5),
                                  child: Container(
                                    height: 120,
                                    width: 90,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10))),
                                    child: Center(
                                      child: Icon(Icons.video_library_outlined),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(child: videoPickListView()),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Text(
                            "# Tags",
                            style: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontSize: 12),
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        TextField(
                          controller: tagController,
                          keyboardType: TextInputType.name,
                          focusNode: myFocusNode,
                          textInputAction: TextInputAction.next,
                          onSubmitted: (value) {
                            setState(() {
                              selected.add('#$value');
                              tagController.text = '';
                            });
                            tagController.clear();
                            myFocusNode.requestFocus();
                          },
                          onChanged: (value) {
                            print(
                                'scroll pixel ${_scrollController.position.pixels} ${_scrollController.position.maxScrollExtent}');
                            if (_scrollController.position.pixels ==
                                _scrollController.position.maxScrollExtent) {}
                          },
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(left: 16, top: 10),
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
                              hintText: "Enter Tags"),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        selected.length < 1
                            ? Container()
                            : Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Wrap(
                                    spacing: 5,
                                    runSpacing: 5,
                                    children: selected.map((s) {
                                      return Chip(
                                          backgroundColor:
                                              AppColors.primaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          deleteIconColor: Colors.white,
                                          label: Text(s,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16)),
                                          onDeleted: () {
                                            setState(() {
                                              selected.remove(s);
                                            });
                                          });
                                    }).toList()),
                              ),
                        !_loader
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: MaterialButton(
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
                                      "Post",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      if (appData.isPro) {
                                        setState(() {
                                          _loader = true;
                                        });
                                        uploadPost();
                                      } else {
                                        var sub = await showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AnotherDialog();
                                            });
                                        if (sub) {
                                          setState(() {
                                            _loader = true;
                                          });
                                          uploadPost();
                                        }
                                      }
                                    } else {
                                      setState(() {
                                        if (images.length == 0) {
                                          isImageListEmpty = true;
                                        }
                                        _loader = false;
                                      });
                                    }
                                  },
                                ),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: ProgressIndicatorWidget(),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )),
    );
  }

  Widget buildGridView() {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, right: 4.0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        primary: true,
        shrinkWrap: true,
        children: List.generate(images.length, (index) {
          Asset asset = images[index];
          return Padding(
            padding: EdgeInsets.only(left: 5),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: AssetThumb(
                    asset: images[index],
                    width: 300,
                    height: 300,
                  ),
                ),
                Positioned(
                  top: 1,
                  right: 1,
                  child: InkWell(
                      onTap: () {
                        images.remove(asset);
                        setState(() {});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.white),
                        child: Icon(
                          Icons.close,
                          size: 20,
                          color: Colors.black,
                        ),
                      )),
                )
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget videoPickListView() {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, right: 4.0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        primary: true,
        shrinkWrap: true,
        children: List.generate(videoList.length, (index) {
          //Asset asset = images[index];
          return Padding(
            padding: EdgeInsets.only(left: 5),
            child: Stack(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.memory(videoList[index].thumbnail)),
                Positioned(
                  top: 1,
                  right: 1,
                  child: InkWell(
                      onTap: () {
                        videoList.removeAt(index);
                        setState(() {});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.white),
                        child: Icon(
                          Icons.close,
                          size: 20,
                          color: Colors.black,
                        ),
                      )),
                )
              ],
            ),
          );
        }),
      ),
    );
  }

  uploadImage(File image) async {
    var reference = FirebaseStorage.instance
        .ref()
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
    /*File compressedImage;
    Uint8List list = await FlutterImageCompress.compressWithFile(image.path, quality: 25,);
    compressedImage = File.fromRawPath(list);*/

    //print("Compressed Image : ${compressedImage.lengthSync()}");

    final filePath = image.absolute.path;

    print("FilePath : $filePath");

    // Create output file path
    // eg:- "Volume/VM/abcd_out.jpeg"

    final lastIndex = filePath.lastIndexOf(new RegExp(r'.pn'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";

    print("OutPath : $outPath");

    final compressedImage = await FlutterImageCompress.compressAndGetFile(
        filePath, outPath,
        minWidth: 1000,
        minHeight: 1000,
        quality: 70,
        format: CompressFormat.png);

    StorageUploadTask uploadTask = reference.putFile(compressedImage);
    (await uploadTask.onComplete).ref.getDownloadURL().then((value) async {
      setState(() {
        urls.add(value);
        index++;
      });
      if (index == _files.length) {
        if (discountModel != null) {
          posterUrl = await uploadPoster();
          setState(() {});
        }
        await FirebaseCredentials().db.collection('OfflinePost').add({
          'id': FirebaseCredentials().auth.currentUser.uid,
          /*'timestamp':
              discountModel.offerType != null && discountModel.offerType == 0
                  ? DateTime.now().millisecondsSinceEpoch + constant * secondsInWeek
                  : DateTime.now().millisecondsSinceEpoch,*/
          'createdAt': FieldValue.serverTimestamp(),
          'title': titleController.text,
          'desc': descController.text,
          'price': initialPrice,
          'category': _selectedCategoryTitle,
          'images': urls,
          'isFav': false,
          'videoUrl': videoUrl.isEmpty ? [] : videoUrl,
          'rating': '0.0',
          'productId': pid.toString(),
          'address': address.address,
          'inStock': true,
          'status': 'pending',
          'offer': discountModel == null
              ? null
              : {
                  'image': posterUrl ?? null,
                  'discount': discountModel.discount ?? null,
                  'discountDesc': discountModel.discountDesc ?? null,
                  'discountType': discountModel.discountType ?? null,
                  'offerType': discountModel.offerType ?? null
                },
          'tags': selected
        }).then((DocumentReference value) {
          GeoFirestore geoFirestore =
              GeoFirestore(FirebaseCredentials().db.collection('OfflinePost'));
          geoFirestore
              .setLocation(
                  value.id, GeoPoint(address.latitude, address.longitude))
              .then((v) async {
            await callOnFcmApiSendPushNotifications(
                token, value.id, FirebaseCredentials().auth.currentUser.uid);
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("Post Approval"),
                content: Text(
                    "We screen everything to keep suspicious and malvertisers out of the Kueens Castle.\n\nPlease bear with us as it may take up to 24 hours for approval."),
                actions: [
                  FlatButton(
                    padding: EdgeInsets.all(8.0),
                    onPressed: () => clearScreen(),
                    child: Text("Ok"),
                  ),
                ],
              ),
            );
          });
        });
      } else {
        uploadImage(_files[index]);
      }
    });
  }

  clearScreen() {
    setState(() {
      index = 0;
      videoIndex = 0;
      _loader = false;
      titleController.clear();
      descController.clear();
      images.clear();
      urls.clear();
      videoList.clear();
      videoUrl.clear();
      discountModel = null;
    });
    Navigator.of(context).pop();
  }

  void uploadPost() async {
    if (images.length != 0) {
      if (videoList.isEmpty) {
        //dialog();
        uploadImage(_files[0]);
      } else {
        //dialog();
        uploadVideo(File(videoList[0].path));
      }
    } else
      setState(() {
        isImageListEmpty = true;
        _loader = false;
      });
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    List<File> files = [];
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 5,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "camera"),
        materialOptions: MaterialOptions(
          actionBarColor: "#7D2C91",
          actionBarTitle: "Kueens App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
      for (Asset asset in resultList) {
        final filePath =
            await FlutterAbsolutePath.getAbsolutePath(asset.identifier);
        files.add(File(filePath));
      }
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;
    setState(() {
      images = resultList;
      _files = files;
      _error = error;
      print(_error);
    });
  }

  uploadVideo(video) async {
    var reference = FirebaseStorage.instance
        .ref()
        .child('${DateTime.now().millisecondsSinceEpoch}.mp4');
    StorageUploadTask uploadTask = reference.putFile(video);
    (await uploadTask.onComplete).ref.getDownloadURL().then((value) async {
      setState(() {
        videoUrl.add(value);
        videoIndex++;
      });
      if (videoIndex == videoList.length) {
        uploadImage(_files[0]);
      } else {
        uploadVideo(File(videoList[videoIndex].path));
      }
    });
  }

  chooseCategory() {
    return SmartSelect<String>.single(
      title: 'Choose Category',
      value: _selectedCategoryValue,
      choiceItems: chooseCategories,
      onChange: (state) => setState(() {
        _selectedCategoryValue = state.value;
        _selectedCategoryTitle = state.valueTitle;
      }),
      modalType: S2ModalType.bottomSheet,
      tileBuilder: (context, state) {
        return S2Tile.fromState(
          state,
          hideValue: true,
          trailing: Icon(
            Icons.arrow_drop_down,
            color: Theme.of(context).hintColor,
          ),
          padding: EdgeInsets.all(0.0),
          title: Text(_selectedCategoryTitle),
        );
      },
    );
  }

  void _onValueChange(value, radius) {
    setState(() {
      _selectedId = value;
      _selectedRadius = radius;
      print('_selectedId ${_selectedId} _selectedRadius ${_selectedRadius}');
    });
  }

  Future uploadPoster() async {
    StorageReference reference = FirebaseStorage.instance
        .ref()
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
    StorageUploadTask uploadTask = reference.putFile(discountModel.image);
    return await (await uploadTask.onComplete).ref.getDownloadURL();
  }

  callOnFcmApiSendPushNotifications(userToken, postId, userId) async {
    final postUrl = 'https://fcm.googleapis.com/fcm/send';

    final data = {
      "notification": {
        "body": "You have a new post to review",
        "title": "New Post Alert"
      },
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "postId": "$postId",
        "uid": "$userId",
        "status": "done"
      },
      "to": "$userToken"
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization':
          'key=AAAAHuEhiq4:APA91bHlA3O7r_rlF7KrTCDLb86TK3-gW95JpKE0xEVUDp3Pxt7TRxV74CfcV59Gpm8pMvzN9XTOpLX6zOHLCZ26iH0ioojGbMktUCY_aAkDJHR6M4DNGm1jeofk6rGImyG1gPAhGna4'
      // 'key=YOUR_SERVER_KEY'
    };

    try {
      final response = await post(postUrl,
          body: json.encode(data),
          encoding: Encoding.getByName('utf-8'),
          headers: headers);

      if (response.statusCode == 200) {
        print('CFM Succeed');
        return true;
      } else {
        print(response.body);
        return false;
      }
    } catch (e) {
      print(e.message);
    }
  }
}

class MyDialog extends StatefulWidget {
  const MyDialog({this.onValueChange, this.initialValue, this.initialRadius});

  final int initialValue;
  final double initialRadius;
  final void Function(dynamic, dynamic) onValueChange;

  @override
  State createState() => new MyDialogState();
}

class MyDialogState extends State<MyDialog> {
  int _selectedId;
  double _selectedRadius;
  bool openRadiusTab = false;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.initialValue;
    _selectedRadius = widget.initialRadius;
  }

  @override
  Widget build(BuildContext context) {
    return new SimpleDialog(
      title: new Text("Confirm your Maximum Distance"),
      children: <Widget>[
        _myRadioButton(
          title: "Domestic",
          value: 0,
          onChanged: (newValue) {
            setState(() {
              openRadiusTab = false;
              _selectedId = newValue;
            });
            widget.onValueChange(newValue, _selectedRadius);
          },
        ),
        _myRadioButton(
          title: "International",
          value: 1,
          onChanged: (newValue) {
            setState(() {
              openRadiusTab = false;
              _selectedId = newValue;
            });
            widget.onValueChange(newValue, _selectedRadius);
          },
        ),
        _myRadioButton(
          title: "Radius",
          value: 2,
          onChanged: (newValue) {
            setState(() {
              openRadiusTab = true;
              _selectedId = newValue;
            });
            widget.onValueChange(newValue, _selectedRadius);
          },
        ),
        Visibility(
          visible: openRadiusTab,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: _mySlider(
              value: _selectedRadius,
              onChanged: (double newValue) {
                setState(() {
                  _selectedRadius = newValue.roundToDouble();
                });
                widget.onValueChange(_selectedId, _selectedRadius);
              },
            ),
          ),
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  'cancel',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  'ok',
                  style: TextStyle(color: Colors.blue),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _myRadioButton({String title, int value, Function onChanged}) {
    return RadioListTile(
      value: value,
      groupValue: _selectedId,
      onChanged: onChanged,
      title: Text(title),
    );
  }

  Widget _mySlider({double value, Function onChanged}) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Text('${value.toString()} Kms'),
        CupertinoSlider(
            value: value, min: 10.0, max: 50.0, onChanged: onChanged),
      ],
    );
  }
}
