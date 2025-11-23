#!/bin/bash

# ブックマークレットページのURL置き換えスクリプト
# 使用方法: ./replace_bookmarklet_url.sh [URL]
# 例: ./replace_bookmarklet_url.sh https://hoshipad.app

set -e

# 引数チェック
if [ -z "$1" ]; then
  echo "エラー: URLを指定してください"
  echo "使用方法: $0 <URL>"
  echo "例: $0 https://hoshipad.app"
  exit 1
fi

HOSHIPAD_URL="$1"
BOOKMARKLET_FILE="web/bookmarklet.html"

# URLの末尾のスラッシュを削除
HOSHIPAD_URL="${HOSHIPAD_URL%/}"

echo "ブックマークレットページのURLを置き換えます..."
echo "URL: $HOSHIPAD_URL"

# macOSとLinuxの両方に対応
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS
  sed -i '' "s|__HOSHIPAD_URL__|$HOSHIPAD_URL|g" "$BOOKMARKLET_FILE"
else
  # Linux
  sed -i "s|__HOSHIPAD_URL__|$HOSHIPAD_URL|g" "$BOOKMARKLET_FILE"
fi

echo "✅ 完了: $BOOKMARKLET_FILE のURLを $HOSHIPAD_URL に置き換えました"
