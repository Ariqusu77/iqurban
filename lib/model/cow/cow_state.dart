import 'package:equatable/equatable.dart';
import 'cow_model.dart';

abstract class CowState extends Equatable {
  const CowState();

  @override
  List<Object?> get props => [];
}

class CowInitial extends CowState {}

class CowLoading extends CowState {}

class CowLoaded extends CowState {
  final List<CowModel> cows;
  final List<String> usersCows;

  const CowLoaded(this.cows, this.usersCows);

  @override
  List<Object?> get props => [cows, usersCows];
}

class CowError extends CowState {
  final String message;

  const CowError(this.message);

  @override
  List<Object?> get props => [message];
}
