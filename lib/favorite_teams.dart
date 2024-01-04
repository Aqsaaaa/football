import 'package:flutter/material.dart';
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
                child: ListView.builder(
                  itemCount: teams.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: Text(teams[index].id.toString()),
                      title: Text(teams[index].name),
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
