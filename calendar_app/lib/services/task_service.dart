import 'package:calendar_app/models/task.dart';
import 'package:sqflite/sqflite.dart';

class TaskService {
  static const String tableTask = "tasks";
  static const String columnId = "_id";
  static const String columnTitle = "title";
  static const String columnNote = "note";
  static const String columnDate = "date";
  static const String columnStartTime = "start_time";
  static const String columnEndTime = "end_time";
  static const String columnColor = "color";
  static const String columnCompleted = "completed";

  late Database db;

  Future open(String path, {int databaseVersion = 1}) async {
    db = await openDatabase(
      path,
      version: databaseVersion,
      onCreate: (Database db, int version) async {
        String tableQuery = 'CREATE TABLE $tableTask (';
        tableQuery += ' $columnId INTEGER PRIMARY KEY AUTOINCREMENT';
        tableQuery += ' $columnTitle TEXT NOT NULL' '$columnNote TEXT';
        tableQuery += ' $columnDate INTEGER';
        tableQuery += ' $columnStartTime INTEGER';
        tableQuery += ' $columnEndTime INTEGER';
        tableQuery += ' $columnColor INTEGER';
        tableQuery += ' $columnCompleted INTEGER';
        tableQuery += ')';

        await db.execute(tableQuery);
      },
    );
  }

  Future<Task> insert(Task task) async {
    task.id = await db.insert(tableTask, task.toMap());
    return task;
  }

  Future<List<Task>> getAll() async {
    List<Map<String, Object?>> maps = await db.query(tableTask);

    if (maps.isNotEmpty) {
      return maps.map((m) => Task.fromMap(m)).toList();
    }

    return [];
  }

  Future<Task?> getById(int id) async {
    List<Map<String, Object?>> maps = await db.query(
      tableTask,
      where: '$columnId = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) return Task.fromMap(maps.first);

    return null;
  }

  Future<int> delete(int id) async {
    return await db.delete(
      tableTask,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<int> update(Task task) async {
    return await db.update(
      tableTask,
      task.toMap(),
      where: '$columnId = ?',
      whereArgs: [task.id],
    );
  }

  Future close() async => db.close();
}
