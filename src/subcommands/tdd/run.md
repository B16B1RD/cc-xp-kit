---
allowed-tools:
  - Read(.claude/agile-artifacts/*)
  - Write
  - Edit
  - MultiEdit
  - Bash(*)
  - Grep
  - Glob
  - LS
  - Task
  - TodoWrite
description: TDD実行 - Red/Green/Refactorサイクルの実行
argument-hint: "[--step|--micro|--step X.Y|--resume]"
---

# TDD実行

オプション: $ARGUMENTS（--step, --micro, --step X.Y, --resume）

## 実行モード

### デフォルト: イテレーション全体の連続実行 🎯

オプションなしの場合、現在のイテレーションの全ステップを自動実行。

### オプション

- `--step`: 単一ステップのみ実行して終了
- `--micro`: ステップごとに確認しながら実行
- `--step X.Y`: 特定ステップから開始
- `--resume`: 中断箇所から再開

## 実行フロー

### 1. 準備

- 最新のイテレーションファイルを読み込み
- 前回フィードバックの確認（未収集なら警告）

### 2. 実行モードに応じた処理

#### イテレーション全体実行（デフォルト）

```text
🚀 イテレーション N 連続実行を開始します
────────────────────────────────────────
  📋 総ステップ数: X個
  ⏱️ 推定時間: XX分
  🎯 自動実行モード
────────────────────────────────────────

各ステップを自動的に実行していきます...
```text

#### 単一ステップ実行（--step）

```text
🔄 単一ステップモードで実行します
次の未完了ステップのみを実行して終了します。
```text

### 3. 各ステップの実行

#### 🔴 RED（テスト作成）

Kent Beck 視点で最小限のテストを作成：

```javascript
test("具体的な例から始める", () => {
  expect(game.getBlock()).toBe("red");
});
```text

テスト実行（タイムアウト対策）:

```bash
npm test -- --watchAll=false --forceExit 2>&1
```text

#### 🟢 GREEN（最小実装）

必ず Fake It から始める：

```javascript
getBlock() {
  return "red"; // ハードコーディング
}
```text

コミット:

```bash
git commit -m "[BEHAVIOR] Step X.Y: Fake It implementation"
```text

#### 🔵 REFACTOR（必要時）

構造的変更のみ（振る舞いは変えない）：

```bash
git commit -m "[STRUCTURE] Step X.Y: Extract method"
```text

### 4. 必須チェック（各ステップ後）

参照: `~/.claude/commands/shared/mandatory-gates.md`

- **動作確認**: プロジェクトタイプに応じて実施
  - Web: Playwright MCP でスクリーンショット
  - CLI: コマンド実行結果
  - API: curl でレスポンス確認

- **受け入れ基準**: ストーリーファイルを更新

```bash
sed -i 's/\[ \]/\[x\]/' project-stories.md
```text

- **進捗更新**: イテレーションファイルの保存

### 5. モードに応じた完了処理

#### イテレーション完了時（デフォルト）

すべてのステップ完了後、フィードバック収集を実行。

#### 単一ステップ完了時（--step）

```text
✅ Step X.Y 完了
次のステップを実行するには: /tdd:run --step
```text

### 6. フィードバック収集（イテレーション完了時のみ）

#### 簡素版（1分で完了）

```text
💭 3つの質問：

1. 期待通りでしたか？ [5段階 + コメント]
2. 次に欲しい機能は？ [一言で]
3. 改善点は？ [あれば]
```text

すべて回答されるまで完了としない。

### 7. フィードバック保存

`.claude/agile-artifacts/reviews/iteration-N-feedback.md`:

```bash
git commit -m "[BEHAVIOR] Save iteration N feedback"
```text

## エラー対応

参照: `~/.claude/commands/shared/error-handling.md`

エラー時は 3 つの質問に答えてから対応。

## プロジェクトタイプ別確認

参照: `~/.claude/commands/shared/project-verification.md`

## 完了メッセージ

### イテレーション完了時

```text
🎉 イテレーション N 完了！
技術実装: 100%
フィードバック: 収集済み

次: /tdd:review N
```text

### 単一ステップ完了時

```text
✅ Step X.Y 完了！
進捗: X/Y ステップ完了

続行: /tdd:run （イテレーション全体）
     /tdd:run --step （次のステップのみ）
```text
