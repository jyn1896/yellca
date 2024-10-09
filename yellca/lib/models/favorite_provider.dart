import 'package:flutter/material.dart';

class FavoriteProvider with ChangeNotifier {
  List<String> _favorites = []; // 즐겨찾기 장소 목록
  List<String> _favoriteRoutes = []; // 즐겨찾기 경로 목록

  List<String> get favorites => _favorites;
  List<String> get favoriteRoutes => _favoriteRoutes; // 추가된 getter

  bool isFavorite(String place) => _favorites.contains(place);
  bool isFavoriteRoute(String route) => _favoriteRoutes.contains(route); // 추가된 메소드

  void toggleFavorite(String place) {
    if (_favorites.contains(place)) {
      _favorites.remove(place);
    } else {
      _favorites.add(place);
    }
    notifyListeners();
  }

  void toggleFavoriteRoute(String route) { // 추가된 메소드
    if (_favoriteRoutes.contains(route)) {
      _favoriteRoutes.remove(route);
    } else {
      _favoriteRoutes.add(route);
    }
    notifyListeners();
  }

  void addFavorite(String place) {
    if (!_favorites.contains(place)) {
      _favorites.add(place);
      notifyListeners();
    }
  }

  void removeFavorite(String place) {
    if (_favorites.contains(place)) {
      _favorites.remove(place);
      notifyListeners();
    }
  }

  void addFavoriteRoute(String route) { // 추가된 메소드
    if (!_favoriteRoutes.contains(route)) {
      _favoriteRoutes.add(route);
      notifyListeners();
    }
  }

  void removeFavoriteRoute(String route) { // 추가된 메소드
    if (_favoriteRoutes.contains(route)) {
      _favoriteRoutes.remove(route);
      notifyListeners();
    }
  }
}
