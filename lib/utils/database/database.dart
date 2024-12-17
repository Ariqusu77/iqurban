import 'package:iqurban/model/cow/cow_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<List<String>> getUserCows(String userId) async {
  try {

    final userDoc = await _firestore.collection('users').doc(userId).get();

    List<String> cowIds = List<String>.from(userDoc.data()?['cows'] ?? []);

    return cowIds;
  } catch (e) {
    print(e);
    return [];
  }
}

Future<CowModel?> getCowsData(String cowId) async {
  try {
    final cowDoc = await _firestore.collection('cows').doc(cowId).get();

    return CowModel.fromMap(cowDoc.data()!);
  } catch (e) {
    print(e);
    return null;
  }
}

Future<Map<String, dynamic>?> getUserData(String userId) async {
  try {
    final userDoc = await _firestore.collection('users').doc(userId).get();

    return userDoc.data();
  } catch (e) {
    print(e);
    return null;
  }
}

Future<bool> deleteCow(String userId, String cowId) async {
  try {
    // Remove the cow from the user's 'cows' array
    await _firestore.collection('users').doc(userId).update({
      'cows': FieldValue.arrayRemove([cowId]),
    });

    // Delete the cow document from the 'cows' collection
    await _firestore.collection('cows').doc(cowId).delete();

    return true;
  } catch (e) {
    print('Failed to delete cow: $e');
    return false;
  }
}