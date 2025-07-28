# Changelog

All notable changes to cc-tdd-kit will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.11] - 2025-07-29

### Added

- `/tdd-quick` に「機能改善」選択肢を追加（4 つの継続オプション）
- 機能改善を選択した際の詳細な改善点収集システム（5 つの質問）
- 一時ファイル用ディレクトリ (`tmp/`) の作成と lint 除外設定
- Kent Beck 流の完全なフィードバックループの実装

### Enhanced

- `/tdd:run` コマンドのフィードバック収集機能を大幅強化
  - 動作確認の具体的案内（プロジェクトタイプ別手順）
  - 実際の動作確認を前提とした 3 つの質問形式
  - 回答例付きでユーザー理解を促進
  - フィードバック未収集時の厳格な警告とガイダンス
- TDD 原則の厳格な遵守を強制
  - 段階的実行の強制（一気に完成版作成を禁止）
  - Fake It 戦略の優先（60%以上）
  - 各 TDD サイクル後の必須チェックポイント
- `/tdd-quick` の継続サイクル改善
  - 継続開発/機能追加/機能改善/完了の 4 つの選択肢
  - 改善点を新しいストーリーに自動変換する仕組み

### Fixed

- 受け入れ基準更新の具体的指示を追加
- ストーリーファイルとイテレーションファイルの更新問題を解決
- フィードバック収集の完全な必須化

### Technical Details

- markdownlint と textlint から `tmp/` ディレクトリを除外
- pre-commit フックの調整
- Kent Beck TDD 原則に基づく厳格なワークフロー実装
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
