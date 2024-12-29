import 'package:logger/logger.dart';

// this class is used to show logs.
class Log {
  static const bool isLog = true;
  static final logger = Logger();

  static void t(dynamic message) {
    if (isLog) logger.t(message);
  }

  static void d(dynamic message) {
    if (isLog) logger.d(message);
  }

  static void i(dynamic message) {
    if (isLog) logger.i(message);
  }

  static void w(dynamic message) {
    if (isLog) logger.w(message);
  }

  static void e(dynamic message) {
    if (isLog) logger.e(message);
  }
}
