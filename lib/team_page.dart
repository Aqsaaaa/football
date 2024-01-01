import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;

import 'team_detail.dart';

class TeamPage extends StatefulWidget {
  const TeamPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TeamPageState createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  final String apiKey = '01c635bc90944fa089f8288e76f78a94';

  Future<List<dynamic>> getTeams() async {
    final response = await http.get(
      Uri.parse(
        'http://api.football-data.org/v4/teams',
      ),
      headers: {'X-Auth-Token': apiKey},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['teams'];
    } else {
      throw Exception('Failed to load team data');
    }
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
              final List? teams = snapshot.data;

              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: MediaQuery.of(context).size.width /
                      (MediaQuery.of(context).size.height / 1.5),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: teams?.length,
                itemBuilder: (context, index) {
                  final team = teams?[index];
                  return InkWell(
                    onTap: () {
                      navigateToDetailTeamPage(team);
                    },
                    child: Card(
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

