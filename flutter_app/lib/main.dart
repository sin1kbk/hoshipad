import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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

  // Supabaseの初期化
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();

    final rootNavigatorKey = GlobalKey<NavigatorState>();

    final router = GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: '/',
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
            // 他のルートもここに追加予定
          ],
        ),
        GoRoute(
          path: '/add',
          parentNavigatorKey: rootNavigatorKey, // ボトムナビの上に表示
          builder: (context, state) => const AddRecipeScreen(),
        ),
      ],
    );

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
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
