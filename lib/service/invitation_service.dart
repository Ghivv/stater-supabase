import 'package:supabase_flutter/supabase_flutter.dart';

class InvitationService {
  static Future<void> create(Map item) async {
    try {
      // Remove id if it exists for new records
      final Map<String, dynamic> cleanItem = Map<String, dynamic>.from(item);
      cleanItem.remove('id');
      
      final response = await Supabase.instance.client
          .from("invitations")
          .insert(cleanItem)
          .select();
      
      if (response.isEmpty) {
        throw Exception('Failed to create invitation');
      }
    } catch (e) {
      print('Error creating invitation: $e');
      throw Exception('Failed to create invitation: ${e.toString()}');
    }
  }

  static Future<void> update(Map item) async {
    try {
      if (item['id'] == null) {
        throw Exception('ID is required for update operation');
      }
      
      final response = await Supabase.instance.client
          .from("invitations")
          .update(item)
          .eq("id", item["id"])
          .select();
      
      if (response.isEmpty) {
        throw Exception('No invitation found with the given ID');
      }
    } catch (e) {
      print('Error updating invitation: $e');
      throw Exception('Failed to update invitation: ${e.toString()}');
    }
  }

  static Future<void> delete(int id) async {
    try {
      final response = await Supabase.instance.client
          .from("invitations")
          .delete()
          .eq("id", id)
          .select();
      
      if (response.isEmpty) {
        throw Exception('No invitation found with the given ID');
      }
    } catch (e) {
      print('Error deleting invitation: $e');
      throw Exception('Failed to delete invitation: ${e.toString()}');
    }
  }

  static Future<List<Map>> getInvitations() async {
    try {
      final response = await Supabase.instance.client
          .from("invitations")
          .select()
          .order("created_at", ascending: false);
      
      return List<Map>.from(response);
    } catch (e) {
      print('Error fetching invitations: $e');
      throw Exception('Failed to fetch invitations: ${e.toString()}');
    }
  }

  static Future<Map?> getInvitationById(int id) async {
    try {
      final response = await Supabase.instance.client
          .from("invitations")
          .select()
          .eq("id", id)
          .single();
      
      return response;
    } catch (e) {
      print('Error fetching invitation by ID: $e');
      return null;
    }
  }
}
