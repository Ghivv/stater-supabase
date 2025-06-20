import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      print("🔍 AuthService: Attempting login for email: $email");

      // Query admin dari database berdasarkan email
      final response = await Supabase.instance.client
          .from("admins")
          .select()
          .eq("email", email)
          .eq("is_active", true)
          .single();

      print(
          "✅ AuthService: Admin found: ${response['name']} (${response['email']})");

      // Verifikasi password (dalam implementasi nyata, gunakan hash password)
      if (response['password'] != password) {
        print("❌ AuthService: Password mismatch for email: $email");
        throw Exception('Email atau password salah');
      }

      print("🎉 AuthService: Login successful for admin: ${response['name']}");

      // Simpan session ke SharedPreferences
      await _saveSession(response);
      return response;
    } on PostgrestException catch (err) {
      print("🚨 AuthService PostgrestException:");
      print("   Code: ${err.code}");
      print("   Message: ${err.message}");
      print("   Details: ${err.details}");
      print("   Hint: ${err.hint}");

      if (err.code == 'PGRST116') {
        throw Exception('Email tidak ditemukan atau admin tidak aktif');
      }
      throw Exception('Database error: ${err.message}');
    } on Exception catch (err) {
      print("🚨 AuthService General Exception: ${err.toString()}");
      throw Exception('Login gagal: ${err.toString()}');
    } catch (err) {
      print("🚨 AuthService Unknown Error: $err");
      print("   Error Type: ${err.runtimeType}");
      throw Exception('Terjadi kesalahan yang tidak diketahui: $err');
    }
  }

  Future<void> _saveSession(Map<String, dynamic> admin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('adminId', admin['id'].toString());
    await prefs.setString('adminEmail', admin['email'] ?? '');
    await prefs.setString('adminName', admin['name'] ?? '');
  }

  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('adminId');
    await prefs.remove('adminEmail');
    await prefs.remove('adminName');
  }

  Future<Map<String, String>?> getCurrentSession() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (!isLoggedIn) return null;
    return {
      'adminId': prefs.getString('adminId') ?? '',
      'adminEmail': prefs.getString('adminEmail') ?? '',
      'adminName': prefs.getString('adminName') ?? '',
    };
  }

  // Method ini tidak diperlukan untuk admin login
  Future<void> initializeUserData() async {
    // Not needed for admin login
  }

  Future<void> logout() async {
    // Untuk admin login, cukup clear session lokal
    await _clearSession();
  }

  // Method ini tidak diperlukan untuk admin (tidak ada register)
  Future<void> register({
    required String email,
    required String password,
  }) async {
    throw Exception('Register tidak tersedia untuk admin');
  }

  // Cek apakah admin sudah login (gunakan shared preferences atau storage lokal)
  // bool isLoggedIn() {
  //   // Implementasi sederhana, dalam production gunakan secure storage
  //   // Sekarang cek dari SharedPreferences
  //   // NOTE: Ini harus async, jadi sebaiknya gunakan Future<bool> di UI
  //   throw UnimplementedError('Gunakan isLoggedInAsync()');
  // }

  Future<bool> isLoggedInAsync() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  Future<void> updateProfile({
    required String adminId,
    required String name,
    required String email,
  }) async {
    try {
      print("🔄 AuthService: Updating profile for admin ID: $adminId");

      await Supabase.instance.client.from("admins").update({
        "name": name,
        "email": email,
        "updated_at": DateTime.now().toIso8601String(),
      }).eq("id", adminId);

      print("✅ AuthService: Profile updated successfully");
    } on PostgrestException catch (err) {
      print("🚨 AuthService updateProfile PostgrestException:");
      print("   Code: ${err.code}");
      print("   Message: ${err.message}");
      print("   Details: ${err.details}");
      throw Exception('Database error: ${err.message}');
    } catch (err) {
      print("🚨 AuthService updateProfile Error: $err");
      throw Exception('Gagal update profile: $err');
    }
  }

  Future<Map<String, dynamic>> getAdminData(String adminId) async {
    try {
      print("🔍 AuthService: Getting admin data for ID: $adminId");

      final response = await Supabase.instance.client
          .from("admins")
          .select()
          .eq("id", adminId)
          .eq("is_active", true)
          .single();

      print("✅ AuthService: Admin data retrieved: ${response['name']}");
      return response;
    } on PostgrestException catch (err) {
      print("🚨 AuthService getAdminData PostgrestException:");
      print("   Code: ${err.code}");
      print("   Message: ${err.message}");
      print("   Details: ${err.details}");

      if (err.code == 'PGRST116') {
        throw Exception('Admin tidak ditemukan atau tidak aktif');
      }
      throw Exception('Database error: ${err.message}');
    } catch (err) {
      print("🚨 AuthService getAdminData Error: $err");
      throw Exception('Gagal mengambil data admin: $err');
    }
  }
}
