import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  // ignore: unused_field
  late GoogleMapController _controller;

  final Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('location 1'),
          position: LatLng(40.985043626593864, 29.02451468470396),
          infoWindow: InfoWindow(title: 'Ertem Pharmacy'),
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId('Location 1'),
          position: LatLng(40.98576443296976, 29.02553392414003),
          infoWindow: InfoWindow(title: 'Ozan Pharmacy'),
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId('Location 2'),
          position: LatLng(40.99334710262723, 29.02878098841033),
          infoWindow: InfoWindow(title: 'Güven Pharmacy'),
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId('Location '),
          position: LatLng(40.9899684107911, 29.027897644229487),
          infoWindow: InfoWindow(title: 'Kaptan Pharmacy'),
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId('Location '),
          position: LatLng(40.989217320543325, 29.032266042376303),
          infoWindow: InfoWindow(title: 'Serra Pharmacy'),
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId('Location 2'),
          position: LatLng(40.98972631932426, 29.023861742376305),
          infoWindow: InfoWindow(title: 'Mühürdar Pharmacy'),
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId('Location '),
          position: LatLng(40.985060035463775, 29.027515386557145),
          infoWindow: InfoWindow(title: 'Verda Pharmacy'),
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId('Location'),
          position: LatLng(40.9908246980721, 29.027949442376304),
          infoWindow: InfoWindow(title: 'Altıyol Pharmacy'),
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId('Location'),
          position: LatLng(40.988899919842105, 29.024006373065653),
          infoWindow: InfoWindow(title: 'Nurhan Pharmacy'),
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId('Location'),
          position: LatLng(40.9896739147833, 29.027721571212467),
          infoWindow: InfoWindow(title: 'Serasker Pharmacy'),
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId('Location'),
          position: LatLng(40.985794933070025, 29.02500232888481),
          infoWindow: InfoWindow(title: 'Mine Pharmacy'),
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId('Location 2'),
          position: LatLng(40.98910892080293, 29.03237777121247),
          infoWindow: InfoWindow(title: 'Erengül Pharmacy'),
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId(' Location'),
          position: LatLng(40.992048608234064, 29.03260307677202),
          infoWindow: InfoWindow(title: 'Akın Pharmacy'),
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId('Location'),
          position: LatLng(40.99189571779003, 29.03201864422948),
          infoWindow: InfoWindow(title: 'Seçkin Pharmacy'),
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId('Location'),
          position: LatLng(40.99331011074051, 29.02866027121247),
          infoWindow: InfoWindow(title: 'Kalkedon Pharmacy'),
        ),
      );
      // Add more markers here
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        markers: _markers,
        initialCameraPosition: CameraPosition(
            target: LatLng(40.99170473210785, 29.02926519054903), zoom: 11),
      ),
    );
  }
}
