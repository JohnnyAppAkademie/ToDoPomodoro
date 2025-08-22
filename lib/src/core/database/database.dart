import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app_data.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // TASKS
    await db.execute('''
      CREATE TABLE tasks (
        db_id INTEGER PRIMARY KEY AUTOINCREMENT,
        u_id TEXT NOT NULL,
        title TEXT NOT NULL,
        duration INTEGER NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // TAGS
    await db.execute('''
      CREATE TABLE tags (
        db_id INTEGER PRIMARY KEY AUTOINCREMENT,
        u_id TEXT NOT NULL,
        title TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // TASK_TAGS (n:m Join-Tabelle)
    await db.execute('''
      CREATE TABLE task_tags (
        task_uid TEXT NOT NULL,
        tag_uid TEXT NOT NULL,
        PRIMARY KEY (task_uid, tag_uid),
        FOREIGN KEY (task_uid) REFERENCES tasks (u_id) ON DELETE CASCADE,
        FOREIGN KEY (tag_uid) REFERENCES tags (u_id) ON DELETE CASCADE
      )
    ''');

    // HISTORY
    await db.execute('''
      CREATE TABLE history (
        db_id INTEGER PRIMARY KEY AUTOINCREMENT,
        u_id TEXT NOT NULL,
        task_uid TEXT NOT NULL,
        tag_uid TEXT NOT NULL, 
        finished INTEGER NOT NULL,
        started_at TEXT NOT NULL,
        ended_at TEXT,
        FOREIGN KEY (task_uid) REFERENCES tasks (u_id)
      )
    ''');

    await db.execute('CREATE INDEX idx_history_task_uid ON history(task_uid)');
    await db.execute(
      'CREATE INDEX idx_history_started_at ON history(started_at)',
    );
    await db.execute('CREATE INDEX idx_history_finished ON history(finished)');
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
