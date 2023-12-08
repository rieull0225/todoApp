import 'package:hive/hive.dart';

part "task.g.dart";

@HiveType(typeId: 0)
class Task {

  @HiveField(0)
  int index;
  @HiveField(1)
  String name;

  @HiveField(2)
  int id;

  @HiveField(3)
  bool isComplete;
  Task(this.index, this.name, this.id, this.isComplete);

  Task copyWith({int? index, int? id, String? name, bool? isComplete}) {
    return Task(
      index ?? this.index,
      name ?? this.name,
      id ?? this.id,
      isComplete ?? this.isComplete,
    );
  }
}