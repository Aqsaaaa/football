import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'database/database.dart';
import 'database/likes.dart';

class CountryDetailPage extends StatefulWidget {
  final Map<String, dynamic> country;

  const CountryDetailPage({Key? key, required this.country}) : super(key: key);

  @override
  _CountryDetailPageState createState() => _CountryDetailPageState();
}

class _CountryDetailPageState extends State<CountryDetailPage> {
  late Future<AppDatabase> databaseFuture;

  @override
  void initState() {
    super.initState();
    databaseFuture = $FloorAppDatabase.databaseBuilder('footballs.db').build();
  }

  Future<bool> _isCountries(int id) async {
    final database = await databaseFuture;
    final existingFavorite = await database.countriesDao.findCountriesById(id);
    return existingFavorite != null;
  }

  Future<void> _addAllCountries(int id) async {
    final database = await databaseFuture;

    final int countryId = widget.country['id'] ?? 0;
    final String name = widget.country['name'] ?? 'Unknown Name';
    final String parentArea =
        widget.country['parentArea'] ?? 'Unknown Parent Area';
    final String flag = widget.country['flag'] ?? 'Unknown Flag URL';

    final Countries countryToAdd = Countries(
      countryId,
      name,
      parentArea,
      flag,
    );

    await database.countriesDao.insertCountries(countryToAdd);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Country Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${widget.country['name'] ?? 'Unknown'} (${widget.country['parentArea']})',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              widget.country['flag'] == null
                  ? const Text('No Flag Image')
                  : widget.country['flag'].endsWith('.svg')
                      ? SvgPicture.network(
                          widget.country['flag'],
                          width: 200,
                          height: 200,
                        )
                      : Image.network(
                          widget.country['flag'],
                          width: 200,
                          height: 200,
                        ),
              const SizedBox(height: 8),
              Text(
                '${widget.country['id'] ?? 'Unknown'}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () async {
                  final database = await databaseFuture;

                  final int countryId = widget.country['id'] ?? 0;
                  final isFavorite = await _isCountries(countryId);

                  if (isFavorite) {
                    await database.countriesDao.deleteCountriesById(countryId);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Removed from favorites'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  } else {
                    await _addAllCountries(countryId);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Added to favorites'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  }

                  setState(() {});
                },
                icon: FutureBuilder<bool>(
                  future: _isCountries(widget.country['id'] ?? 0),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.data == true) {
                      return const Icon(Icons.bookmark, color: Colors.yellow);
                    } else {
                      return const Icon(Icons.bookmark_border);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
