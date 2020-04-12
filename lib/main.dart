import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/products.dart';
import './providers/cart.dart';
import './providers/order.dart';
import './providers/auth.dart';

import './screens/Product_detail_screen.dart';
import './screens/cart_screen.dart';
import './screens/splash_screen..dart';
import './screens/products_overview_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_product_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      //MultiProvider is the function that takes list of Provider as providers
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        // builder: (ctx) => Products(), // if your provider doesn't depends on context then you can use value syntax of the ChangeNotifierProvider
        ChangeNotifierProxyProvider<Auth, Products>(
          // we need to use this type of the Provider if we want to provide a value from different provider into another provider : But we have to define Auth provider before the Products provider to use the Auth provider value inside the products provider
          builder: (ctx, auth, previousProduct) => Products(
            auth.token,
            auth.userId,
            previousProduct == null ? [] : previousProduct.items,
          ),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          builder: (ctx, auth, previousOrders) => Orders(
            auth.token,
            auth.userId,
            previousOrders == null ? [] : previousOrders.orders,
          ),
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: "Shop App",
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          debugShowCheckedModeBanner: false,
          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authScreenSnapsort) =>
                      authScreenSnapsort.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductScreen.routeName: (ctx) => UserProductScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
