import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:razorpay_web/razorpay_web.dart';
import 'package:shopping_cart_ui/controller/cart_screen_controller.dart';

import 'package:shopping_cart_ui/view/cart_screen/widgets/cart_item_widget.dart';
import 'package:shopping_cart_ui/view/home_screen/home_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) async {
    await context.read<CartScreenController>().getAllItems();
    
   });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cartscreenProvider=context.watch<CartScreenController>();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Cart"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return CartItemWidget(
                    title: cartscreenProvider.cartItems[index]["name"],
                    desc: cartscreenProvider.cartItems[index]["price"].toString(),
                    qty: cartscreenProvider.cartItems[index]["qty"].toString(), 
                    image:
                        cartscreenProvider.cartItems[index]["image"],
                    onIncrement: () {
                      context.read<CartScreenController>().incrementQty(
                       cartscreenProvider.cartItems[index]["qty"],
                        cartscreenProvider.cartItems[index]["id"],
                       );
                    },
                    onDecrement: () {
                      context.read<CartScreenController>().decrementQty(
                       cartscreenProvider.cartItems[index]["qty"],
                        cartscreenProvider.cartItems[index]["id"],
                       );
                      
                    },
                    onRemove: () async {
                     await context.read<CartScreenController>().removeAnItem(cartscreenProvider.cartItems[index]["id"]);
                    },
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 15),
                itemCount: cartscreenProvider.cartItems.length)),
                bottomNavigationBar: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                       color: Colors.black,

                    ),
                    height: 70,
                   
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Text("Total price:",style: TextStyle(fontSize: 18,color: Colors.white),),
                               Text("${cartscreenProvider.totalPrice.toStringAsFixed(2)}",style: TextStyle(fontSize: 18,color: Colors.white),)
                            ],
                            
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(onPressed: (){
                             Razorpay razorpay = Razorpay();
                  var options = {
                    'key': 'rzp_test_1DP5mmOlF5G5ag',
                    'amount': cartscreenProvider.totalPrice * 100,
                    'name': 'Acme Corp.',
                    'description': 'Fine T-Shirt',
                    'retry': {'enabled': true, 'max_count': 1},
                    'send_sms_hash': true,
                    'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
                    'external': {
                      'wallets': ['paytm']
                    }
                  };
                  razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
                  razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
                  razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
                  razorpay.open(options);
                          }, child: Text("Pay Now")),
                        )
                      ],
                    ),
                  ),
                ),
      ),
    );
  }
   void handlePaymentErrorResponse(PaymentFailureResponse response){
   
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */
    showAlertDialog(context, "Payment Failed", "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response){
    /*

    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */
     Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context)=>HomeScreen(),
    ),(route)=>false,
    );
    showAlertDialog(context, "Payment Successful", "Payment ID: ${response.paymentId}");
  }

  void handleExternalWalletSelected(ExternalWalletResponse response){
    showAlertDialog(context, "External Wallet Selected", "${response.walletName}");
  }
  void showAlertDialog(BuildContext context, String title, String message){
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed:  () {},
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
