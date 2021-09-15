import 'package:mustache_template/mustache.dart';
import 'package:test/test.dart';

void main() {
  group('ConfigReader', () {
    test('Process Templates', () {
      var config = '{{#A}}{{B}}{{/A}}';
      var params = {'A': 'true', 'B': 'XYZ'};
      var template = Template(config);
      var result = template.renderString(params);

      expect(result, 'XYZ');
    });
  });
}
