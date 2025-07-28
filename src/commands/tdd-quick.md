---
allowed-tools:
  - Task
  - TodoWrite
description: TDD開発を即座に開始する統合コマンド
argument-hint: "作りたいものを3行で説明"
---

# 🚀 TDDクイックスタート

**要望**: $ARGUMENTS

このコマンドは以下の4つのTDDサブコマンドを自動実行します：

1. 🔧 `/tdd:init` - 環境初期化
2. 📝 `/tdd:story` - ストーリー作成  
3. 📋 `/tdd:plan 1` - イテレーション計画
4. 🚀 最終的に `/tdd:run` 実行の準備完了

---

## 自動実行開始

以下の手順でTDD開発環境を自動セットアップします：

### ステップ1: 環境初期化

TDD開発環境を初期化します。Git設定、ディレクトリ作成、CLAUDE.md作成を行います。

### ステップ2: ユーザーストーリー作成

ユーザーの要望「$ARGUMENTS」を分析してストーリーファイルを作成します。

### ステップ3: イテレーション計画策定

90分のTDD実装計画を作成します。Kent Beck流のFake It戦略とTidy First原則に基づきます。

### ステップ4: 実行準備完了

## 🎯 実行指示

上記のセットアップを実行するため、以下のタスクを順次実行してください：

1. **環境初期化タスク**: `/tdd:init` コマンドを実行
2. **ストーリー作成タスク**: `/tdd:story "$ARGUMENTS"` コマンドを実行  
3. **計画策定タスク**: `/tdd:plan 1` コマンドを実行

## 完了後の次ステップ

### 🎉 準備完了

TDD開発の準備が整いました！以下のコマンドで実際のTDD開発を開始してください：

```text
/tdd:run
```

または段階的に進める場合：

```text
/tdd:run --step-by-step
```

### 作成されるファイル

- `.claude/agile-artifacts/stories/user-story-001.md` - ユーザーストーリー
- `.claude/agile-artifacts/iterations/iteration-001.md` - イテレーション計画  
- `CLAUDE.md` - プロジェクト設定（必要に応じて）

---

**✨ TDDクイックスタートが完了します。上記の手順に従ってTDD開発を開始してください。**
