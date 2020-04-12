import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product({
    @required this.id,
    @required this.description,
    @required this.title,
    @required this.price,
    @required this.imageUrl,
    this.isFavourite = false, // default value is false
  });

  // > the http package only throws the error for get and post method, but not for others

  void _setFavValue(bool newValue) {
    isFavourite = newValue;
    notifyListeners();
  }

  void toogleFavouriteStatus(String token, String userId) async {
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    final url =
        'https://flutter-shop-app-5754f.firebaseio.com/userFavourite/$userId/$id.json?auth=$token';
    // this is also potismitic update, here we first store the current state in a variable and change the favourite locally  and then call the api, if api call fails then we roll back the favourite the previous state
    try {
      final response = await http.put(url,
          body: json.encode(
            isFavourite,
          ));
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
