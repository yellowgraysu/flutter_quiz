import 'dart:convert';
import 'dart:collection';
import 'package:http/http.dart' as http;

const testImage = 'test-img';

class DomainTester {
  DomainTester._internal();

  static final DomainTester _instance = DomainTester._internal();

  factory DomainTester() => _instance;

  String result = '[]';

  Future<double> downloadImg(String domain) async {
    final stopwatch = Stopwatch()..start();
    await http.get(Uri.parse('https://$domain/$testImage'));
    stopwatch.stop();
    return stopwatch.elapsedMilliseconds.toDouble();
  }

  void set(Map<String, double> domainTimes) {
    final invertedMap = domainTimes.map((k, v) => MapEntry(v, k));
    final sortedMap = SplayTreeMap<double, String>()..addAll(invertedMap);
    result = jsonEncode(
      sortedMap.entries.map((e) => {'domain': e.value, 'time': e.key}).toList(),
    );
  }

  List<Map<String, double>> get() {
    final data = jsonDecode(result) as List;
    return data
        .map((e) => {e['domain'] as String: e['time'] as double})
        .toList();
  }
}
