// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DetailTeamPage extends StatelessWidget {
  final dynamic team;

  const DetailTeamPage({Key? key, required this.team}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Team'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (team['crest'] != null)
                team['crest'].endsWith('.svg')
                    ? SvgPicture.network(
                        team['crest'],
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain,
                      )
                    : Image.network(
                        team['crest'],
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain,
                      ),
              const SizedBox(height: 16),
              Text(
                '${team['name']}, ${team['shortName']}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Text('(${team['tla']})'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Stadium '),
                        SizedBox(height: 8),
                        // Text('Address '),
                        // SizedBox(height: 8),
                        Text('Website '),
                        SizedBox(height: 8),
                        Text('Founded '),
                        SizedBox(height: 8),
                        Text('Club Colors '),
                      ]),
                  const SizedBox(width: 16),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(':  ${team['venue']}'),
                        // const SizedBox(height: 8),
                        // Text(':  ${team['address']}'),
                        const SizedBox(height: 8),
                        Text(
                          ':  ${team['website']}',
                        ),
                        const SizedBox(height: 8),
                        Text(':  ${team['founded']}'),
                        const SizedBox(height: 8),
                        Text(':  ${team['clubColors']}'),
                      ]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
