import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'location.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE location(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        latitude TEXT,
        longitude TEXT
      )
    ''');
  }

  Future<int> insertLocation(String latitude, String longitude) async {
    Database db = await database;
    return await db.insert('location', {
      'latitude': latitude,
      'longitude': longitude,
    });
  }

  Future<List<Map<String, dynamic>>> getLocations() async {
    Database db = await database;
    return await db.query('location');
  }
}
