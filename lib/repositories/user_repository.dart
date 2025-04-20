import 'package:pfa/models/user.dart';
import 'package:pfa/services/supabase_service.dart';

class UserRepository {
  final SupabaseService _supabaseService = SupabaseService();

  Future<Child?> getChildById(String userId) async {
    try {
      final response = await _supabaseService.client
          .from('Child')
          .select()
          .eq('user_id', userId)
          .single();

      // Get special conditions
      final specialConditionsResponse = await _supabaseService.client
          .from('ChildSpecialCondition')
          .select('condition')
          .eq('child_id', userId);

      List<SpecialCondition> specialConditions = [];
      specialConditions = (specialConditionsResponse as List)
          .map((condition) => SpecialCondition.values.firstWhere((e) =>
              e.toString() == 'SpecialCondition.${condition['condition']}'))
          .toList();
    
      return Child(
        userId: response['user_id'],
        email: response['email'],
        password: '', // Password is not returned from the database
        createdAt: DateTime.parse(response['created_at']),
        firstName: response['first_name'],
        lastName: response['last_name'],
        birthdate: DateTime.parse(response['birthdate']),
        avatarUrl: response['avatar_url'],
        specialConditions: specialConditions,
      );
    } catch (e) {
      print('Error getting child: $e');
      return null;
    }
  }

  Future<Child?> createChild(Child child) async {
    try {
      // First create the user account
      final authResponse = await _supabaseService.signUp(
        email: child.email,
        password: child.password,
      );

      if (authResponse.user == null) {
        throw Exception('Failed to create user account');
      }

      final userId = authResponse.user!.id;

      await _supabaseService.client.from('Child').insert({
        'user_id': userId,
        'email': child.email,
        'first_name': child.firstName,
        'last_name': child.lastName,
        'birthdate': child.birthdate.toIso8601String(),
        'avatar_url': child.avatarUrl,
        'created_at': DateTime.now().toIso8601String(),
      });

      for (var condition in child.specialConditions) {
        await _supabaseService.client.from('ChildSpecialCondition').insert({
          'child_id': userId,
          'condition': condition.toString().split('.').last,
        });
      }

      return Child(
        userId: userId,
        email: child.email,
        password: child.password,
        firstName: child.firstName,
        lastName: child.lastName,
        birthdate: child.birthdate,
        avatarUrl: child.avatarUrl,
        specialConditions: child.specialConditions,
      );
    } catch (e) {
      print('Error creating child: $e');
      return null;
    }
  }

  Future<bool> updateChild(Child child) async {
    try {
      await _supabaseService.client.from('Child').update({
        'first_name': child.firstName,
        'last_name': child.lastName,
        'birthdate': child.birthdate.toIso8601String(),
        'avatar_url': child.avatarUrl,
      }).eq('user_id', child.userId);

      // Delete existing special conditions
      await _supabaseService.client
          .from('ChildSpecialCondition')
          .delete()
          .eq('child_id', child.userId);

      // Insert new special conditions
      for (var condition in child.specialConditions) {
        await _supabaseService.client.from('ChildSpecialCondition').insert({
          'child_id': child.userId,
          'condition': condition.toString().split('.').last,
        });
      }

      return true;
    } catch (e) {
      print('Error updating child: $e');
      return false;
    }
  }

  Future<Educator?> getEducatorById(String userId) async {
    try {
      final response = await _supabaseService.client
          .from('Educator')
          .select()
          .eq('user_id', userId)
          .single();

      return Educator(
        userId: response['user_id'],
        email: response['email'],
        password: '', // Password is not returned from the database
        createdAt: DateTime.parse(response['created_at']),
        speciality: response['specialty'],
      );
    } catch (e) {
      print('Error getting educator: $e');
      return null;
    }
  }

  Future<Educator?> createEducator(Educator educator) async {
    try {
      // First create the user account
      final authResponse = await _supabaseService.signUp(
        email: educator.email,
        password: educator.password,
      );

      if (authResponse.user == null) {
        throw Exception('Failed to create user account');
      }

      final userId = authResponse.user!.id;

      await _supabaseService.client.from('Educator').insert({
        'user_id': userId,
        'email': educator.email,
        'specialty': educator.speciality,
        'created_at': DateTime.now().toIso8601String(),
      });

      return Educator(
        userId: userId,
        email: educator.email,
        password: educator.password,
        speciality: educator.speciality,
      );
    } catch (e) {
      print('Error creating educator: $e');
      return null;
    }
  }
}
