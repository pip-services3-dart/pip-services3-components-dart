import 'package:pip_services3_commons/pip_services3_commons.dart';

///
/// A set of utility functions to process connection parameters
///
class ConnectionUtils {
  /// Concatinates two options by combining duplicated properties into comma-separated list
  ///
  /// - [options1] first options to merge
  /// - [options2] second options to merge
  /// - [keys] when define it limits only to specific keys
  static ConfigParams concat(ConfigParams options1, ConfigParams options2,
      [List<String> keys]) {
    dynamic options = ConfigParams.fromValue(options1);

    for (var key in options2.getKeys()) {
      var value1 = options1.getAsString(key) ?? '';
      var value2 = options2.getAsString(key) ?? '';

      if (value1 != '' && value2 != '') {
        if (keys == null || keys.isEmpty || keys.contains(key)) {
          options.setAsObject(key, value1 + ',' + value2);
        }
      } else if (value1 != '') {
        options.setAsObject(key, value1);
      } else if (value2 != '') {
        options.setAsObject(key, value2);
      }
    }
    return options;
  }

  static String concatValues(String value1, String value2) {
    if (value1 == null || value1 == '') return value2;
    if (value2 == null || value2 == '') return value1;
    return value1 + ',' + value2;
  }

  /// Parses URI into config parameters.
  /// The URI shall be in the following form:
  ///   protocol://username@password@host1:port1,host2:port2,...?param1=abc&param2=xyz&...
  ///
  /// - [uri] the URI to be parsed
  /// - [defaultProtocol] a default protocol
  /// - [defaultPort] a default port
  /// return a configuration parameters with URI elements
  ///
  static ConfigParams parseUri(
      String uri, String defaultProtocol, int defaultPort) {
    var options = ConfigParams();

    if (uri == null || uri == '') return options;

    uri = uri.trim();

    // Process parameters
    var pos = uri.indexOf('?');
    if (pos > 0) {
      var params = uri.substring(pos + 1);
      uri = uri.substring(0, pos);

      var paramsList = params.split('&');
      for (var param in paramsList) {
        var pos = param.indexOf('=');
        if (pos >= 0) {
          var key = Uri.decodeComponent(param.substring(0, pos));
          var value = Uri.decodeComponent(param.substring(pos + 1));
          options.setAsObject(key, value);
        } else {
          options.setAsObject(Uri.decodeComponent(param), null);
        }
      }
    }

    // Process protocol
    pos = uri.indexOf('://');
    if (pos > 0) {
      var protocol = uri.substring(0, pos);
      uri = uri.substring(pos + 3);
      options.setAsObject('protocol', protocol);
    } else {
      options.setAsObject('protocol', defaultProtocol);
    }

    // Process user and password
    pos = uri.indexOf('@');
    if (pos > 0) {
      var userAndPass = uri.substring(0, pos);
      uri = uri.substring(pos + 1);

      pos = userAndPass.indexOf(':');
      if (pos > 0) {
        options.setAsObject('username', userAndPass.substring(0, pos));
        options.setAsObject('password', userAndPass.substring(pos + 1));
      } else {
        options.setAsObject('username', userAndPass);
      }
    }

    // Process host and ports
    // options.setAsObject('servers', concatValues(options.getAsString('servers'), uri));
    var servers = uri.split(',');
    for (var server in servers) {
      pos = server.indexOf(':');
      if (pos > 0) {
        options.setAsObject(
            'servers', concatValues(options.getAsString('servers'), server));
        options.setAsObject(
            'host',
            concatValues(
                options.getAsString('host'), server.substring(0, pos)));
        options.setAsObject(
            'port',
            concatValues(
                options.getAsString('port'), server.substring(pos + 1)));
      } else {
        options.setAsObject(
            'servers',
            concatValues(options.getAsString('servers'),
                server + ':' + defaultPort.toString()));
        options.setAsObject(
            'host', concatValues(options.getAsString('host'), server));
        options.setAsObject('port',
            concatValues(options.getAsString('port'), defaultPort.toString()));
      }
    }

    return options;
  }

  /// Composes URI from config parameters.
  /// The result URI will be in the following form:
  ///   protocol://username@password@host1:port1,host2:port2,...?param1=abc&param2=xyz&...
  ///
  /// - [options] configuration parameters
  /// - [defaultProtocol] a default protocol
  /// - [defaultPort] a default port
  static String composeUri(
      ConfigParams options, String defaultProtocol, int defaultPort) {
    var builder = '';

    var protocol = options.getAsStringWithDefault('protocol', defaultProtocol);
    if (protocol != null) {
      builder = protocol + '://' + builder;
    }

    var username = options.getAsNullableString('username');
    if (username != null) {
      builder += username;
      var password = options.getAsNullableString('password');
      if (password != null) {
        builder += ':' + password;
      }
      builder += '@';
    }

    var servers = '';
    var defaultPortStr =
        defaultPort != null && defaultPort > 0 ? defaultPort.toString() : '';
    var hosts = options.getAsStringWithDefault('host', '???').split(',');
    var ports =
        options.getAsStringWithDefault('port', defaultPortStr).split(',');
    for (var index = 0; index < hosts.length; index++) {
      if (servers.isNotEmpty) {
        servers += ',';
      }

      var host = hosts[index];
      servers += host;

      var port = ports.length > index ? ports[index] : defaultPortStr;
      port = port != '' ? port : defaultPortStr;
      if (port != '') {
        servers += ':' + port;
      }
    }

    builder += servers;

    var params = '';
    var reservedKeys = [
      'protocol',
      'host',
      'port',
      'username',
      'password',
      'servers'
    ];
    for (var key in options.getKeys()) {
      if (reservedKeys.contains(key)) {
        continue;
      }

      if (params.isNotEmpty) {
        params += '&';
      }
      params += Uri.encodeComponent(key);

      var value = options.getAsNullableString(key);
      if (value != null && value != '') {
        params += '=' + Uri.encodeComponent(value);
      }
    }

    if (params.isNotEmpty) {
      builder += '?' + params;
    }

    return builder.toString();
  }

  /// Includes specified keys from the config parameters.
  ///
  /// - [options] configuration parameters to be processed.
  /// - [keys] a list of keys to be included.
  /// return a processed config parameters.
  static ConfigParams include(ConfigParams options, List<String> keys) {
    if (keys == null || keys.isEmpty) return options;

    var result = ConfigParams();

    for (var key in options.getKeys()) {
      if (keys.contains(key)) {
        result.setAsObject(key, options.getAsString(key));
      }
    }

    return result;
  }

  /// Excludes specified keys from the config parameters.
  ///
  /// - [options] configuration parameters to be processed.
  /// - [keys] a list of keys to be included.
  /// return a processed config parameters.
  static ConfigParams exclude(ConfigParams options, List<String> keys) {
    if (keys == null || keys.isEmpty) return options;

    var result = ConfigParams.fromString(options.clone().toString());

    for (var key in keys) {
      result.remove(key);
    }

    return result;
  }
}
