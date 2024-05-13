
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
 final CollectionReference toDoCollection = FirebaseFirestore.instance.collection('todos');

  Future<void> addTask(String title) async {
    try {
      await toDoCollection.add({
        'task': title,
        'isDone': false,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      log(e.toString());
    }
  }

  Future<QuerySnapshot<Object?>> getTasks() async {
   final tasks = await toDoCollection.get();

   return tasks;

   

    
    

}

  Future<void> updatetask(String id){
      return toDoCollection.doc(id).update({
        'isDone':true,
        'updatedAt': FieldValue.serverTimestamp(),
      });
   }
   Future<void> deletetask(String id){
    return toDoCollection.doc(id).delete();
   }
}