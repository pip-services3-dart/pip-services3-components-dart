import 'package:test/test.dart';
import 'package:mustache4dart2/mustache4dart2.dart';

void main() {
  group('ConfigReader', () {
    test('Process Templates', () {
      var config = '{{#A}}{{B}}{{/A}}';
      var params = {'A': 'true', 'B': 'XYZ'};
      var result = render(config, params);

      expect(result, 'XYZ');
    });
  });
}
