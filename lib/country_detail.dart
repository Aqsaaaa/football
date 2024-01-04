import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CountryDetailPage extends StatelessWidget {
  final Map<String, dynamic> country;

  const CountryDetailPage({Key? key, required this.country}) : super(key: key);

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
                '${country['name'] ?? 'Unknown'} ( ${country['parentArea']} )',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              country['flag'] == null
                  ? const Text('No Flag Image')
                  : country['flag'].endsWith('.svg')
                      ? SvgPicture.network(
                          country['flag'],
                          width: 200,
                          height: 200,
                        )
                      : Image.network(
                          country['flag'],
                          width: 200,
                          height: 200,
                        ),
              const SizedBox(height: 8),
              Text(
                '${country['id'] ?? 'Unknown'}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
