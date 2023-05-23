import 'package:pip_services3_commons/pip_services3_commons.dart';
import '../../pip_services3_components.dart';

/// Creates [IConfigReader] components by their descriptors.
///
/// See [Factory]
/// See [MemoryConfigReader]
/// See [JsonConfigReader]
/// See [YamlConfigReader]

class DefaultConfigReaderFactory extends Factory {
  static final descriptor =
      Descriptor('pip-services', 'factory', 'config-reader', 'default', '1.0');
  static final MemoryConfigReaderDescriptor =
      Descriptor('pip-services', 'config-reader', 'memory', '*', '1.0');
  static final JsonConfigReaderDescriptor =
      Descriptor('pip-services', 'config-reader', 'json', '*', '1.0');
  static final YamlConfigReaderDescriptor =
      Descriptor('pip-services', 'config-reader', 'yaml', '*', '1.0');

  /// Create a new instance of the factory.

  DefaultConfigReaderFactory() : super() {
    registerAsType(DefaultConfigReaderFactory.MemoryConfigReaderDescriptor,
        MemoryConfigReader);
    registerAsType(DefaultConfigReaderFactory.JsonConfigReaderDescriptor,
        JsonConfigReader);
    registerAsType(DefaultConfigReaderFactory.YamlConfigReaderDescriptor,
        YamlConfigReader);
  }
}
