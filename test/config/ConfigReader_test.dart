import 'package:test/test.dart';
//import 'package:handlebars2/handlebars2.dart' as handlebars;
import 'package:stubble/stubble.dart';

void main() {
  group('ConfigReader', () {
    test('Process Templates', () {
      var config = '{{#if A}}{{B}}{{/if}}';
      var params = {'A': 'true', 'B': 'XYZ'};

      var handlebars = Stubble();
      var template = handlebars.compile(config);
      var result = template(params);

      expect(result, 'XYZ');
    });
  });
}
