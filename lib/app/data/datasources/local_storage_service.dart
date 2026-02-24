import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  Future<void> saveLike(int postId, bool isLiked) async {
    await _prefs.setBool('like_$postId', isLiked);
  }

  bool getLike(int postId) {
    return _prefs.getBool('like_$postId') ?? false;
  }

  Future<Map<int, bool>> getAllLikes() async {
    final keys = _prefs.getKeys().where((key) => key.startsWith('like_'));
    final Map<int, bool> likes = {};
    for (var key in keys) {
      final postId = int.tryParse(key.replaceFirst('like_', ''));
      if (postId != null) {
        likes[postId] = _prefs.getBool(key) ?? false;
      }
    }
    return likes;
  }
}
