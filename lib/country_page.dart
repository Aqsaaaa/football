// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;

import 'country_detail.dart';
import 'database/database.dart';
import 'database/likes.dart';

class AreaPage extends StatefulWidget {
  const AreaPage({Key? key}) : super(key: key);

  @override
  _AreaPageState createState() => _AreaPageState();
}

class _AreaPageState extends State<AreaPage> {
  late Future<AppDatabase> databaseFuture;
  late Future<List<Countries>> countriesFuture;
  List<Map<String, dynamic>> filteredAreas = [];

  final String apiKey = '01c635bc90944fa089f8288e76f78a94';
  TextEditingController searchController = TextEditingController();

  Future<List<Map<String, dynamic>>> getAreas() async {
    final response = await http.get(
      Uri.parse('https://api.football-data.org/v4/areas'),
      headers: {'X-Auth-Token': apiKey},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> areas = data['areas'] ?? [];
      return areas.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load team data');
    }
  }

  List<Map<String, dynamic>> filterAreas(
      String query, List<Map<String, dynamic>> areas) {
    return areas.where((area) {
      final name = area['name'].toString().toLowerCase();
      return name.contains(query.toLowerCase());
    }).toList();
  }

  Future<List<Countries>> getkCountries() async {
    final database = await databaseFuture;
    return database.countriesDao.findAllCountries();
  }

  Future<void> _addAllCountries(int index) async {
    final database = await databaseFuture;

    if (index >= 0 && index < filteredAreas.length) {
      final dynamic countryData = filteredAreas[index];

      final int id = countryData['id'] ?? Random().nextInt(1000);
      final String name = countryData['name'] ?? 'Unknown Name';
      final String parentArea =
          countryData['parentArea'] ?? 'Unknown Parent Area';
      final String flag = countryData['flag'] ?? 'Unknown Flag URL';

      final Countries countryToAdd = Countries(
        id,
        name,
        parentArea,
        flag,
      );

      await database.countriesDao.insertCountries(countryToAdd);

      setState(() {
        countriesFuture = getkCountries();
      });
    }
  }

  Future<bool> _isCountries(int index) async {
    final database = await databaseFuture;
    final dynamic country = filteredAreas[index];
    final int id = country['id'];

    final existingFavorite = await database.countriesDao.findCountriesById(id);
    return existingFavorite != null;
  }

  @override
  void initState() {
    super.initState();

    databaseFuture = $FloorAppDatabase.databaseBuilder('football.db').build();
    countriesFuture = getkCountries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: IconButton(
                  onPressed: () => searchController.clear(),
                  icon: const Icon(Icons.clear),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: getAreas(),
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
                    final List<Map<String, dynamic>> areas = snapshot.data!;
                    var filteredAreas =
                        filterAreas(searchController.text, areas);

                    return ListView.builder(
                      itemCount: filteredAreas.length,
                      itemBuilder: (context, index) {
                        final area = filteredAreas[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CountryDetailPage(country: area),
                              ),
                            );
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
                                  Center(
                                    child: Column(
                                      children: [
                                        // area['flag'] == null
                                        //     ? Image.asset(
                                        //         'assets/missing_flag.png',
                                        //         width: 100,
                                        //         height: 100)
                                        //     : area['flag'].endsWith('.svg')
                                        //         ? SvgPicture.network(
                                        //             area['flag'],
                                        //             width: 100,
                                        //             height: 100,
                                        //           )
                                        //         : Image.network(
                                        //             area['flag'],
                                        //             width: 100,
                                        //             height: 100,
                                        //           ),
                                        Text(
                                          area['name'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text('(${area['parentArea']})'),
                                      ],
                                    ),
                                  ),
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
          ],
        ),
      ),
    );
  }
}
