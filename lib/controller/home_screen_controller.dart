import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:shopping_cart_ui/app_config.dart';
import 'package:shopping_cart_ui/model/product_model.dart';

class HomeScreenController with ChangeNotifier{
  // bool isLoading=false;
  List categories=[];
  int Selectedcategory=0;
  List<ProductModel> productList=[];

Future<void>  getCategories() async{
  final url =Uri.parse(AppConfig.baseurl+ "products/categories");
  try{
    //  isLoading=true;
    notifyListeners();
    final response= await http.get(url);
    if(response.statusCode==200){

      categories=jsonDecode(response.body);
      categories.insert(0, "All");        // to add all into category
     

    }

  }
  catch(e){
    print(e);


  }
  // isLoading=false;
  notifyListeners();
}
Future<void>  getProducts({String? category}) async{
String endpointurl=category == null ?"products" : "products/category/$category";
final url=Uri.parse(AppConfig.baseurl+ endpointurl);
log(url.toString());
try{
  // isLoading =true;
  notifyListeners();
  final response=await http.get(url);
  if(response.statusCode==200){
    productList = productModelFromJson(response.body);
  }
 

}catch (e){
  log(e.toString());

}
// isLoading=false;
notifyListeners();

}


 
  
  


void  onCategorySelection( {required int clickedIndex}){


Selectedcategory=clickedIndex;
print(Selectedcategory);
getProducts(category: Selectedcategory==0? null:categories[Selectedcategory]);
notifyListeners();
}
  
}