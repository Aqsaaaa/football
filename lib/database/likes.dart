import 'package:floor/floor.dart';

@entity
class Teams {
  @primaryKey
  final int id;
  final String name;
  final String shortName;
  final String crest;
  final String tla;
  final String stadium;
  final String website;
  final String founded;
  final String clubColors;

  Teams(
    this.id,
    this.name,
    this.tla,
    this.stadium,
    this.website,
    this.founded,
    this.clubColors,
    this.shortName,
    this.crest,
  );
}

@entity
class Countries {
  @primaryKey
  final int id;
  final String name;
  final String flag;
  final String parentArea;

  Countries(
    this.id,
    this.name,
    this.flag,
    this.parentArea,
  );
}
