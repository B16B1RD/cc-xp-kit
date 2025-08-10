# CLAUDE.md

Claude Code (claude.ai/code) でこのリポジトリのコード作業をする際のガイダンスファイル。

## プロジェクト概要

cc-xp-kit（旧 cc-tdd-kit）は、Kent Beck の XP 原則と TDD サイクルを統合した開発支援ツールキットです。5 つのスラッシュコマンドで体系的な開発ワークフローを提供します。

## 重要な言語設定

**すべての出力は日本語で行ってください。** ただし以下を除く：
- YAML のキー名（id, title, status 等）
- 英語が標準のテクニカルターム（TDD, XP, hypothesis 等）

## コマンド

### XPワークフローコマンド（メイン）

```bash
# 1. 要求分析とストーリー抽出
/cc-xp:plan "ユーザーの要望"

# 2. ストーリー詳細化
/cc-xp:story [story-id]

# 3. TDD開発
/cc-xp:develop

# 4. レビュー
/cc-xp:review

# 5. 振り返り
/cc-xp:retro
```

### ワークフロー進行

1. **plan** → backlog.yaml 生成（戦略的ストーリー抽出）
2. **story** → 受け入れ条件定義、フィーチャーブランチ作成
3. **develop** → Red→Green→Refactor サイクル（仮説駆動 TDD）
4. **review** → E2E 統合テスト、仮説検証
5. **retro** → KPI 分析、健全性評価

## アーキテクチャ

### ディレクトリ構造

```
/src/cc-xp/        # コマンド定義（.mdファイル）
  plan.md          # 要求分析・ストーリー抽出
  story.md         # ストーリー詳細化
  develop.md       # TDD開発サイクル
  review.md        # レビュー・検証
  retro.md         # 振り返り・分析

/docs/cc-xp/       # 生成される作業ファイル（プロジェクトごと）
  backlog.yaml     # ストーリーバックログ
  *.spec.js        # テストファイル
  *.js             # 実装ファイル
```

### backlog.yamlの構造

```yaml
iteration:
  id: タイムスタンプ
  business_goal: ビジネス目標
  success_criteria: 成功基準
  target_users: 対象ユーザー

stories:
  - id: ストーリーID
    title: タイトル
    # 戦略的情報
    business_value: 1-10
    user_value: 1-10
    hypothesis: 仮説
    kpi_target: KPI目標
    # ステータス管理
    status: selected|in-progress|testing|done
    # 検証結果
    hypothesis_validation: 検証結果（完了時）
```

### plan.mdのシンプル化について

**改善内容（v0.2.2）**:
- 778 行 → 113 行の大幅簡略化
- 5 段階プロセス → 3 段階に統合
- 過度に詳細なチェックリストを削除
- AI の能力を信頼したシンプルな指示

**維持された機能**:
- 真の目的分析、ペルソナ特定、ストーリー生成の核心プロセス
- backlog.yaml の構造（他コマンドとの互換性）
- 仮説駆動開発の要素（hypothesis, kpi_target）

### 日本語統一に関する重要事項

backlog.yaml の内容は以下のルールで日本語化：
- **値（value）**: すべて日本語
- **キー（key）**: 英語のまま維持
- **例外**:
  - ステータス値（selected, in-progress 等）は英語
  - URL やファイルパスは英語
  - 技術用語（TDD, KPI 等）は英語可

### 仮説駆動開発の要素

すべてのストーリーには以下が必須：
- **hypothesis**: 検証すべき仮説（日本語）。
- **kpi_target**: 測定可能な成功指標（日本語）。
- **success_metrics**: 測定方法（日本語）。

### Git操作の権限

.claude/settings.local.json で設定済み。
- コミット、ブランチ操作は許可
- SKIP_HOOKS=1 を使用した直接コミット可能

## 開発時の注意事項

1. **backlog.yamlは自動生成**
   - 手動編集禁止
   - `/cc-xp:plan`コマンドで生成・更新

2. **ブランチ戦略**
   - story-{id}形式でフィーチャーブランチ作成
   - main へのマージはレビュー後。

3. **テスト優先**
   - 必ず Red→Green→Refactor サイクルを守る
   - E2E テストによる仮説検証を重視

4. **言語混在の修正**
   - backlog.yaml で英語が混入した場合、生成元の.md ファイルを修正
   - 特に persona, user_story, value などの文字列項目に注意