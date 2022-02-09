import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reportcam/modules/camera/controller/camera_controller.dart';

class PreviewMapWidget extends StatefulWidget {
  const PreviewMapWidget(
      {Key? key, required this.latUser, required this.lngUser})
      : super(key: key);
  final double latUser;
  final double lngUser;

  @override
  _PreviewMapWidgetState createState() => _PreviewMapWidgetState();
}

class _PreviewMapWidgetState extends State<PreviewMapWidget> {
  // init controller
  final AppCameraController _cameraController = Get.put(AppCameraController());

  // for map
  final Completer<GoogleMapController> _controller = Completer();
  double lat = 0, lng = 0;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    lat = widget.latUser;
    lng = widget.lngUser;
    _markers.add(
      Marker(
        markerId: MarkerId("3.595196, 98.672226"),
        position: LatLng(lat, lng),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.hybrid,
      markers: _markers,
      initialCameraPosition: CameraPosition(
        target: LatLng(lat, lng),
        zoom: 18,
      ),
      onMapCreated: (GoogleMapController controller) async {
        Timer(const Duration(seconds: 2), () async {
          final result = await controller.takeSnapshot();
          final directory = (await getApplicationDocumentsDirectory())
              .path; // to get path of the file
          String fileName = DateTime.now()
              .toIso8601String(); // the name needs to be unique every time you take a screenshot
          var path = '$directory/$fileName.png';

          File image = await File(path).writeAsBytes(result!);
          _cameraController.saveMapImage(boolValue: true, fileImage: image);
        });

        _controller.complete(controller);
      },
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
    );
  }
}
