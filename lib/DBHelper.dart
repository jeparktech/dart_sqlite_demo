import 'dart:async';

import 'package:flutter/widgets.dart';
import './carWash.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  final Future<Database> database;

  DBHelper(this.database);

  // Define a function that inserts dogs into the database
  Future<void> insertMemo(CarWash carwash) async {
    // Get a reference to the database.
    final db = await database;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'carWashes',
      carwash.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the dogs from the dogs table.
  Future<List<CarWash>> carWashes() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('carWashes');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return CarWash(
        date: maps[i]['datae'],
        amount: maps[i]['amount'],
        memo: maps[i]['memo'],
      );
    });
  }

  Future<void> updatememo(CarWash carWash) async {
    // Avoid errors caused by flutter upgrade.
    // Importing 'package:flutter/widgets.dart' is required.
    WidgetsFlutterBinding.ensureInitialized();
    // Open the database and store the reference.
    final database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'car_database.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE carWashes(date INTEGER PRIMARY KEY, amount INTEGER, memo TEXT)',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );

    // Get a reference to the database.
    final db = await database;

    // Update the given Dog.
    await db.update(
      'carWashes',
      carWash.toMap(),
      // Ensure that the Dog has a matching id.
      where: 'date = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [carWash.date],
    );
  }

  Future<void> deleteMemo(int date) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the database.
    await db.delete(
      'carWashes',
      // Use a `where` clause to delete a specific dog.
      where: 'date = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [date],
    );
  }
}
