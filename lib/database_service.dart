import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Note {
  final String id;
  final String title;
  final String content;
  final Timestamp createdTime;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdTime,
  });

  factory Note.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Note(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      createdTime: data['createdTime'] ?? Timestamp.now(),
    );
  }
}

class DataBaseService {
  static addNote(TextEditingController myTitleController,
      TextEditingController myContentController) async {
    CollectionReference notes = FirebaseFirestore.instance.collection('notes');
    await notes.add({
      'docID': '',
      'title': myTitleController.text,
      'content': myContentController.text,
      'createdTime': Timestamp.now(),
    }).then((value) => value.update({'docID': value.id}));
  }

  final CollectionReference collectionRef =
      FirebaseFirestore.instance.collection("notes");

  Future<List<Note>> readNote() async {
    try {
      List<Note> notesList = [];
      QuerySnapshot querySnapshot = await collectionRef.get();

      for (var result in querySnapshot.docs) {
        notesList.add(Note.fromFirestore(result));
      }

      return notesList;
    } catch (e) {
      debugPrint("Error - $e");
      throw e; // Propagate the error
    }
  }

  Future<void> deleteNote(String noteId) async {
    try {
      await collectionRef.doc(noteId).delete();
      debugPrint("Note $noteId deleted successfully");
    } catch (e) {
      debugPrint("Error deleting note: $e");
    }
  }

  Future<void> updateNote(String noteId, String title, String content) async {
    try {
      await collectionRef.doc(noteId).update({
        'title': title,
        'content': content,
        'updatedTime': Timestamp.now(), // Optional field to track update time
      });
      debugPrint("Note $noteId updated successfully");
    } catch (e) {
      debugPrint("Error updating note: $e");
    }
  }
}
