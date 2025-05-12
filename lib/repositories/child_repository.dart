import 'dart:ffi';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pfa/models/user.dart';
import 'package:pfa/services/supabase_service.dart';
import 'package:pfa/services/logging_service.dart';

class ChildRepository {
  final SupabaseService _supabaseService;
  final LoggingService _logger;

  ChildRepository({
    required SupabaseService supabaseService,
    required LoggingService logger,
  })  : _supabaseService = supabaseService,
        _logger = logger;

  /// Fetches all child profiles associated with the currently logged-in parent.
  Future<List<Child>> getChildProfilesForParent() async {
    final currentUser = _supabaseService.currentUser;
    if (currentUser == null) {
      _logger.error('Attempted to fetch child profiles while not logged in.');
      return [];
    }
    final accountId = currentUser.id;

    try {
      _logger.info('Fetching child profiles for account: $accountId');
      final response = await _supabaseService.client
          .from('child')
          .select()
          .eq('user_id', accountId);

      final List<Child> profiles =
          response.map((data) => Child.fromJson(data)).toList();

      _logger.info(
          'Found ${profiles.length} child profiles for account: $accountId');
      return profiles;
    } on PostgrestException catch (e, stackTrace) {
      _logger.error('Supabase error fetching child profiles', e, stackTrace);
      throw Exception('Failed to load child profiles: ${e.message}');
    } catch (e, stackTrace) {
      _logger.error('Unexpected error fetching child profiles', e, stackTrace);
      throw Exception('An unexpected error occurred while loading profiles.');
    }
  }

  Future<Child?> getChildProfileById(String childId) async {
    try {
      _logger.info('Fetching child profile by ID: $childId');
      final response = await _supabaseService.client
          .from('child')
          .select()
          .eq('child_id', childId)
          .maybeSingle();

      if (response == null) {
        _logger.error(
            'Child profile not found or not accessible for ID: $childId');
        return null;
      }

      _logger.info('Successfully fetched child profile: $childId');
      return Child.fromJson(response);
    } on PostgrestException catch (e, stackTrace) {
      _logger.error(
          'Supabase error fetching child profile $childId', e, stackTrace);
      throw Exception('Failed to load child profile: ${e.message}');
    } catch (e, stackTrace) {
      _logger.error(
          'Unexpected error fetching child profile $childId', e, stackTrace);
      throw Exception(
          'An unexpected error occurred while loading the profile.');
    }
  }

  /// Creates a child profile entry linked to the currently authenticated parent.
  Future<Child?> createChildProfile({
    required String firstName,
    String? lastName,
    DateTime? birthdate,
    String? avatarUrl,
    Set<SpecialCondition> specialConditions = const {},
  }) async {
    final currentUser = _supabaseService.currentUser;
    if (currentUser == null) {
      _logger.error('Attempted to create child profile while not logged in.');
      throw Exception('User must be logged in to create a child profile.');
    }
    final accountId = currentUser.id;

    try {
      _logger
          .info('Attempting to create child profile for account: $accountId');

      final birthdateString = birthdate?.toIso8601String().substring(0, 10);
      final List<String> specialConditionsList =
          specialConditions.map((e) => e.name).toList();

      final response = await _supabaseService.client
          .from('child')
          .insert({
            'user_id': accountId,
            'first_name': firstName,
            'last_name': lastName,
            'birthdate': birthdateString,
            'avatar_url': avatarUrl,
            'special_conditions':
                specialConditionsList.isEmpty ? null : specialConditionsList,
          })
          .select()
          .single();

      _logger.info(
          'Successfully created child profile with ID: ${response['child_id']}');
      return Child.fromJson(response);
    } on PostgrestException catch (e, stackTrace) {
      _logger.error('Supabase error creating child profile', e, stackTrace);
      throw Exception('Database error: Failed to save profile. ${e.message}');
    } catch (e, stackTrace) {
      _logger.error('Unexpected error creating child profile', e, stackTrace);
      throw Exception(
          'An unexpected error occurred while creating the profile.');
    }
  }

