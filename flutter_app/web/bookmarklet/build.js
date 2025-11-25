/**
 * ブックマークレットビルドスクリプト
 *
 * ES Modulesのソースコードを1つのファイルに結合し、
 * 圧縮してブックマークレット形式に変換します。
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { minify } from 'terser';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// 設定
const TARGET_URL = process.env.TARGET_URL || 'http://localhost:8080';
const SRC_DIR = path.join(__dirname, 'src');
const DIST_DIR = path.join(__dirname, 'dist');
const BOOKMARKLET_HTML = path.join(__dirname, '..', 'bookmarklet.html');

/**
 * モジュールを結合してブラウザ互換の単一ファイルに変換
 */
function bundleModules() {
  console.log('📦 モジュールを結合中...');

  // ファイルの読み込み
  const scoring = fs.readFileSync(path.join(SRC_DIR, 'utils', 'scoring.js'), 'utf8');
  const generic = fs.readFileSync(path.join(SRC_DIR, 'extractors', 'generic.js'), 'utf8');
  const instagram = fs.readFileSync(path.join(SRC_DIR, 'extractors', 'instagram.js'), 'utf8');
  const main = fs.readFileSync(path.join(SRC_DIR, 'main.js'), 'utf8');

  // import/exportを削除してIIFEでラップ
  const bundled = `
(function() {
  // Utils: scoring.js
  ${scoring.replace(/export\s+/g, '').replace(/import\s+.*?from\s+['"].*?['"];?\s*/g, '')}

  // Extractors: generic.js
  ${generic.replace(/export\s+/g, '').replace(/import\s+.*?from\s+['"].*?['"];?\s*/g, '')}

  // Extractors: instagram.js
  ${instagram.replace(/export\s+/g, '').replace(/import\s+.*?from\s+['"].*?['"];?\s*/g, '')}

  // Main
  ${main.replace(/export\s+/g, '').replace(/import\s+.*?from\s+['"].*?['"];?\s*/g, '').replace('(function() {', '').replace(/}\)\(\);?\s*$/, '')}
})();
`;

  return bundled;
}

/**
 * コードを圧縮
 */
async function minifyCode(code) {
  console.log('🗜️  コードを圧縮中...');

  const result = await minify(code, {
    compress: {
      dead_code: true,
      drop_console: false,
      drop_debugger: true,
      keep_fargs: false,
      passes: 2
    },
    mangle: {
      toplevel: true
    },
    format: {
      comments: false
    }
  });

  if (result.error) {
    throw result.error;
  }

  return result.code;
}

/**
 * 環境変数を置き換え
 */
function replaceEnvironmentVariables(code) {
  console.log(`🔧 TARGET_URL を設定: ${TARGET_URL}`);
  return code.replace('%%TARGET_URL%%', TARGET_URL);
}

/**
 * ブックマークレット形式に変換
 */
function toBookmarklet(code) {
  console.log('🔖 ブックマークレット形式に変換中...');

  // javascript: プレフィックスを追加
  // エンコードは不要（最新ブラウザでは生のJavaScriptも動作する）
  return `javascript:${code}`;
}

/**
 * HTMLファイルを更新
 */
function updateHTML(bookmarkletCode) {
  console.log('📝 bookmarklet.html を更新中...');

  let html = fs.readFileSync(BOOKMARKLET_HTML, 'utf8');

  // エスケープ処理（HTML属性用）
  const escapedForHref = bookmarkletCode
    .replace(/&/g, '&amp;')
    .replace(/"/g, '&quot;');

  // エスケープ処理（textarea用）
  const escapedForTextarea = bookmarkletCode
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;');

  // href属性を更新（176行目付近）
  html = html.replace(
    /(<a href=")javascript:[^"]*(")/,
    `$1${escapedForHref}$2`
  );

  // textarea内のコードを更新（234行目付近）
  // textareaの内容は複数行に渡る可能性があるのでマルチラインフラグと非貪欲マッチを使用
  html = html.replace(
    /(<textarea[^>]*>)javascript:[\s\S]*?(<\/textarea>)/,
    `$1${escapedForTextarea}$2`
  );

  fs.writeFileSync(BOOKMARKLET_HTML, html, 'utf8');
  console.log('✅ bookmarklet.html を更新しました');
}

/**
 * メインビルド処理
 */
async function build() {
  try {
    console.log('🚀 ブックマークレットのビルドを開始...\n');

    // distディレクトリを作成
    if (!fs.existsSync(DIST_DIR)) {
      fs.mkdirSync(DIST_DIR, { recursive: true });
    }

    // 1. モジュールを結合
    let code = bundleModules();

    // 2. 環境変数を置き換え
    code = replaceEnvironmentVariables(code);

    // 3. コードを圧縮
    code = await minifyCode(code);

    // 4. ブックマークレット形式に変換
    const bookmarkletCode = toBookmarklet(code);

    // 5. distディレクトリに保存
    const outputPath = path.join(DIST_DIR, 'bookmarklet.js');
    fs.writeFileSync(outputPath, bookmarkletCode, 'utf8');
    console.log(`📁 保存: ${outputPath}`);

    // 6. HTMLファイルを更新
    updateHTML(bookmarkletCode);

    // 統計情報
    const stats = {
      size: bookmarkletCode.length,
      sizeKB: (bookmarkletCode.length / 1024).toFixed(2)
    };

    console.log('\n📊 ビルド完了:');
    console.log(`   サイズ: ${stats.size} bytes (${stats.sizeKB} KB)`);
    console.log(`   出力: ${outputPath}`);
    console.log(`   HTML: ${BOOKMARKLET_HTML}`);

  } catch (error) {
    console.error('❌ ビルドエラー:', error);
    process.exit(1);
  }
}

// ビルド実行
build();
