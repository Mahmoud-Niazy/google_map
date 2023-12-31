import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_map/presentation/screens/register_screen.dart';
import 'package:google_map/presentation/screens/searched_places_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';

import 'package:url_launcher/url_launcher.dart';
import '../../business_logic/home_cubit/home_cubit.dart';
import '../../business_logic/home_cubit/home_states.dart';
import '../../cashe_helper/cashe_helper.dart';
import '../../constants/constants.dart';
import '../../functions/functions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // var mapController = Completer<GoogleMapController>();
  var searchController = FloatingSearchBarController();

  @override
  void initState() {
    super.initState();
    HomeCubit.get(context).getUserLocation();
    mapController = Completer<GoogleMapController>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        return Scaffold(
          drawer: Drawer(
            child: ListView(
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(color: Colors.black12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Center(
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 40.sp,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: CasheHelper.getData(
                                                  key: 'profileImage') !=
                                              null
                                          ? NetworkImage(CasheHelper.getData(
                                              key: 'profileImage'))
                                          : const NetworkImage(
                                              'https://img.freepik.com/free-icon/pin-geolocalization_318-9542.jpg?w=740&t=st=1687911749~exp=1687912349~hmac=2f6794fde6b13f1f23eca498444c4bc84f1f7b2280bf1e2a9c23bffab812f3eb',
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                              CircleAvatar(
                                backgroundColor: Colors.black,
                                radius: 14.sp,
                                child: IconButton(
                                  onPressed: () {
                                    cubit.getProfileImage();
                                  },
                                  icon: Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.white,
                                    size: 15.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        CasheHelper.getData(key: 'name') ?? '',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        CasheHelper.getData(key: 'email') ?? '',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        CasheHelper.getData(key: 'phone') ?? '',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  onTap: () {
                    cubit.removeEveryThingToGoToYourLocation();
                    CasheHelper.removeData(key: 'profileImage');
                    // cubit.clearDatabase();
                    navigateAndFinish(
                        route: '/', context: context, page: RegisterScreen());
                  },
                  leading: const Icon(
                    Icons.person,
                  ),
                  title: Text(
                    'Log out',
                    style: TextStyle(
                      fontSize: 17.sp,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.login,
                  ),
                ),
                // SizedBox(
                //   height: 15.h,
                // ),
                ListTile(
                  onTap: () {
                    navigate(
                      route: 'SearchedPlacesScreen',
                      context: context,
                      page: const SearchedPlacesScreen(),
                    );
                  },
                  leading: const Icon(
                    Icons.location_on_outlined,
                  ),
                  title: Text(
                    'Searched Places',
                    style: TextStyle(
                      fontSize: 17.sp,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height - 310.h,
                ),

                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                  ),
                  child: Row(
                    children: [
                      buildSocialMediaIcon(
                        icon: FontAwesomeIcons.facebook,
                        url:
                            'https://www.facebook.com/profile.php?id=100010024906237',
                      ),
                      buildSocialMediaIcon(
                        icon: FontAwesomeIcons.linkedin,
                        url:
                            'https://www.linkedin.com/in/mahmoud-niazy-29a251254/',
                      ),
                      buildSocialMediaIcon(
                        icon: FontAwesomeIcons.github,
                        url: 'https://github.com/Mahmoud-Niazy',
                      ),
                      buildSocialMediaIcon(
                        icon: FontAwesomeIcons.instagram,
                        url: 'https://www.instagram.com/mahmoud__elsolia/',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // appBar: AppBar(),
          body: cubit.userLocation != null
              ? Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          cubit.userLocation!.latitude,
                          cubit.userLocation!.longitude,
                        ),
                        zoom: 18.sp,
                      ),
                      zoomControlsEnabled: false,
                      onMapCreated: (map_Controller) {
                        mapController.complete(map_Controller);
                      },
                      polylines:
                          cubit.placeDirection != null ? cubit.polyLine : {},
                      markers: cubit.markers,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      child: FloatingSearchBar(
                        hint: 'Search...',
                        controller: searchController,
                        scrollPadding:
                            const EdgeInsets.only(top: 20, bottom: 56),
                        transitionDuration: const Duration(milliseconds: 500),
                        transitionCurve: Curves.easeInOut,
                        physics: const BouncingScrollPhysics(),
                        // axisAlignment: isPortrait ? 0.0 : -1.0,
                        axisAlignment: 0,
                        openAxisAlignment: 0.0,
                        width: 500.w,
                        // width: isPortrait ? 600 : 500,
                        onFocusChanged: (value) {
                          cubit.isTimeAndDateVisible = false;
                        },
                        debounceDelay: const Duration(milliseconds: 500),
                        onQueryChanged: (query) {
                          cubit.getAutoCompletePlaces(
                            input: query.toString(),
                          );
                        },
                        transition: CircularFloatingSearchBarTransition(),
                        actions: [
                          FloatingSearchBarAction(
                            showIfOpened: false,
                            child: CircularButton(
                              icon: const Icon(Icons.place),
                              onPressed: () {},
                            ),
                          ),
                          FloatingSearchBarAction.searchToClear(
                            showIfClosed: false,
                          ),
                        ],
                        builder: (context, transition) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Material(
                              color: Colors.white,
                              elevation: 4.0,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: cubit.autoCompletePlaces == null
                                    ? []
                                    : cubit.autoCompletePlaces!.data.map((e) {
                                        return ListTile(
                                          onTap: () {
                                            searchController.close();
                                            cubit.getPlaceDetails(
                                              placeId: e.placeId,
                                              // mapController: mapController,
                                            );
                                            cubit.insertIntoDatabase(
                                              title: e.title,
                                              subTitle: e.body,
                                              placeId: e.placeId,
                                            );
                                          },
                                          title: Text(
                                            e.title,
                                          ),
                                          subtitle: Text(
                                            e.body,
                                          ),
                                        );
                                      }).toList(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    cubit.isTimeAndDateVisible && cubit.placeDirection != null
                        ? Positioned(
                            top: 90.h,
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 100.h,
                                  width: 150.w,
                                  child: Card(
                                    margin: const EdgeInsets.all(20),
                                    color: Colors.white,
                                    child: Center(
                                        child: Text(
                                            cubit.placeDirection!.duration)),
                                  ),
                                ),
                                SizedBox(
                                  width: 50.w,
                                ),
                                SizedBox(
                                  height: 100.h,
                                  width: 150.w,
                                  child: Card(
                                    margin: const EdgeInsets.all(20),
                                    color: Colors.white,
                                    child: Center(
                                        child: Text(
                                            cubit.placeDirection!.distance)),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                  ],
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),

          floatingActionButton: FloatingActionButton(
            child: const Icon(
              Icons.location_on_outlined,
            ),
            onPressed: () {
              cubit.removeEveryThingToGoToYourLocation();
              goToLocation(
                lat: cubit.userLocation!.latitude,
                lng: cubit.userLocation!.longitude,
                mapController: mapController,
              );
            },
          ),
        );
      },
    );
  }

  buildSocialMediaIcon({
    required IconData icon,
    required String url,
  }) {
    return IconButton(
      onPressed: () {
        lanchUrlOfIcon(
          link: url,
        );
      },
      icon: Icon(
        icon,
        size: 40,
      ),
    );
  }

  lanchUrlOfIcon({
    required String link,
  }) async {
    final Uri url = Uri.parse(link);
    if (!await launchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Can\'t launch this url',
          ),
        ),
      );
    }
  }
}
