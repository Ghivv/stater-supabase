import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      await initializeUserData();
    } on Exception catch (err) {
      throw Exception(err);
    }
  }

  Future<void> initializeUserData() async {
    //insert data ke users table
    final user = Supabase.instance.client.auth.currentUser!;
    final userId = user.id;
    final email = user.email!;

    //if users table gak punya data dengan email ini
    final response = await Supabase.instance.client
        .from("users")
        .select()
        .eq("email", email);

    if (response.isNotEmpty) {
      return;
    }

    await Supabase.instance.client.from("users").insert({
      "id": userId,
      "name": "No Name",
      "email": email,
      "role": "User",
    });
  }

  Future<void> logout() async {
    try {
      await Supabase.instance.client.auth.signOut();
    } on Exception catch (err) {
      throw Exception(err);
    }
  }

  Future<void> register({
    required String email,
    required String password,
  }) async {
    try {
      await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );
      await initializeUserData();
    } on Exception catch (err) {
      throw Exception(err);
    }
  }

  bool isLoggedIn() {
    final session = Supabase.instance.client.auth.currentSession;
    if (session == null) {
      return false;
    }
    return true;
  }

  Future<void> updateProfile({
    required String name,
    required String email,
  }) async {
    final user = Supabase.instance.client.auth.currentUser!;
    await Supabase.instance.client.from("users").update({
      "name": name,
      "email": email,
    }).eq("email", user.email!);
  }

  Future<Map<String, dynamic>> getUserData() async {
    final user = Supabase.instance.client.auth.currentUser!;
    final response = await Supabase.instance.client
        .from("users")
        .select()
        .eq("email", user.email!)
        .single();
    return response;
  }
}
