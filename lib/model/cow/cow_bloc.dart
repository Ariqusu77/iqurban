import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cow_event.dart';
import 'cow_state.dart';
import 'cow_model.dart';

class CowBloc extends Bloc<CowEvent, CowState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CowBloc() : super(const CowLoaded([],[])) {
    on<AddCowToUserEvent>((event, emit) async {
      List<String> userCows = List.from((state as CowLoaded).usersCows);
      List<CowModel> cows = List.from((state as CowLoaded).cows);
      emit(CowLoading());
      try {
        // Save the cow to the cows collection
        DocumentReference cowRef = await _firestore.collection('cows').add(event.cow.toMap());

        // Update the user's cow list
        await _firestore.collection('users').doc(event.userId).update({
          'cows': FieldValue.arrayUnion([cowRef.id]),
        });

        emit(CowLoaded(cows, userCows)); // Refresh the cow list (refetch if necessary)
      } catch (e) {
        emit(CowError("Failed to add cow to user: ${e.toString()}"));
      }
    });

    on<LoadUserCowsEvent>((event, emit) async {
      List<String> userCows = List.from((state as CowLoaded).usersCows);
      emit(CowLoading());
      try {
        // Fetch the user's cow list
        final userDoc = await _firestore.collection('users').doc(event.userId).get();
        if (!userDoc.exists || userDoc.data()?['cows'] == null) {
          emit(CowLoaded([], userCows));
          return;
        }

        List<String> cowIds = List<String>.from(userDoc.data()?['cows'] ?? []);
        List<CowModel> cows = [];

        for (String cowId in cowIds) {
          final cowDoc = await _firestore.collection('cows').doc(cowId).get();
          if (cowDoc.exists) {
            cows.add(CowModel.fromMap(cowDoc.data()!));
          }
        }

        emit(CowLoaded(cows, userCows));
      } catch (e) {
        emit(CowError("Failed to load user cows: ${e.toString()}"));
      }
    });

    on<LoadUserWithCows>((event, emit) async {
      List<CowModel> cows = List.from((state as CowLoaded).cows);
      emit(CowLoading());
      try {
        // Fetch all users who have associated cows
        final usersQuery = await _firestore
            .collection('users')
            .where('cows', isNotEqualTo: null)
            .get();

        List<String> userCows = [];

        for (var userDoc in usersQuery.docs) {
          userCows.add(userDoc.id);
        }

        emit(CowLoaded(cows, userCows));
      } catch (e) {
        emit(CowError("Failed to load users with cows: ${e.toString()}"));
      }
    });

  }
}
