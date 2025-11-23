import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'config/supabase_config.dart';
import 'theme/app_theme.dart';
import 'services/api_service.dart';
import 'providers/recipe_provider.dart';
import 'providers/shopping_list_provider.dart';
import 'providers/history_provider.dart';
import 'services/local_storage_service.dart';
import 'screens/home_screen.dart';
import 'screens/add_recipe_screen.dart';
import 'screens/shopping_list_screen.dart';
import 'screens/history_screen.dart';
import 'screens/my_kitchen_screen.dart';
import 'widgets/main_scaffold.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // WebでパスベースのURLを使用（ハッシュなし）
  usePathUrlStrategy();

  // Supabaseの初期化
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription _intentDataStreamSubscription;
  late GoRouter _router;

  @override
  void initState() {
    super.initState();
    _initializeRouter();
    _setupSharingIntentListeners();
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  void _initializeRouter() {
    final rootNavigatorKey = GlobalKey<NavigatorState>();

    _router = GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: '/',
      debugLogDiagnostics: true, // デバッグログを有効化
      routes: [
        ShellRoute(
          builder: (context, state, child) {
            return MainScaffold(child: child);
          },
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HomeScreen(),
            ),
            GoRoute(
              path: '/shopping-list',
              builder: (context, state) => const ShoppingListScreen(),
            ),
            GoRoute(
              path: '/history',
              builder: (context, state) => const HistoryScreen(),
            ),
            GoRoute(
              path: '/profile',
              builder: (context, state) => const MyKitchenScreen(),
            ),
          ],
        ),
        GoRoute(
          path: '/add',
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) {
            debugPrint('=== /add route accessed ===');
            debugPrint('URL: ${state.uri}');
            debugPrint('Query params: ${state.uri.queryParameters}');
            final sharedUrl = state.uri.queryParameters['url'];
            final sharedTitle = state.uri.queryParameters['title'];
            debugPrint('Shared URL: $sharedUrl');
            debugPrint('Shared Title: $sharedTitle');
            return AddRecipeScreen(
              sharedUrl: sharedUrl,
              prefilledTitle: sharedTitle,
            );
          },
        ),
      ],
    );
  }

  void _setupSharingIntentListeners() {
    // アプリ起動中に共有された場合(ホットリンク)
    _intentDataStreamSubscription = ReceiveSharingIntent.instance.getMediaStream().listen(
      (List<SharedMediaFile> value) {
        if (value.isNotEmpty) {
          // SharedMediaFileからテキスト/URLを取得
          final sharedData = value.first;
          if (sharedData.path.isNotEmpty) {
            _handleSharedUrl(sharedData.path);
          }
        }
      },
      onError: (err) {
        debugPrint('Error receiving shared intent: $err');
      },
    );

    // アプリが閉じている時に共有された場合(コールドリンク)
    ReceiveSharingIntent.instance.getInitialMedia().then((List<SharedMediaFile> value) {
      if (value.isNotEmpty) {
        final sharedData = value.first;
        if (sharedData.path.isNotEmpty) {
          _handleSharedUrl(sharedData.path);
        }
        // 共有データを処理したらクリア
        ReceiveSharingIntent.instance.reset();
      }
    });
  }

  void _handleSharedUrl(String url) {
    debugPrint('Received shared URL: $url');
    // レシピ追加画面に遷移（URLをクエリパラメータとして渡す）
    _router.go('/add?url=${Uri.encodeComponent(url)}');
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider( // Changed to MultiProvider
      providers: [
        ChangeNotifierProvider(
          create: (context) => RecipeProvider(
            ApiService(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ShoppingListProvider(
            LocalStorageService(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => HistoryProvider(
            LocalStorageService(),
            ApiService(),
          ),
        ),
      ],
      child: MaterialApp.router(
        title: 'hoshipad',
        theme: AppTheme.lightTheme,
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
