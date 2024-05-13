import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:to_do_project/firebase_service.dart';

class Complete extends StatefulWidget {
  const Complete({super.key});

  @override
  State<Complete> createState() => _CompleteState();
}

class _CompleteState extends State<Complete> {
  List<QueryDocumentSnapshot> items = [];

  getData() async {
    FirebaseService firebaseService = FirebaseService();
    QuerySnapshot data = await firebaseService.getTasks();
    List<QueryDocumentSnapshot> newItems = [];
    for (var info in data.docs) {
      if (info['isDone'] == true) {
        newItems.add(info);
      }
    }

    setState(() {
      items = newItems;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // extendBodyBehindAppBar: true,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Colors.black54,
          title: const Text('To Do App'),
        ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(15),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black45,
              ),
              child: const Text(
                'Completed Tasks',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  // shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = items[index];
                    String id = document.id;
                    FirebaseService firebaseService = FirebaseService();
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey[600],
                        child: Text("${index + 1}"),
                      ),
                      title: Text(items[index]['task']),
                      contentPadding: const EdgeInsets.all(10),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              firebaseService.deletetask(id);
                              getData();
                            },
                            color: Colors.red,
                          ),
                        ],
                      ),
                    );
                  }),
            )
          ],
        ));
  }
}


