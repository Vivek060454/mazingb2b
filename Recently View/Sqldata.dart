import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;

class SQLHelper1 {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE itemee1(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        ide INTEGER NOT NULL,
        Image TEXT,
        title TEXT,
        price TEXT,
       
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

// id: the id of a item
// title, description: name and description of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'dbtecuhe1.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (journal)
  static Future<int> createItem(
      int ide,
      String Image,
      String title,
      String price) async {
    final db = await SQLHelper1.db();

    final data = {
      'ide': ide,
      'Image': Image,
      'title': title,
      'price': price
    };
    final id = await db.insert('itemee1', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items (journals)
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper1.db();
    return db.query('itemee1', orderBy: "id");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper1.db();
    return db.query('itemee1', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper1.db();
    try {
      await db.delete("itemee1", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}