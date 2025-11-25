import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/social_login_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('利用規約に同意してください'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      displayName: _displayNameController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      // ログイン状態を確認（メール確認待ちの場合はログインしていない）
      if (authProvider.currentUser == null) {
        if (!mounted) return;
        context.go('/email-verification');
        return;
      }

      // リダイレクト先を取得（デフォルトはホーム）
      final state = GoRouterState.of(context);
      final redirectTo = state.uri.queryParameters['redirect'] ?? '/';

      // URLパラメータを保持
      final queryParams = Map<String, String>.from(state.uri.queryParameters);
      queryParams.remove('redirect'); // redirectパラメータは削除

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('アカウントを作成しました'),
          backgroundColor: Colors.green,
        ),
      );

      if (queryParams.isEmpty) {
        context.go(redirectTo);
      } else {
        final uri = Uri.parse(redirectTo).replace(queryParameters: queryParams);
        context.go(uri.toString());
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'サインアップに失敗しました'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleSocialLogin(Future<bool> Function() loginMethod) async {
    final success = await loginMethod();

    if (!mounted) return;

    if (success) {
      final state = GoRouterState.of(context);
      final redirectTo = state.uri.queryParameters['redirect'] ?? '/';

      final queryParams = Map<String, String>.from(state.uri.queryParameters);
      queryParams.remove('redirect');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('アカウントを作成しました'),
          backgroundColor: Colors.green,
        ),
      );

      if (queryParams.isEmpty) {
        context.go(redirectTo);
      } else {
        final uri = Uri.parse(redirectTo).replace(queryParameters: queryParams);
        context.go(uri.toString());
      }
    } else {
      final authProvider = context.read<AuthProvider>();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'ログインに失敗しました'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('新規登録'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                // ロゴ
                const Icon(
                  Icons.restaurant_menu,
                  size: 80,
                  color: Colors.orange,
                ),
                const SizedBox(height: 16),
                const Text(
                  'hoshipad',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 48),
                // ソーシャルログインボタン
                SocialLoginButton(
                  provider: SocialProvider.google,
                  onPressed: () => _handleSocialLogin(
                    context.read<AuthProvider>().signInWithGoogle,
                  ),
                  isLoading: authProvider.isLoading,
                ),
                const SizedBox(height: 12),
                SocialLoginButton(
                  provider: SocialProvider.apple,
                  onPressed: () => _handleSocialLogin(
                    context.read<AuthProvider>().signInWithApple,
                  ),
                  isLoading: authProvider.isLoading,
                ),
                const SizedBox(height: 12),
                SocialLoginButton(
                  provider: SocialProvider.github,
                  onPressed: () => _handleSocialLogin(
                    context.read<AuthProvider>().signInWithGitHub,
                  ),
                  isLoading: authProvider.isLoading,
                ),
                const SizedBox(height: 24),
                // 区切り線
                const OrDivider(),
                const SizedBox(height: 24),
                // 表示名
                TextFormField(
                  controller: _displayNameController,
                  decoration: InputDecoration(
                    labelText: '表示名',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '表示名を入力してください';
                    }
                    if (value.length < 2) {
                      return '表示名は2文字以上である必要があります';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // メールアドレス
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'メールアドレス',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'メールアドレスを入力してください';
                    }
                    if (!value.contains('@')) {
                      return '有効なメールアドレスを入力してください';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // パスワード
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'パスワード',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'パスワードを入力してください';
                    }
                    if (value.length < 6) {
                      return 'パスワードは6文字以上である必要があります';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // パスワード確認
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'パスワード(確認)',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'パスワード(確認)を入力してください';
                    }
                    if (value != _passwordController.text) {
                      return 'パスワードが一致しません';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                // 利用規約同意
                Row(
                  children: [
                    Checkbox(
                      value: _agreedToTerms,
                      onChanged: (value) {
                        setState(() {
                          _agreedToTerms = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _agreedToTerms = !_agreedToTerms;
                          });
                        },
                        child: const Text('利用規約に同意する'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // サインアップボタン
                ElevatedButton(
                  onPressed: authProvider.isLoading ? null : _handleSignup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: authProvider.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          '新規登録',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                const SizedBox(height: 24),
                // ログインリンク
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('既にアカウントをお持ちの方は'),
                    TextButton(
                      onPressed: () {
                        context.go('/login');
                      },
                      child: const Text(
                        'ログイン',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
