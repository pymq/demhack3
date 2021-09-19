import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

const String _adress = 'https://bfp-demo.ml';

const Map _methods = {
  'process_fingerprint' : '/api/process_fingerprint'
};

Future<http.Response> send(String value) async {
  http.Response response = await http.post(
      Uri.parse(_adress + _methods['process_fingerprint']),
      headers: {"Content-Type": "application/json"},
      body: value
  );

  return response;
}

Future<http.Response> isolateSend(String value) async {
  return compute(send, value);
}

