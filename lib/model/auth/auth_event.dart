abstract class AuthEvent {}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;

  SignInEvent(this.email, this.password);
}

class LogInEvent extends AuthEvent {
  final String email;
  final String password;

  LogInEvent(this.email, this.password);
}

class SubmitFormEvent extends AuthEvent {
  final Map<String, dynamic> formData;

  SubmitFormEvent(this.formData);
}

class CheckUserDataEvent extends AuthEvent {
  final String uid;

  CheckUserDataEvent(this.uid);
}

class ForgotPasswordEvent extends AuthEvent {
  final String email;

  ForgotPasswordEvent(this.email);
}

class EditProfileEvent extends AuthEvent {
  final Map<String, dynamic> updatedData;

  EditProfileEvent(this.updatedData);
}
