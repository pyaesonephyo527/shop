import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavorites;

  Product({
    required this.price,
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.isFavorites = false,
  });
void _setFavBackUp(bool newValue){
  isFavorites = newValue;
  notifyListeners();

}
  Future<void> toggleFavoriteStatus(String authToken) async {
    final oldStatus = isFavorites;
    isFavorites = !isFavorites;
    notifyListeners();
    final url = Uri.parse(
        'https://flutter-first-app-a74f4-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id?auth=$authToken');

    try {
      final response =await http.patch(url,
          body: json.encode({
            'isFavorite': isFavorites,
          }));
      if(response.statusCode >= 400){
        _setFavBackUp(oldStatus);
      }
    } catch (error) {
      _setFavBackUp(oldStatus);
    }
  }
}
