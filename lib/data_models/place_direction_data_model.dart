import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceDirection {
  late LatLngBounds bounds;
  late String distance ;
  late String duration ;
  late List<PointLatLng> points ;
  late String encodePoints;

  PlaceDirection.fromJson(Map<String, dynamic> json) {

    final northeast = json['routes'][0]['bounds']['northeast'];
    final southwest = json['routes'][0]['bounds']['southwest'];

    bounds = LatLngBounds(
      southwest: LatLng(southwest['lat'], southwest['lng']),
      northeast: LatLng(northeast['lat'], northeast['lng']),
    );

    distance = json['routes'][0]['legs'][0]['distance']['text'];
    duration = json['routes'][0]['legs'][0]['duration']['text'];

    points = PolylinePoints().decodePolyline(json['routes'][0]['overview_polyline']['points']);
  }
}
