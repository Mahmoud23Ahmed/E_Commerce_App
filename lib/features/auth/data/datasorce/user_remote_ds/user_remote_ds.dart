import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/user_model.dart';

abstract class UsersRemoteDs {
  /// إضافة بيانات المستخدم إلى [Firestore]
  Future<void> addUser(UserModel userModel);

  /// جلب جميع المستخدمين من [Firestore]
  Future<List<UserModel>> getUsers();

  /// جلب المستخدم بناءً على authId
  Future<UserModel?> getUserByAuthId(String authId);
}

const collectionName = 'users';

class UsersRemoteDsImp implements UsersRemoteDs {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<void> addUser(UserModel userModel) async {
    final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final String nameDocumentId = userId;

    await firestore.collection(collectionName).doc(nameDocumentId).set(userModel.toMap());
  }

  @override
  Future<List<UserModel>> getUsers() async {
    final snapshot = await firestore.collection(collectionName).get();
    return snapshot.docs.map((doc) => UserModel.fromDocumentSnapshot(doc)).toList();
  }

  @override
  Future<UserModel?> getUserByAuthId(String authId) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> doc =
      await firestore.collection(collectionName).doc(authId).get();

      if (doc.exists) {
        return UserModel.fromDocumentSnapshot(doc);
      } else {
        print('User not found');
        return null;
      }
    } catch (e) {
      print('Error fetching single user: $e');
      return null;
    }
  }

}
