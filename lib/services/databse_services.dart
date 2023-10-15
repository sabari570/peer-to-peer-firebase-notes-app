import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseServices {
  final CollectionReference notesCollection =
      FirebaseFirestore.instance.collection('notes');

  Future addTodosToFirebase(String todoName, String timeCreated) async {
    try {
      return await notesCollection.add({
        "todoName": todoName,
        "timeCreated": timeCreated,
      });
    } catch (e) {
      debugPrint("Exception: $e");
      return null;
    }
  }

  Stream<QuerySnapshot> fetchTodosFromFirebase() {
    return notesCollection.orderBy('timeCreated').snapshots();
  }

  Future updateTodosInFirebase(
      String docID, String todoName, String timeCreated) async {
    return await notesCollection.doc(docID).update({
      "todoName": todoName,
      "timeCreated": timeCreated,
    });
  }

  deleteTodosFromFirebase(String docID) async {
    await notesCollection.doc(docID).delete();
  }
}
