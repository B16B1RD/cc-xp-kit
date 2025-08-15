---
description: XP review – 価値×技術の二軸評価と判定（accept/reject/skipで指定）+ 価値体験確認
argument-hint: '[accept|reject|skip] [理由（rejectの場合）] [--skip-demo] [--skip-e2e]'
allowed-tools: Bash(git:*), Bash(date), Bash(test), Bash(kill:*), Bash(cat), Bash(http-server:*), Bash(lsof:*), Bash(netstat:*), ReadFile, WriteFile(docs/cc-xp/stories/*-feedback.md), WriteFile(docs/cc-xp/backlog.yaml), mcp__playwright__browser_navigate, mcp__playwright__browser_snapshot, mcp__playwright__browser_take_screenshot
---

# XP Review - 価値×技術 二軸評価

## ゴール

実際に価値を体験してユーザー視点で評価し、価値実現度と技術品質の二軸で承認/却下を判定する。**1回のコマンドで完結**。

## ⛔ 絶対的禁止事項 - CRITICAL

### review コマンドの責務境界

**review コマンドは評価・判定のみを行います。修正作業は一切行いません。**

#### 🚫 実装修正の絶対禁止

1. **ソースコードの修正・作成の絶対禁止**
   - src/*.js, src/*.ts, src/*.py 等への一切の変更禁止
   - HTMLファイルの修正・新規作成禁止（index.html, test-*.html等）
   - 実装ファイルへの編集・作成は絶対禁止
   - **⛔ CRITICAL**: 不完全な実装を補うためのファイル作成は絶対禁止

2. **開発作業の完全禁止**
   - Red→Green→Refactor サイクル実行禁止
   - 問題解決の実装禁止
   - バグ修正作業禁止
   - コード改善作業禁止

## XP原則

@src/cc-xp/shared/xp-principles.md

## 引数チェック（最初に実行）

コマンドに渡された引数を確認してください：

$ARGUMENTS の最初の単語を確認：
- 引数が "accept" の場合: Phase 0-4をスキップして直接Phase 5のAccept処理を実行
- 引数が "reject" の場合: Phase 0-4をスキップして直接Phase 5のReject処理を実行（理由は引数の残り部分）  
- 引数が "skip" の場合: Phase 0-4をスキップして直接Phase 5のSkip処理を実行
- 引数がない場合: Phase 0-4を通常通り実行してガイダンス表示で終了

## 共通処理

@src/cc-xp/shared/git-check.md

## ステータス遷移ルール

**重要**: ステータスの正しい遷移を厳守してください。

```
selected (plan) → in-progress (story) → testing (develop) → done (review accept のみ)
                                               ↓ (reject)
                                          in-progress
```

- `done` にできるのは **`/cc-xp:review accept` のみ**
- `reject` の場合は `in-progress` に戻す
- すでに `done` のストーリーは変更不可

## 現在の状態確認

### 価値実現中心のストーリー情報取得

@src/cc-xp/shared/backlog-reader.md から `"testing"` ステータスのストーリーを確認し、**価値実現に必要な全情報**を取得してください。

**重要なバリデーション**：
- `"testing"` ステータスのストーリーがない場合は、「先に `/cc-xp:develop` を実行してください」と案内
- すでに `"done"` のストーリーは対象外（再レビュー不可）

### 既存プロセスの確認

- サーバー稼働確認: !test -f .server.pid
- 現在のブランチ: !git branch --show-current

## Phase 0: 自動品質ゲート（読み取り専用）

### テスト結果の確認と評価

**⚠️ 重要: review コマンドはテスト結果の確認のみ実行**
- テストの実行と結果確認は可能
- テストやコードの修正は絶対禁止
- 問題があれば reject して develop コマンドへ案内

#### 0.1 全テスト実行

プロジェクトのテストスイートを実行して品質を確認：

```bash
# プロジェクトタイプに応じたテスト実行
npm test || yarn test || pnpm test ||
python -m pytest || python -m unittest ||
go test ./... ||
cargo test ||
bundle exec rspec
```

**テスト結果の判定**:
- **全テストPASS**: レビュー継続
- **1つでも失敗**: 自動的に reject、develop コマンドでの修正を案内
  （review コマンドでは修正作業は行わない）

#### 0.2 テストカバレッジ確認

```bash
# カバレッジ付きテスト実行
npm test -- --coverage ||
pytest --cov ||
go test -cover ./...
```

**カバレッジ基準**:
- **85%以上**: ✅ 合格
- **85%未満**: ⚠️ 警告（rejectするかユーザー判断）
- **測定不可**: ℹ️ 情報表示のみ

## Phase 1: 価値体験実地検証

### 価値体験の実際の確認

実際にソフトウェアを操作して、backlog.yamlの `minimum_experience` が体験可能かを確認してください。

#### プロジェクトタイプ別の確認方法

**Web アプリケーション・ゲーム**:
1. ローカルサーバーを起動
2. ブラウザでアクセス
3. minimum_experience の各項目を実際に操作
4. 価値体験の実現度を評価

**CLI ツール**:
1. コマンドラインから実行
2. 基本機能の動作確認
3. ユーザーが期待する価値の提供確認

#### 価値実現度の評価

**1-2点: 価値体験不可能**（開発メッセージやエラーのみ）
**3-4点: 価値体験不十分**（minimum_experienceの一部のみ）
**5-6点: 最小限価値体験**（minimum_experienceほぼ実現）
**7-10点: 期待通り〜期待超え**（minimum_experience完全実現+α）

### 必須確認項目

- ユーザーがbacklog.yamlのminimum_experienceを実際に体験可能
- 開発メッセージでなく実際のコンテンツが表示  
- 技術的テスト成功でなく実際の価値提供を確認

## Phase 2: 技術品質評価

### コード品質の評価

以下の観点で技術品質を評価してください：

1. **TDD原則遵守**
   - Red-Green-Refactorサイクルの完全性
   - テストファースト原則の遵守
   - テスト品質の評価

2. **設計品質**
   - コードの可読性
   - 重複の除去
   - 適切な抽象化

3. **価値実現技術**
   - minimum_experienceの技術的実現
   - ユーザー体験の技術的サポート

## Phase 3: 判定とフィードバック

### 価値×技術の二軸評価

**accept 基準**:
- 価値実現度: 5点以上（minimum_experience実現）
- 技術品質: 全テストPASS + 設計品質良好
- minimum_experience未実現は強制Reject

**reject 基準**:
- 価値実現度: 4点以下
- 技術品質: テスト失敗またはTDD原則違反
- 開発メッセージ表示のみ

### フィードバック記録

`docs/cc-xp/stories/[story-id]-feedback.md` にレビュー結果を記録：

```markdown
# Review Feedback - [Story ID]

## 価値実現度評価: [1-10点]

### minimum_experience 確認結果
- [確認項目1]: ✅/❌
- [確認項目2]: ✅/❌

## 技術品質評価

### テスト結果
- テスト実行: ✅/❌
- カバレッジ: [%]

### TDD品質
- Red-Green-Refactor: ✅/❌
- テストファースト: ✅/❌

## 判定: [Accept/Reject]

### 理由
[判定理由の詳細]

### 改善提案（Rejectの場合）
[具体的な改善指示]
```

## Phase 4: ステータス更新

### Accept の場合

1. backlog.yamlのストーリーステータスを `testing` から `done` に更新
2. `value_realization` に価値実現状況を記録
3. `completed_at` に完了時刻を記録

### Reject の場合

1. backlog.yamlのストーリーステータスを `testing` から `in-progress` に戻す
2. 回帰テストファイル生成（必要に応じて）
3. フィードバックに基づく修正指示

## 完了確認

```
🎯 Review 完了 - [Accept/Reject]
================================
ストーリー: [story-id]
価値実現度: [点数]/10
技術品質: [評価]

価値体験確認:
✅/❌ minimum_experience実現
✅/❌ ユーザー価値提供
✅/❌ 実際の動作確認

技術品質:
✅/❌ 全テストPASS
✅/❌ TDD原則遵守
✅/❌ 設計品質良好

次のアクション:
→ [Accept: 次のストーリー / Reject: /cc-xp:develop で修正]
```

## 次のステップ

@src/cc-xp/shared/next-steps.md