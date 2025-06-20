import 'package:supabase_flutter/supabase_flutter.dart';

class InvitationService {
  static Future<void> create(Map item) async {
    await Supabase.instance.client.from("invitations").insert(item);
  }

  static Future<void> update(Map item) async {
    await Supabase.instance.client.from("invitations").update(item).eq("id", item["id"]);
  }

  static Future<void> delete(int id) async {
    await Supabase.instance.client.from("invitations").delete().eq("id", id);
  }

  static Future<List<Map>> getInvitations() async {
    var response = await Supabase.instance.client
        .from("invitations")
        .select()
        .order("created_at", ascending: false);
    return List<Map>.from(response);
  }
}
