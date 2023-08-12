import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/item.dart';
import '../models/wish_list.dart';

class DatabaseClient {
  //2 tables
  //1. liste de souhaits table. ex: liste informatique, liste de cadeaux (nom, id)
  //2. liste de souhaits items table. ex: ps5, clavier (nom, prix, magasin, image, id de la liste, id de l'item)
  //INTEGER, TEXT, REAL
  //INTEGER PRIMARY KEY pour id unique
  //TEXT NOT NULL

  // acceder a la DB
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return database;
    } else {
      return await createDatabase();
    }
  }

  Future<Database> createDatabase() async {
    //recuperer les dossiers dans l'application
    Directory directory = await getApplicationDocumentsDirectory();
    //Creer un chemin pour la DB
    final path = join(directory.path, "database.db");
    return await openDatabase(path, version: 1, onCreate: onCreate);
  }

  onCreate(Database database, int version) async {
    await database.execute('''
        CREATE TABLE list (
          id INTEGER PRIMARY KEY, 
          name TEXT NOT NULL
        )
      ''');
    await database.execute('''
        CREATE TABLE item (
          id INTEGER PRIMARY KEY, 
          name TEXT NOT NULL, 
          price REAL, 
          shop TEXT, 
          image TEXT, 
          list INTEGER, 
          FOREIGN KEY(list) REFERENCES list(id)
        )
      ''');
  }

  //Obtenir données
  Future<List<WishList>> allLists() async {
    //recuperer le DB
    Database db = await database;
    //faire une query ou demande
    const query = 'SELECT * FROM list';
    //recuperer les resultats
    List<Map<String, dynamic>> results = await db.rawQuery(query);
    //List<Map<String, dynamic>> results = await db.query("list");
    List<WishList> lists = [];
    results.forEach((map) {
      lists.add(WishList.fromMap(map));
    });
    //ou return results.map((map) => WishList.fromMap(map)).toList();
    return lists;
  }

  //Ajouter données
  Future<bool> addWishList(String text) async {
    //recuperer le DB
    Database db = await database;
    // inserer dans la DB
    await db.insert("list", {"name": text});
    //notifier le changement terminé
    return true;
  }

  //Upsert item
  Future<bool> upsert(Item item) async {
    //recuperer le DB
    Database db = await database;
    if (item.id == null) {
      item.id = await db.insert('item', item.toMap());
    } else {
      await db
          .update('item', item.toMap(), where: 'id = ?', whereArgs: [item.id]);
    }
    return true;
  }

  //supprimer wishlist
  Future<bool> deleteWishList(WishList wishList) async {
    //recuperer le DB
    Database db = await database;
    //supprimer dans la DB
    await db.delete("list", where: "id = ?", whereArgs: [wishList.id]);
    //supprimer aussi les items de la liste
    await db.delete("item", where: "list = ?", whereArgs: [wishList.id]);
    //notifier le changement terminé
    return true;
  }

  //Obtenir les items
  Future<List<Item>> itemFromWishlist(int id) async {
    //recuperer le DB
    Database db = await database;

    List<Map<String, dynamic>> results =
        await db.query("item", where: "list = ?", whereArgs: [id]);

    // ou const query = 'SELECT * FROM item WHERE list = ?';
    // List<Map<String, dynamic>> results = await db.rawQuery(query, [id]);

    return results.map((map) => Item.fromMap(map)).toList();
  }
}
