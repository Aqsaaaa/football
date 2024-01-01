import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://api-basketball.p.rapidapi.com";

  Future<List<dynamic>> getLeagues() async {
    final response = await http.get(
      Uri.parse("$baseUrl/leagues"),
      headers: {
        "X-RapidAPI-Host": "api-basketball.p.rapidapi.com",
        "X-RapidAPI-Key": "b35e80c155msh0d8c5fd1524b48ep1c9006jsnf2ac7ae4331c",
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load leagues");
    }
  }
}
