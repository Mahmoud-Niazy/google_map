import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_map/business_logic/home_cubit/home_cubit.dart';
import 'package:google_map/functions/functions.dart';

import '../../data_models/searceh_place_data_model.dart';

class BuildTextFormField extends StatelessWidget {
   final  IconData prefixIcon;
   final  String label;
  final TextInputType? keyboardType;

   final TextEditingController controller;

  final String? Function(String?)? validator;

  const BuildTextFormField({super.key,
    required this.label,
    required this.prefixIcon,
    this.keyboardType,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
        border: const OutlineInputBorder(),
        prefixIcon: Icon(
          prefixIcon,
        ),
        hintText: label,
      ),
    );
  }
}

class BuildButton extends StatelessWidget {
  final  String label;
  final  void Function()? onPressed;
  final double width;
  final double height;

   const BuildButton({super.key,
    required this.label,
    required this.onPressed,
    this.width = 100,
    this.height = 40,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height.h,
      width: width.w,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor:
              MaterialStateColor.resolveWith((states) => Colors.black),
        ),
        child: Text(
          label,
        ),
      ),
    );
  }
}

class BuildTextButton extends StatelessWidget {
  final void Function()? onPressed;
  final String label;

  const BuildTextButton({super.key,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(
          color: Colors.black,
          fontSize: 15.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class PageTransition extends PageRouteBuilder {
  late Widget page;
  late String route;
  Map? arguments;

  PageTransition({required this.page, required this.route, this.arguments})
      : super(
            settings: RouteSettings(
              name: route,
              arguments: arguments,
            ),
            pageBuilder: (context, animation1, animation2) {
              return page;
            },
            transitionsBuilder: (context, animation1, animation2, child) {
              return SlideTransition(
                position: animation1.drive(Tween<Offset>(
                  begin: const Offset(-1, 0),
                  end: const Offset(0, 0),
                )),
                child: child,
              );
            });
}

class SearchedPlaceModel extends StatelessWidget {
   final SearchedPlaceDataModel place;

  const SearchedPlaceModel({super.key,
    required this.place,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10
      ),
      child: Card(
        elevation: 10,
        child: ListTile(
          onTap: () {
            navigatePop(context: context);
            HomeCubit.get(context).getPlaceDetails(placeId: place.placeId);
          },
          title: Text(
            place.title,
          ),
          subtitle: Text(
            place.subTitle,
          ),
          trailing: const Icon(
            Icons.location_on_outlined,
          ),
        ),
      ),
    );
  }
}
