import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'likes.dart';
import 'likes_dao.dart';


part 'database.g.dart';

@Database(version: 1, entities: [Teams, Countries])
abstract class AppDatabase extends FloorDatabase {
  TeamsDao get teamsDao;
  CountriesDao get countriesDao;
}
