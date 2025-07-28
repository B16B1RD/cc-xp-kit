# Changelog

All notable changes to cc-tdd-kit will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### 今後の予定

- 今後追加される機能をここに記載

## [0.2.1] - 2025-01-28

### Fixed

- 🔧 **Markdown lint errors**
  - MD010: Makefile のハードタブをスペースに変換
  - GitHub Actions CI でのマークダウンリントエラーを解消

## [0.2.0] - 2025-01-15

### Added

- 🌍 **言語別モダンプラクティス対応**
  - Python (uv, src/layout, pytest)
  - JavaScript/TypeScript (pnpm, ESM, Vite)
  - Rust (cargo 標準, clippy)
  - Go (modules, 標準プロジェクト構造)
  - 汎用/デフォルト設定

- 🏗️ **プロジェクトタイプ自動検出**
  - 単一言語プロジェクト
  - **混合言語プロジェクト** (例: Python + TypeScript)
  - モノレポプロジェクト
  - プライマリ言語の自動選択

- 🔧 **コンテキスト認識型コマンド実行**
  - 現在のディレクトリに応じたコンテキスト別コマンド実行
  - 言語別テスト・リント・ビルドコマンド
  - プラクティスファイルからの設定読み込み

- 📁 **階層的設定システム**
  - グローバル設定 (言語別プラクティス)
  - プロジェクトレベル設定 (.claude/language-practice.md)
  - サブプロジェクト設定 (モノレポ対応)

- **新サブコマンド**
  - `/tdd:detect` - プロジェクト構造の詳細分析
  - 混合プロジェクトとモノレポの詳細表示

### Changed

- **init コマンドの大幅強化**
  - 言語自動検出と最適化された初期設定
  - 言語別 .gitignore 生成
  - プロジェクトタイプ別 CLAUDE.md 生成

- **run コマンドの進化**
  - 言語別コマンドの自動選択
  - プラクティスファイルベースの実行
  - 必須ゲートでのリント自動実行

- **project-verification の言語対応**
  - 各言語の環境確認
  - 言語別開発サーバー起動
  - 混合プロジェクトの統合検証

### Enhanced

- 📖 **agile-artifacts のGit管理最適化**
  - stories, iterations, reviews は Git 管理対象
  - tdd-logs のみ個人用として除外
  - チーム開発とプライバシーの両立

## [0.1.0] - 2025-07-25

### Added

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

### Technical Details

- Red→Green→Refactor サイクルの厳密な実施
- Fake It 戦略（60%以上）の推奨
- Tidy First 原則（構造と振る舞いの分離）
- Git 統合（TDD/STRUCT/FEAT 等のコミットタグ）
- Playwright MCP との連携（Web 確認）

[Unreleased]: https://github.com/B16B1RD/cc-tdd-kit/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/B16B1RD/cc-tdd-kit/releases/tag/v0.1.0
