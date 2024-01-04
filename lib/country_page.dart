import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'country_detail.dart';

class AreaPage extends StatefulWidget {
  const AreaPage({Key? key}) : super(key: key);

  @override
  _AreaPageState createState() => _AreaPageState();
}

class _AreaPageState extends State<AreaPage> {
  final String apiKey = '01c635bc90944fa089f8288e76f78a94';
  TextEditingController searchController = TextEditingController();
  late Future<List<Map<String, dynamic>>> areasFuture;

  @override
  void initState() {
    super.initState();
    areasFuture = getAreas();
  }

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
      throw Exception('Failed to load area data');
    }
  }

  List<Map<String, dynamic>> filterAreas(
      String query, List<Map<String, dynamic>> areas) {
    return areas.where((area) {
      final name = area['name'].toString().toLowerCase();
      return name.contains(query.toLowerCase());
    }).toList();
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
                future: areasFuture,
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
                    final filteredAreas =
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
                            elevation: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  const SizedBox(height: 8),
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
