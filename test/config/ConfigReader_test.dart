import 'package:pip_services3_expressions/pip_services3_expressions.dart';
import 'package:test/test.dart';

void main() {
  group('ConfigReader', () {
    test('Process Templates', () {
      var config = '{{#if A}}{{B}}{{/if}}';
      var params = {'A': true, 'B': 'XYZ'};
      var template = MustacheTemplate(config);
      var result = template.evaluateWithVariables(params);

      expect(result, 'XYZ');
    });
  });
}
