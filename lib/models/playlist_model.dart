import 'package:cloud_firestore/cloud_firestore.dart';

class PlaylistModel {
  String? id;
  String? title;
  String? icon;

  PlaylistModel({
    this.id,
    this.title,
    this.icon,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'icon': icon,
    };
  }

  PlaylistModel.fromDocument(DocumentSnapshot doc) {
    id = doc.id;
    title = doc.get('title');
    icon = doc.get('icon');
  }
}
