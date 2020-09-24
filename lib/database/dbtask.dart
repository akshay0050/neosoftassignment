import 'dart:convert';

import 'package:idb_shim/idb.dart';
import 'package:idb_shim/idb_browser.dart';
import 'package:neosoftassignment/models/brewery_models.dart';

class DbTask {
  Database _db;
  String dbName = 'brewerydata';
  IdbFactory idbFactory;
  static const String storeName = "breweryrecords";
  static const String TITLE_INDEX = 'titleIndex';

  Future<Database> open() {
    this.idbFactory = getIdbFactory();
    return idbFactory.open(dbName, version: 1, onUpgradeNeeded: _initDb);
    //.then((value) => loadDb);
  }

  void _initDb(VersionChangeEvent event) {
    Database db = event.database;
    // create the store
    var store = db.createObjectStore(storeName, autoIncrement: true);
    store.createIndex(TITLE_INDEX, 'title', unique: true);
  }

//  Future<Database> loadDb(Database db) {
//    _db = db;
//    return  db;
//  }

  Future insertData(BreweryModel breweryModel, Database db) async {
    var txn = db.transaction(storeName, "readwrite");
    var store = txn.objectStore(storeName);
    var request = await store.put(breweryModel.toJson());
    //print("insertData req - ${request.toString()}");
    return await txn.completed;
  }

  Future<List<BreweryModel>> getData(Database db) async {
    List<BreweryModel> breweryList = new List();
    var txn = db.transaction(storeName, "readwrite");
    var store = txn.objectStore(storeName);
    Stream<CursorWithValue> cursorRequest =
        store.openCursor(direction: idbDirectionPrev, autoAdvance: true);

//       cursorRequest.forEach((element) async{
//      // print("data value - ${element.value}");
//      breweryList.add(new BreweryModel.fromJson(element.value));
//      print("breweryList count - ${breweryList.length}");
//       });
      await for(var element in cursorRequest) {
         breweryList.add(new BreweryModel.fromJson(element.value));
       }
   // print("breweryList count - ${breweryList.length}");
    return breweryList;
  }
}
