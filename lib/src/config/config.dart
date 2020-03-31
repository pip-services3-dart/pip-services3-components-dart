 
/// @module config 
/// 
/// Todo: Rewrite this description
/// 
/// @preferred
/// Contains implementation of the config design pattern. 
/// 
/// ConfigReader's Parameterize method allows us to take a standard configuration, and, 
/// using a set of current parameters (e.g. environment variables), parameterize it. When 
/// we create the configuration of a container, we can use environment variables to tailor 
/// it to the system, dynamically add addresses, ports, etc.
 
export './ConfigReader.dart';
export './FileConfigReader.dart';
export './IConfigReader.dart';
export './JsonConfigReader.dart';
export './MemoryConfigReader.dart';
export './YamlConfigReader.dart';
export './DefaultConfigReaderFactory.dart';