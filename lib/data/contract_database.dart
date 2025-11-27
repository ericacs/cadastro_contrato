import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ContractDatabase {
  ContractDatabase._();

  static final ContractDatabase instance = ContractDatabase._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase('contracts.db');
    return _database!;
  }

  Future<Database> _initDatabase(String fileName) async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, fileName);
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE contracts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        client_name TEXT NOT NULL,
        start_date INTEGER NOT NULL,
        end_date INTEGER NOT NULL,
        validity_months INTEGER NOT NULL,
        project_type TEXT NOT NULL,
        status TEXT NOT NULL,
        has_monitoring INTEGER NOT NULL,
        renewal_date INTEGER
      )
    ''');
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
