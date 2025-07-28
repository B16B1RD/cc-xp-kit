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

## 開発ブランチ運用

このプロジェクトでは常に開発ブランチで作業を行います：

```bash
# 新機能開発
git checkout -b feature/feature-name

# バグ修正
git checkout -b fix/bug-description

# ドキュメント更新
git checkout -b docs/update-description
```

準備ができたら main ブランチにマージします。

## スラッシュコマンド仕様

### YAML Frontmatter
すべてのスラッシュコマンドに以下の frontmatter を含めます：

```yaml
---
allowed-tools: [必要最小限のツール]
description: コマンドの簡潔な説明
argument-hint: 期待される引数の形式
---
```

### 動的コンテンツ機能
- `$ARGUMENTS` - ユーザー入力を埋め込み
- `!`記法 - Bashコマンド実行結果を埋め込み（要 allowed-tools）
- `@`記法 - ファイル内容を参照

### ドキュメント
- `docs/slash-command-spec.md` - 完全な仕様書
- `docs/best-practices.md` - ベストプラクティス集
- `examples/advanced-commands/` - 高度な使用例

## リリース管理

### バージョン管理ルール
[Semantic Versioning](https://semver.org/spec/v2.0.0.html) に従います：

- **MAJOR.MINOR.PATCH** (例: 1.2.3)
- **MAJOR**: 破壊的変更
- **MINOR**: 後方互換性のある機能追加
- **PATCH**: 後方互換性のあるバグ修正

### リリース時の必須作業
新バージョンをリリースする際は以下を**必ず**実行：

1. **バージョン更新**
   ```bash
   # install.sh のバージョン更新
   sed -i 's/VERSION="[^"]*"/VERSION="X.Y.Z"/' install.sh
   ```

2. **CHANGELOG.md の更新**
   - `[Unreleased]` セクションの内容を新バージョンに移動
   - 日付とバージョン番号を追加
   - 新しい `[Unreleased]` セクションを作成

3. **Git タグの作成**
   ```bash
   git tag -a vX.Y.Z -m "Release version X.Y.Z"
   git push origin vX.Y.Z
   ```

4. **リリース後の確認**
   - GitHub Releases でリリースノート作成
   - インストールスクリプトが新バージョンを正しく取得することを確認

### 変更履歴の記録
開発中は常に `CHANGELOG.md` の `[Unreleased]` セクションを更新：

```markdown
## [Unreleased]

### Added
- 新機能の説明

### Changed  
- 変更された機能の説明

### Fixed
- 修正されたバグの説明

### Removed
- 削除された機能の説明
```
