import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDb {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await intialDb();
      return _db;
    } else {
      return _db;
    }
  }

  intialDb() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'qs.db');
    Database mydb = await openDatabase(path, onCreate: _onCreate, version: 5, onUpgrade: _onUpgrade);
    return mydb;
  }

  _onUpgrade(Database db, int oldversion, int newversion) {
    print("onUpgrade =====================================");
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
  CREATE TABLE "favorites" (
    "id" INTEGER  NOT NULL PRIMARY KEY  AUTOINCREMENT,
      "img" INTEGER NOT NULL,
      "name" TEXT NOT NULL
 

      
    


  )
 ''');
    await db.execute('''
  CREATE TABLE "mood" (
    "id" INTEGER  NOT NULL PRIMARY KEY  AUTOINCREMENT,
      "status" INTEGER NOT NULL,
       "colum" INTEGER NOT NULL
      
 

      
    


  )
 ''');
     await db.execute('''
  CREATE TABLE "ads" (
    "id" INTEGER  NOT NULL PRIMARY KEY  AUTOINCREMENT,
      "status" INTEGER NOT NULL
     
      
 

      
    


  )
 ''');

    print(" onCreate =====================================");
  }

  readData(String sql) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql);
    return response;
  }

  insertData(String sql) async {
    Database? mydb = await db;

    int response = await mydb!.rawInsert(sql);
    return response;
  }

  updateData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }

  deleteData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }

  rawQuery(String sql, List<String> list) {}

  batch() {}

// SELECT
// DELETE
// UPDATE
// INSERT
}
