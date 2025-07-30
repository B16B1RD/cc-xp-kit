---
description: "要望からユーザーストーリーを作成し、受け入れ基準を設定。プロダクトオーナーの視点で価値を定義します。"
argument-hint: "作成したいストーリーの説明（例: ログイン機能）"
allowed-tools: ["Write", "Read", "LS"]
---

# ユーザーストーリーの作成

要望: $ARGUMENTS

## 実行内容

### 1. 本質分析（5つのなぜ）

要望の背景にある本質的なニーズを探ります。

### 2. プロジェクトタイプ判定と技術スタック選択

**段階的に考えます：**

まず現在年を確認します：`date +%Y` で2025年であることを確認。

要求内容から最適なプロジェクトタイプを判定：

- **Web アプリケーション**: ウェブ、ブラウザ、UI、ゲーム、HTML関連
  - 技術スタック: Vite + Vitest + TypeScript + Canvas/WebGL
  - 環境特徴: HTMLファイル単体実行可能、モダンなビルドツール

- **API サーバー**: API、サーバー、データベース、認証、バックエンド関連  
  - 技術スタック: Express.js + Jest/Vitest + OpenAPI
  - 環境特徴: RESTful設計、セキュリティ重視

- **CLI ツール**: コマンド、ツール、スクリプト、自動化関連
  - 技術スタック: Node.js + Commander.js + テストフレームワーク
  - 環境特徴: クロスプラットフォーム対応、実行可能ファイル

判定結果と技術スタック情報を `.claude/agile-artifacts/project-config.json` に保存：

```json
{
  "project_type": "web-app",
  "tech_stack": {
    "build_tool": "vite",
    "test_framework": "vitest", 
    "language": "typescript",
    "additional_tools": ["canvas", "eslint", "prettier"]
  },
  "requirements": {
    "deployment": "single-html-file",
    "target": "modern-browsers"
  }
}
```

### 3. 最新情報検索（2025年ベース）

判定されたプロジェクトタイプに応じて、現在年（2025年）の最新仕様・ベストプラクティスを検索：

- Web アプリケーション: 公式仕様やモダンなフレームワーク情報
- API サーバー: 最新のセキュリティガイドラインやAPI設計パターン  
- CLI ツール: 最新のNode.jsベストプラクティスや配信方法

### 4. ストーリー分割

以下の 3 つのリリースに分けて、段階的に価値を提供：

- **Release 0**: 最初の 30 分で見えるもの（2-3 ストーリー）
- **Release 1**: 基本的な価値（3-4 ストーリー）  
- **Release 2**: 継続的な価値（3-4 ストーリー）

### 3. ストーリー形式

```text
Story X.Y: [簡潔なタイトル]
As a [役割]
I want [機能]
So that [価値]

見積もり: XX分
受け入れ基準:
- [ ] 具体的で検証可能な条件1
- [ ] 具体的で検証可能な条件2
- [ ] 具体的で検証可能な条件3

確認履歴:
- [ ] 実装時の動作確認
- [ ] 統合時の確認
```

### 5. ファイル作成

以下の2つのファイルを作成：

**A. プロジェクト設定**: `.claude/agile-artifacts/project-config.json`
- プロジェクトタイプ判定結果
- 技術スタック情報
- 要件特性（deployment方法等）

**B. ユーザーストーリー**: `.claude/agile-artifacts/stories/project-stories.md`
- 本質分析の結果
- ペルソナと成功指標
- リリース計画（プロジェクトタイプ最適化済み）
- 各ストーリーの詳細
- プロジェクトタイプ別の確認方法

### 6. コミット

```bash
git add .claude/agile-artifacts/
git commit -m "[BEHAVIOR] Create user stories with project type analysis"
```

## 原則

- **YAGNI**: 今必要ない機能は含めない
- **検証可能**: 曖昧な基準を避ける
- **段階的**: 小さく始めて大きく育てる

## 完了後

```text
📝 ストーリーとプロジェクト設定を作成しました！

🎯 プロジェクト判定: [Web App/API/CLI]
🛠️ 技術スタック: [選択された技術群]
📊 ストーリー総数: X個、推定: Y時間

次: /tdd:init (判定結果ベースでモダン環境構築)
```
