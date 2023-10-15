import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController addTodosController = TextEditingController();
  TextEditingController updateTodosController = TextEditingController();

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
                          borderSide: BorderSide(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes app"),
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
      body: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: GestureDetector(
                onTap: () {},
                child: Card(
                  child: ListTile(
                    title: const Text(
                      "<Name of the notes>",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
