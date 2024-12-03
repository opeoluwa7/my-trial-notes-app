import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  final String id;
  final String title;
  final String content;
  final Timestamp timestamp;

  NoteModel(
      {required this.id,
      required this.title,
      required this.content,
      required this.timestamp});

  factory NoteModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return NoteModel(
        title: map['title'],
        content: map['content'],
        id: map['id'],
        timestamp: map['timestamp']);
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'timestamp': Timestamp.now(),
      'id': id
    };
  }

  NoteModel copyWith({
    String? id,
    String? title,
    String? content,
    Timestamp? timestamp,
  }) {
    return NoteModel(
        id: id ?? this.id,
        title: title ?? this.title,
        content: content ?? this.content,
        timestamp: timestamp ?? this.timestamp);
  }
}
