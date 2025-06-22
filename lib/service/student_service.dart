import 'package:supabase_flutter/supabase_flutter.dart';

class StudentService {
  static Future<void> create(Map item) async {
    try {
      // Remove id if it exists for new records
      final Map<String, dynamic> cleanItem = Map<String, dynamic>.from(item);
      cleanItem.remove('id');
      
      final response = await Supabase.instance.client
          .from("students")
          .insert(cleanItem)
          .select();
      
      if (response.isEmpty) {
        throw Exception('Failed to create student');
      }
    } catch (e) {
      print('Error creating student: $e');
      throw Exception('Failed to create student: ${e.toString()}');
    }
  }

  static Future<void> update(Map item) async {
    try {
      if (item['id'] == null) {
        throw Exception('ID is required for update operation');
      }
      
      final response = await Supabase.instance.client
          .from("students")
          .update(item)
          .eq("id", item["id"])
          .select();
      
      if (response.isEmpty) {
        throw Exception('No student found with the given ID');
      }
    } catch (e) {
      print('Error updating student: $e');
      throw Exception('Failed to update student: ${e.toString()}');
    }
  }

  static Future<void> delete(int id) async {
    try {
      final response = await Supabase.instance.client
          .from("students")
          .delete()
          .eq("id", id)
          .select();
      
      if (response.isEmpty) {
        throw Exception('No student found with the given ID');
      }
    } catch (e) {
      print('Error deleting student: $e');
      throw Exception('Failed to delete student: ${e.toString()}');
    }
  }

  static Future<List<Map>> getStudents() async {
    try {
      final response = await Supabase.instance.client
          .from("students")
          .select()
          .order("created_at", ascending: false);
      
      return List<Map>.from(response);
    } catch (e) {
      print('Error fetching students: $e');
      throw Exception('Failed to fetch students: ${e.toString()}');
    }
  }

  static Future<Map?> getStudentById(int id) async {
    try {
      final response = await Supabase.instance.client
          .from("students")
          .select()
          .eq("id", id)
          .single();
      
      return response;
    } catch (e) {
      print('Error fetching student by ID: $e');
      return null;
    }
  }
}
