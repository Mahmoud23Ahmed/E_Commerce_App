import 'package:cloud_firestore/cloud_firestore.dart';

abstract class RemoteDbHelper {
  Future<void> add(
      String collectionName,
      Map<String, dynamic> data, {
        String? documentId,
      });
  Future<void> update(
      String collectionName, String docId, Map<String, dynamic> data);
  Future<void> delete(String collectionName, String docId);

  Future<List> get(String collectionName, Function dTOConverter);
}
class RemoteDbHelperImp implements RemoteDbHelper {
  @override
  Future<void> add(String collectionName, Map<String, dynamic> data, {String? documentId}) async {
    final CollectionReference collection = FirebaseFirestore.instance.collection(collectionName);

    if (documentId != null) {
      await collection.doc(documentId).set(data);
    } else {
      await collection.add(data);
    }
  }

  @override
  Future<void> delete(String collectionName, String docId) =>
      FirebaseFirestore.instance.collection(collectionName).doc(docId).delete();

  @override
  Future<List> get(String collectionName, Function dToConverter) async {
    final snapshot = await FirebaseFirestore.instance.collection(collectionName).get();
    return snapshot.docs.map((doc) => dToConverter(doc)).toList(); // Ensure this returns a list
  }

  @override
  Future<void> update(String collectionName, String docId, Map<String, dynamic> data) =>
      FirebaseFirestore.instance.collection(collectionName).doc(docId).update(data);
}
