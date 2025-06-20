import 'package:supabase_flutter/supabase_flutter.dart';

class StudentService {
  static Future<void> create(Map item) async {
    await Supabase.instance.client.from("students").insert(item);
  }

  static Future<void> update(Map item) async {
    await Supabase.instance.client.from("students").update(item).eq("id", item["id"]);
  }

  static Future<void> delete(int id) async {
    await Supabase.instance.client.from("students").delete().eq("id", id);
  }

  static Future<List<Map>> getStudents() async {
    var response = await Supabase.instance.client
        .from("students")
        .select()
        .order("created_at", ascending: false);
    return List<Map>.from(response);
  }
}
