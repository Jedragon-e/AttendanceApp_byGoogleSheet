
import 'package:http/http.dart' as http;      // Http
import 'dart:convert';                        // Json
import 'package:google_demo/services/prefs.dart';

class GoogleSheetService {
  String baseUrl = '';

  // main data
  List<Map<String, dynamic>> _data = [];

  // getter
  List<String> get names => _data.map((e) => e['name'].toString()).toList();

  Future<bool> getUserInfo() async {
    final savedUrl = await Prefs.getBaseUrl();
    if (savedUrl == null || savedUrl.isEmpty) {
      return false;
    }

    final url = Uri.parse(savedUrl);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        _data = jsonData.map((e) => e as Map<String, dynamic>).toList();
        _data.sort((a, b) => a['name'].compareTo(b['name'])); // 이름순으로 정렬
        return true;
      } else {
        // 요청 실패
        return false;
      }
    } catch (e) {
      // 에러 발생
      return false;
    }
  }

  Future<bool> sendUserData(String name, int age, String memo) async {
    final body = {
      'type' : 'adduser',
      'name': name,
      'age': age,
      'memo': memo,
    };

    final savedUrl = await Prefs.getBaseUrl();
    if (savedUrl == null || savedUrl.isEmpty) {
      return false;
    }

    final url = Uri.parse(savedUrl);

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return result['status'] == 'success';
    } else {
    }

    return false;
  }

  Future<bool> sendAttendanceData(List<String> names, String date, String time) async {
    final body = {
      'type' : 'attendance',
      'date': date,
      'time': time,
      'names': names,
    };

    final savedUrl = await Prefs.getBaseUrl();
    if (savedUrl == null || savedUrl.isEmpty) {
      return false;
    }

    final url = Uri.parse(savedUrl);

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return result['status'] == 'success';
    } else {
    }
    return false;
  }
}
