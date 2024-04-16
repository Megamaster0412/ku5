import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:location/location.dart';

class ARPage extends StatefulWidget {
  @override
  _ARPageState createState() => _ARPageState();  // Correct the class name to _ARPageState
}

class _ARPageState extends State<ARPage> {  // Correct the class name to match the StatefulWidget
  late ARSessionManager arSessionManager;
  late GoogleMapController mapController;
  Location location = new Location();

  LatLng _currentLocation = LatLng(0, 0);
  late bool _serviceEnabled;  // Use 'late' for late initialization
  late PermissionStatus _permissionGranted;  // Use 'late' for late initialization

  @override
  void initState() {
    super.initState();
    _initLocationService();
  }

  void _initLocationService() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) return;
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) return;
    }

    location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        _currentLocation = LatLng(currentLocation.latitude!, currentLocation.longitude!);
        if (mapController != null) {
          mapController.animateCamera(CameraUpdate.newLatLng(_currentLocation));
        }
      });
    });
  }

  void onARViewCreated(ARSessionManager arSessionManager, ARObjectManager arObjectManager, ARAnchorManager arAnchorManager, ARLocationManager arLocationManager) {
    this.arSessionManager = arSessionManager;
    this.arSessionManager.onInitialize();
    // Additional initialization for AR objects and anchors can be done here
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.animateCamera(CameraUpdate.newLatLng(_currentLocation));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AR and Map Integration")),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _currentLocation,
              zoom: 14.0,
            ),
          ),
          ARView(
              onARViewCreated: (sessionManager, objectManager, anchorManager, locationManager) =>
                  onARViewCreated(sessionManager, objectManager, anchorManager, locationManager)
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    arSessionManager.dispose();
    if (mapController != null) {
      mapController.dispose();
    }
    super.dispose();
  }
}
