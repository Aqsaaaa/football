import 'package:flutter/material.dart';
import 'package:football_app/database/database.dart';
import 'package:football_app/database/likes.dart';

class FavoriteCountries extends StatefulWidget {
  const FavoriteCountries({super.key});

  @override
  State<FavoriteCountries> createState() => _FavoriteCountriesState();
}

class _FavoriteCountriesState extends State<FavoriteCountries> {
  late Future<AppDatabase> databaseFuture;
  late Future<List<Countries>> countriesFuture;

  @override
  void initState() {
    super.initState();
    databaseFuture = $FloorAppDatabase.databaseBuilder('football.db').build();
    countriesFuture = getkCountries();
  }

  Future<List<Countries>> getkCountries() async {
    final database = await databaseFuture;
    return database.countriesDao.findAllCountries();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([databaseFuture, countriesFuture]),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return Text('Error: ${snapshot.error}');
          }
          print(snapshot.data);
          var teams = snapshot.data![1] as List<Countries>;
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
                      onTap: () {},
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
