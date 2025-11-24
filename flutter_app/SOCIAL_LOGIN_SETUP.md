# ソーシャルログイン設定ガイド

このドキュメントでは、Supabase Authのソーシャルログイン(Google、Apple、GitHub)を設定する手順を説明します。

## 1. Supabase設定

### 1.1 Supabaseダッシュボードにアクセス

1. [Supabase Dashboard](https://app.supabase.com/)にログイン
2. プロジェクトを選択
3. 左サイドバーから **Authentication** → **Providers** を選択

### 1.2 各プロバイダーの有効化

#### Google

1. **Google**プロバイダーを選択
2. **Enable Sign in with Google**をONにする
3. 後述のGoogle Cloud Consoleで取得した情報を入力:
   - **Client ID (for OAuth)**
   - **Client Secret (for OAuth)**
4. **Save**をクリック

#### Apple

1. **Apple**プロバイダーを選択
2. **Enable Sign in with Apple**をONにする
3. 後述のApple Developerで取得した情報を入力:
   - **Services ID**
   - **Team ID**
   - **Key ID**
   - **Private Key**
4. **Save**をクリック

#### GitHub

1. **GitHub**プロバイダーを選択
2. **Enable Sign in with GitHub**をONにする
3. 後述のGitHubで取得した情報を入力:
   - **Client ID**
   - **Client Secret**
4. **Save**をクリック

---

## 2. Google Cloud Console設定

### 2.1 プロジェクトの作成

1. [Google Cloud Console](https://console.cloud.google.com/)にアクセス
2. 新しいプロジェクトを作成(または既存のプロジェクトを選択)

### 2.2 OAuth同意画面の設定

1. **APIs & Services** → **OAuth consent screen**を選択
2. **User Type**を選択(External推奨)
3. アプリ情報を入力:
   - **App name**: hoshipad
   - **User support email**: あなたのメールアドレス
   - **Developer contact information**: あなたのメールアドレス
4. **Save and Continue**をクリック

### 2.3 OAuth 2.0クライアントIDの作成

1. **APIs & Services** → **Credentials**を選択
2. **Create Credentials** → **OAuth client ID**をクリック
3. **Application type**を選択:
   - **Web application**を選択
4. **Name**を入力: `hoshipad Web Client`
5. **Authorized redirect URIs**を追加:
   ```
   https://[YOUR_SUPABASE_PROJECT_REF].supabase.co/auth/v1/callback
   ```
   - `[YOUR_SUPABASE_PROJECT_REF]`はSupabaseプロジェクトのURL
6. **Create**をクリック
7. 表示された**Client ID**と**Client Secret**をコピーしてSupabaseに設定

### 2.4 iOS/Androidアプリの追加(モバイルアプリの場合)

#### iOS

1. **Create Credentials** → **OAuth client ID**をクリック
2. **Application type**: **iOS**を選択
3. **Bundle ID**を入力: `com.yourcompany.hoshipad`
4. **Create**をクリック

#### Android

1. **Create Credentials** → **OAuth client ID**をクリック
2. **Application type**: **Android**を選択
3. **Package name**を入力: `com.yourcompany.hoshipad`
4. **SHA-1 certificate fingerprint**を入力(後述)
5. **Create**をクリック

---

## 3. Apple Developer設定

### 3.1 App IDの作成

1. [Apple Developer](https://developer.apple.com/)にログイン
2. **Certificates, Identifiers & Profiles**を選択
3. **Identifiers**を選択
4. **+**ボタンをクリック
5. **App IDs**を選択して**Continue**
6. **App**を選択して**Continue**
7. 情報を入力:
   - **Description**: hoshipad
   - **Bundle ID**: `com.yourcompany.hoshipad`
8. **Capabilities**で**Sign in with Apple**をチェック
9. **Continue** → **Register**をクリック

### 3.2 Services IDの作成

1. **Identifiers**で**+**ボタンをクリック
2. **Services IDs**を選択して**Continue**
3. 情報を入力:
   - **Description**: hoshipad Web
   - **Identifier**: `com.yourcompany.hoshipad.web`
4. **Sign in with Apple**をチェック
5. **Configure**をクリック
6. **Domains and Subdomains**を追加:
   ```
   [YOUR_SUPABASE_PROJECT_REF].supabase.co
   ```
7. **Return URLs**を追加:
   ```
   https://[YOUR_SUPABASE_PROJECT_REF].supabase.co/auth/v1/callback
   ```
8. **Save** → **Continue** → **Register**をクリック

### 3.3 Keyの作成

1. **Keys**で**+**ボタンをクリック
2. **Key Name**を入力: `hoshipad Sign in with Apple Key`
3. **Sign in with Apple**をチェック
4. **Configure**をクリックして先ほど作成したApp IDを選択
5. **Save** → **Continue** → **Register**をクリック
6. **Download**をクリックしてキーファイル(.p8)をダウンロード
7. **Key ID**をメモ

### 3.4 Team IDの取得

1. Apple Developer画面の右上にある**Membership**をクリック
2. **Team ID**をメモ

---

## 4. GitHub OAuth App設定

### 4.1 OAuth Appの作成

1. [GitHub](https://github.com/)にログイン
2. 右上のプロフィールアイコン → **Settings**をクリック
3. 左サイドバーの**Developer settings**をクリック
4. **OAuth Apps** → **New OAuth App**をクリック
5. 情報を入力:
   - **Application name**: hoshipad
   - **Homepage URL**: `https://your-app-domain.com`
   - **Authorization callback URL**:
     ```
     https://[YOUR_SUPABASE_PROJECT_REF].supabase.co/auth/v1/callback
     ```
6. **Register application**をクリック
7. **Client ID**をコピー
8. **Generate a new client secret**をクリックして**Client Secret**をコピー

---

## 5. プラットフォーム固有の設定

### 5.1 iOS (Info.plist)

`ios/Runner/Info.plist`に以下を追加:

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>hoshipad</string>
    </array>
  </dict>
</array>
```

### 5.2 Android (AndroidManifest.xml)

`android/app/src/main/AndroidManifest.xml`の`<activity>`タグ内に以下を追加:

```xml
<intent-filter>
  <action android:name="android.intent.action.VIEW" />
  <category android:name="android.intent.category.DEFAULT" />
  <category android:name="android.intent.category.BROWSABLE" />
  <data
    android:scheme="hoshipad"
    android:host="auth"
    android:pathPrefix="/callback" />
</intent-filter>
```

### 5.3 Web

Webアプリの場合、追加の設定は不要です。Supabaseが自動的にリダイレクトを処理します。

---

## 6. テスト

### 6.1 開発環境でのテスト

1. アプリを起動
2. ログイン画面でソーシャルログインボタンをクリック
3. 各プロバイダーの認証画面が表示されることを確認
4. 認証後、アプリにリダイレクトされることを確認
5. プロフィール情報が正しく取得されることを確認

### 6.2 本番環境への移行

1. 本番環境のURLでOAuth設定を更新
2. Supabaseの本番環境でプロバイダー設定を確認
3. 本番環境でテストを実施

---

## トラブルシューティング

### Google

- **エラー: redirect_uri_mismatch**
  - Authorized redirect URIsが正しく設定されているか確認
  - SupabaseのプロジェクトURLが正しいか確認

### Apple

- **エラー: invalid_client**
  - Services IDが正しく設定されているか確認
  - Return URLsが正しいか確認
  - Keyファイルが正しくアップロードされているか確認

### GitHub

- **エラー: redirect_uri_mismatch**
  - Authorization callback URLが正しく設定されているか確認

---

## 参考リンク

- [Supabase Auth Documentation](https://supabase.com/docs/guides/auth)
- [Google OAuth 2.0](https://developers.google.com/identity/protocols/oauth2)
- [Apple Sign in](https://developer.apple.com/sign-in-with-apple/)
- [GitHub OAuth Apps](https://docs.github.com/en/developers/apps/building-oauth-apps)
