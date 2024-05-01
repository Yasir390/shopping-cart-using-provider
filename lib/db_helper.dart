import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shopping_cart/cart_model.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;

class DbHelper{

  static Database? _db;

  Future<Database?> get db async{
    if(_db != null){
      return _db!;
    }
   return  _db = await initDatabase();
  }

 Future<Database> initDatabase() async{
   io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path =  join(documentDirectory.path,'cart.db'); //database name
    var db = await openDatabase(path,version: 1,onCreate: _onCreate);
    return db;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE cart (
      id INTEGER PRIMARY KEY,
      productId VARCHAR UNIQUE,
      productName TEXT,
      initialPrice INTEGER, 
      productPrice INTEGER ,
      quantity INTEGER,
      unitTag TEXT , 
      image TEXT 
      )''');
  }

 Future<int> insert(CartModel cartModel)async{
    print(cartModel.toMap());
    var dbClient = await db;
   return  await dbClient!.insert('cart',cartModel.toMap());
  }

  Future<List<CartModel>> getCartList()async{
    var dbClient = await db;
    final List<Map<String,Object? >> queryResult = await dbClient!.query('cart');
   return queryResult.map((e) => CartModel.fromMap(e)).toList();
  }

  Future<int> deleteItem(int id)async{
    var dbClient = await db;
   return await dbClient!.delete(
     'cart',
     where: 'id = ?',
     whereArgs: [id]
   );
  }

  Future<int> updateQuantity(CartModel cartModel)async{
    var dbClient = await db;
   return await dbClient!.update(
     'cart',
     cartModel.toMap(),
     where: 'id = ?',
     whereArgs: [cartModel.id]
   );
  }
}