# 🚀 次のステップ案内

## ワークフロー進行ルール

コマンド終了時、backlog.yamlのステータスに基づいて適切な次のコマンドを案内してください：

### 1. plan 完了時

→ /cc-xp:story [selected-story-id]
（最初のストーリーを詳細化）

### 2. story 完了時

→ /cc-xp:research
（技術調査を実施）

### 3. research 完了時

→ /cc-xp:develop
（TDD開発サイクル開始）

### 4. develop 完了時（status: "testing"）

→ /cc-xp:review
（自動テスト実行とコードレビュー）

### 5. review accept時（status: "done"）

- 他のストーリーがある場合:
  → /cc-xp:story [next-story-id]
- 振り返りを実施する場合:
  → /cc-xp:retro

### 6. review reject時（status: "testing"）

→ /cc-xp:develop
（修正を実施）

### 7. retro 完了時

- selectedストーリーがある:
  → /cc-xp:story
- in-progressストーリーがある:
  → /cc-xp:develop
- すべて完了:
  → /cc-xp:plan "次の要求"

## 表示フォーマット

必ず以下の形式で表示してください：

```
🚀 次のステップ
================
[状況に応じた案内文]:
→ /cc-xp:[次のコマンド]

[補足説明があれば記載]
```

## 重要注意事項

**重要**: すべてのcc-xp:*コマンド終了時に、必ず「🚀 次のステップ」セクションを表示してください。