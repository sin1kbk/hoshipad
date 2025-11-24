import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';

/// ユーザープロファイル情報を保持するクラス
class UserProfile {
  final String id;
  final String displayName;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.id,
    required this.displayName,
    this.avatarUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      displayName: json['display_name'] as String,
      avatarUrl: json['avatar_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'display_name': displayName,
      'avatar_url': avatarUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// Supabase Authのラッパーサービス
class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// 現在のユーザーを取得
  User? get currentUser => _supabase.auth.currentUser;

  /// 認証状態の変更を監視するStream
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  /// メールアドレスとパスワードでサインアップ
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'display_name': displayName,
      },
    );

    return response;
  }

  /// メールアドレスとパスワードでログイン
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    return response;
  }

  /// ログアウト
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // ========================================
  // ソーシャルログイン
  // ========================================

  /// Googleアカウントでログイン
  Future<bool> signInWithGoogle() async {
    try {
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: _getRedirectUrl(),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Appleアカウントでログイン
  Future<bool> signInWithApple() async {
    try {
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.apple,
        redirectTo: _getRedirectUrl(),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  /// GitHubアカウントでログイン
  Future<bool> signInWithGitHub() async {
    try {
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.github,
        redirectTo: _getRedirectUrl(),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  /// リダイレクトURLを取得
  String _getRedirectUrl() {
    // Web: 現在のオリジン + /auth/callback
    // Mobile: カスタムURLスキーム
    // 環境に応じて適切なURLを返す
    return 'hoshipad://auth/callback';
  }

  /// パスワードリセットメールを送信
  Future<void> resetPassword(String email) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }

  /// パスワードを更新
  Future<UserResponse> updatePassword(String newPassword) async {
    final response = await _supabase.auth.updateUser(
      UserAttributes(password: newPassword),
    );
    return response;
  }

  /// ユーザープロファイルを取得
  Future<UserProfile?> getUserProfile(String userId) async {
    final response = await _supabase
        .from('user_profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return UserProfile.fromJson(response);
  }

  /// 現在のユーザーのプロファイルを取得
  Future<UserProfile?> getCurrentUserProfile() async {
    final user = currentUser;
    if (user == null) {
      return null;
    }

    return getUserProfile(user.id);
  }

  /// ユーザープロファイルを更新
  Future<void> updateUserProfile({
    required String userId,
    String? displayName,
    String? avatarUrl,
  }) async {
    final updates = <String, dynamic>{};

    if (displayName != null) {
      updates['display_name'] = displayName;
    }

    if (avatarUrl != null) {
      updates['avatar_url'] = avatarUrl;
    }

    if (updates.isEmpty) {
      return;
    }

    await _supabase.from('user_profiles').update(updates).eq('id', userId);
  }

  /// アバター画像をアップロード
  Future<String> uploadAvatar({
    required String userId,
    required String filePath,
    required List<int> fileBytes,
  }) async {
    final fileExt = filePath.split('.').last;
    final fileName = '$userId-${DateTime.now().millisecondsSinceEpoch}.$fileExt';
    final path = 'avatars/$fileName';

    await _supabase.storage.from('avatars').uploadBinary(
          path,
          Uint8List.fromList(fileBytes),
          fileOptions: FileOptions(
            upsert: true,
          ),
        );

    final publicUrl = _supabase.storage.from('avatars').getPublicUrl(path);

    return publicUrl;
  }
}
