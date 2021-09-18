import 'dart:convert';

import 'package:http/http.dart' as http;

const String _adress = '';

const Map methods = {
  'process_fingerprint' : '/process_fingerprint'
};

void send(String value) {
  http.post(
      Uri.parse(_adress + methods['process_fingerprint']),
      headers: {"Content-Type": "application/json"},
      body: value
  );
}
