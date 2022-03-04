import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'main.dart';

class SQLiteDbProvider {
  SQLiteDbProvider._();

  static final SQLiteDbProvider db = SQLiteDbProvider._();
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDB();
    return _database;
  }

  final data = [
    {
      'title': 'Anh Đếch Cần Gì Nhiều Ngoài Em',
      'desc': 'Đen, Vũ',
      'coverUrl': 'assets/Anh Dech Can Gi Nhieu Ngoai Em - Den_ Vu.jpg',
    },
    {
      'title': 'Cảm ơn',
      'desc': 'Đen, Biên',
      'coverUrl': 'assets/Cam On - Den_ Bien.jpg',
    },
    {
      'title': 'Cho Tôi Lang Thang',
      'desc': 'Ngọt, Đen',
      'coverUrl': 'assets/Cho Toi Lang Thang - Ngot_ Den.jpg',
    },
    {
      'title': 'Đi Về Nhà',
      'desc': 'Đen, JustaTee',
      'coverUrl': 'assets/Di Ve Nha - Den_ JustaTee.jpg',
    },
    {
      'title': 'Hai Triệu Năm',
      'desc': 'Đen, Biên',
      'coverUrl': 'assets/Hai Trieu Nam - Den_ Bien.jpg',
    },
    {
      'title': 'một triệu like',
      'desc': 'Đen, Thành Đồng',
      'coverUrl': 'assets/Mot Trieu Like - Den_ Thanh Dong.jpg',
    },
    {
      'title': 'Tình Đắng Như Ly Cà Phê',
      'desc': 'Nân, Ngơ',
      'coverUrl': 'assets/Tinh Dang Nhu Ly Ca Phe - Nan_ Ngo.jpg',
    },
    {
      'title': 'Trời hôm nay nhiều mây cực!',
      'desc': 'Đen',
      'coverUrl': 'assets/Troi Hom Nay Nhieu May Cuc_ - Den.jpg',
    },
  ];

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "ItemDB.db");
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute("CREATE TABLE Item ("
            "id INTEGER PRIMARY KEY,"
            "title TEXT,"
            "desc TEXT,"
            "coverUrl TEXT,"
            "rating INTEGER"
            ")");

        for (var element in data) {
          await db.execute(
              "INSERT INTO Item ('id', 'title', 'desc', 'coverUrl', 'rating') values (?, ?, ?, ?, ?)",
              [
                data.indexOf(element),
                element['title'],
                element['desc'],
                element['coverUrl'],
                0
              ]);
        }
      },
    );
  }

  Future<List<Item>> getItems() async {
    final db = await database;
    List<Map> results =
        await db!.query("Item", columns: Item.columns, orderBy: "id ASC");

    List<Item> items = [];
    for (var result in results) {
      Item item = Item.fromMap(result);
      items.add(item);
    }
    return items;
  }

  Future<Item?> getItemById(int id) async {
    final db = await database;
    var result = await db!.query("Item", where: "id = ", whereArgs: [id]);
    return result.isNotEmpty ? Item.fromMap(result.first) : null;
  }

  insert(Item item) async {
    final db = await database;
    var maxIdResult =
        await db!.rawQuery("SELECT MAX(id)+1 as last_inserted_id FROM Item");

    var id = maxIdResult.first["last_inserted_id"];
    var result = await db.rawInsert(
        "INSERT INTO Item ('id', 'title', 'desc', 'coverUrl', 'rating') VALUES (?, ?, ?, ?, ?)",
        [id, item.title, item.desc, item.coverUrl, item.rating]);
    return result;
  }

  update(Item item) async {
    final db = await database;
    var result = await db!
        .update("Item", item.toMap(), where: "id = ?", whereArgs: [item.id]);
    return result;
  }

  delete(int id) async {
    final db = await database;
    db!.delete("Item", where: "id = ?", whereArgs: [id]);
  }
}
