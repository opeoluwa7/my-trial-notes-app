import 'package:cloud_firestore/cloud_firestore.dart';

class Notes {
  final String id;
  final String title;
  final String content;
  final Timestamp timestamp;

  Notes({required this.id, required this.title, required this.content, required this.timestamp});

  factory Notes.fromMap(Map<String, dynamic> map, String documentId) {
    return Notes(
        title: map['title'],
        content: map['content'],
        id: documentId,
        timestamp: map['timestamp']);
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'timestamp': Timestamp.now()
    };
  }
}
