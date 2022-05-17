import 'package:flutter/material.dart';
import 'dart:io';

class DiscountModel {
  dynamic image;
  String discount, discountDesc;
  int discountType, offerType;

  DiscountModel(
      {this.discount,
      this.discountDesc,
      this.discountType,
      this.image,
      this.offerType});
}
