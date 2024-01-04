// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:football_app/database/likes.dart';
import 'package:http/http.dart' as http;

import 'database/database.dart';
import 'team_detail.dart';

class TeamPage extends StatefulWidget {
  const TeamPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TeamPageState createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  late Future<AppDatabase> databaseFuture;
  late Future<List<Teams>> teamsFuture;
  List<dynamic> teams = [];

  final String apiKey = '01c635bc90944fa089f8288e76f78a94';

  Future<List<dynamic>> getTeams() async {
    final response = await http.get(
      Uri.parse(
        'http://api.football-data.org/v4/teams',
      ),
      headers: {'X-Auth-Token': apiKey},
    );

    if (response.statusCode == 200) {
      final teams = json.decode(response.body)['teams'] ?? [];
      return teams;
    } else {
      throw Exception('Failed to load team data');
    }
  }

  Future<List<Teams>> getkTeams() async {
    final database = await databaseFuture;
    return database.teamsDao.findAllTeams();
  }

  Future<void> _addAllTeams(int index) async {
    final database = await databaseFuture;
    final dynamic teamData = teams[index];

    final int id = teamData['id'] ?? Random().nextInt(1000);
    final String name = teamData['name'] ?? 'Unknown Name';
    final String tla = teamData['tla'] ?? 'Unknown TLA';
    final String stadium = teamData['venue'] ?? 'Unknown Stadium';
    final String website = teamData['website'] ?? 'Unknown Website';
    final String founded = teamData['founded']?.toString() ?? 'Unknown Founded';
    final String clubColors = teamData['clubColors'] ?? 'Unknown Club Colors';
    final String crestUrl = teamData['crest'] ?? 'Unknown Crest URL';
    final String shortName = teamData['shortName'] ?? 'Unknown Short Name';

    final Teams teamToAdd = Teams(
      id,
      name,
      tla,
      stadium,
      website,
      founded,
      clubColors,
      shortName,
      crestUrl,
    );

    await database.teamsDao.insertTeams(teamToAdd);

    setState(() {
      teamsFuture = getkTeams();
    });
  }

  Future<bool> _isTeams(int index) async {
    final database = await databaseFuture;
    final dynamic team = teams[index];
    final int id = team['id'] ?? 0;

    final existingFavorite = await database.teamsDao.findTeamsById(id);
    return existingFavorite != null;
  }

  void navigateToDetailTeamPage(dynamic team) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailTeamPage(team: team),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    databaseFuture = $FloorAppDatabase
        .databaseBuilder('football.db')
        .addMigrations([AppDatabase.migration1to2]) // Tambahkan migrasi di sini
        .build();
    teamsFuture = getkTeams();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: getTeams(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              teams = snapshot.data as List<dynamic>;

              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: MediaQuery.of(context).size.width /
                      (MediaQuery.of(context).size.height / 1.5),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: teams.length,
                itemBuilder: (context, index) {
                  final team = teams[index];
                  return InkWell(
                    onTap: () {
                      navigateToDetailTeamPage(team);
                    },
                    child: Card(
                      color: Colors.transparent,
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            if (team['crest'] != null)
                              team['crest'].endsWith('.svg')
                                  ? SvgPicture.network(
                                      team['crest'],
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.contain,
                                    )
                                  : Image.network(
                                      team['crest'],
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.contain,
                                    ),
                            const SizedBox(height: 8),
                            Text(
                              team['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                final database = await databaseFuture;
                                final team = teams[index];
                                final id = team['id'] ?? 0;
                                final isFavorite = await _isTeams(index);

                                if (isFavorite) {
                                  await database.teamsDao.deleteTeamsById(id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Removed from favorites'),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                } else {
                                  await _addAllTeams(index);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Added to favorites'),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                }

                                setState(() {
                                  // Ensure the UI updates by clearing out the old data
                                  teams = [];
                                  teamsFuture = getkTeams();
                                });
                              },
                              icon: FutureBuilder<bool>(
                                future: _isTeams(index),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    // Show a placeholder or loading indicator while waiting for the future to complete
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.data == true) {
                                    return const Icon(Icons.favorite,
                                        color: Colors.red);
                                  } else {
                                    return const Icon(
                                        Icons.favorite_border_outlined);
                                  }
                                },
                              ),
                            ),
                            Text('(${team['tla']})'),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
