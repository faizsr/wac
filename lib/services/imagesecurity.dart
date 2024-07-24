import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<String> saveImageToFileSystem(String imageUrl, String fileName) async {
  final response = await http.get(Uri.parse(imageUrl));
  if (response.statusCode == 200) {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$fileName';
    print(path);
    final file = File(path);
    await file.writeAsBytes(response.bodyBytes);
    return path;
  } else {
    throw Exception('Failed to load image');
  }
}
