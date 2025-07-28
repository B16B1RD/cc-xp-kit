# CLAUDE.md

This file provides guidance to Claude Code when working with code
in this repository.

## プロジェクト概要

cc-tdd-kit は Claude Code 用の TDD 開発キットです。Kent Beck 流の
TDD 原則に基づいて、Red → Green → Refactor サイクルを厳格に実施し、
小さく始めて大きく育てる開発を支援します。

## 基本コマンド

### テスト実行

```bash
bash tests/run-tests.sh
```text

### インストールテスト

```bash
# ユーザー用インストール (1を選択)
bash install.sh

# プロジェクト用インストール (2を選択)
bash install.sh

# アンインストール
bash install.sh uninstall
```text

### コード品質チェック（ShellCheck利用可能時）

```bash
shellcheck install.sh
```text

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

### Markdown品質管理

**すべてのMarkdownファイルは厳格なlintチェックを通過する必要があります：**

#### 必須ツール

- **markdownlint**: Markdown構文とスタイルチェック
- **textlint**: 日本語テキスト品質チェック

#### セットアップ

```bash
# 初回セットアップ
./scripts/setup-lint.sh

# 手動インストール
npm install
```text

#### 利用可能なコマンド

```bash
npm run lint        # 全lintチェック
npm run lint:md     # markdownlintのみ
npm run lint:text   # textlintのみ  
npm run lint:fix    # 自動修正
```text

#### コミット時の自動チェック

- pre-commitフックで自動実行
- **エラーがある場合はコミット拒否**
- 修正後に再度コミット

#### lint設定

- `.markdownlint.json`: 厳格な設定（100文字制限等）
- `.textlintrc.json`: 日本語品質ルール

## 開発ブランチ運用

このプロジェクトでは常に開発ブランチで作業を行います：

```bash
# 新機能開発
git checkout -b feature/feature-name

# バグ修正
git checkout -b fix/bug-description

# ドキュメント更新
git checkout -b docs/update-description
```text

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
```text

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

1. **CHANGELOG.md の更新**
   - `[Unreleased]` セクションの内容を新バージョンに移動
   - 日付とバージョン番号を追加
   - 新しい `[Unreleased]` セクションを作成

1. **Git タグの作成**

   ```bash
   git tag -a vX.Y.Z -m "Release version X.Y.Z"
   git push origin vX.Y.Z
   ```

1. **リリース後の確認**
   - GitHub Releases でリリースノート作成
   - インストールスクリプトが新バージョンを正しく取得することを確認

### リリーススクリプト

手動作業を減らすため、`scripts/release.sh` を使用します。

```bash
./scripts/release.sh 0.2.0
```text

このスクリプトは以下を自動化：

- バージョン番号の更新
- CHANGELOG.md 編集のガイド
- Git コミットとタグ作成
- 手動作業の指示表示

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
```text
