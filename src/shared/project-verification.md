# プロジェクトタイプ別動作確認

## 🌐 Webアプリケーション

### サーバー起動（バックグラウンド）
```bash
# Python HTTPサーバー
if ! lsof -ti:8000 >/dev/null 2>&1; then
  nohup python3 -m http.server 8000 > /dev/null 2>&1 & disown
fi

# Vite/Node.js
if ! lsof -ti:5173 >/dev/null 2>&1; then
  nohup npm run dev > /dev/null 2>&1 & disown
fi
```

### 確認手順
1. Playwright MCP で `http://localhost:8000` を開く
2. 0.5 秒待機して描画を待つ
3. スクリーンショットを取得
4. 受け入れ基準の視覚的要素を確認

## 🖥️ CLIツール

### 動作確認
```bash
# ヘルプ表示
timeout 3s ./my-tool --help 2>&1

# 実際のコマンド実行
timeout 5s ./my-tool command args 2>&1 | head -20
```

## 🔌 API

### エンドポイント確認
```bash
# ヘルスチェック
curl -m 2 http://localhost:3000/api/health 2>&1

# 実際のAPI呼び出し
curl -m 3 -X POST http://localhost:3000/api/items \
  -H "Content-Type: application/json" \
  -d '{"test": "data"}' 2>&1
```
