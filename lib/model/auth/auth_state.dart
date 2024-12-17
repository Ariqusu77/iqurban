abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSignedIn extends AuthState{}

class AuthAuthenticated extends AuthState {}

class AuthFormSubmission extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

class ForgotPasswordLoading extends AuthState {}

class ForgotPasswordSuccess extends AuthState {
  final String message;

  ForgotPasswordSuccess(this.message);
}

class ForgotPasswordError extends AuthState {
  final String message;

  ForgotPasswordError(this.message);
}
