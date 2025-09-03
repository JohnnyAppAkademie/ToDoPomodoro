/* General Import */
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todopomodoro/src/core/database/tables.dart'
    show UserTable, TaskTable, TagTable, TaskTagTable;

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
    await UserTable.create(db);
    await TaskTable.create(db);
    await TagTable.create(db);
    await TaskTagTable.create(db);
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
