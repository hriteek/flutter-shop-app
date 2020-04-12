import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/order.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = "/orders";

  // by using the FutureBuild widget we didn't have to convert this widget into Stateful widget just to have initState method to call the api
  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context); // while using the FutureBuilder and Provider like this then you are can enter in infinite loop, so you should use the Context of the Provider package to consume the data
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: Appdrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapshot.error != null) {
              return Center(
                child: Text('An error occured'),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, _) => ListView.builder(
                  itemBuilder: (ctx, i) => OrderItem(
                    orderData.orders[i],
                  ),
                  itemCount: orderData.orders.length,
                ),
              );
            }
          }
        },
      ),
    );
  }
}
