abstract class LoginEvent {}

class LoginSelectedEvent implements LoginEvent{}
class SignUpSelectedEvent implements LoginEvent{}

abstract class SwitchBetweenLoginAndSignUpBtnEvent {}

class ShowLoginBtnEvent implements SwitchBetweenLoginAndSignUpBtnEvent{}
class ShowSignUpBtnEvent implements SwitchBetweenLoginAndSignUpBtnEvent{}