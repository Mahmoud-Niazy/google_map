import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map/data_models/auto_complete_places_data_model.dart';
import 'package:google_map/data_models/place_details_data_model.dart';
import 'package:google_map/data_models/place_direction_data_model.dart';
import 'package:google_map/data_models/searceh_place_data_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../../cashe_helper/cashe_helper.dart';
import '../../constants/constants.dart';
import '../../dio_helper/dio_helper.dart';
import '../../functions/functions.dart';
import 'home_states.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  Position? userLocation;

  getUserLocation() async {
    emit(GetUserLocationLoadingState());
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Geolocator.openLocationSettings();
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      emit(GetUserLocationErrorState());
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      emit(GetUserLocationErrorState());
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Geolocator.getCurrentPosition().then((Position value) {
      userLocation = value;
      emit(GetUserLocationSuccessfullyState());
    });
  }

  AutoCompletePlaces? autoCompletePlaces;

  getAutoCompletePlaces({
    required String input,
  }) {
    var uuid = Uuid().v4();
    emit(GetAutoCompletePlacesLoadingState());
    DioHelper.getData(
      path: 'place/autocomplete/json',
      query: {
        'input': input,
        'radius': 5000,
        'key': 'AIzaSyDZnXt5NZJnsntMked4qGtDaBO2lVxuDWM',
        'components': 'country:eg',
        'types': 'address',
        'sessiontoken': '${uuid}',
      },
    ).then((value) {
      print(uuid);
      autoCompletePlaces = AutoCompletePlaces.fromJson(value.data);
      emit(GetAutoCompletePlacesSuccessfullyState());
    }).catchError((error) {
      print(error);
      emit(GetAutoCompletePlacesErrorState());
    });
  }

  PlaceDetails? placeDetails;

  Future? getPlaceDetails({
    required String placeId,
    // required Completer<GoogleMapController> mapController,
  }) {
    emit(GetPlaceDetailsLoadingState());
    var uuid = Uuid().v4();
    DioHelper.getData(
      path: 'place/details/json',
      query: {
        'place_id': placeId,
        'fields': 'geometry',
        'sessiontoken': '${uuid}',
        'key': 'AIzaSyDZnXt5NZJnsntMked4qGtDaBO2lVxuDWM',
      },
    ).then((value) {
      placeDetails = PlaceDetails.fromJson(value.data);

      loadPlaceDirection(
        origin: LatLng(
          userLocation!.latitude,
          userLocation!.longitude,
        ),
        destination: LatLng(
          placeDetails!.result.geometry.location.lat,
          placeDetails!.result.geometry.location.lng,
        ),
      );
      addMarkers(
        userLocation: LatLng(
          userLocation!.latitude,
          userLocation!.longitude,
        ),
        searchedPlace: LatLng(
          placeDetails!.result.geometry.location.lat,
          placeDetails!.result.geometry.location.lng,
        ),
      );
      goToLocation(
        mapController: mapController,
        lat: placeDetails!.result.geometry.location.lat,
        lng: placeDetails!.result.geometry.location.lng,
      );
      emit(GetPlaceDetailsSuccessfullyState());
      return placeDetails;
    }).catchError((error) {
      emit(GetPlaceDetailsErrorState());
    });
  }

  PlaceDirection? placeDirection;
  Set<Polyline> polyLine = {};

  loadPlaceDirection({
    required LatLng origin,
    required LatLng destination,
  }) {
    emit(LoadPlaceDirectionLoadingState());
    DioHelper.getData(
      path: 'directions/json',
      query: {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'key': 'AIzaSyDZnXt5NZJnsntMked4qGtDaBO2lVxuDWM'
      },
    ).then((value) {
      placeDirection = PlaceDirection.fromJson(value.data);
      polyLine = {
        Polyline(
          polylineId: PolylineId('1'),
          width: 2,
          points: placeDirection!.points
              .map((e) => LatLng(e.latitude, e.longitude))
              .toList(),
        ),
      };
      emit(LoadPlaceDirectionSuccessfullyState());
    }).catchError((error) {
      emit(LoadPlaceDirectionErrorState());
    });
  }

  var markers = HashSet<Marker>();

  addMarkers({
    required LatLng userLocation,
    required LatLng searchedPlace,
  }) {
    markers.clear();
    markers.add(
      Marker(
          markerId: MarkerId('${Uuid().v4()}'),
          position: LatLng(userLocation.latitude, userLocation.longitude),
          infoWindow: InfoWindow(
            title: 'Your location',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(200)),
    );
    markers.add(
      Marker(
          markerId: MarkerId('${Uuid().v4()}'),
          position: LatLng(searchedPlace.latitude, searchedPlace.longitude),
          infoWindow: InfoWindow(
            title: 'Searched place',
          ),
          onTap: () {
            showTimeAndDate();
          }),
    );
    emit(AddMarkersState());
  }

  bool isTimeAndDateVisible = false;

  showTimeAndDate() {
    isTimeAndDateVisible = !isTimeAndDateVisible;
    emit(ShowTimeAndDateState());
  }

  removeEveryThingToGoToYourLocation() {
    isTimeAndDateVisible = false;
    markers.clear();
    polyLine.clear();
    emit(RemoveEveryThingState());
  }

  final ImagePicker picker = ImagePicker();
  File? profileImage;

  getProfileImage() async {
    emit(GetPlaceDetailsLoadingState());
    final pickedPhoto = await picker.pickImage(source: ImageSource.gallery);
    if (pickedPhoto != null) {
      profileImage = File(pickedPhoto.path);
      emit(GetPlaceDetailsSuccessfullyState());
      FirebaseStorage.instance
          .ref()
          .child('images/${Uri.file(profileImage!.path).pathSegments.last}')
          .putFile(profileImage!)
          .then((value) {
        value.ref.getDownloadURL().then((value) {
          CasheHelper.saveData(key: 'profileImage', value: value);
          emit(UploadProfileImageSuccessfullyState());
        });
      });
    } else {
      emit(GetPlaceDetailsErrorState());
    }
  }

  late Database database;

  createDatabase() async {
    emit(CreateTableLoadingState());
    database = await openDatabase(
      'places.db',
      version: 1,
      onCreate: (database, version) {
        database
            .execute(
                'CREATE TABLE places (id INTEGER PRIMARY KEY , title TEXT , subTitle TEXT , placeId TEXT )')
            .then((value) {
          emit(CreateTableSuccessfullyState());
        }).catchError((error) {
          emit(CreateTableErrorState());
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
      },
    );
  }

  insertIntoDatabase({
    required String title,
    required String subTitle,
    required String placeId,
  }) async {
    emit(InsertIntoDatabaseLoadingState());
    return await database.transaction((txn) {
      return txn.rawInsert(
          'INSERT INTO places( title , subTitle , placeId ) VALUES ("$title" , "$subTitle" , "$placeId" ) ');
    }).then((value) {
      getDataFromDatabase(database);
      emit(InsertIntoDatabaseSuccessfullyState());
    }).catchError((error) {
      emit(InsertIntoDatabaseErrorState());
    });
  }

  List<SearchedPlaceDataModel> places = [];

  getDataFromDatabase(database) {
    places = [];
    emit(GetDataFromDatabaseLoadingState());
    database.rawQuery('SELECT * FROM places').then((value) {
      value.forEach((element) {
        places.add(SearchedPlaceDataModel(
          subTitle: element['subTitle'],
          title: element['title'],
          placeId: element['placeId'],
        ));
      });
      emit(GetDataFromDatabaseSuccessfullyState());
    }).catchError((error) {
      emit(GetDataFromDatabaseErrorState());
    });
  }

  // Future<void> clearDatabase() =>
  //     databaseFactory.deleteDatabase('places.db');

  // clearDatabase() {
  //   emit(ClearDatabaseLoadingState());
  //   database.rawDelete('DELETE FROM places').then((value) {
  //     emit(ClearDatabaseSuccessfullyState());
  //   }).catchError((error) {
  //     emit(ClearDatabaseErrorState());
  //   });
  // }
}
