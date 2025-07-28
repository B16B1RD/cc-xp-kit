---
allowed-tools:
  - Bash(git status --short)
  - Bash(git diff --cached --stat)
  - Bash(git diff --cached)
  - Bash(git log --oneline -10)
  - Bash(git add *)
  - Bash(git commit -m *)
  - Read(CLAUDE.md)
  - Read(.gitignore)
description: コンテキストを理解してインテリジェントなコミットを作成
argument-hint: "[files-to-add] [--amend]"
---

# 🧠 インテリジェント Git コミット

入力引数: $ARGUMENTS

## 📋 現在のコンテキスト

### Git ステータス

!`git status --short`

### ステージング済みの変更統計

!`git diff --cached --stat`

### ステージング済みの詳細な変更

```diff
!`git diff --cached`

### 最近のコミット履歴

!`git log --oneline -10`

### プロジェクトのコミット規則

@CLAUDE.md

## 🎯 タスク

上記のコンテキストを基に:

1. **変更内容を分析**して、適切なコミットタイプを判定:
   - `[FEAT]`: 新機能追加
   - `[FIX]`: バグ修正
   - `[REFACTOR]`: リファクタリング
   - `[STYLE]`: コードスタイルの変更
   - `[TEST]`: テストの追加・修正
   - `[DOCS]`: ドキュメントの更新
   - `[CHORE]`: ビルドプロセスや補助ツールの変更

2. **コミットメッセージを生成**:
   - 最初の行: タイプタグ + 簡潔な要約（50文字以内）
   - 空行
   - 詳細な説明（必要に応じて）
   - 関連するイシュー番号（あれば）

3. **ベストプラクティスに従う**:
   - 現在形で記述（"Add" not "Added"）
   - 何を変更したかではなく、なぜ変更したかを説明
   - 破壊的変更がある場合は明記

4. **実行**:
   - 必要なファイルを `git add`
   - 適切なメッセージで `git commit`

### 特別な指示

$ARGUMENTS

- `--amend` が含まれる場合: 最新のコミットを修正
- ファイルパスが指定されている場合: それらのファイルのみをステージング

## 💡 ヒント

このコマンドは以下の場合に特に有用です:

- 複数の関連する変更をまとめてコミットする時
- プロジェクトのコミット規約に従った一貫性のあるメッセージが必要な時
- 変更の文脈を理解した上で適切な説明を生成したい時
