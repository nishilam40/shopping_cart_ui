import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:shopping_cart_ui/app_config.dart';
import 'package:shopping_cart_ui/model/product_model.dart';

class ProductDetailspageController with ChangeNotifier{
  ProductModel? selectedProduct;
  bool isLoading=false;
  getProductdetails(String productId) async {
    final url=Uri.parse(AppConfig.baseurl+"products/$productId");
    try{
      isLoading=true;
     notifyListeners();
      final response=await http. get(url);
      if(response.statusCode==200);{
        selectedProduct=ProductModel.fromJson(jsonDecode(response.body));
      }


    }catch(e){
      print(e);
    }
    isLoading =false;
    notifyListeners();
    
  }
}