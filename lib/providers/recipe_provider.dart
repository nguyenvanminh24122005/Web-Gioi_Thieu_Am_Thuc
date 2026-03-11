import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../data/repositories/recipe_repository.dart';

class RecipeProvider extends ChangeNotifier {
  final RecipeRepository _repository = RecipeRepository();

  List<Recipe> recipes = [];
  bool isLoading = false;
  String? lastError;

  Future<void> loadRecipes() async {
    isLoading = true;
    lastError = null;
    notifyListeners();

    try {
      recipes = await _repository.getAllRecipes();
    } catch (e) {
      lastError = e.toString();
      debugPrint('loadRecipes error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addRecipe(Recipe recipe) async {
    try {
      await _repository.insertRecipe(recipe);
      await loadRecipes();
    } catch (e) {
      lastError = e.toString();
      debugPrint('addRecipe error: $e');
      notifyListeners();
    }
  }

  Future<void> updateRecipe(Recipe recipe) async {
    try {
      await _repository.updateRecipe(recipe);
      await loadRecipes();
    } catch (e) {
      lastError = e.toString();
      debugPrint('updateRecipe error: $e');
      notifyListeners();
    }
  }

  Future<void> deleteRecipe(int id) async {
    try {
      await _repository.deleteRecipe(id);
      await loadRecipes();
    } catch (e) {
      lastError = e.toString();
      debugPrint('deleteRecipe error: $e');
      notifyListeners();
    }
  }

  Future<void> search(String keyword) async {
    isLoading = true;
    lastError = null;
    notifyListeners();

    try {
      final k = keyword.trim();
      if (k.isEmpty) {
        recipes = await _repository.getAllRecipes();
      } else {
        recipes = await _repository.searchRecipes(k);
      }
    } catch (e) {
      lastError = e.toString();
      debugPrint('search error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}