import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_map/presentation/widgets/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

navigate({
  required String route,
  required BuildContext context,
  required Widget page,
  Map? arguments,
}) {
  Navigator.of(context).push(
    PageTransition(
      page: page,
      route: route,
      arguments: arguments,
    ),
  );
}

navigatePop({
  required BuildContext context,
}) {
  Navigator.of(context).pop();
}

navigateAndFinish({
  required String route,
  required BuildContext context,
  required Widget page,
  Map? arguments,
}) {
  Navigator.of(context).pushAndRemoveUntil(
    PageTransition(
      page: page,
      route: route,
    ),
    (route) => false ,
  );
}


goToLocation({
  required double lat,
  required double lng,
  required Completer<GoogleMapController> mapController ,
}) async {
  final GoogleMapController controller = await mapController.future;
  await controller
      .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
    target: LatLng(
      lat,
      lng,
    ),
    zoom: 15.sp,
  )));
}