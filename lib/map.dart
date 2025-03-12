import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:location/location.dart';

class MyMapView extends StatefulWidget {
  const MyMapView({super.key});

  @override
  State<MyMapView> createState() => _MyMapViewState();
}

class _MyMapViewState extends State<MyMapView> {
  late MapController mapController;

  final location = Location();
  LocationData? myLocationData;
  @override
  void initState() {
    super.initState();
    initOSM();
    initLocation();
  }

  void initOSM() async {
    mapController = MapController(
        // initMapWithUserPosition: UserTrackingOption(enableTracking: true),
        initPosition: GeoPoint(
      latitude: myLocationData?.latitude ?? 0.0,
      longitude: myLocationData?.longitude ?? 0.0,
    ));
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
    final myGeoPoint = GeoPoint(
        latitude: myLocationData!.latitude!,
        longitude: myLocationData!.longitude!);
    // ignore: deprecated_member_use
    await mapController.goToLocation(myGeoPoint);
    await mapController.addMarker(myGeoPoint,
        markerIcon: const MarkerIcon(
          icon: Icon(
            Icons.location_on_outlined,
            size: 40,
            color: Colors.red,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OSMFlutter(
        controller: mapController,
        osmOption: OSMOption(
          zoomOption: ZoomOption(initZoom: 15),
        ),
      ),
    );
  }
}
