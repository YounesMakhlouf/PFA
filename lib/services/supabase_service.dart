import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  late final SupabaseClient _client;
  bool _initialized = false;

  // Singleton pattern
  factory SupabaseService() {
    return _instance;
  }

  SupabaseService._internal();

  Future<void> initialize() async {
    if (_initialized) return;

    await dotenv.load();

    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL'] ?? '',
      anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
    );

    _client = Supabase.instance.client;
    _initialized = true;
  }

  SupabaseClient get client {
    if (!_initialized) {
      throw Exception('SupabaseService must be initialized before use');
    }
    return _client;
  }

  // Auth methods
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return await client.auth.signUp(email: email, password: password);
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  bool get isAuthenticated => client.auth.currentUser != null;

  User? get currentUser => client.auth.currentUser;
}
