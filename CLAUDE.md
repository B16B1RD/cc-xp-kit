# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## プロジェクト概要

cc-tdd-kit は Claude Code 用のTDD開発キットです。Kent Beck 流のTDD原則に基づいて、Red → Green → Refactor サイクルを厳格に実施し、小さく始めて大きく育てる開発を支援します。

## 基本コマンド

### テスト実行
```bash
bash tests/run-tests.sh
```

### インストールテスト
```bash
# ユーザー用インストール (1を選択)
bash install.sh

# プロジェクト用インストール (2を選択)
bash install.sh

# アンインストール
bash install.sh uninstall
```

### コード品質チェック（ShellCheck利用可能時）
```bash
shellcheck install.sh
```

## アーキテクチャ

### 主要ディレクトリ構造
- `src/commands/` - メインコマンド（`/tdd`, `/tdd-quick`）
- `src/subcommands/tdd/` - TDDサブコマンド（`init`, `story`, `plan`, `run`, `status`, `review`）
- `src/shared/` - 共通リソース（Kent Beck原則、必須ゲート、プロジェクト検証など）
- `tests/` - 自動テストスイート
- `examples/` - 使用例（api-server, cli-tool, web-app）

### 設計原則
- **Tidy First原則**: 構造的変更（[STRUCTURE]）と振る舞いの変更（[BEHAVIOR]）を厳格に分離
- **必須ゲート**: 各ステップで動作確認、受け入れ基準チェック、Git コミットを強制
- **プログレッシブ表示**: 必要な情報を必要なときに表示（`-v` オプションで詳細表示）

### TDD ワークフロー
1. `/tdd:init` - 環境初期化とGit初期化
2. `/tdd:story` - ユーザーストーリー作成
3. `/tdd:plan` - 90分イテレーション計画
4. `/tdd:run` - TDD実行（連続実行 or ステップ実行）
5. `/tdd:status` - 進捗確認
6. `/tdd:review` - 品質分析とフィードバック

### インストールタイプ
- **ユーザー用**: `~/.claude/commands/` - 全プロジェクトで利用可能
- **プロジェクト用**: `.claude/commands/` - プロジェクト固有カスタマイズ可能

## データ管理

各プロジェクトに `.claude/agile-artifacts/` ディレクトリが作成され、以下を管理：
- `stories/` - ユーザーストーリー
- `iterations/` - イテレーション計画
- `reviews/` - レビューとフィードバック
- `tdd-logs/` - 実行ログ

## Kent Beck TDD 戦略

- **Fake It戦略**（60%以上で使用）: 最初はハードコーディングで実装
- **Triangulation**: 2つ目のテストで一般化
- **Obvious Implementation**: 明白な場合のみ最初から正しい実装

## 品質管理

- 全テストスイートによる自動検証
- ShellCheck によるシェルスクリプト品質チェック
- インストール/アンインストール機能の統合テスト
- ファイル整合性チェック