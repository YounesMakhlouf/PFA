import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pfa/services/logging_service.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  late final SupabaseClient _client;
  bool _initialized = false;
  final LoggingService _logger = LoggingService();

  // Singleton pattern
  factory SupabaseService() {
    return _instance;
  }

  SupabaseService._internal();

  Future<void> initialize() async {
    if (_initialized) return;

    try {
      _logger.initialize();
      _logger.info('Initializing SupabaseService');

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

      _client = Supabase.instance.client;
      _initialized = true;
      _logger.info('SupabaseService initialized successfully');
    } catch (e, stackTrace) {
      _logger.error('Failed to initialize SupabaseService', e, stackTrace);
      rethrow;
    }
  }

  SupabaseClient get client {
    if (!_initialized) {
      _logger.error('SupabaseService accessed before initialization');
      throw Exception('SupabaseService must be initialized before use');
    }
    return _client;
  }

  String getPublicUrl({
    required String bucketId,
    required String filePath,
  }) {
    if (!_initialized) {
      _logger.error('SupabaseService accessed before initialization');
      throw Exception('SupabaseService must be initialized before use');
    }
    try {
      // Construct the public URL using the client's storage methods
      final url = _client.storage.from(bucketId).getPublicUrl(filePath);
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
      _logger.info('Signing out user');
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
