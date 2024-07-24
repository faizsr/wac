import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  Future<List<dynamic>> fetchData() async {
    final response = await http
        .get(Uri.parse('https://64bfc2a60d8e251fd111630f.mockapi.io/api/Todo'));

    if (response.statusCode == 200) {
      print("successfullly fetched");
      final data = json.decode(response.body) as List<dynamic>;
      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
