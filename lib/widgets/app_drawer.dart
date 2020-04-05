import 'package:flutter/material.dart';

import '../screens/orders_screen.dart';

class Appdrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hell Friends'),
            automaticallyImplyLeading:
                false, // this will not add the back button
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () {
              Navigator.of(context).pushNamed("/");
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () {
              Navigator.of(context).pushNamed(
                OrdersScreen.routeName,
              );
            },
          ),
        ],
      ),
    );
  }
}