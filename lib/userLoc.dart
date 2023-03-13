import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LiveLocationTracker extends StatefulWidget {
  @override
  _LiveLocationTrackerState createState() => _LiveLocationTrackerState();
}

class _LiveLocationTrackerState extends State<LiveLocationTracker> {
  late GoogleMapController _mapController;
  Location _location = Location();
  late LocationData _locationData;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        _locationData = currentLocation;
        _markers.add(Marker(
          markerId: MarkerId('user_location'),
          position: LatLng(currentLocation.latitude ?? 0, currentLocation.longitude??0),
        ));
        if (_mapController != null) {
          _mapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(currentLocation.latitude??0, currentLocation.longitude??0),
              zoom: 17.0,
            ),
          ));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(0.0, 0.0),
              zoom: 14.0,
            ),
            onMapCreated: (GoogleMapController controller) {
              setState(() {
                _mapController = controller;
              });
            },
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          Positioned(
            bottom: 20.0,
            left: 20.0,
            child: Text(
              'Lat: ${_locationData.latitude ?? ''}, Lng: ${_locationData.longitude ?? ''}',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
