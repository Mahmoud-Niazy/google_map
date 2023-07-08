import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../business_logic/phone_auth_cubit/phone_auth_cubit.dart';
import '../../business_logic/phone_auth_cubit/phone_auth_states.dart';
import '../../cashe_helper/cashe_helper.dart';
import '../../functions/functions.dart';
import 'home_screen.dart';

class CheckCodeScreen extends StatelessWidget {
  final codeController = TextEditingController();

  CheckCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PhoneAuthCubit, PhoneAuthStates>(
      listener: (context, state) async {
        if(state is PhoneAuthSuccessfullyState){
          Fluttertoast.showToast(msg: 'Successfully').then((value) {
            CasheHelper.saveData(key: 'isRegisteredBefore', value: true);
            navigateAndFinish(
              route: 'Home',
              context: context,
              page: const HomeScreen(),
            );
          });
        }
        if(state is PhoneAuthErrorState) {
          await Fluttertoast.showToast(msg: state.error!);
        }
      },
      builder: (context, state) {
        var cubit = PhoneAuthCubit.get(context);
        // final recievedData = ModalRoute.of(context)!.settings.arguments as Map ;
        // String email = recievedData['email'];
        // String phone = recievedData['phone'];
        // String name = recievedData['name'];

        return Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 15.w,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter the Code sent',
                  style: TextStyle(
                    fontSize: 20.sp,
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                PinCodeTextField(
                  appContext: context,
                  keyboardType: TextInputType.phone,
                  length: 6,
                  cursorColor: Colors.black,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50.h,
                      fieldWidth: 40.w,
                      selectedColor: Colors.black45,
                      selectedFillColor: Colors.white,
                      inactiveColor: Colors.black45,
                      inactiveFillColor: Colors.white,
                      activeFillColor: Colors.black45,
                      activeColor: Colors.black45),
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: true,
                  controller: codeController,
                  onCompleted: (v) {
                    cubit.checkCode(
                      smsCode: codeController.text,
                    );
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
