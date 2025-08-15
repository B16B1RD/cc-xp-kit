---
description: XP plan – プロジェクト初期化とTDD環境構築 + 価値ストーリー抽出
argument-hint: '"ウェブブラウザで遊べるテトリスが欲しい"'
allowed-tools: Bash(date), Bash(echo), Bash(git:*), Bash(test), Bash(mkdir:*), Bash(cat), Bash(npm:*), Bash(yarn:*), Bash(pnpm:*), Bash(python:*), Bash(go:*), ReadFile, WriteFile
---

# XP Plan - TDD環境構築と価値ストーリー抽出

## 🎯 ゴール

1. **TDD環境の構築** - プロジェクトでTDDを実践できる環境を整備
2. **価値ストーリーの抽出** - ユーザー要求「$ARGUMENTS」の**本質価値**を抽出し、実現するストーリーセットを生成

## 共通処理

@shared/git-check.md

## TDD環境構築

### CLAUDE.md生成/更新

プロジェクトにTDD原則を適用するため、CLAUDE.mdを確認・生成してください。

**既存CLAUDE.mdの確認**:
- CLAUDE.mdが存在する場合：TDDセクション追加/更新
- CLAUDE.mdが存在しない場合：新規作成

**生成するCLAUDE.md内容**:
```markdown
# CLAUDE.md

<!-- 既存の内容がある場合はここに保持 -->

<!-- cc-xp-kit:start -->

## cc-xp-kit TDD Guidelines

*このセクションは /cc-xp:plan により自動生成されました*

@shared/tdd-principles.md

### /cc-xp コマンド使用時の注意

#### develop実行時

- 必ず `npm test` が存在することを確認
- テストなしでの実装は自動的に拒否されます
- 手動テストのみでの検証は禁止

#### review実行時  

- 全テストPASSが必須条件
- カバレッジ85%未満は自動reject
- 回帰テストの失敗は即座に修正

### 🚨 アンチパターン自動検出

以下が検出された場合、コマンドは自動停止します：
- テストファイルが存在しない
- テストを後から追加
- テストを通すためにテストを修正
- 構造と振る舞いの変更を混在

@shared/next-steps.md

<!-- cc-xp-kit:end -->
```

### プロジェクトタイプ検出とテスト環境構築

@shared/test-env-check.md

### プロジェクトタイプ別必須ファイル生成

**🎯 価値体験を可能にする基本ファイルの自動生成**

プロジェクトタイプに応じて、ユーザーが実際に価値体験できる基本ファイルを生成してください。

#### Web アプリケーション・ゲーム（package.json 存在時）

以下のファイルが存在しない場合のみ生成してください：

**index.html** - ブラウザで開けるメインファイル
**server.js** - 開発サーバー（npm run dev 対応）
**src/[main-file].js** - メイン実装ファイル

#### CLI ツール・ライブラリ（package.json 存在時）

package.json への bin 設定追加と cli.js 生成

#### Python プロジェクト（requirements.txt 等存在時）

main.py 生成

## 価値抽出プロセス

### Stage 0: 要求から本質価値を抽出（最重要）

表面的要求から本質的なユーザー価値を発見してください。

#### 1. 本質価値の特定

- **核心価値**: この要求でユーザーが本当に得たい価値・体験は何か。
- **最終状態**: 実現後、ユーザーはどんな状態になりたいのか。
- **価値の実体**: 技術実装ではなく、ユーザー体験として何を実現すべきか。

#### 2. 最小価値体験の定義

- **最小体験**: 最も簡単な実装でもこの価値は提供できるか。
- **体験核心**: ユーザーが「これが欲しかった」と感じる最小構成は何か。
- **価値純度**: 技術的複雑性を排除した純粋な価値は何か。

#### 3. 価値確認方法の設計

- **確認手段**: この価値が実現されていることをどう確認するか。
- **体験測定**: ユーザーが実際に体験してどう感じるかをどう測るか。
- **価値証明**: 技術的成功と価値実現の整合性をどう確認するか。

### Stage 1: 真の目的分析

本質価値を背景から確認・強化してください。

### Stage 2: 価値体験者の特定

本質価値を体験する人々とその動機を明確化してください。

### Stage 3: 価値ストーリー生成と優先度設定

本質価値を実現するストーリーを価値優先度で整理してください。

## Value Story フォーマット

価値実現を中心としたストーリーフォーマット。

```
As a [価値体験者]
I want [価値体験]
So that [本質価値の実現]
And I expect [体験できること・感じること]

Core Value Criteria:
- [本質価値が実現されていることの確認方法]

Experience Criteria:
- [価値体験が提供されていることの確認方法]
```

**優先度判定（価値中心）**:
- **Core Value**: 本質価値の直接実現（最優先）
- **Experience Enhancement**: 価値体験の向上
- **Context Optimization**: 価値提供の文脈適応

### backlog.yaml生成

分析結果を基に価値中心のストーリーセットを生成し、backlog.yaml に記録してください。

**価値実現必須メタデータ**:
```yaml
iteration:
  id: [timestamp]
  core_value: "本質価値（最重要）"
  minimum_experience: "最小価値体験"
  target_experience: "目標価値体験"
  value_experiencers: "価値体験者"

stories:
  - id: [story-id]
    title: "ストーリータイトル"
    value_story: "価値ストーリー（As a... I want... So that... And I expect...）"
    # 価値実現必須項目
    core_value: "このストーリーが実現する本質価値"
    minimum_experience: "最低限必要な価値体験"
    hypothesis: "価値体験を中心とした検証可能な仮説"
    kpi_target: "価値体験完成度・満足度・継続意欲の数値目標"
    success_metrics: "価値が体験できることの確認項目リスト"
    value_uniqueness: "このソフトウェアならではの価値"
    value_experiencer: "具体的な価値体験者"
    value_context: "価値が必要とされる文脈"
    status: "selected"
    priority: "Core Value|Experience Enhancement|Context Optimization"
```

## 完了確認

**TDD環境構築完了**:
```
🔧 TDD環境構築完了
====================
言語: [検出された言語]
テストランナー: [jest|pytest|go test|など]
CLAUDE.md: [新規作成|TDDセクション追加]

構築された環境:
✅ テスト実行環境
✅ ディレクトリ構造
✅ 初期テストファイル
✅ CI/CD基本設定
✅ プロジェクト固有TDD原則
✅ 価値体験基盤ファイル（index.html, server.js等）

価値体験準備状況:
✅ Web アプリ: ブラウザで開ける基本構造
✅ ゲーム: プレイ可能な基盤の準備
✅ CLI: 実行可能な基本コマンド

確認コマンド:
→ npm test (または該当言語のテストコマンド)
```

**価値ストーリー抽出完了**:

## 次のステップ

@shared/next-steps.md