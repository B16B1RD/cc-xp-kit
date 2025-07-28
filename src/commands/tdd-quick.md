---
allowed-tools:
  - Task
description: TDD開発を即座に開始する統合コマンド
argument-hint: "作りたいものを3行で説明"
---

# TDD クイックスタート

Kent Beck 流の完全なフィードバックループでTDD開発を自動実行します。

要望: $ARGUMENTS

## Phase 1: 初期セットアップと最初のイテレーション

以下のカスタムスラッシュコマンドを順番に実行：

1. `/tdd:init`
2. `/tdd:story $ARGUMENTS`
3. `/tdd:plan 1`
4. `/tdd:run`

## Phase 2: レビューと継続判断

1. `/tdd:review 1`

## Phase 3: 継続サイクル

レビュー完了後、ユーザーに継続意思を確認し、選択に応じて以下を自動実行：

- **継続開発**: `/tdd:plan 2` → `/tdd:run` → `/tdd:review 2`
- **機能追加**: `/tdd:story [新機能]` → 継続フロー  
- **完了**: プロジェクト終了

XP原則に基づく即座のフィードバック、頻繁な顧客接触、継続的なコミュニケーション、レトロスペクティブを自動化。
