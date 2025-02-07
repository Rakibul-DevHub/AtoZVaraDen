//Todo: under develop
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class MapLocation extends StatefulWidget {
//   const MapLocation({super.key});
//
//   @override
//   State<MapLocation> createState() => _MapLocationState();
// }
//
// class _MapLocationState extends State<MapLocation> {
//   late GoogleMapController mapController;
//
//   final LatLng _initialPosition = const LatLng(37.7749, -122.4194); // San Francisco as an example
//
//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Map Location'),
//         backgroundColor: Colors.teal,
//       ),
//       body: GoogleMap(
//         onMapCreated: _onMapCreated,
//         initialCameraPosition: CameraPosition(
//           target: _initialPosition,
//           zoom: 12.0,
//         ),
//       ),
//     );
//   }
// }
