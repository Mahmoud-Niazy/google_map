import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_map/business_logic/phone_auth_cubit/phone_auth_cubit.dart';
import 'package:google_map/functions/functions.dart';
import 'package:google_map/presentation/screens/register_screen.dart';
import 'package:google_map/presentation/widgets/widgets.dart';
import '../../business_logic/phone_auth_cubit/phone_auth_states.dart';
import 'check_otp_code_screen.dart';

class LoginScreen extends StatelessWidget {
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PhoneAuthCubit, PhoneAuthStates>(
      listener: (context, state) {
        if(state is PhoneNumberVerifiedState){
          navigate(
            page: CheckCodeScreen(),
            context: context,
            route: 'CheckCodeScreen',
          );
        }
      },
      builder: (context, state) {
        var cubit = PhoneAuthCubit.get(context);
        return Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 15.w,
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BuildTextFormField(
                    label: 'Phone',
                    controller: phoneController,
                    prefixIcon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Phone is empty';
                      }
                      if (value.length != 11) {
                        return 'Phone must be 11 number';
                      }
                      return null ;
                    },
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  BuildButton(
                    label: 'Login',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        cubit.phoneAuth(
                          phoneNumber: phoneController.text,
                        );
                      }
                    },
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Don\'t have an account ?',
                        style: TextStyle(
                          fontSize: 15.sp,
                        ),
                      ),
                      BuildTextButton(
                        onPressed: () {
                          navigate(
                            route: 'RegisterScreen',
                            context: context,
                            page: RegisterScreen(),
                          );
                        },
                        label: 'Register now',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
