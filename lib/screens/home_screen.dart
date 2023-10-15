import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_notes_app/services/databse_services.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController addTodosController = TextEditingController();
  TextEditingController updateTodosController = TextEditingController();
  DatabaseServices databaseServices = DatabaseServices();
  addTodos() async {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: addTodosController,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Enter Todo',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          print(addTodosController.text);
                          String todoName = addTodosController.text;
                          DateTime currentDate = DateTime.now();
                          await databaseServices.addTodosToFirebase(
                            todoName,
                            currentDate.toString(),
                          );
                          setState(() {
                            addTodosController.text = '';
                            Navigator.pop(context);
                          });
                        },
                        child: Text("Add Todo"))
                  ],
                ),
              ),
            ),
          );
        });
  }

  deleteTodo(String docId) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: const Text('Are you sure you want to delete?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  updateTodo(DocumentSnapshot documentSnapshot) {
    updateTodosController.text = documentSnapshot['todoName'];
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: updateTodosController,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Update Todo',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          print(updateTodosController.text);
                          String todoName = updateTodosController.text;
                          DateTime currentDate = DateTime.now();
                          await databaseServices.updateTodosInFirebase(
                              documentSnapshot.id,
                              todoName,
                              currentDate.toString());
                          setState(() {
                            updateTodosController.text = '';
                            Navigator.pop(context);
                          });
                        },
                        child: const Text("Update Todo"))
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Toods app"),
        backgroundColor: Colors.amberAccent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addTodos();
        },
        backgroundColor: Colors.amberAccent,
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      body: StreamBuilder(
          stream: databaseServices.fetchTodosFromFirebase(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData &&
                streamSnapshot.data!.docs.isNotEmpty) {
              return ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      child: GestureDetector(
                        onTap: () {
                          updateTodo(documentSnapshot);
                        },
                        child: Card(
                          child: ListTile(
                            title: Text(
                              documentSnapshot['todoName'],
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                debugPrint(
                                    "DocumentSnapshot: ${documentSnapshot.id}");
                                databaseServices.deleteTodosFromFirebase(
                                    documentSnapshot.id);
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            } else {
              return const Center(
                child: Text("No Todos created yet.."),
              );
            }
          }),
    );
  }
}
