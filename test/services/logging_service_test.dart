import 'package:flutter_test/flutter_test.dart';
import 'dart:async';
import 'package:logging/logging.dart';
import 'package:pfa/services/logging_service.dart';

void main() {
  group('LoggingService', () {
    late LoggingService loggingService;
    late List<LogRecord> capturedLogs;
    StreamSubscription<LogRecord>? logSubscription;
    setUp(() {
      // Reset captured logs for each test
      capturedLogs = [];
      loggingService = LoggingService();
      loggingService.initialize();

      // Capture logs
      logSubscription = Logger.root.onRecord.listen((record) {
        capturedLogs.add(record);
      });
    });

    tearDown(() {
      logSubscription?.cancel();
    });

    test('should be a singleton', () {
      final instance1 = LoggingService();
      final instance2 = LoggingService();

      expect(identical(instance1, instance2), isTrue);
    });

    test('initialize should set up logger correctly', () {
      // Verify that the root logger is configured correctly
      expect(Logger.root.level, equals(Level.ALL));

      // Calling initialize again should not cause issues
      loggingService.initialize();
    });

    test('debug method should log with fine level and correct message', () {
      const message = 'Debug message';
      loggingService.debug(message);

      expect(capturedLogs.length, 1);
      expect(capturedLogs.first.level, Level.FINE);
      expect(capturedLogs.first.message, message);
    });

    test('info method should log with info level and correct message', () {
      const message = 'Info message';
      loggingService.info(message);

      expect(capturedLogs.length, 1);
      expect(capturedLogs.first.level, Level.INFO);
      expect(capturedLogs.first.message, message);
    });

    test('warning method should log with warning level and correct message',
        () {
      const message1 = 'Warning message';
      loggingService.warning(message1);

      const message2 = 'Warning with error and stacktrace';
      final error = Exception('Test error');
      final stackTrace = StackTrace.current;
      loggingService.warning(message2, error, stackTrace);

      expect(capturedLogs.length, 2);
      expect(capturedLogs[0].level, Level.WARNING);
      expect(capturedLogs[0].message, message1);
      expect(capturedLogs[0].error, isNull);
      expect(capturedLogs[0].stackTrace, isNull);

      expect(capturedLogs[1].level, Level.WARNING);
      expect(capturedLogs[1].message, message2);
      expect(capturedLogs[1].error, error);
      expect(capturedLogs[1].stackTrace, stackTrace);
    });

    test('error method should log with severe level and correct message', () {
      const message1 = 'Error message';
      loggingService.error(message1);

      const message2 = 'Error with exception and stacktrace';
      final error = Exception('Test error');
      final stackTrace = StackTrace.current;
      loggingService.error(message2, error, stackTrace);

      expect(capturedLogs.length, 2);
      expect(capturedLogs[0].level, Level.SEVERE);
      expect(capturedLogs[0].message, message1);
      expect(capturedLogs[0].error, isNull);
      expect(capturedLogs[0].stackTrace, isNull);

      expect(capturedLogs[1].level, Level.SEVERE);
      expect(capturedLogs[1].message, message2);
      expect(capturedLogs[1].error, error);
      expect(capturedLogs[1].stackTrace, stackTrace);
    });

    test('formatError should format error message correctly', () {
      final result = loggingService.formatError(
          'Failed to load', Exception('Network error'));
      expect(result, 'Failed to load: Exception: Network error');

      // Test with null error
      final resultNullError =
          loggingService.formatError('Failed to load', null);
      expect(resultNullError, 'Failed to load');

      // Test with null message
      final resultNullMessage =
          loggingService.formatError(null, Exception('Network error'));
      expect(resultNullMessage, contains('null: Exception: Network error'));

      // Test with empty message
      final resultEmptyMessage =
          loggingService.formatError('', Exception('Some error'));
      expect(resultEmptyMessage, ': Exception: Some error');

      // Test with null message and null error
      final resultNullBoth = loggingService.formatError(null, null);
      expect(resultNullBoth, 'null');

      // Test with empty message and null error
      final resultEmptyMessageNullError = loggingService.formatError('', null);
      expect(resultEmptyMessageNullError, '');
    });

    test('handleNetworkError should return appropriate messages', () {
      // Case-insensitive checks
      final connectionErrorLower =
          loggingService.handleNetworkError(Exception('connection failed'));
      expect(connectionErrorLower,
          'Network connection error. Please check your internet connection.');

      final connectionErrorUpper =
          loggingService.handleNetworkError(Exception('CONNECTION FAILED'));
      expect(connectionErrorUpper,
          'Network connection error. Please check your internet connection.');

      final timeoutErrorLower =
          loggingService.handleNetworkError(Exception('timeout occurred'));
      expect(timeoutErrorLower, 'Request timed out. Please try again later.');

      final timeoutErrorUpper =
          loggingService.handleNetworkError(Exception('TIMEOUT OCCURRED'));
      expect(timeoutErrorUpper, 'Request timed out. Please try again later.');

      final otherError =
          loggingService.handleNetworkError(Exception('unknown error'));
      expect(otherError,
          'An unexpected network error occurred. Please try again.');

      // Test with null input
      final nullError = loggingService.handleNetworkError(null);
      expect(
          nullError, 'An unexpected network error occurred. Please try again.');

      // Test with non-Exception error object
      final nonExceptionError =
          loggingService.handleNetworkError('just a string error');
      expect(nonExceptionError,
          'An unexpected network error occurred. Please try again.');
    });
  });
}
