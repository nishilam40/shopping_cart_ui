

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class CartScreenController with ChangeNotifier{
 static late Database database;
 List <Map> cartItems=[];
 double totalPrice=0.0;
 
  Future<void> initDb() async {
    if (kIsWeb) {
  // Change default factory on the web
  databaseFactory = databaseFactoryFfiWeb;
    }
    database=await openDatabase("cart.db",
    version: 1,
     onCreate: (Database db, int version) async {
      
     
  // When creating the db, create the table
  await db.execute(
      'CREATE TABLE Cart (id INTEGER PRIMARY KEY, name TEXT, qty INTEGER, price REAL,image TEXT,des Text,productId INTEGER)');
},
);

  }
  
   Future addItem({
    required BuildContext context,
    required int productId,
    required String name,
    required String des,
    required String imageUrl,
    required double price ,
    })
   
    

   
   
   async {
    await getAllItems();
    log("initial :"+ cartItems.toString());
    bool alreadyIncart =false;
    for(int i=0; i< cartItems.length;i++){
      if(cartItems[i]["productId"]==productId){
        alreadyIncart=true;
        log(alreadyIncart.toString());
      }
    }
    log("already in cart = " + alreadyIncart.toString());

    if(alreadyIncart==false){
   
   await database.rawInsert(
     'INSERT INTO Cart (name, qty, price, image, des,productId ) VALUES(?, ?, ?, ?, ?, ?)',
      [name,1,price,imageUrl,des,productId]);
      
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text("item added to the cart"),
      ));
    } else{
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text("Alreay in cart"),
      ));
    }
      await getAllItems();
  } 
   Future getAllItems() async{
   cartItems = await database.rawQuery('SELECT * FROM Cart');
    log(cartItems.toString());
    calculateTotal();
    notifyListeners();

   }
    removeAnItem( int id) async {
      await database.rawDelete('DELETE FROM Cart WHERE id = ?', [id]);
      getAllItems();
      notifyListeners();
    }
    decrementQty(int qty, int id) async {
      if(qty>=2){
        qty--;
      await database.rawUpdate(
    'UPDATE Cart SET qty = ? WHERE id = ?',
    [qty,id]);
      }
    }
   incrementQty(int qty,int id) async {
    qty++;
     await database.rawUpdate(
    'UPDATE Cart SET qty = ? WHERE id = ?',
    [qty,id]);

   }
   void calculateTotal(){
    totalPrice=0;
    for(int i=0; i<cartItems.length;i++){
      double currentItemprice =cartItems[i]["price"] * cartItems[i]["qty"];
      totalPrice =totalPrice+currentItemprice;
    }
    notifyListeners();
   }

  
  }

