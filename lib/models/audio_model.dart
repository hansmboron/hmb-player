import 'package:cloud_firestore/cloud_firestore.dart';

class AudioModel {
  String? id;
  String? title;
  String? audio;
  String? author;

  AudioModel({
    this.id,
    this.title,
    this.audio,
    this.author,
  });

  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      'title': title,
      'audio': audio,
      'author': author,
    };
  }

  AudioModel.fromDocument(DocumentSnapshot doc) {
    id = doc.id;
    title = doc.get('title');
    audio = doc.get('audio');
    author = doc.get('author');
  }
}
