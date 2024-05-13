import 'dart:developer';

// import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:to_do_project/firebase_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {


  List<QueryDocumentSnapshot> items = [];
  getData() async {
  FirebaseService firebaseService = FirebaseService();
   QuerySnapshot data = await firebaseService.getTasks();
   List<QueryDocumentSnapshot> newItems = [];
   for (var info in data.docs) {
     if(info['isDone'] == false){
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                const Text('To Do App'),
              IconButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue[400]),
                ),
                icon: const Text("Completed "),
                onPressed: () {
                  Navigator.pushNamed(context, '/complete');
                }, 
              ),
            ],
          ),
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
                'To Do Tasks',
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
                        backgroundColor: const Color.fromRGBO(117, 117, 117, 1),
                        child: Text("${index + 1}"),
                      ),
                      title: Text(items[index]['task']),
                      contentPadding: const EdgeInsets.all(10),
                      trailing:  Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check_circle_rounded),
                            onPressed: (){
                              firebaseService.updatetask(id);
                              getData();
                            },
                            color: Colors.green,
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: (){
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
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _dialogBuilder(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Icon(Icons.add),
        ));
  }
  Future<void> _dialogBuilder(BuildContext context) {
  final TextEditingController textFieldController = TextEditingController();
  final FirebaseService firebaseService = FirebaseService();
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Add New Task'),
        content: TextField(
          controller: textFieldController,
          decoration: const InputDecoration(
            hintText: 'Enter Task',
          ),
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.bodyLarge,
            ),
            child: const Text('Add Task'),
            onPressed: () {

              firebaseService.addTask(textFieldController.text);
              getData();
              log(textFieldController.text);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
}





