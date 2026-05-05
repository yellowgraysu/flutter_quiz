import 'dart:convert';
import 'dart:collection';
import 'package:http/http.dart' as http;

const testImage = 'test-img';

// storage which is temporarily stored in memory, which can be replaced
// by SharedPreferences, SQLite, or other persistence mechanism.
//
// The class is a singleton, and the instance is available through the
// factory constructor.
//
// setter and getter use 'domain' as key, 'time' as value, simpify the usage.
class DomainTester {
  DomainTester._internal();

  static final DomainTester _instance = DomainTester._internal();

  factory DomainTester() => _instance;

  String _storage = '[]';

  Future<double> downloadImg(String domain) async {
    final stopwatch = Stopwatch()..start();
    await http.get(Uri.parse('https://$domain/$testImage'));
    stopwatch.stop();
    return stopwatch.elapsedMilliseconds.toDouble();
  }

  void set(Map<String, double> domainTimes) {
    final invertedMap = domainTimes.map((k, v) => MapEntry(v, k));
    final sortedMap = SplayTreeMap<double, String>()..addAll(invertedMap);
    _storage = jsonEncode(
      sortedMap.entries.map((e) => {'domain': e.value, 'time': e.key}).toList(),
    );
  }

  Map<String, double> get() {
    final data = jsonDecode(_storage) as List;
    final result = <String, double>{};
    for (final e in data) {
      result[e['domain'] as String] = e['time'] as double;
    }
    return result;
  }
}
