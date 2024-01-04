import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:football_app/database/database.dart';
import 'package:football_app/database/likes.dart';

class FavoriteTeams extends StatefulWidget {
  const FavoriteTeams({super.key});

  @override
  State<FavoriteTeams> createState() => _FavoriteTeamsState();
}

class _FavoriteTeamsState extends State<FavoriteTeams> {
  late Future<AppDatabase> databaseFuture;
  late Future<List<Teams>> teamsFuture;
  List<dynamic> teams = [];

  @override
  void initState() {
    super.initState();
    databaseFuture = $FloorAppDatabase.databaseBuilder('football.db').build();
    teamsFuture = getkTeams();
  }

  Future<List<Teams>> getkTeams() async {
    final database = await databaseFuture;
    return database.teamsDao.findAllTeams();
  }

  Future<bool> _isTeams(int index) async {
    final database = await databaseFuture;
    final dynamic team = teams[index];
    final int id = team['id'] ?? 0;

    final existingFavorite = await database.teamsDao.findTeamsById(id);
    return existingFavorite != null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([databaseFuture, teamsFuture]),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          var teams = snapshot.data![1] as List<Teams>;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 1.8,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: teams.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Column(children: [
                        const SizedBox(height: 8),
                        Text('(${teams[index].id.toString()})'),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            teams[index].crest.endsWith('.svg')
                                ? SvgPicture.network(
                                    teams[index].crest,
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.contain,
                                  )
                                : Image.network(
                                    teams[index].crest,
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.contain,
                                  ),
                            const SizedBox(width: 8),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Club Name'),
                                Text('Stadium'),
                                Text('Web'),
                                Text('Founded'),
                                Text('Club Colors'),
                              ],
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    ': ${teams[index].name} (${teams[index].tla})'),
                                Text(': ${teams[index].stadium}'),
                                Text(': ${teams[index].website}'),
                                Text(': ${teams[index].founded}'),
                                Text(': ${teams[index].clubColors}'),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () async {
                            final database = await databaseFuture;
                            final team = teams[index];
                            final id = team.id;

                            await database.teamsDao.deleteTeamsById(id);
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Removed from favorites'),
                                duration: Duration(seconds: 1),
                              ),
                            );

                            setState(() {
                              teams = [];
                              teamsFuture = getkTeams();
                            });
                          },
                          child: const Text('Remove'),
                        ),
                        const SizedBox(height: 8),
                      ]),
                    );
                  },
                ),
              ),
            ],
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
// leading: Text(teams[index].id.toString()),
                      // title: Text(teams[index].name),