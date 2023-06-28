class PlaceDetails {
  late PlaceResult result;

  PlaceDetails.fromJson(Map<String, dynamic> json) {
    result = PlaceResult.fromJson(json['result']);
  }
}

class PlaceResult {
  late PlaceGeometry geometry;
  PlaceResult.fromJson(Map<String,dynamic>json){
    geometry = PlaceGeometry.fromJson(json['geometry']);
  }
}

class PlaceGeometry {
  late PlaceLocation location;
  PlaceGeometry.fromJson(Map<String,dynamic>json){
    location = PlaceLocation.fromJson(json['location']);
  }
}

class PlaceLocation {
  late double lat;

  late double lng;

  PlaceLocation.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }
}
