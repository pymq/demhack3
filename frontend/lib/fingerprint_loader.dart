import 'dart:js_util';
import 'package:js/js.dart';

@JS()
external getFPJSLibDataPromise();

@JS("JSON.stringify")
external String stringify(value, [replacer, space]);

Future getBrowserFingerPrint() {
  var promise = getFPJSLibDataPromise();
  return promiseToFuture(promise);
}


