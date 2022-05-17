import 'package:flutter/material.dart';

class SubscriptionDealCard extends StatelessWidget {
  static const String subscriptionDealCardScreenRoute = "SubscriptionDealCard";

  SubscriptionDealCard({
    this.price,
    this.duration,
    this.isVisible,
    this.plan,
  });

  final String duration;
  final String price;
  final bool isVisible;
  final String plan;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Visibility(
            visible: isVisible,
            child: Container(
              height: 130,
              width: MediaQuery.of(context).size.width/3.1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                border: Border.all(
                  color: Color(0xff7D2C91),
                  width: 2,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 130,
            width: MediaQuery.of(context).size.width/3.1,
            child: Card(
              elevation: 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    duration,
                    style: TextStyle(
                      color: Color(0xff7D2C91),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "months",
                    style: TextStyle(
                      color: Color(0xff7D2C91),
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    "$price",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: isVisible,
            child: Positioned(
              top: 8,
              left: 10,
              right: 10,
              child: Container(
                height: 35,
                width: 50,
                decoration: BoxDecoration(
                  color: Color(0xff7D2C91),
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Color(0xff7D2C91),
                      Colors.deepPurple,
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    plan,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
