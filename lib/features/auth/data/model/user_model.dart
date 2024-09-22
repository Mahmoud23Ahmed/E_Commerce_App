import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String name;
  final String userId;
  final String email;
  final String? phone; // اختياري
  final String? address; // اختياري
  final int? age; // اختياري

  UserModel({
    required this.name,
    required this.userId,
    required this.email,
    this.phone,
    this.address,
    this.age,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'userId': userId,
        'email': email,
        'phone': phone,
        'address': address,
        'age': age,
      };

  factory UserModel.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    print('${doc.id} from testing docId');
    return UserModel(
      name: doc.data()?['name'] ?? '',
      userId: doc.id,
      email: doc.data()?['email'] ?? '',
      phone: doc.data()?['phone'],
      address: doc.data()?['address'],
      age: doc.data()?['age'],
    );
  }

  UserModel copyWith({
    String? name,
    String? userId,
    String? email,
    String? phone,
    String? address,
    int? age,
  }) {
    return UserModel(
      name: name ?? this.name,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      age: age ?? this.age,
    );
  }

  @override
  String toString() {
    return 'UserModel{name: $name, id: $userId, email: $email, phone: $phone, address: $address, age: $age}';
  }
}
