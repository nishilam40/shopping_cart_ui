import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart_ui/controller/cart_screen_controller.dart';
import 'package:shopping_cart_ui/controller/home_screen_controller.dart';
import 'package:shopping_cart_ui/controller/product_details_screen.dart';
import 'package:shopping_cart_ui/view/cart_screen/cart_screen.dart';

import 'package:shopping_cart_ui/view/home_screen/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

 await CartScreenController().initDb();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (create)=>HomeScreenController()
        ),
         ChangeNotifierProvider(create: (create)=>ProductDetailspageController()
        ),
         ChangeNotifierProvider(create: (create)=>CartScreenController()
         )
        ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}