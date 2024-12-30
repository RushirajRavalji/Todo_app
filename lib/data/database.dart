import 'package:hive/hive.dart';

class TodoDataBase {
  List toDoList = [];

  // Reference to the Hive box
  final _myBox = Hive.box('myBox');

  // Create initial data (for first-time app use)
  void createInitialData() {
    toDoList = [
      ["Complete tasks", false],
      ["Do Exercise", false]
    ];
  }

  // Load data from Hive
  void loadData() {
    List storedData = _myBox.get('TODOLIST', defaultValue: []);
    toDoList = List<List<dynamic>>.from(storedData);
  }

  // Save data to Hive
  void saveData() {
    _myBox.put('TODOLIST', toDoList);
  }
}