  Future<bool> updateChildProfile(Child updatedChild) async {
    final currentUser = _supabaseService.currentUser;
    if (currentUser == null) {
      _logger.warning('Attempted to update child profile while not logged in.');
      return false;
    }
    try {
      _logger
          .info('Attempting to update child profile: ${updatedChild.childId}');

      final birthdateString =
          updatedChild.birthdate.toIso8601String().substring(0, 10);
      final List<String> specialConditionsList =
          updatedChild.specialConditions.map((e) => e.name).toList();

      await _supabaseService.client.from('child').update({
        'first_name': updatedChild.firstName,
        'last_name': updatedChild.lastName,
        'birthdate': birthdateString,
        'avatar_url': updatedChild.avatarUrl,
        'special_conditions':
            specialConditionsList.isEmpty ? null : specialConditionsList,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('child_id', updatedChild.childId);

      _logger
          .info('Successfully updated child profile: ${updatedChild.childId}');
      return true;
    } on PostgrestException catch (e, stackTrace) {
      _logger.error(
          'Supabase error updating child profile ${updatedChild.childId}',
          e,
          stackTrace);
      throw Exception('Database error: Failed to update profile. ${e.message}');
    } catch (e, stackTrace) {
      _logger.error(
          'Unexpected error updating child profile ${updatedChild.childId}',
          e,
          stackTrace);
      throw Exception(
          'An unexpected error occurred while updating the profile.');
    }
  }

  Future<bool> deleteChildProfile(String childId) async {
    final currentUser = _supabaseService.currentUser;
    if (currentUser == null) {
      _logger.warning('Attempted to delete child profile while not logged in.');
      return false;
    }

    try {
      _logger.info('Attempting to delete child profile: $childId');
      await _supabaseService.client
          .from('child')
          .delete()
          .eq('child_id', childId);

      _logger.info(
          'Successfully deleted child profile: $childId (if it existed and was permitted)');
      return true;
    } on PostgrestException catch (e, stackTrace) {
      _logger.error(
          'Supabase error deleting child profile $childId', e, stackTrace);
      throw Exception('Database error: Failed to delete profile. ${e.message}');
    } catch (e, stackTrace) {
      _logger.error(
          'Unexpected error deleting child profile $childId', e, stackTrace);
      throw Exception(
          'An unexpected error occurred while deleting the profile.');
    }
  }

  /// child - educator operations

  /// fetches all educators associated to a given child
  Future<List<String>> getEducatorsForChild(String childId) async {
    final currentUser = _supabaseService.currentUser;
    if (currentUser == null) {
      _logger.warning('Attempted to add educator while not logged in.');
      throw Exception('Unauthorized, please login first');
    }
    try{
      _logger.info("Attempting to fetch educators for child $childId");
      final response = await _supabaseService.client.rpc<List<String>>(
        'get_educators_for_child',
        params: {
          'child_id': childId,
        }
      );
      return response;
    } catch(e,stackTrace){
      _logger.error(
        'Unexpected error fetching educators for child $childId', e, stackTrace,
      );
      throw Exception('An unexpected error occurred while fetching educators');
    }
  }
  /// associates an educator to  a given child
  Future<String> addEducatorByEmail(String childId, String educatorEmail) async {
    final currentUser = _supabaseService.currentUser;
    if (currentUser == null) {
      _logger.warning('Attempted to add educator while not logged in.');
      return 'Unauthorized, please login first';
    }
    try {
      _logger.info("Attempting to add educator $educatorEmail to child $childId");
      final response = await _supabaseService.client.rpc<String>(
        'add_educator_by_email',
        params: {
          'child_id': childId,
          'educator_email': educatorEmail,
        },
      );
      return response;
    } catch (e, stackTrace) {
      _logger.error(
        'Unexpected error adding educator to child $childId', e, stackTrace,
      );
      throw Exception('An unexpected error occurred while adding the educator');
    }
  }
  /// removes an educator from a child's list of educators
  Future<String> removeEducatorByEmail(String childId, String educatorEmail) async {
    final currentUser = _supabaseService.currentUser;
    if (currentUser == null) {
      _logger.warning('Attempted to remove educator while not logged in.');
      return 'Unauthorized, please login first';
    }
    try {
      _logger.info("Attempting to remove educator $educatorEmail from child $childId");
      final response = await _supabaseService.client.rpc<String>(
        'remove_educator_by_email',
        params: {
          'child_id': childId,
          'educator_email': educatorEmail,
        },
      );
      return response;
    } catch (e, stackTrace) {
      _logger.error(
        'Unexpected error removing educator from child $childId', e, stackTrace,
      );
      throw Exception('An unexpected error occurred while removing the educator');
    }
  }
}
