# Changelog

All notable changes to cc-tdd-kit will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- スラッシュコマンド完全仕様書 (`docs/slash-command-spec.md`)
- ベストプラクティス集 (`docs/best-practices.md`)
- 高度なコマンド使用例 (`examples/advanced-commands/`)
  - プロジェクト健康診断コマンド (`health-check.md`)
  - インテリジェント Git コミットコマンド (`smart-commit.md`)
  - プロジェクトコンテキスト収集コマンド (`context-gather.md`)
- すべてのスラッシュコマンドに YAML frontmatter 追加
- 開発ブランチ運用ルールの明文化
- リリース管理とバージョン管理ルールの策定

### Changed

- `/tdd:status` コマンドに動的コンテンツ機能を追加（Git 状況のリアルタイム表示）
- 全スラッシュコマンドでセキュリティ強化（必要最小限の`allowed-tools`指定）

### Technical Details

- YAML frontmatter による `allowed-tools`, `description`, `argument-hint` の明示
- 動的コンテンツ機能: `$ARGUMENTS`, `!`記法, `@`記法の活用
- Claude Code 公式仕様への完全準拠

## [0.1.0] - 2025-07-25

### Features

- 初回リリース
- Kent Beck 流 TDD の完全サポート
- `/tdd-quick` コマンドによるクイックスタート機能
- 7 つの TDD コマンドのサポート
  - init: 環境初期化
  - story: ユーザーストーリー作成
  - plan: イテレーション計画
  - run: TDD 実行
  - status: 進捗確認
  - review: レビューと改善
- イテレーション単位での自動実行機能
- プロジェクトタイプ（Web/CLI/API）の自動判定
- 必須ゲートによる品質保証
- フィードバック駆動の継続的改善
- タイムアウト対策を含む堅牢な実行環境
- ユーザー用/プロジェクト用の選択可能なインストール
- 日本語対応（メッセージ、ドキュメント）

### Technical Implementation

- Red→Green→Refactor サイクルの厳密な実施
- Fake It 戦略（60%以上）の推奨
- Tidy First 原則（構造と振る舞いの分離）
- Git 統合（TDD/STRUCT/FEAT 等のコミットタグ）
- Playwright MCP との連携（Web 確認）

[Unreleased]: https://github.com/B16B1RD/cc-tdd-kit/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/B16B1RD/cc-tdd-kit/releases/tag/v0.1.0
