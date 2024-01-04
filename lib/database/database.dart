import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'likes.dart';
import 'likes_dao.dart';

part 'database.g.dart';

@Database(version: 2, entities: [Teams, Countries])
abstract class AppDatabase extends FloorDatabase {
  TeamsDao get teamsDao;
  CountriesDao get countriesDao;

  static final migration1to2 = Migration(1, 2, (database) async {
    await database.execute('ALTER TABLE Teams ADD COLUMN sponsor TEXT');
    await database
        .execute('ALTER TABLE Countries ADD COLUMN population INTEGER');
  });
}
