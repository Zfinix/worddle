import 'dart:convert';

String jsonPretty(dynamic _obj) {
  String prettyprint;

  var obj = _obj;

  if (_obj is String) {
    obj = json.decode(_obj);
  }

  if (obj is Map ||
      obj is Map<dynamic, dynamic> ||
      obj is Map<String, dynamic>) {
    const encoder = JsonEncoder.withIndent('  ');
    prettyprint = encoder.convert(obj);
  } else {
    prettyprint = '$obj';
  }

  return prettyprint;
}
