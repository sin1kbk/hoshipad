# ブックマークレット本番環境設定ガイド

## 概要

ブックマークレットページ（`web/bookmarklet.html`）は、ビルド時に環境変数またはスクリプトでURLを置き換える方式を採用しています。

## URL置き換え方法

### 方法1: シェルスクリプトを使用（推奨）

ビルド前にスクリプトを実行してURLを置き換えます。

```bash
# ローカルテスト用
./scripts/replace_bookmarklet_url.sh http://localhost:8080

# 本番環境用
./scripts/replace_bookmarklet_url.sh https://hoshipad.app

# その後、Flutterビルド
flutter build web
```

### 方法2: 手動で置き換え

`web/bookmarklet.html`内の`__HOSHIPAD_URL__`を直接置き換えます。

```bash
# macOS
sed -i '' 's|__HOSHIPAD_URL__|https://hoshipad.app|g' web/bookmarklet.html

# Linux
sed -i 's|__HOSHIPAD_URL__|https://hoshipad.app|g' web/bookmarklet.html
```

### 方法3: CI/CDパイプラインで自動化

GitHub ActionsやCircleCIなどで自動化する例：

```yaml
# .github/workflows/deploy.yml
- name: Replace bookmarklet URL
  run: |
    ./scripts/replace_bookmarklet_url.sh ${{ secrets.HOSHIPAD_URL }}

- name: Build Flutter Web
  run: flutter build web
```

## ローカル開発用の設定

ローカル開発時は、以下のコマンドでローカルホストに戻せます：

```bash
./scripts/replace_bookmarklet_url.sh http://localhost:8080
```

## プレースホルダーに戻す

本番URLから開発用プレースホルダーに戻す場合：

```bash
# macOS
sed -i '' 's|https://hoshipad.app|__HOSHIPAD_URL__|g' web/bookmarklet.html

# Linux
sed -i 's|https://hoshipad.app|__HOSHIPAD_URL__|g' web/bookmarklet.html
```

## 環境変数の設定例

### 開発環境

```bash
export HOSHIPAD_URL=http://localhost:8080
./scripts/replace_bookmarklet_url.sh $HOSHIPAD_URL
```

### ステージング環境

```bash
export HOSHIPAD_URL=https://staging.hoshipad.app
./scripts/replace_bookmarklet_url.sh $HOSHIPAD_URL
```

### 本番環境

```bash
export HOSHIPAD_URL=https://hoshipad.app
./scripts/replace_bookmarklet_url.sh $HOSHIPAD_URL
```

## デプロイフロー

1. **URL置き換え**
   ```bash
   ./scripts/replace_bookmarklet_url.sh https://hoshipad.app
   ```

2. **Flutterビルド**
   ```bash
   flutter build web
   ```

3. **デプロイ**
   ```bash
   # 例: Firebase Hosting
   firebase deploy --only hosting

   # 例: Vercel
   vercel --prod

   # 例: AWS S3
   aws s3 sync build/web s3://your-bucket/
   ```

4. **プレースホルダーに戻す（オプション）**
   ```bash
   git checkout web/bookmarklet.html
   ```

## 注意事項

- `web/bookmarklet.html`はGitにコミットする際、プレースホルダー（`__HOSHIPAD_URL__`）の状態にしておくことを推奨
- 本番URLに置き換えた状態でコミットしないように注意
- `.gitignore`に追加する必要はありません（プレースホルダーのままコミット）

## トラブルシューティング

### Q: ブックマークレットが動作しない

**確認事項:**
1. `web/bookmarklet.html`内のURLが正しく置き換えられているか
2. URLの末尾にスラッシュ（`/`）がないか（スクリプトが自動削除）
3. ビルド後の`build/web/bookmarklet.html`も確認

### Q: 開発中に本番URLになってしまった

**解決方法:**
```bash
git checkout web/bookmarklet.html
# または
./scripts/replace_bookmarklet_url.sh http://localhost:8080
```

## まとめ

- ✅ プレースホルダー方式で環境ごとにURLを切り替え可能
- ✅ スクリプトで簡単に置き換え
- ✅ CI/CDで自動化可能
- ✅ Gitにはプレースホルダーのままコミット

ご質問があれば、お気軽にどうぞ！
