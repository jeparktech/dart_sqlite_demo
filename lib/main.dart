import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_dbdemo/DBHelper.dart';
import 'package:flutter_dbdemo/carWash.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
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

  var dbHelper = DBHelper(database);

  // Create a Dog and add it to the dogs table
  var wash1 = CarWash(amount: 19000, date: 20210622, memo: '실내, 실외 세차');

  await dbHelper.insertMemo(wash1);

  // Now, use the method above to retrieve all the dogs.
  print(await (dbHelper.carWashes())); // Prints a list that include Fido.

  // Update Fido's age and save it to the database.
  wash1 =
      CarWash(date: wash1.date, amount: wash1.amount + 2000, memo: '휠 윤택 추가');
  await dbHelper.updatememo(wash1);

  // Print the updated results.
  print(await dbHelper.carWashes()); // Prints Fido with age 42.

  // Delete Fido from the database.
  await dbHelper.deleteMemo(wash1.date);

  // Print the list of dogs (empty).
  print(await dbHelper.carWashes());
}
