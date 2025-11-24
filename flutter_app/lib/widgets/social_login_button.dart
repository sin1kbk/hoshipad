import 'package:flutter/material.dart';

/// ソーシャルログインプロバイダーの種類
enum SocialProvider {
  google,
  apple,
  github,
}

/// ソーシャルログインボタンウィジェット
class SocialLoginButton extends StatelessWidget {
  final SocialProvider provider;
  final VoidCallback onPressed;
  final bool isLoading;

  const SocialLoginButton({
    super.key,
    required this.provider,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: _getBackgroundColor(),
          foregroundColor: _getForegroundColor(),
          side: BorderSide(
            color: _getBorderColor(),
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getForegroundColor(),
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _getIcon(),
                  const SizedBox(width: 12),
                  Text(
                    _getLabel(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (provider) {
      case SocialProvider.google:
        return Colors.white;
      case SocialProvider.apple:
        return Colors.black;
      case SocialProvider.github:
        return const Color(0xFF24292E);
    }
  }

  Color _getForegroundColor() {
    switch (provider) {
      case SocialProvider.google:
        return Colors.black87;
      case SocialProvider.apple:
        return Colors.white;
      case SocialProvider.github:
        return Colors.white;
    }
  }

  Color _getBorderColor() {
    switch (provider) {
      case SocialProvider.google:
        return Colors.grey.shade300;
      case SocialProvider.apple:
        return Colors.black;
      case SocialProvider.github:
        return const Color(0xFF24292E);
    }
  }

  Widget _getIcon() {
    switch (provider) {
      case SocialProvider.google:
        return Image.asset(
          'assets/icons/google.png',
          height: 24,
          width: 24,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.g_mobiledata, size: 24);
          },
        );
      case SocialProvider.apple:
        return const Icon(Icons.apple, size: 24);
      case SocialProvider.github:
        return Image.asset(
          'assets/icons/github.png',
          height: 24,
          width: 24,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.code, size: 24);
          },
        );
    }
  }

  String _getLabel() {
    switch (provider) {
      case SocialProvider.google:
        return 'Googleでログイン';
      case SocialProvider.apple:
        return 'Appleでログイン';
      case SocialProvider.github:
        return 'GitHubでログイン';
    }
  }
}

/// 区切り線ウィジェット
class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.grey.shade300,
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'または',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.grey.shade300,
            thickness: 1,
          ),
        ),
      ],
    );
  }
}
