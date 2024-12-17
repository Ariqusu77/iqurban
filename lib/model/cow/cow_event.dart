import 'package:equatable/equatable.dart';
import 'cow_model.dart';

abstract class CowEvent extends Equatable {
  const CowEvent();

  @override
  List<Object?> get props => [];
}

class AddCowToUserEvent extends CowEvent {
  final String userId;
  final CowModel cow;

  const AddCowToUserEvent({
    required this.userId,
    required this.cow,
  });

  @override
  List<Object?> get props => [userId, cow];
}

class LoadUserCowsEvent extends CowEvent {
  final String userId;

  const LoadUserCowsEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class LoadUserWithCows extends CowEvent {
  const LoadUserWithCows();

  @override
  List<Object?> get props => [];
}
