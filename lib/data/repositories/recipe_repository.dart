import 'package:sqflite/sqflite.dart';
import '../../models/recipe.dart';
import '../db/app_database.dart';

class RecipeRepository {
  // CREATE
  Future<int> insertRecipe(Recipe recipe) async {
    final db = await AppDatabase.instance.database;
    return db.insert(
      'recipes',
      recipe.toMap()..remove('id'),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // READ ALL
  Future<List<Recipe>> getAllRecipes() async {
    final db = await AppDatabase.instance.database;
    final maps = await db.query(
      'recipes',
      orderBy: 'id DESC',
    );

    return maps.map((e) => Recipe.fromMap(e)).toList();
  }

  // SEARCH
  Future<List<Recipe>> searchRecipes(String keyword) async {
    final db = await AppDatabase.instance.database;

    final maps = await db.query(
      'recipes',
      where: 'name LIKE ?',
      whereArgs: ['%$keyword%'],
      orderBy: 'id DESC',
    );

    return maps.map((e) => Recipe.fromMap(e)).toList();
  }

  // UPDATE
  Future<int> updateRecipe(Recipe recipe) async {
    final db = await AppDatabase.instance.database;

    return db.update(
      'recipes',
      recipe.toMap()..remove('id'),
      where: 'id = ?',
      whereArgs: [recipe.id],
    );
  }

  // DELETE
  Future<int> deleteRecipe(int id) async {
    final db = await AppDatabase.instance.database;

    return db.delete(
      'recipes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}