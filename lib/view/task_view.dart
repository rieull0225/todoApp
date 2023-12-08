import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toodat_test/data/tasks.dart';
import 'package:toodat_test/model/task.dart';
import 'package:toodat_test/view/edit_view.dart';

class TaskViewController extends GetxController {
  TaskViewController();

  final box = TaskHive();
  final todos = <Task>[].obs();

  @override
  void onInit() {
    super.onInit();
    todos.clear();
    loadTodos();
  }

  Future<void> loadTodos() async {
    final List<Task> result = await box.getTasks();
    todos.addAll(result);
    index = todos.length;
    todos.sort((a, b) => a.index.compareTo(b.index));
    update();
  }

  void addTodo(Task task) async {
    todos.add(task);
    box.putTasks(todos);
    box.putLastId(await lastId() + 1);
    update();
  }

  Future<int> lastId() async {
    id = await box.getLastId();
    return id;
  }

  int index = 0;
  int id = 0;

  void reorderList(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final Task item = todos.removeAt(oldIndex);
    todos.insert(newIndex, item);
    for (int i = 0; i < todos.length; ++i) {
      todos[i].index = i;
    }
    box.putTasks(todos);
    update();
  }

  void toggleIsComplete(Task task) {
    final index = todos.indexWhere((element) => element.id == task.id);
    todos[index] = task.copyWith(isComplete: !task.isComplete);
    box.putTasks(todos);
    update();
  }

  void deleteTask(int id) async {
    todos.removeWhere((task) => task.id == id);
    box.putTasks(todos);
    update();
  }

  void updateTask(int id, String title) {
    int index = todos.indexWhere((task) => task.id == id);
    todos[index].name = title;
    box.putTasks(todos);
    update();
  }
}

class TaskView extends StatelessWidget {
  const TaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskViewController>(
        init: TaskViewController(),
        builder: (controller) {
          return DefaultTabController(
            length: 2,
            child: SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  title: const Text('Todo'),
                  bottom: const TabBar(
                    tabs: [
                      Tab(text: '할 일', icon: Icon(Icons.watch_later_outlined)),
                      Tab(text: '한 일', icon: Icon(Icons.done)),
                    ],
                  ),
                  actions: [
                    IconButton(
                      onPressed: () async {
                        int id = await controller.lastId();
                        controller.addTodo(Task(controller.todos.length, "$id번째 task", id, false));
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                body: TabBarView(children: [
                  _buildTaskCards(context, controller.todos.toList(), false),
                  _buildTaskCards(context, controller.todos.toList(), true)
                ]),
              ),
            ),
          );
        });
  }

  Widget _buildTaskCards(context, List<Task> tasks, bool isComplete) {
    final controller = Get.find<TaskViewController>();
    return ReorderableListView.builder(
      itemCount: tasks.length,
      itemBuilder: (_, index) {
        final task = tasks[index].obs;
        return isComplete == task.value.isComplete
            ? _buildTaskCard(context, task.value)
            : Container(
                key: Key("${task.value.id}"),
              );
      },
      onReorder: (int oldIndex, int newIndex) {
        controller.reorderList(oldIndex, newIndex);
      },
    );
  }

  Widget _buildTaskCard(context, Task task) {
    final controller = Get.find<TaskViewController>();
    return Padding(
      key: Key("${task.id}"),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 0.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              Text(task.name),
              const Spacer(),
              GestureDetector(
                onTap: () async {
                  var value = await Get.to(
                    EditView(task: task),
                  );
                  controller.updateTask(task.id, value);
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.4),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
                    child: Text("수정"),
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              GestureDetector(
                onTap: () => controller.toggleIsComplete(task),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.4),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
                    child: Text(task.isComplete ? "진행하기" : "완료하기"),
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              GestureDetector(
                onTap: () => controller.deleteTask(task.id),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.4),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
                    child: Text("삭제"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
