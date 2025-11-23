class SupabaseConfig {
  // TODO: Supabaseプロジェクトを作成後、以下の値を設定してください
  // 1. https://supabase.com/ でプロジェクトを作成
  // 2. Project Settings → API から以下の値を取得
  // 3. この値をここに貼り付けるか、環境変数から読み込む

  static const String supabaseUrl = 'https://vluccuxxcmzuixvftcdc.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZsdWNjdXh4Y216dWl4dmZ0Y2RjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM4ODg1OTMsImV4cCI6MjA3OTQ2NDU5M30.SuqyPIi7ZkHt1_ToNskESomxOShRCQFnYiHAW152o9w';

  // 環境変数から読み込む場合の例:
  // static String get supabaseUrl => const String.fromEnvironment(
  //   'SUPABASE_URL',
  //   defaultValue: 'YOUR_SUPABASE_URL',
  // );
  // static String get supabaseAnonKey => const String.fromEnvironment(
  //   'SUPABASE_ANON_KEY',
  //   defaultValue: 'YOUR_SUPABASE_ANON_KEY',
  // );
}
