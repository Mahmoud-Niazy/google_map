import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_map/business_logic/phone_auth_cubit/phone_auth_cubit.dart';
import 'package:google_map/cashe_helper/cashe_helper.dart';
import 'package:google_map/presentation/screens/check_otp_code_screen.dart';
import 'package:google_map/presentation/widgets/widgets.dart';
import '../../business_logic/phone_auth_cubit/phone_auth_states.dart';
import '../../functions/functions.dart';

class RegisterScreen extends StatelessWidget {
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PhoneAuthCubit, PhoneAuthStates>(
      listener: (context, state) {
        if (state is PhoneNumberVerifiedState) {
          CasheHelper.saveData(key: 'name', value: nameController.text);
          CasheHelper.saveData(key: 'email', value: emailController.text);
          CasheHelper.saveData(key: 'phone', value: phoneController.text);

          navigateAndFinish(
            page: CheckCodeScreen(),
            context: context,
            route: 'CheckCodeScreen',
            // arguments: {
            //   'name' : nameController.text,
            //   'email' : emailController.text,
            //   'phone' : phoneController.text,
            // }
          );
        }
        if (state is PhoneAuthErrorState) {
          Fluttertoast.showToast(
            msg: state.error!,
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
                    label: 'Name',
                    controller: nameController,
                    prefixIcon: Icons.person,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Name is empty ';
                      }
                      return null ;
                    },
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  BuildTextFormField(
                    label: 'Phone',
                    controller: phoneController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Phone is empty ';
                      }
                      if (value.length != 11) {
                        return 'Phone must be 11 number';
                      }
                      return null ;
                    },
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icons.phone,
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  BuildTextFormField(
                    label: 'Email',
                    controller: emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Email is empty ';
                      }
                      return null ;
                    },
                    prefixIcon: Icons.email_outlined,
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  BuildButton(
                    label: 'Register',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        cubit.phoneAuth(
                          phoneNumber: phoneController.text,
                        );
                      }
                    },
                    width: double.infinity,
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
