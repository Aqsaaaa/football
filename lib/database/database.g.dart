// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  TeamsDao? _teamsDaoInstance;

  CountriesDao? _countriesDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Teams` (`id` INTEGER NOT NULL, `name` TEXT NOT NULL, `shortName` TEXT NOT NULL, `crest` TEXT NOT NULL, `tla` TEXT NOT NULL, `stadium` TEXT NOT NULL, `website` TEXT NOT NULL, `founded` TEXT NOT NULL, `clubColors` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Countries` (`id` INTEGER NOT NULL, `title` TEXT NOT NULL, `adult` INTEGER NOT NULL, `popularity` REAL NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  TeamsDao get teamsDao {
    return _teamsDaoInstance ??= _$TeamsDao(database, changeListener);
  }

  @override
  CountriesDao get countriesDao {
    return _countriesDaoInstance ??= _$CountriesDao(database, changeListener);
  }
}

class _$TeamsDao extends TeamsDao {
  _$TeamsDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _teamsInsertionAdapter = InsertionAdapter(
            database,
            'Teams',
            (Teams item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'shortName': item.shortName,
                  'crest': item.crest,
                  'tla': item.tla,
                  'stadium': item.stadium,
                  'website': item.website,
                  'founded': item.founded,
                  'clubColors': item.clubColors
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Teams> _teamsInsertionAdapter;

  @override
  Future<List<Teams>> findAllTeams() async {
    return _queryAdapter.queryList('SELECT * FROM Teams',
        mapper: (Map<String, Object?> row) => Teams(
            row['id'] as int,
            row['name'] as String,
            row['tla'] as String,
            row['stadium'] as String,
            row['website'] as String,
            row['founded'] as String,
            row['clubColors'] as String,
            row['shortName'] as String,
            row['crest'] as String));
  }

  @override
  Future<Teams?> findTeamsById(int id) async {
    return _queryAdapter.query('SELECT * FROM Teams WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Teams(
            row['id'] as int,
            row['name'] as String,
            row['tla'] as String,
            row['stadium'] as String,
            row['website'] as String,
            row['founded'] as String,
            row['clubColors'] as String,
            row['shortName'] as String,
            row['crest'] as String),
        arguments: [id]);
  }

  @override
  Future<void> deleteTeamsById(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM Teams WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> insertTeams(Teams teams) async {
    await _teamsInsertionAdapter.insert(teams, OnConflictStrategy.abort);
  }
}

class _$CountriesDao extends CountriesDao {
  _$CountriesDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _countriesInsertionAdapter = InsertionAdapter(
            database,
            'Countries',
            (Countries item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'adult': item.adult ? 1 : 0,
                  'popularity': item.popularity
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Countries> _countriesInsertionAdapter;

  @override
  Future<List<Countries>> findAllCountries() async {
    return _queryAdapter.queryList('SELECT * FROM Countries',
        mapper: (Map<String, Object?> row) => Countries(
            row['id'] as int,
            row['title'] as String,
            (row['adult'] as int) != 0,
            row['popularity'] as double));
  }

  @override
  Future<Countries?> findCountriesById(int id) async {
    return _queryAdapter.query('SELECT * FROM Countries WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Countries(
            row['id'] as int,
            row['title'] as String,
            (row['adult'] as int) != 0,
            row['popularity'] as double),
        arguments: [id]);
  }

  @override
  Future<void> deleteCountriesById(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM Countries WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> insertCountries(Countries countries) async {
    await _countriesInsertionAdapter.insert(
        countries, OnConflictStrategy.abort);
  }
}
