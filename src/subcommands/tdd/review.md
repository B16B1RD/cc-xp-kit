---
allowed-tools:
  - Read(.claude/agile-artifacts/*)
  - Write
  - Bash(git log *)
  - Bash(git diff --stat *)
  - Bash(find .claude/agile-artifacts -name "*.md" -o -name "*.json" | wc -l)
description: イテレーションレビューと品質分析
argument-hint: "[iteration-number]"
---

# イテレーションレビュー

レビュー対象: Iteration $ARGUMENTS（省略時は最新）

## レビュー内容

### 1. フィードバック確認

フィードバックファイルが存在しない場合：

```text
❌ フィードバック未収集
イテレーションは技術的には完了していますが、
正式には未完了です。

/tdd:run でフィードバック収集を実行してください。
```text

### 2. 実行データ収集

- イテレーションファイル: 完了状況
- TDD ログ: 実行時間、サイクル数
- Git 履歴: コミット分析
- ストーリーファイル: 受け入れ基準達成率

### 3. メトリクス計算

#### 必須ゲート達成率

詳細な必須ゲートは @~/.claude/commands/shared/mandatory-gates.md を参照：
```text
動作確認: XX%
受け入れ基準: XX%
フィードバック: ✅/❌
総合: XX%
```text

#### TDD品質

```text
Fake It使用率: XX%（目標 > 60%）
平均サイクル: X.X分（目標 < 5分）
Tidy First遵守: XX%（目標 > 95%）
```text

#### Git分析

```text
[BEHAVIOR]: XX個
[STRUCTURE]: YY個
混在: ZZ個（理想は0）
```text

### 4. レポート生成

`.claude/agile-artifacts/reviews/iteration-N-review.md`:

- 実行サマリー
- 必須ゲート達成状況
- 実装された機能
- ユーザーフィードバック（あれば）
- 学習と改善点
- 次回への提案

### 5. 品質評価

**グレード判定**:

- S: 全指標優秀 + フィードバック完了
- A: 基準達成 + フィードバック完了
- B: 一部未達成
- C: 大幅な改善必要

### 6. コミット

コミット規則は @~/.claude/commands/shared/commit-rules.md を参照：
```bash
git commit -m "[BEHAVIOR] Complete iteration N review"
```text

## 自動改善提案

メトリクスとフィードバックから：

- プロセス改善案
- 技術的な提案
- 次回の優先順位

## 完了後

```text
📊 レビュー完了！
品質: [グレード]
改善点: [要約]

次: /tdd:plan N+1
```text
