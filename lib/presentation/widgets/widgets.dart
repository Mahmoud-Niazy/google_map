import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildTextFormField extends StatelessWidget {
  late IconData prefixIcon;
  late String label;
  TextInputType? keyboardType ;
  late TextEditingController controller ;
  String? Function(String?)? validator ;

  BuildTextFormField({
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
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
        border: OutlineInputBorder(),
        prefixIcon: Icon(
          prefixIcon,
        ),
        hintText: label,

      ),
    );
  }
}

class BuildButton extends StatelessWidget {
  late String label;
  late void Function()? onPressed;
  double width;
  double height;

  BuildButton({
    required this.label,
    required this.onPressed,
    this.width =100,
    this.height = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height.h,
      width: width.w,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          label,
        ),
        style: ButtonStyle(
          backgroundColor:
          MaterialStateColor.resolveWith((states) => Colors.black),
        ),
      ),
    );
  }
}

class BuildTextButton extends StatelessWidget {
  late void Function()? onPressed;
  late String label;

  BuildTextButton({
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

  PageTransition({
    required this.page,
    required this.route,
    this.arguments
  })
      : super(
      settings: RouteSettings(
          name: route,
          arguments: arguments,
      ),
      pageBuilder: (context, animation1, animation2) {
        return page;
      }, transitionsBuilder: (context, animation1, animation2, child) {
    return SlideTransition(
      position: animation1.drive(Tween<Offset>(
        begin: Offset(-1, 0),
        end: Offset(0, 0),
      )),
      child: child,
    );
  });
}
