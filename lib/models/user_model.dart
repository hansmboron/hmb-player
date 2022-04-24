import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? name;
  String? email;
  String? photoUrl;

  UserModel({this.uid, this.name, this.email, this.photoUrl});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      photoUrl: map['photoUrl'],
    );
  }

  UserModel.fromDocument(DocumentSnapshot doc) {
    uid = doc.id;
    name = doc.get('name');
    email = doc.get('email');
    photoUrl = doc.get('photoUrl');
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
