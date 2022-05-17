import 'dart:async';
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kueens/geo_firestore/geo_firestore.dart';
import 'package:kueens/geo_firestore/geo_utils.dart';
import 'package:kueens/repo/settingRepo.dart';
import 'package:kueens/utils/app_colors.dart';
import 'package:kueens/utils/firebase_credentials.dart';
import 'package:flutter/material.dart';
import 'package:kueens/utils/helper.dart';
import 'package:kueens/screens/drawer.dart';
import 'dart:math' as math;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:numberpicker/numberpicker.dart';

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  Set<Marker> _markers = Set<Marker>();
  int radius;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  CameraUpdate cameraUpdate;
  GoogleMapController mapController;
  Set<Circle> circles;
  NumberPicker integerInfiniteNumberPicker;
  NumberPicker decimalNumberPicker;

  getLoc(BuildContext context) async {
    await getCurrentLocation().then((value) async {
      if (!value.isUnknown()) {
        circles = Set.from([
          Circle(
            circleId: CircleId("mainCircles"),
            center: LatLng(value.latitude, value.longitude),
            radius: (GeoUtils.capRadius(double.parse(radius.toString())) * 1000),
            fillColor: Color.fromRGBO(171, 39, 133, 0.1),
            strokeColor: Color.fromRGBO(171, 39, 133, 0.5),
            strokeWidth: 5,
          )
        ]);
        var _coord = LatLng(value.latitude, value.longitude);
        cameraUpdate = CameraUpdate.newCameraPosition(CameraPosition(
          target: _coord,
          zoom: getZoomLevel((GeoUtils.capRadius(double.parse(radius.toString())) * 1000)),
        ));
        GeoFirestore geoFirestore =
            GeoFirestore(FirebaseCredentials().db.collection('User'));
        final queryLocation = GeoPoint(value.latitude, value.longitude);
        final List<DocumentSnapshot> documents =
            await geoFirestore.getAtLocation(queryLocation, double.parse(radius.toString()));
        documents.forEach((document) async {
          if (documents.isNotEmpty) {
            await _setMarkers(document, context);
          }
        });
        if (mounted) setState(() {});
      }
    });
  }

  getRadius ()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    radius = prefs.containsKey('radius') ? prefs.getInt('radius') : 10;
  }

  setRadius (int radius)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('radius', radius);
  }

  Future<void> _setMarkers(DocumentSnapshot point, context) async {
    await Helper.getMarkerImage(point, context).then((marker) {
      setState(() {
        _markers.add(marker);
      });
    });
  }

  double getZoomLevel(double radius) {
    double zoomLevel = 11;
    if (radius > 0) {
      double radiusElevated = radius + radius / 2;
      double scale = radiusElevated / 500;
      zoomLevel = 16 - math.log(scale) / math.log(2);
    }
    zoomLevel = num.parse(zoomLevel.toStringAsFixed(2));
    return zoomLevel;
  }

  Future _showDoubleDialog() async {
    await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return new NumberPickerDialog.integer(
          minValue: 1,
          maxValue: 1000,
          step: 1,
          //decimalPlaces: 0,
          initialIntegerValue: radius,
          title: new Text("Choose Distance in km", style: TextStyle(fontWeight: FontWeight.bold),),
        );
      },
    ).then((num value) {
      if (value != null) {
        setState(() {
          radius = value;
          setRadius(radius);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getRadius();
    if (mounted) {

      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {
          cameraUpdate = CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(0.0, 0.0),
            zoom: 18,
          ));
        });
        getLoc(context);
      });
    }
  }

  @override
  void dispose() {
    circles.clear();
    _markers.clear();
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          extendBodyBehindAppBar: true,
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              onPressed: () => _scaffoldKey.currentState.openDrawer(),
              icon: Icon(Icons.notes_sharp),
              color: AppColors.primaryColor,
            ),
            elevation: 0.0,
            actions: [
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/profile'),
                    child: Container(
                      height: 10,
                      width: 35,
                      decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(30)),
                      child: Icon(Icons.person),
                    ),
                  ))
            ],
          ),
          drawer: Drawerr(),
          body: Stack(
            children: [
              GoogleMap(
                circles: circles,
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                  mapController.animateCamera(cameraUpdate);
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(0.0, 0.0),
                  zoom: 18,
                ),
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                  new Factory<OneSequenceGestureRecognizer>(
                    () => new EagerGestureRecognizer(),
                  ),
                ].toSet(),
                mapType: MapType.normal,
                markers: _markers,
                // myLocationEnabled: true,
              ),
              Positioned(
                left: 10,
                bottom: 10,
                child: FloatingActionButton.extended(
                  heroTag: "chooseDistanceBtn",
                  onPressed: () async{
                    await _showDoubleDialog();
                    getRadius();
                    print("Radius Value : $radius");
                    getLoc(context);
                  },
                  label: Text(
                    'Choose Distance',
                  ),
                  icon: Icon(
                    Icons.location_searching,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          )),
    );
  }
}
