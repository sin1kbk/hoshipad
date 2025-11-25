# hoshipad ブックマークレット

レシピページから URL、タイトル、画像を抽出して hoshipad に送信するブックマークレット。

## 📁 ディレクトリ構造

```
bookmarklet/
├── src/                    # ソースコード
│   ├── main.js             # エントリーポイント
│   ├── extractors/         # データ抽出モジュール
│   │   ├── instagram.js    # Instagram専用ロジック
│   │   └── generic.js      # 汎用ロジック
│   └── utils/              # ユーティリティ
│       └── scoring.js      # 画像スコアリング
├── dist/                   # ビルド出力
│   └── bookmarklet.js      # 圧縮版ブックマークレット
├── package.json            # 依存関係
├── build.js                # ビルドスクリプト
└── README.md               # このファイル
```

## 🚀 セットアップ

```bash
cd bookmarklet
npm install
```

## 🔨 ビルド

### 開発環境用（localhost）

```bash
npm run build
```

デフォルトで `http://localhost:8080` を使用します。

### 本番環境用

```bash
npm run build:prod
```

または、カスタムURLを指定：

```bash
TARGET_URL=https://your-domain.com npm run build
```

## 📝 開発ワークフロー

1. `src/` 内のファイルを編集
2. `npm run build` でビルド
3. `../bookmarklet.html` が自動的に更新される
4. ブラウザで動作確認

## 🧩 モジュール説明

### main.js
ブックマークレットのエントリーポイント。ページタイトルに基づいて適切な抽出ロジックを選択。

### extractors/instagram.js
Instagram専用のデータ抽出ロジック。
- 投稿画像の検出（ヘッダーやプロフィール画像を除外）
- og:title/og:description からタイトルを抽出

### extractors/generic.js
汎用的なページからのデータ抽出。
- og:image メタタグから画像URLを取得

### utils/scoring.js
画像の適切さをスコアリング。
- 画像サイズ、位置、alt属性などを評価
- 最適な画像を自動選択

## 🔧 環境変数

- `TARGET_URL`: ブックマークレットの送信先URL（デフォルト: `http://localhost:8080`）

## 📦 ビルド出力

ビルドすると以下が生成されます：

1. `dist/bookmarklet.js`: 圧縮されたブックマークレットコード
2. `../bookmarklet.html`: 更新されたHTMLファイル（2箇所のブックマークレットコードが自動更新される）

## ⚠️ 注意事項

- `bookmarklet.html` のブックマークレットコード（176行目と234行目）は**自動生成**されます
- 手動で編集せず、必ず `src/` のファイルを編集して `npm run build` を実行してください
