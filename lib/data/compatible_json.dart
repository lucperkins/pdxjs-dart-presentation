part of data;

abstract class CompatibleJson {
  Map<String, dynamic> get attributes;

  bool jsonCompatible(Map<String, dynamic> json) {
    return (json.keys.length == attributes.keys.length) &&
      (json.keys.every((key) => key.runtimeType == String)) &&
      (json.keys.every((key) => attributes.keys.contains(key))) &&
      (json.values.every((value) => attributes.values.runtimeType == value.runtimeType));
  }

  String inspectJson() => JSON.encode(attributes);
}