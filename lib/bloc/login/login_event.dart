abstract class LoginEvent {}

class LoginSelectedEvent implements LoginEvent{}
class SignUpSelectedEvent implements LoginEvent{}

abstract class DisplayLoginOrSignUpFormEvent {}

class DisplayLoginFormEvent implements DisplayLoginOrSignUpFormEvent{}
class DisplaySignUpEvent implements DisplayLoginOrSignUpFormEvent{}