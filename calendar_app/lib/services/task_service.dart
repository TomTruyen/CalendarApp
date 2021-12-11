import 'package:calendar_app/models/task.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TaskService {
  static const String _databaseName = "calendar_app.db";
  static const int _databaseVersion = 1;
  static const String tableTask = "tasks";

  static const String columnId = "_id";
  static const String columnTitle = "title";
  static const String columnNote = "note";
  static const String columnDate = "date";
  static const String columnStartTime = "start_time";
  static const String columnEndTime = "end_time";
  static const String columnColor = "color";
  static const String columnCompleted = "completed";

  // Singleton class
  TaskService._privateConstructor();
  static final TaskService instance = TaskService._privateConstructor();

  // App-wide reference to database
  static Database? _database;
  Future<Database> get database async {
    return _database ??= await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableTask (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnTitle TEXT NOT NULL,
        $columnNote TEXT,
        $columnDate INTEGER,
        $columnStartTime INTEGER,
        $columnEndTime INTEGER,
        $columnColor INTEGER,
        $columnCompleted INTEGER
      )
    ''');
  }

  Future<Task> insert(Task task) async {
    Database db = await instance.database;
    task.id = await db.insert(tableTask, task.toMap());
    return task;
  }

  Future<List<Task>> getAll() async {
    Database db = await instance.database;

    List<Map<String, Object?>> maps = await db.query(tableTask);

    if (maps.isNotEmpty) {
      return maps.map((m) => Task.fromMap(m)).toList();
    }

    return [];
  }

  Future<Task?> getById(int id) async {
    Database db = await instance.database;

    List<Map<String, Object?>> maps = await db.query(
      tableTask,
      where: '$columnId = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) return Task.fromMap(maps.first);

    return null;
  }

  Future<List<Task>> getByDate(DateTime date) async {
    // Get start of day (midnight)
    int start = DateTime(
      date.year,
      date.month,
      date.day,
    ).millisecondsSinceEpoch;

    // Get last possible moment of day
    int end = DateTime(
      date.year,
      date.month,
      date.day,
      23,
      59,
      59,
      999,
      999,
    ).millisecondsSinceEpoch;

    Database db = await instance.database;

    List<Map<String, Object?>> maps = await db.rawQuery(
      '''
        SELECT * FROM $tableTask
        WHERE $columnDate >= $start
        AND $columnDate <= $end
      ''',
    );

    if (maps.isNotEmpty) {
      return maps.map((m) => Task.fromMap(m)).toList();
    }

    return [];
  }

  Future<int> delete(int? id) async {
    Database db = await instance.database;

    return await db.delete(
      tableTask,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<int> update(Task task) async {
    Database db = await instance.database;

    return await db.update(
      tableTask,
      task.toMap(),
      where: '$columnId = ?',
      whereArgs: [task.id],
    );
  }

  Future close() async {
    Database db = await instance.database;

    db.close();
  }
}
