import 'package:todopomodoro/src/core/data/repository.dart';
import 'package:todopomodoro/src/core/data/task.dart';

class TaskRepository implements Repository<Task> {
  final List<Task> _tasks = [];

  @override
  Future<List<Task>> getAll() async => _tasks;

  @override
  Future<void> add(Task task) async {
    _tasks.add(task);
  }

  @override
  Future<void> update(Task updatedTask) async {
    final index = _tasks.indexWhere((t) => t.uID == updatedTask.uID);
    if (index != -1) {
      _tasks[index] = updatedTask;
    } else {
      return;
    }
  }

  @override
  Future<void> delete(String uID) async {
    _tasks.removeWhere((t) => t.uID == uID);
  }
}
