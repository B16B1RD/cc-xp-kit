---
allowed-tools:
  - Read(.claude/agile-artifacts/*)
  - Bash(git status --short)
  - Bash(git log --oneline -10)
  - Bash(git log --since="today" --oneline | wc -l)
  - Bash(find .claude/agile-artifacts -name "*.md" -o -name "*.json" | wc -l)
  - LS
description: TDD進捗状況の確認とレポート
argument-hint: "[-v for detailed view]"
---

# TDD進捗状況

オプション: $ARGUMENTS（-v で詳細表示）

## 🔄 現在の状態

### Git 状況

!`git status --short`

### 最近のコミット

!`git log --oneline -10`

### 本日の活動

- コミット数: !`git log --since="today" --oneline | wc -l`

## 📊 進捗情報

### 基本情報

Iteration N: 60% 完了 (36/60 チェック)
├─ Phase 1: ✅ 完了
├─ Phase 2: 🔄 進行中 (Step 2.3)
└─ Phase 3: ⏳ 未着手

必須ゲート（@~/.claude/commands/shared/mandatory-gates.md 詳細）: ⚠️ フィードバック未収集

### プロジェクトファイル

- アーティファクト数: !`find .claude/agile-artifacts -name "*.md" -o -name "*.json" | wc -l`

### 🚀 次のアクション

現在の状況に応じて、以下のコマンドを実行してください：

#### 中断したTDD開発を再開する場合
```
/tdd:run --resume
```
これにより以下が自動実行されます：
- 中断箇所の自動特定
- 未完了ステップからの継続実行
- 進捗状況の自動同期

#### より詳しい進捗情報を確認する場合
```
/tdd:status -v
```
これにより以下の詳細情報が表示されます：
- 各ステップの実行時間
- Git コミット履歴
- テスト結果の詳細分析

## 詳細表示（-v オプション）

### 追加情報

- ストーリー別進捗（受け入れ基準の達成状況）
- 本日の統計（作業時間、サイクル数、平均時間）
- 品質指標（Fake It 使用率、Tidy First 遵守率）
- フィードバック履歴
- 現在作業中の詳細

### データソース

- イテレーションファイル: 進捗状況
- セッション JSON: 統計情報
- Git ログ: コミット履歴
- ストーリーファイル: 受け入れ基準

## 健康状態インジケーター

🟢 健全（必須ゲート > 90%）
🟡 注意（70-90%）
🔴 要改善（< 70%）

## エラー時

- ファイルが見つからない: 初期化を促す
- Git なし: Git 統計をスキップ
