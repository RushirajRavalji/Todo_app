import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:_2_todo_app/data/database.dart';
import 'package:_2_todo_app/util/dialog_box.dart';
import 'package:_2_todo_app/util/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Reference the hive box
  late Box _myBox;

  // Initialize the TextEditingController
  final TextEditingController _controller = TextEditingController();

  // Create an instance of TodoDataBase
  TodoDataBase db = TodoDataBase();

  @override
  void initState() {
    super.initState();
    _initializeBox();
  }

  // Open the Hive box asynchronously
  Future<void> _initializeBox() async {
    _myBox = await Hive.openBox('myBox');
    db.loadData(); // Load tasks from Hive when the app starts
    setState(() {});
  }

  // Checkbox tapped
  void checkedBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = value ?? false;
      db.saveData(); // Save data to Hive after a task's state is changed
    });
  }

  // Save new task
  void saveNewTask() {
    setState(() {
      db.toDoList.add([_controller.text, false]);
      db.saveData(); // Save data to Hive after adding a task
    });
    Navigator.of(context).pop();
  }

  // Create new task
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  // Delete task
  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
      db.saveData(); // Save data to Hive after deleting a task
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[200],
      appBar: AppBar(
        title: const Text(
          "To-Do",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        toolbarHeight: 80,
        elevation: 10,
        shadowColor: Colors.deepPurpleAccent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        backgroundColor: Colors.deepPurple,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: db.toDoList.isEmpty
          ? Center(
              child: Text(
                'No tasks yet!',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: db.toDoList.length,
              itemBuilder: (context, index) {
                return TodoTile(
                  taskName: db.toDoList[index][0],
                  taskCompleted: db.toDoList[index][1],
                  onChanged: (value) => checkedBoxChanged(value, index),
                  deleteFunction: (context) => deleteTask(index),
                );
              },
            ),
    );
  }
}
