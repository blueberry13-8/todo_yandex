import 'package:http/http.dart' as http;

Future<bool> checkInternetBool() async {
  try {
    await http.get(Uri.parse("https://api.chucknorris.io/jokes/random"));
    return true;
  } catch (_) {
    return false;
  }
}
