---
allowed-tools:
  - Read(.claude/agile-artifacts/*)
  - Write
  - Bash(mkdir -p *)
  - Bash(git add *)
  - Bash(git commit -m *)
description: イテレーション計画の作成（90分単位）
argument-hint: "[iteration-number]"
---

# イテレーション計画の作成

イテレーション番号: $ARGUMENTS（省略時は自動判定）

## 実行内容

### 1. 前回フィードバックの確認（2回目以降）

前回のフィードバックがあれば自動的に反映：

- 優先順位の変更
- プロセスの改善
- ユーザーの要望

未収集の場合は警告を表示。

### 2. ストーリー選択

- 1.5-2 時間で完了できる量（3-4 ストーリー）
- イテレーション 1 は必ず「プロジェクト基盤構築」を含む
- フィードバックによる優先順位変更を反映

### 3. 技術スタック決定（初回のみ）

ストーリーの内容から自動判定：

- Web アプリ → HTML/JS/Canvas + Vitest
- CLI ツール → Node.js/Python + 適切なテストツール
- API → Express/FastAPI + テストフレームワーク

### 4. ステップ分解

各ストーリーを 15-30 分のステップに分解し、さらに 2-5 分のマイクロサイクルへ：

```text
Step X.Y: [ステップ名]（20分）
├─ Cycle 1: [具体的タスク]（4分）
│  ├─ RED: テスト作成
│  ├─ GREEN: Fake It実装（Kent Beck戦略は @~/.claude/commands/shared/kent-beck-principles.md 参照）
│  └─ COMMIT: [BEHAVIOR] Message
├─ Cycle 2: [次のタスク]（4分）
└─ ...
```text

### 5. ファイル生成

`.claude/agile-artifacts/iterations/iteration-N.md`:

- 選択ストーリー
- 実行計画（ステップとサイクル）
- 必須ゲート（@~/.claude/commands/shared/mandatory-gates.md 参照）
- 進捗管理情報

### 6. コミット

コミット規則は @~/.claude/commands/shared/commit-rules.md を参照：
```bash
git add .claude/agile-artifacts/iterations/
git commit -m "[BEHAVIOR] Create iteration N plan"
```text

## Tidy First実行計画

- 振る舞いの変更 → 構造的変更の順序
- コミット予定数を明示
- [BEHAVIOR]と[STRUCTURE]を分離

## 完了後

```text
📋 Iteration N 計画完了！
ストーリー: X個、時間: Y分

次: /tdd:run
```text
