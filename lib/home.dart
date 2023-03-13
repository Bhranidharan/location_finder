import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;
  dynamic _latitude, _longitude;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Page'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: const CameraPosition(
          target: LatLng(37.7749, -122.4194),
          zoom: 11,
        ),
        markers: _latitude != null && _longitude != null
            ? Set.of([_createMarker()])
            : Set<Marker>(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getLatLngFromUser,
        child: const Icon(Icons.edit_location),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _getLatLngFromUser() async {
    final latLng = await showDialog<LatLng>(
      context: context,
      builder: (context) => _LatLngDialog(),
    );
    if (latLng != null) {
      setState(() {
        _latitude = latLng.latitude;
        _longitude = latLng.longitude;
        if (_mapController != null) {
          _mapController!.animateCamera(CameraUpdate.newLatLng(latLng));
        }
      });
    }
  }

  Marker _createMarker() {
    return Marker(
      markerId: const MarkerId('location'),
      position: LatLng(_latitude, _longitude),
    );
  }
}

class _LatLngDialog extends StatefulWidget {
  const _LatLngDialog({Key? key}) : super(key: key);

  @override
  __LatLngDialogState createState() => __LatLngDialogState();
}

class __LatLngDialogState extends State<_LatLngDialog> {
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter Latitude and Longitude'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _latitudeController,
            keyboardType:
                TextInputType.numberWithOptions(signed: true, decimal: true),
            decoration: const InputDecoration(
              labelText: 'Latitude',
              hintText: 'e.g. 37.7749',
            ),
          ),
          TextField(
            controller: _longitudeController,
            keyboardType:
                TextInputType.numberWithOptions(signed: true, decimal: true),
            decoration: const InputDecoration(
              labelText: 'Longitude',
              hintText: 'e.g. -122.4194',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final latitude = double.tryParse(_latitudeController.text);
            final longitude = double.tryParse(_longitudeController.text);
            if (latitude != null && longitude != null) {
              Navigator.of(context).pop(LatLng(latitude, longitude));
            }
          },
          child: const Text('OK'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }
}
