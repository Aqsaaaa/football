import 'package:floor/floor.dart';

import 'likes.dart';

@dao
abstract class TeamsDao {
  @Query('SELECT * FROM Teams')
  Future<List<Teams>> findAllTeams();

  @Query('SELECT * FROM Teams WHERE id = :id')
  Future<Teams?> findTeamsById(int id);

  @insert
  Future<void> insertTeams(Teams teams);

  @Query('DELETE FROM Teams WHERE id = :id')
  Future<void> deleteTeamsById(int id);
}

@dao
abstract class CountriesDao {
  @Query('SELECT * FROM Countries')
  Future<List<Countries>> findAllCountries();

  @Query('SELECT * FROM Countries WHERE id = :id')
  Future<Countries?> findCountriesById(int id);

  @insert
  Future<void> insertCountries(Countries countries);

  @Query('DELETE FROM Countries WHERE id = :id')
  Future<void> deleteCountriesById(int id);
}
