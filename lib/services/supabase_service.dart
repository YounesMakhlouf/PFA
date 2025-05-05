import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pfa/services/logging_service.dart';

class SupabaseService {
  final LoggingService _logger;
  bool _initAttempted = false;
  SupabaseService(this._logger);

  Future<void> initialize() async {
    if (_initAttempted) {
      _logger.debug('Initialization attempt skipped (already attempted).');
      return;
    }
    _initAttempted = true;
    try {
      _logger.info('Initializing Supabase global instance...');
      await dotenv.load();

      final supabaseUrl = dotenv.env['SUPABASE_URL'];
      final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

      if (supabaseUrl == null || supabaseUrl.isEmpty) {
        throw Exception('SUPABASE_URL is not defined in .env file');
      }

      if (supabaseAnonKey == null || supabaseAnonKey.isEmpty) {
        throw Exception('SUPABASE_ANON_KEY is not defined in .env file');
      }

      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
      );

      _logger.info('Supabase global instance initialized successfully.');
    } catch (e, stackTrace) {
      _logger.error('Error during Supabase.initialize() call', e, stackTrace);
      if (!e.toString().contains("already been initialized")) {
        rethrow;
      } else {
        _logger.warning("Supabase was already initialized.");
      }
    }
  }

  SupabaseClient get client {
    try {
      return Supabase.instance.client;
    } catch (e) {
      _logger.error(
          'Supabase.instance.client accessed before Supabase was successfully initialized.',
          e);
      throw Exception(
          'Supabase client is not available. Ensure initialization succeeded.');
    }
  }

  String getPublicUrl({
    required String bucketId,
    required String filePath,
  }) {
    try {
      // Construct the public URL using the client's storage methods
      final url = client.storage.from(bucketId).getPublicUrl(filePath);
      _logger.debug('Generated public URL for $bucketId/$filePath: $url');
      return url;
    } catch (e, stackTrace) {
      _logger.error(
          'Failed to get public URL for $bucketId/$filePath', e, stackTrace);
      rethrow;
    }
  }

  // Auth methods
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    try {
      _logger.info('Attempting to sign up user: $email');
      final response =
          await client.auth.signUp(email: email, password: password);
      _logger.info('User signed up successfully');
      return response;
    } catch (e, stackTrace) {
      _logger.error('Failed to sign up user', e, stackTrace);
      throw _handleAuthError(e);
    }
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _logger.info('Attempting to sign in user: $email');
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      _logger.info('User signed in successfully');
      return response;
    } catch (e, stackTrace) {
      _logger.error('Failed to sign in user', e, stackTrace);
      throw _handleAuthError(e);
    }
  }

  Future<void> signOut() async {
    try {
      final userId = currentUser?.id;
      _logger.info('Signing out user: $userId');
      await client.auth.signOut();
      _logger.info('User signed out successfully');
    } catch (e, stackTrace) {
      _logger.error('Failed to sign out user', e, stackTrace);
      throw Exception('Failed to sign out: ${e.toString()}');
    }
  }

  bool get isAuthenticated => client.auth.currentUser != null;

  User? get currentUser => client.auth.currentUser;

  Exception _handleAuthError(Object error) {
    String message = 'Authentication failed';

    if (error is AuthException) {
      switch (error.statusCode) {
        case '400':
          message = 'Invalid email or password';
          break;
        case '401':
          message = 'Unauthorized. Please sign in again';
          break;
        case '422':
          message = 'Invalid credentials';
          break;
        default:
          message = error.message;
      }
    } else if (error.toString().contains('network')) {
      message = 'Network error. Please check your connection';
    }

    return Exception(message);
  }
}
