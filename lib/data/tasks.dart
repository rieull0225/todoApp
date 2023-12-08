import 'package:hive/hive.dart';
import 'package:toodat_test/model/task.dart';


class TaskHive{

  Future<Box<Task>> get taskBox async => await Hive.openBox('tasks');
  Future<Box<int>> get idBox async => await Hive.openBox('id');

  Future<void> putTasks(List<Task> tasks) async {
    final box = await taskBox;
    box.clear();
    for(Task task in tasks){
      box.put(task.id, task);
    }
  }

  Future<List<Task>> getTasks() async {
    final box = await taskBox;
    return box.values.toList();
  }

  void putLastId(int id) async {
    final box = await idBox;
    box.put('id', id);
  }

  Future<int> getLastId() async {
    final box = await idBox;
    return box.get('id') ?? 0;
  }
}