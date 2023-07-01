import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_map/presentation/screens/home_screen.dart';
import 'package:google_map/presentation/screens/searched_places_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../presentation/screens/check_otp_code_screen.dart';
import '../presentation/screens/register_screen.dart';

Map<String, Widget Function(BuildContext)> routes = {
  '/': (context) => RegisterScreen(),
  'CheckCodeScreen' : (context) => CheckCodeScreen(),
  'HomeScreen' : (context) => HomeScreen(),
  'SearchedPlacesScreen' : (context) => SearchedPlacesScreen(),
};


var mapController = Completer<GoogleMapController>();
