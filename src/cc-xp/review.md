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

@shared/xp-principles.md

## 引数チェック（最初に実行）

コマンドに渡された引数を確認してください：

$ARGUMENTS の最初の単語を確認：
- 引数が "accept" の場合: Phase 0-2をスキップして直接Phase 3-4のAccept処理を実行
- 引数が "reject" の場合: Phase 0-2をスキップして直接Phase 3-4のReject処理を実行（理由は引数の残り部分）  
- 引数が "skip" の場合: Phase 0-2をスキップして直接Phase 3-4のSkip処理を実行
- **引数がない場合**:
  - Phase 0-2を実行して評価結果を表示
  - **Phase 3-4（判定・ステータス更新処理）は実行しない**
  - 評価結果表示後、以下のガイダンスを表示して終了：
    ```
    📋 評価完了
    ================
    判定を行うには、以下のいずれかのコマンドを実行してください：
    
    ✅ 承認する場合: /cc-xp:review accept
    ❌ 却下する場合: /cc-xp:review reject [理由]
    ⏭️ スキップする場合: /cc-xp:review skip
    ```

## 共通処理

@shared/git-check.md

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

@shared/backlog-reader.md から `"testing"` ステータスのストーリーを確認し、**価値実現に必要な全情報**を取得してください。

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

## Phase 1: 受け入れ基準実現検証（E2Eテストベース）

### acceptance_criteria の完全実現確認

backlog.yamlの `acceptance_criteria` がE2Eテストで完全に実現されているかを確認してください。

#### 1. E2Eテストの実行と結果確認

```bash
# E2Eテスト実行
npm run test:e2e
# または
npx playwright test
# または該当するE2Eテストコマンド
```

#### 2. 受け入れ基準ベースの価値実現度判定

**10点: 完全実現** - 全acceptance_criteriaのE2EテストがPASS
**7-9点: ほぼ実現** - 重要な基準は満たすが一部で軽微な問題
**4-6点: 部分実現** - acceptance_criteriaの50%以上が満たされている
**1-3点: 実現不可** - acceptance_criteriaの多くが未実現
**0点: 全く未実現** - E2Eテストが全て失敗またはテストファイル不存在

#### 3. acceptance_criteria 個別確認

各受け入れ基準について個別に確認：

```yaml
acceptance_criteria:
  - "ブラウザでページを開くとゲーム画面が表示される" → ✅/❌
  - "テトロミノが1秒間隔で自動的に1行下に移動する" → ✅/❌
  - "プレースホルダーメッセージが表示されない" → ✅/❌
```

#### 4. 実際の動作確認（補完的）

E2Eテスト結果を補完するため、実際のアプリケーション起動も確認：
- E2Eテストで検証された動作が手動でも確認できるか
- ユーザー体験として自然で満足できるか

### 価値実現判定の厳格化

**🚨 強制Reject条件**:
- acceptance_criteriaが存在しない
- E2Eテストファイルが存在しない
- E2Eテストが1つでも失敗している
- プレースホルダーメッセージ（「開発中」等）が表示される

**Accept可能条件**:
- 全acceptance_criteriaのE2EテストがPASS
- 実際の価値体験が実現されている
- minimum_experienceが完全に体験可能

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

**⚠️ 引数チェック**: 引数がない場合は、以下の評価結果表示のみ行い、判定・ステータス更新（Phase 3-4）は実行せずにガイダンス表示で終了してください。

### 受け入れ基準×技術品質の二軸評価

**🎯 Accept基準（すべて必須）**:
- **受け入れ基準**: 全acceptance_criteriaのE2EテストがPASS
- **技術品質**: 全ユニットテストPASS + カバレッジ85%以上
- **統合品質**: E2Eテストと実際の動作が一致

**❌ Reject基準（いずれか1つでも該当）**:
- acceptance_criteriaが存在しない
- E2Eテストが1つでも失敗
- ユニットテストが1つでも失敗
- カバレッジ85%未満
- プレースホルダーメッセージの表示

**⚠️ 重要**: 従来の「価値実現度の主観的評価」から「受け入れ基準の客観的検証」に変更

### フィードバック記録

`docs/cc-xp/stories/[story-id]-feedback.md` にレビュー結果を記録：

```markdown
# Review Feedback - [Story ID]

## 受け入れ基準検証結果

### acceptance_criteria 確認結果
- "[基準1の内容]": ✅ PASS / ❌ FAIL
- "[基準2の内容]": ✅ PASS / ❌ FAIL
- "[基準3の内容]": ✅ PASS / ❌ FAIL

### E2Eテスト実行結果
- テストファイル: [ファイル名]
- 実行結果: ✅ 全PASS / ❌ [N]件失敗
- 失敗項目: [失敗したテストケース一覧]

## 技術品質評価

### ユニットテスト結果
- 実行結果: ✅ 全PASS / ❌ [N]件失敗
- カバレッジ: [%] (基準: 85%以上)

### TDD品質
- Red-Green-Refactor: ✅/❌
- テストファースト: ✅/❌

## 判定: [Accept/Reject]

### Accept理由（Acceptの場合）
- 全acceptance_criteriaのE2EテストがPASS
- 全ユニットテストがPASS
- カバレッジ基準を満たしている

### Reject理由（Rejectの場合）
- [具体的な失敗した受け入れ基準]
- [失敗したテスト項目]
- [技術品質の不足点]

### 改善指示（Rejectの場合）
- [失敗したacceptance_criteriaの実装方法]
- [E2Eテストを成功させる具体的な修正指示]
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

## 次のステップ

@shared/next-steps.md