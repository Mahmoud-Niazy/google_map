import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_map/business_logic/home_cubit/home_cubit.dart';
import 'package:google_map/business_logic/phone_auth_cubit/phone_auth_cubit.dart';
import 'package:google_map/cashe_helper/cashe_helper.dart';
import 'package:google_map/constants/constants.dart';
import 'package:google_map/dio_helper/dio_helper.dart';
import 'presentation/screens/login_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  await CasheHelper.init();
  DioHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ScreenUtilInit(
      child: LoginScreen(),
      builder: (BuildContext context, Widget? child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context)=> PhoneAuthCubit()),
            BlocProvider(create: (context)=> HomeCubit()..createDatabase()),
          ],
          child: MaterialApp(
            initialRoute:  CasheHelper.getData(key: 'isRegisteredBefore') == true ? 'HomeScreen' : '/',
            routes: routes,
            theme: ThemeData(
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                elevation: 0,
                iconTheme: IconThemeData(
                  color: Colors.black,
                ),
              ),
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              scaffoldBackgroundColor: Colors.white,
            ),
          ),
        );
      },

    );
  }


}
