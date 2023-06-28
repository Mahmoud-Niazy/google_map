abstract class PhoneAuthStates {}

class PhoneAuthInitialState extends PhoneAuthStates{}

class PhoneAuthSuccessfullyState extends PhoneAuthStates{}
class PhoneAuthErrorState extends PhoneAuthStates{
  String? error;
  PhoneAuthErrorState(this.error);
}
class PhoneNumberVerifiedState extends PhoneAuthStates{}

class UserLoginSuccessfullyState extends PhoneAuthStates{}
class UserLoginErrorState extends PhoneAuthStates{}