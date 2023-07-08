import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_map/business_logic/phone_auth_cubit/phone_auth_states.dart';

class PhoneAuthCubit extends Cubit<PhoneAuthStates> {
  PhoneAuthCubit() : super(PhoneAuthInitialState());

  static PhoneAuthCubit get(context) => BlocProvider.of(context);

  phoneAuth({
    required String phoneNumber,
  }) {
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+2$phoneNumber',
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  verificationCompleted(PhoneAuthCredential credential) {
    FirebaseAuth.instance.signInWithCredential(credential);
  }

  verificationFailed(FirebaseAuthException exception) {
    emit(PhoneAuthErrorState(exception.toString()));
  }

  String? verificationId;

  codeSent(String verificationId, int? resendToken) {
    this.verificationId = verificationId;
    emit(PhoneNumberVerifiedState());
  }

  codeAutoRetrievalTimeout(String error) {}

  checkCode({
    required String smsCode,
  }) {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId!,
      smsCode: smsCode,
    );
    FirebaseAuth.instance.signInWithCredential(credential).then((value) {
      emit(PhoneAuthSuccessfullyState());
    }).catchError((error) {
      emit(PhoneAuthErrorState(error.toString()));
    });
  }

}
