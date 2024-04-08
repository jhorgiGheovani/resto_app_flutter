import 'package:resto_app/data/model/restaurant_list_item.dart';
import 'package:sqflite/sqflite.dart';

class SqLiteDatabaseHelper {
  static SqLiteDatabaseHelper? _instance;
  static Database? _database;

  SqLiteDatabaseHelper._internal() {
    _instance = this;
  }

  factory SqLiteDatabaseHelper() =>
      _instance ?? SqLiteDatabaseHelper._internal();

  static const String _tabelFavorite = 'favorite';

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();

    var db = openDatabase(
      '$path/restaurantapp.db',
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $_tabelFavorite (
             id TEXT PRIMARY KEY,
             name TEXT,
             description TEXT,
             pictureId TEXT,
             city TEXT,
             rating REAL
           )     
        ''');
      },
      version: 1,
    );

    return db;
  }

  Future<Database?> get database async {
    _database ??= await _initializeDb();

    return _database;
  }

  Future<void> insertFavoriteResto(RestaurantListItem restaurant) async {
    final db = await database;
    await db!.insert(_tabelFavorite, restaurant.toJson());
  }

  Future<List<RestaurantListItem>> getFavoriteResto() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db!.query(_tabelFavorite);

    return results.map((res) => RestaurantListItem.fromJson(res)).toList();
  }

  Future<Map> getFavoriteById(String id) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db!.query(
      _tabelFavorite,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return {};
    }
  }

  Future<void> removeFavoriteResto(String id) async {
    final db = await database;

    await db!.delete(
      _tabelFavorite,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
