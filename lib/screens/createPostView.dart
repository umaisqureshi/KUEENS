import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kueens/model/discountModel.dart';
import 'package:kueens/utils/app_colors.dart';

class CreatePostView extends StatefulWidget {
  final DiscountModel discountModel;
  CreatePostView({this.discountModel});

  @override
  _CreatePostViewState createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  final offerController = TextEditingController();

  File _imageFile;

  bool weeklySpecial = false;
  bool newArrivals = false;
  bool discountType = false;
  int _radioValue1 = -1;
  int _radioValue2 = -2;

  String discount;
  List<String> discountPercent = [
    '10 %',
    '20 %',
    '30 %',
    '40 %',
    '50 %',
    '60 %',
    '70 %',
  ];

  void _handleRadioValueChange1(int value) {
    setState(() {
      _radioValue1 = value;
    });
  }

  void _handleRadioValueChange2(int value) {
    setState(() {
      _radioValue2 = value;
    });
  }

  Future<void> pickImage() async {
    File file = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      _imageFile = file;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: double.infinity,
        width: double.infinity,
        child: ListView(
          children: [
            Container(
              height: 200,
              color: Colors.grey[300],
              child: _imageFile != null
                  ? Image.file(
                      _imageFile,
                      fit: BoxFit.fill,
                    )
                  : Center(
                      child: ButtonTheme(
                          height: 45,
                          minWidth: MediaQuery.of(context).size.width / 2,
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            onPressed: () async {
                              pickImage();
                            },
                            color: Colors.transparent,
                            child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                                child: ClipRect(
                                  child: new Stack(
                                    children: [
                                      new Positioned(
                                        top: 2.0,
                                        left: 2.0,
                                        child: new Text(
                                          "+ Add Poster",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black
                                                  .withOpacity(0.5)),
                                        ),
                                      ),
                                      new BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 2.0, sigmaY: 2.0),
                                        child: Text(
                                          "+ Add Poster",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          )),
                    ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Row(
                  children: [
                    Flexible(
                      child: DropdownButton(
                        items: discountPercent
                            .map((value) => DropdownMenuItem(
                                  child: Text(value),
                                  value: value,
                                ))
                            .toList(),
                        onChanged: (String value) {
                          setState(() {
                            discount = value;
                          });
                        },
                        hint: Text("Discount"),
                        isExpanded: true,
                        value: discount,
                        iconEnabledColor: Color.fromRGBO(20, 20, 20, 0.7),
                      ),
                    ),
                    Row(
                      children: [
                        Radio(
                          value: 0,
                          groupValue: _radioValue2,
                          onChanged: _handleRadioValueChange2,
                        ),
                        new Text(
                          'UpTo',
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        new Radio(
                          value: 1,
                          groupValue: _radioValue2,
                          onChanged: _handleRadioValueChange2,
                        ),
                        new Text(
                          'Flat',
                          style: new TextStyle(
                            fontSize: 16.0,
                          ),
                        )
                      ],
                    ),
                  ],
                )),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Text(
                "Description",
                style:
                    TextStyle(color: Theme.of(context).hintColor, fontSize: 12),
              ),
            ),
            SizedBox(
              height: 3,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
              child: TextFormField(
                controller: offerController,
                validator: (input) {
                  if (input.isEmpty)
                    return "Required Field";
                  else
                    return null;
                },
                maxLines: 10,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 16, top: 15),
                    border: new OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    fillColor: Colors.grey[300],
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    hintText: "Enter Offer Description"),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Radio(
                        value: 0,
                        groupValue: _radioValue1,
                        onChanged: _handleRadioValueChange1,
                      ),
                      new Text(
                        'Weekly Special',
                        style: new TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      new Radio(
                        value: 1,
                        groupValue: _radioValue1,
                        onChanged: _handleRadioValueChange1,
                      ),
                      new Text(
                        'New Arrival',
                        style: new TextStyle(
                          fontSize: 16.0,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      new Radio(
                        value: 2,
                        groupValue: _radioValue1,
                        onChanged: _handleRadioValueChange1,
                      ),
                      new Text(
                        'Special Offer',
                        style: new TextStyle(
                          fontSize: 16.0,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: ButtonTheme(
                  height: 45,
                  minWidth: MediaQuery.of(context).size.width,
                  child: RaisedButton(
                    elevation: 10.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    onPressed: () async {
                      Navigator.of(context).pop(DiscountModel(
                          discount: discount,
                          discountDesc: offerController.text,
                          discountType: _radioValue2,
                          offerType: _radioValue1,
                          image: _imageFile));
                    },
                    color: AppColors.primaryColor,
                    child: Text(
                      "Done",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  )),
            ),
          ],
        ));
  }
}
