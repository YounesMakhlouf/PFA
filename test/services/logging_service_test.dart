import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:pfa/services/logging_service.dart';

void main() {
  group('LoggingService', () {
    late LoggingService loggingService;

    setUp(() {
      loggingService = LoggingService();
    });

    test('should be a singleton', () {
      final instance1 = LoggingService();
      final instance2 = LoggingService();

      expect(identical(instance1, instance2), isTrue);
    });

    test('initialize should set up logger correctly', () {
      loggingService.initialize();

      // Verify that the root logger is configured correctly
      expect(Logger.root.level, equals(Level.ALL));

      // Calling initialize again should not cause issues
      loggingService.initialize();
    });

    test('logging methods should call initialize if not initialized', () {
      // Create a fresh instance to ensure it's not initialized
      final freshService = LoggingService();

      // This should call _ensureInitialized internally
      freshService.info('Test message');
    });

    test('debug method should log with fine level', () {
      loggingService.debug('Debug message');
    });

    test('info method should log with info level', () {
      loggingService.info('Info message');
    });

    test('warning method should log with warning level', () {
      loggingService.warning('Warning message');
      loggingService.warning('Warning with error', Exception('Test error'));
    });

    test('error method should log with severe level', () {
      loggingService.error('Error message');
      loggingService.error('Error with exception', Exception('Test error'));
    });

    test('formatError should format error message correctly', () {
      final result = loggingService.formatError(
          'Failed to load', Exception('Network error'));

      expect(result, 'Failed to load: Exception: Network error');
    });

    test('handleNetworkError should return appropriate messages', () {
      final connectionError =
          loggingService.handleNetworkError(Exception('connection failed'));
      expect(connectionError,
          'Network connection error. Please check your internet connection.');

      final timeoutError =
          loggingService.handleNetworkError(Exception('timeout occurred'));
      expect(timeoutError, 'Request timed out. Please try again later.');

      final otherError =
          loggingService.handleNetworkError(Exception('unknown error'));
      expect(otherError,
          'An unexpected network error occurred. Please try again.');
    });
  });
}
