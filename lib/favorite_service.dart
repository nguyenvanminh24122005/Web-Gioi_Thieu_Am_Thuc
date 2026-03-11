import 'package:flutter/material.dart';

class FavoriteService {
  static final FavoriteService _instance = FavoriteService._internal();
  factory FavoriteService() => _instance;
  FavoriteService._internal();

  final ValueNotifier<Set<String>> _favorites =
      ValueNotifier<Set<String>>({});

  ValueNotifier<Set<String>> get favorites => _favorites;

  bool isFavorite(String id) {
    return _favorites.value.contains(id);
  }

  void toggleFavorite(String id) {
    final current = _favorites.value;
    if (current.contains(id)) {
      current.remove(id);
    } else {
      current.add(id);
    }
    _favorites.value = Set.from(current);
  }

  void clear() {
    _favorites.value = {};
  }
}