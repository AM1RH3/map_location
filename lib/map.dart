import 'package:flutter/material.dart';
import 'package:location/location.dart';

class MyMapView extends StatefulWidget {
  const MyMapView({super.key});

  @override
  State<MyMapView> createState() => _MyMapViewState();
}

class _MyMapViewState extends State<MyMapView> {
  final location = Location();
  LocationData? myLocationData;
  @override
  void initState() {
    super.initState();
    initLocation();
  }

  void initLocation() async {
    final permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.granted) {
      myLocationData = await location.getLocation();
    } else {
      await location.requestPermission();
      myLocationData = await location.getLocation();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('${myLocationData?.latitude},${myLocationData?.longitude}'),
      ),
    );
  }
}
