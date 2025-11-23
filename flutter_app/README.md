# hoshipad - レシピ管理アプリ

Cookpad風のレシピ管理アプリです。Flutter + Supabaseで構築されています。

## 機能

- レシピの追加、編集、削除
- カテゴリー別レシピ表示
- レシピ検索
- ソースフィルター（YouTube、Instagram、Twitter、クックパッド）
- レスポンシブデザイン（Web、iOS、Android対応）

## セットアップ

### 1. Supabaseプロジェクトの作成

1. [Supabase](https://supabase.com/)にアクセスしてアカウントを作成
2. 新しいプロジェクトを作成
3. SQL Editorを開き、`supabase/schema.sql`のスクリプトを実行
4. Project Settings → API から以下の情報を取得：
   - Project URL
   - Anon/Public key

### 2. 環境設定

`lib/config/supabase_config.dart`を編集し、取得した情報を設定：

```dart
static const String supabaseUrl = 'YOUR_SUPABASE_URL';
static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
```

### 3. 依存パッケージのインストール

```bash
flutter pub get
```

### 4. アプリの起動

#### Web
```bash
flutter run -d chrome
```

#### iOS
```bash
flutter run -d ios
```

#### Android
```bash
flutter run -d android
```

## ビルド

### Web
```bash
flutter build web
```

### iOS
```bash
flutter build ios --release
```

### Android
```bash
flutter build apk --release
```

## 技術スタック

- **フロントエンド**: Flutter
- **バックエンド**: Supabase (PostgreSQL + REST API)
- **状態管理**: Provider
- **ルーティング**: go_router
- **UI**: Material Design 3 + Google Fonts

## プロジェクト構造

```
lib/
├── config/          # 設定ファイル
├── models/          # データモデル
├── providers/       # 状態管理
├── screens/         # 画面
├── services/        # APIサービス
├── theme/           # テーマ設定
├── widgets/         # 再利用可能なウィジェット
└── main.dart        # エントリーポイント
```

## ライセンス

MIT
