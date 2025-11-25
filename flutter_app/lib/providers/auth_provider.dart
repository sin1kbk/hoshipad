import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';

/// 認証状態を管理するProvider
class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  User? _currentUser;
  UserProfile? _currentUserProfile;
  bool _isLoading = true;
  String? _errorMessage;
  StreamSubscription<AuthState>? _authSubscription;

  AuthProvider(this._authService) {
    _initialize();
  }

  /// 現在のユーザー
  User? get currentUser => _currentUser;

  /// 現在のユーザープロファイル
  UserProfile? get currentUserProfile => _currentUserProfile;

  /// ローディング状態
  bool get isLoading => _isLoading;

  /// エラーメッセージ
  String? get errorMessage => _errorMessage;

  /// 認証済みかどうか
  bool get isAuthenticated => _currentUser != null;

  /// 初期化処理
  void _initialize() {
    _currentUser = _authService.currentUser;
    _loadUserProfile();

    // 認証状態の変更を監視
    _authSubscription = _authService.authStateChanges.listen((AuthState data) {
      _currentUser = data.session?.user;
      _loadUserProfile();
      notifyListeners();
    });
  }

  /// ユーザープロファイルを読み込む
  Future<void> _loadUserProfile() async {
    if (_currentUser == null) {
      _currentUserProfile = null;
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      _currentUserProfile = await _authService.getCurrentUserProfile();
    } catch (e) {
      debugPrint('Failed to load user profile: $e');
      _currentUserProfile = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// サインアップ
  Future<bool> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _authService.signUp(
        email: email,
        password: password,
        displayName: displayName,
      );

      // セッションがある場合はログイン状態にする（メール確認不要の場合）
      if (response.session != null) {
        _currentUser = response.user;
        await _loadUserProfile();
      }
      // セッションがない場合はメール確認待ち（ログイン状態にはしない）

      return true;
    } on AuthException catch (e) {
      _setError(_getErrorMessage(e));
      return false;
    } catch (e) {
      _setError('予期しないエラーが発生しました: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// ログイン
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _authService.signIn(
        email: email,
        password: password,
      );

      if (response.user != null) {
        _currentUser = response.user;
        await _loadUserProfile();
        return true;
      }

      _setError('ログインに失敗しました');
      return false;
    } on AuthException catch (e) {
      _setError(_getErrorMessage(e));
      return false;
    } catch (e) {
      _setError('予期しないエラーが発生しました: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// ログアウト
  Future<void> signOut() async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.signOut();
      _currentUser = null;
      _currentUserProfile = null;
    } catch (e) {
      _setError('ログアウトに失敗しました: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// パスワードリセット
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.resetPassword(email);
      return true;
    } on AuthException catch (e) {
      _setError(_getErrorMessage(e));
      return false;
    } catch (e) {
      _setError('パスワードリセットに失敗しました: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ========================================
  // ソーシャルログイン
  // ========================================

  /// Googleアカウントでログイン
  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    _clearError();

    try {
      final success = await _authService.signInWithGoogle();
      if (!success) {
        _setError('Googleログインに失敗しました');
      }
      return success;
    } catch (e) {
      _setError('Googleログインに失敗しました: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Appleアカウントでログイン
  Future<bool> signInWithApple() async {
    _setLoading(true);
    _clearError();

    try {
      final success = await _authService.signInWithApple();
      if (!success) {
        _setError('Appleログインに失敗しました');
      }
      return success;
    } catch (e) {
      _setError('Appleログインに失敗しました: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// GitHubアカウントでログイン
  Future<bool> signInWithGitHub() async {
    _setLoading(true);
    _clearError();

    try {
      final success = await _authService.signInWithGitHub();
      if (!success) {
        _setError('GitHubログインに失敗しました');
      }
      return success;
    } catch (e) {
      _setError('GitHubログインに失敗しました: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// プロファイルを更新
  Future<bool> updateProfile({
    String? displayName,
    String? avatarUrl,
  }) async {
    if (_currentUser == null) {
      _setError('ログインしていません');
      return false;
    }

    _setLoading(true);
    _clearError();

    try {
      await _authService.updateUserProfile(
        userId: _currentUser!.id,
        displayName: displayName,
        avatarUrl: avatarUrl,
      );

      await _loadUserProfile();
      return true;
    } catch (e) {
      _setError('プロファイルの更新に失敗しました: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// アバター画像をアップロード
  Future<String?> uploadAvatar({
    required String filePath,
    required List<int> fileBytes,
  }) async {
    if (_currentUser == null) {
      _setError('ログインしていません');
      return null;
    }

    _setLoading(true);
    _clearError();

    try {
      final url = await _authService.uploadAvatar(
        userId: _currentUser!.id,
        filePath: filePath,
        fileBytes: fileBytes,
      );

      return url;
    } catch (e) {
      _setError('画像のアップロードに失敗しました: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// ローディング状態を設定
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// エラーメッセージを設定
  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  /// エラーメッセージをクリア
  void _clearError() {
    _errorMessage = null;
  }

  /// AuthExceptionから日本語のエラーメッセージを取得
  String _getErrorMessage(AuthException exception) {
    switch (exception.message) {
      case 'Invalid login credentials':
        return 'メールアドレスまたはパスワードが正しくありません';
      case 'User already registered':
        return 'このメールアドレスは既に登録されています';
      case 'Email not confirmed':
        return 'メールアドレスが確認されていません';
      case 'Password should be at least 6 characters':
        return 'パスワードは6文字以上である必要があります';
      default:
        return exception.message;
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
