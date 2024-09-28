import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/api/api_url.dart';
import '../../../auth/domain/entities/auth_user.dart';

class FireStoreUser {
  static Future<void> createUser(AuthUser authUser) async {
    await ApiUrl.users.add(authUser.toMap());
  }

  static Future<AuthUser> getUserByEmail(String email) async {
    try {
      QuerySnapshot<Map<String, dynamic>> result =
          await ApiUrl.users.where('email', isEqualTo: email).limit(1).get();

      if (result.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> doc = result.docs.first;
        return AuthUser.fromMap(doc.data());
      } else {
        throw Exception('No user found with the provided email');
      }
    } catch (e) {
      throw Exception('Failed to retrieve user by email: $e');
    }
  }

  static Future<void> updateUser(AuthUser authUser) async {
    try {
      // Query to find the document by email
      QuerySnapshot<Map<String, dynamic>> result = await ApiUrl.users
          .where('email', isEqualTo: authUser.email)
          .limit(1)
          .get();

      if (result.docs.isNotEmpty) {
        // Get the document ID from the first matching document
        DocumentSnapshot<Map<String, dynamic>> doc = result.docs.first;
        String documentId = doc.id;

        // Update the document with the given ID
        await ApiUrl.users.doc(documentId).update(authUser.toMap());
      } else {
        throw Exception('No user found with the provided email');
      }
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  static Future<void> deleteUser(String userId) async {
    try {
      await ApiUrl.users.doc(userId).delete();
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }
}
