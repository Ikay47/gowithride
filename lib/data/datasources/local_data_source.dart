import 'dart:convert'; // For jsonEncode and jsonDecode
import 'package:gowithride/core/errors/exceptions.dart';
import 'package:gowithride/data/models/user_model.dart'; // Import UserModel
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalDataSource {
  // Token methods
  Future<String?> getAuthToken(); // Changed to nullable String
  Future<void> cacheAuthToken(String token);
  Future<void> clearAuthToken();

  // User caching methods
  Future<void> cacheUser(UserModel userToCache);
  Future<UserModel> getCachedUser();
  Future<void> clearCachedUser();

  // General cache clear (optional if you prefer more granular control)
  Future<void> clearAllAppCache(); // Renamed to be more explicit
}

const CACHED_AUTH_TOKEN = 'auth_token';
const CACHED_USER = 'cached_user';

class LocalDataSourceImpl implements LocalDataSource {
  final SharedPreferences sharedPreferences;

  LocalDataSourceImpl({required this.sharedPreferences});

  // --- Token Methods ---
  @override
  Future<String?> getAuthToken() async {
    final token = sharedPreferences.getString(CACHED_AUTH_TOKEN);
    if (token != null) {
      return token;
    } else {
      // It's common to return null if not found, rather than throwing.
      // The repository or use case can then decide if this is a "Failure".
      return null;
      // If you absolutely want to throw:
      // throw CacheException('No auth token found');
    }
  }

  @override
  Future<void> cacheAuthToken(String token) async {
    try {
      await sharedPreferences.setString(CACHED_AUTH_TOKEN, token);
    } catch (e) {
      throw CacheException('Failed to cache auth token: ${e.toString()}');
    }
  }

  @override
  Future<void> clearAuthToken() async {
    try {
      await sharedPreferences.remove(CACHED_AUTH_TOKEN);
    } catch (e) {
      throw CacheException('Failed to clear auth token: ${e.toString()}');
    }
  }

  // --- User Caching Methods ---
  @override
  Future<void> cacheUser(UserModel userToCache) async {
    try {
      final userJsonString = json.encode(userToCache.toJson());
      await sharedPreferences.setString(CACHED_USER, userJsonString);
    } catch (e) {
      throw CacheException('Failed to cache user: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> getCachedUser() async {
    final jsonString = sharedPreferences.getString(CACHED_USER);
    if (jsonString != null) {
      try {
        return UserModel.fromJson(json.decode(jsonString) as Map<String, dynamic>);
      } catch (e) {
        // If decoding fails, it's a cache error (corrupted data)
        throw CacheException('Failed to decode cached user: ${e.toString()}');
      }
    } else {
      throw CacheException('No user cached.'); // Or 'User not found in cache'
    }
  }

  @override
  Future<void> clearCachedUser() async {
    try {
      await sharedPreferences.remove(CACHED_USER);
    } catch (e) {
      throw CacheException('Failed to clear cached user: ${e.toString()}');
    }
  }

  // --- General Cache Clear ---
  @override
  Future<void> clearAllAppCache() async {
    try {
      // Be careful with clear() as it removes EVERYTHING from SharedPreferences.
      // It's often better to remove specific keys unless a full reset is intended.
      await sharedPreferences.remove(CACHED_AUTH_TOKEN);
      await sharedPreferences.remove(CACHED_USER);
      // If you want to clear absolutely everything:
      // await sharedPreferences.clear();
      print("App cache (token and user) cleared.");
    } catch (e) {
      throw CacheException('Failed to clear app cache: ${e.toString()}');
    }
  }
}