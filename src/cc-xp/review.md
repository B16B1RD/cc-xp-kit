---
description: XP review – 動作確認とフィードバック（ユーザー視点）
argument-hint: '[accept|reject] [id] [理由]'
allowed-tools: Bash(*), ReadFile, WriteFile
---

## ゴール

実際に動かしてユーザー視点で確認し、素早くフィードバックする。

## XP原則

- **動くソフトウェア**: 実際に触れるものが最高のフィードバック
- **オンサイトカスタマー**: ユーザーの立場で判断
- **素早いフィードバック**: 問題は早期に発見
- **継続的インテグレーション**: 承認後は即マージ

## 手順

### 1. 起動フェーズ（引数なしの場合）
プロジェクトタイプを自動判定し、モダンなツールでバックグラウンド起動：

**Web アプリケーション**
```bash
# Bun
bun run dev > server.log 2>&1 &

# pnpm + Vite  
pnpm dev > server.log 2>&1 &

# Python + uv (FastAPI)
uv run uvicorn main:app --reload > server.log 2>&1 &

# Python + uv (Flask)
uv run flask run > server.log 2>&1 &

# Python + uv (Django)
uv run python manage.py runserver > server.log 2>&1 &

# Rust
cargo run --release > server.log 2>&1 &

# Go
go run . > server.log 2>&1 &
# または air（ホットリロード）
air > server.log 2>&1 &

# Ruby on Rails
bundle exec rails server > server.log 2>&1 &

# 静的サイト
bunx http-server -p 8080 > server.log 2>&1 &
```

起動後の処理：
- プロセスIDを記録: `echo $! > .server.pid`
- 起動確認: `sleep 2 && curl -s http://localhost:PORT || tail -20 server.log`
- URLを表示: 「🚀 アプリケーションが起動しました: http://localhost:PORT」
- 停止方法を案内: 「停止するには: kill $(cat .server.pid)」

**CLI ツール**
- 実行例とヘルプを表示
- 主要なコマンドのデモ
- インタラクティブモードがあれば起動

**API サーバー**
- エンドポイント一覧を表示
- HTTPieやcurlでの実行例
- OpenAPI/Swaggerがあれば自動起動

backlog.yaml の更新時に現在日時を取得：
```bash
current_time=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
# status を review に更新し、updated_at に $current_time を設定
```

**変更をコミット**：
```bash
git add docs/cc-xp/backlog.yaml
git commit -m "chore: ストーリー ${id} を review に更新"
```

### 2. フィードバックフェーズ（accept/reject指定時）

#### **accept の場合**: 
1. ストーリーを `done` に更新
2. 完了日時を記録: `completed_at: $(date -u +"%Y-%m-%dT%H:%M:%SZ")`
3. 変更をコミット：
   ```bash
   git add docs/cc-xp/backlog.yaml
   git commit -m "feat: ✨ ストーリー ${id} 完了"
   ```
4. **ブランチをマージ**：
   ```bash
   # mainブランチにマージ
   git checkout main
   git merge --no-ff story-${id} -m "merge: ストーリー ${id} - ${title}"
   
   # タグを付ける（オプション）
   git tag -a "story-${id}-done" -m "完了: ${title}"
   ```
5. 次のストーリーまたは振り返りを提案

#### **reject の場合**:
1. 具体的な問題点を記録
2. 修正ストーリーを backlog に追加（作成日時付き）
3. `status` を `in-progress` に戻す
4. 変更をコミット：
   ```bash
   git add docs/cc-xp/backlog.yaml
   git commit -m "fix: 🐛 ストーリー ${id} - ${reject_reason}"
   ```

## 実行例

```bash
# 初回（起動）
/cc-xp:review

# フィードバック
/cc-xp:review accept
/cc-xp:review reject "ブロックの色が見づらい"
```

## 次コマンド

### accept の場合
```text
振り返りと改善：
/cc-xp:retro
```

### reject の場合
```text
修正を実装：
/cc-xp:develop
```
