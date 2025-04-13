import 'package:logging/logging.dart';

class LoggingService {
  static final LoggingService _instance = LoggingService._internal();
  late final Logger _logger;
  bool _initialized = false;

  // Singleton pattern
  factory LoggingService() {
    return _instance;
  }

  LoggingService._internal();

  void initialize() {
    if (_initialized) return;

    Logger.root.level = Level.ALL; // Capture all log levels
    Logger.root.onRecord.listen((record) {
      // Format: [LEVEL] LOGGER_NAME: MESSAGE
      print('${record.level.name}: ${record.loggerName}: ${record.message}');

      if (record.error != null) {
        print('ERROR: ${record.error}');
        if (record.stackTrace != null) {
          print('STACK TRACE: ${record.stackTrace}');
        }
      }
    });

    _logger = Logger('AppLogger');
    _initialized = true;

    info('Logging service initialized');
  }

  void debug(String message) {
    _ensureInitialized();
    _logger.fine(message);
  }

  void info(String message) {
    _ensureInitialized();
    _logger.info(message);
  }

  void warning(String message, [Object? error, StackTrace? stackTrace]) {
    _ensureInitialized();
    _logger.warning(message, error, stackTrace);
  }

  void error(String message, [Object? error, StackTrace? stackTrace]) {
    _ensureInitialized();
    _logger.severe(message, error, stackTrace);
  }

  void _ensureInitialized() {
    if (!_initialized) {
      initialize();
    }
  }

  String formatError(String message, Object error) {
    return '$message: $error';
  }

  String handleNetworkError(Object error) {
    if (error.toString().contains('connection')) {
      return 'Network connection error. Please check your internet connection.';
    } else if (error.toString().contains('timeout')) {
      return 'Request timed out. Please try again later.';
    } else {
      return 'An unexpected network error occurred. Please try again.';
    }
  }
}
