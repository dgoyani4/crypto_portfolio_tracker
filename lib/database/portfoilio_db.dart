import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PortfolioDB {
  static final PortfolioDB instance = PortfolioDB._init();
  static Database? _database;

  PortfolioDB._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('portfolio.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE portfolio (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        symbol TEXT NOT NULL,
        price REAL NOT NULL,
        quantity REAL NOT NULL
      )
    ''');
  }

  Future<void> insertOrUpdateCoin(Map<String, dynamic> coin) async {
    final db = await instance.database;

    final existing = await db.query(
      'portfolio',
      where: 'id = ?',
      whereArgs: [coin['id']],
    );

    if (existing.isNotEmpty) {
      // Add to existing quantity
      final existingQty = existing.first['quantity'] as num;
      final newQty = existingQty + (coin['quantity'] as num);

      await db.update(
        'portfolio',
        {'quantity': newQty},
        where: 'id = ?',
        whereArgs: [coin['id']],
      );
    } else {
      await db.insert('portfolio', coin);
    }
  }

  Future<List<Map<String, dynamic>>> fetchPortfolio() async {
    final db = await instance.database;
    return await db.query('portfolio');
  }

  Future<void> deleteCoin(String id) async {
    final db = await instance.database;
    await db.delete('portfolio', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearPortfolio() async {
    final db = await instance.database;
    await db.delete('portfolio');
  }
}
