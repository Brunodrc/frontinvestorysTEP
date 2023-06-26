import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/user.dart';

class DatabaseConnect {
  Database? _database;

  Future<Database> get database async {
    final dbpath = await getDatabasesPath();
    const dbname = 'user_local2';
    final path = join(dbpath, dbname);

    _database = await openDatabase(path, version: 1, onCreate: _createDB);
    return _database!;
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute(
      '''CREATE TABLE IF NOT EXISTS user_local2 (
      id TEXT PRIMARY KEY,
      name TEXT, 
      email TEXT, 
      riskProfile TEXT,
      acessToken TEXT, 
      refreshToken TEXT 
    )''',
    );
  }

  Future<void> insertUser(User user) async {
    final db = await database;

    await db.insert(
      'user_local2',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteToken(String userId) async {
    final db = await database;

    await db.delete(
      'user_local2',
      where: 'id == ?',
      whereArgs: [userId],
    );
  }

  Future<List<User>> getUsers() async {
    final db = await database;

    final List<Map<String, dynamic>> data = await db.query('user_local2');

    return List.generate(
      data.length,
      (i) => User(
        id: data[i]['id'],
        name: data[i]['name'],
        email: data[i]['email'],
        riskProfile: data[i]['riskProfile'],
        acessToken: data[i]['acessToken'],
        refreshToken: data[i]['refreshToken'],
      ),
    );
  }

  updateToken({required String userId, required String newToken}) async {
    final db = await database;
    final items = await db.rawUpdate(
      'UPDATE user_local2 SET acessToken = ? WHERE id = $userId',
      [newToken, userId],
    );
  }
}
