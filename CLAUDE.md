# CLAUDE.md

Claude Code (claude.ai/code) でこのリポジトリのコード作業をする際のガイダンスファイル。

## プロジェクト概要

cc-xp-kit（旧 cc-tdd-kit）は、Kent Beck の XP 原則と Value-Driven TDD サイクルを統合した価値中心の開発支援ツールキットです。5 つのスラッシュコマンドで体系的な開発ワークフローを提供します。

## 重要な言語設定

**すべての出力は日本語で行ってください。** ただし以下を除く。
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

1. **plan** → backlog.yaml 生成（価値中心ストーリー抽出）
2. **story** → 価値実現の条件定義、フィーチャーブランチ作成
3. **develop** → Red→Green→Refactor サイクル（価値駆動 TDD）
4. **review** → 価値×技術の二軸評価、価値体験検証
5. **retro** → 価値実現分析、健全性評価

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
  core_value: 本質価値（最重要）
  minimum_experience: 最小価値体験
  target_experience: 目標価値体験
  value_experiencers: 価値体験者

stories:
  - id: ストーリーID
    title: タイトル
    value_story: 価値ストーリー
    # 価値実現情報
    core_value: 本質価値
    minimum_experience: 最小価値体験
    hypothesis: 価値仮説
    kpi_target: 価値測定目標
    # ステータス管理
    status: selected|in-progress|testing|done
    priority: "Core Value|Experience Enhancement|Context Optimization"
    # 検証結果
    value_realization: 価値実現状況（完了時）
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

backlog.yaml の内容は以下のルールで日本語化。
- **値（value）**: すべて日本語
- **キー（key）**: 英語のまま維持
- **例外**:
  - ステータス値（selected, in-progress 等）は英語
  - URL やファイルパスは英語
  - 技術用語（TDD, KPI 等）は英語可

### 価値駆動開発の要素

すべてのストーリーには以下が必須。
- **core_value**: 実現すべき本質価値（日本語）。
- **minimum_experience**: 最低限必要な価値体験（日本語）。
- **hypothesis**: 価値体験を中心とした検証可能な仮説（日本語）。
- **success_metrics**: 価値体験の測定方法（日本語）。

### Git操作の権限

.claude/settings.local.json で設定済み。
- コミット、ブランチ操作は許可
- SKIP_HOOKS=1 を使用した直接コミット可能

### 価値中心哲学への転換 (v0.2.2)

**重大な哲学的変更**:「Technical Excellence」から「User Value Excellence」への転換。
- **従来**: 技術的に完璧だが価値がない実装を許容
- **新規**: ユーザーが実際に価値を体験できる実装を必須化

**テトリス例での改善**:
- 従来: テトロミノデータ構造は完璧だが、プレイできない
- 新規: プレイヤーが実際にゲームを楽しめる実装を必須

## 開発時の注意事項

1. **backlog.yamlは自動生成**
   - 手動編集禁止
   - `/cc-xp:plan`コマンドで生成・更新

2. **ブランチ戦略**
   - story-{id}形式でフィーチャーブランチ作成
   - main へのマージはレビュー後。

3. **価値優先**
   - 必ず Red→Green→Refactor サイクルで価値実現を確認。
   - ユーザーが実際に価値を体験できることを重視

4. **言語統一の維持**
   - backlog.yaml で英語が混入した場合、生成元の.md ファイルを修正
   - 特に value_experiencer, core_value, value_story などの文字列項目に注意

## カスタムスラッシュコマンドの作成指針

### 基本原則

カスタムスラッシュコマンド（src/cc-xp/*.md）には、**自然文による指示**のみを記載してください。

**✅ 正しい書き方**：
```
Gitリポジトリが初期化されているか確認してください。
初期化されていない場合は、適切な解決方法を案内してください。
```

**❌ 間違った書き方**：
```bash
if [ ! -d ".git" ]; then
    echo "❌ エラー: Gitリポジトリが初期化されていません"
    exit 1
fi
```

### 重要な理由

- **並列実行問題の回避**: 複数の```bash ブロックがあると、Claude Code が並列実行し、同じ処理が重複する
- **保守性**: 自然文なら、Claude Code が適切に解釈して実行する
- **柔軟性**: 環境や状況に応じて適切な手法を選択できる

### 推奨パターン

1. **状況確認**:「〜を確認してください」
2. **条件分岐**:「〜の場合は〜してください」
3. **実行指示**:「〜してください」
4. **エラー対応**:「失敗した場合は〜を案内してください」
