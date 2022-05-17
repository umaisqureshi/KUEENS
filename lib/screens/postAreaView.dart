import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kueens/model/discountModel.dart';
import 'package:kueens/utils/app_colors.dart';

class PosAreaView extends StatefulWidget {
  @override
  _PosAreaViewState createState() => _PosAreaViewState();
}

class _PosAreaViewState extends State<PosAreaView> {


  @override
  Widget build(BuildContext context) {
    return Container(
        height: double.infinity,
        width: double.infinity,
        child: ListView(
          children: [

          ],
        ));
  }
}
