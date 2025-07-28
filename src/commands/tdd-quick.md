---
allowed-tools:
  - Task
description: TDD開発を即座に開始する統合コマンド
argument-hint: "作りたいものを3行で説明"
---

# TDD クイックスタート

以下のカスタムスラッシュコマンドを順番に実行して、TDD開発を即座に開始します。

要望: $ARGUMENTS

## 実行するコマンド

1. `/tdd:init` - TDD環境の初期化
2. `/tdd:story $ARGUMENTS` - ユーザーストーリーの作成
3. `/tdd:plan 1` - 最初のイテレーション計画
4. `/tdd:run` - TDD実行の開始
