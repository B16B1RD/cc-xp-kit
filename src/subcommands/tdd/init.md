---
description: "プロジェクト設定を読み込んで、適切なモダンTDD開発環境をセットアップします。"
allowed-tools: ["Bash", "Write", "Read", "LS"]
---

# TDD開発環境の初期化

**段階的に考えます：**

まず現在年を取得します：`date +%Y` で2025年であることを確認。

## 実行内容

### 1. プロジェクト設定の読み込み

最初に `/tdd:story` で作成されたプロジェクト設定を読み込みます：

`.claude/agile-artifacts/project-config.json` を読み取り、以下の情報を取得：
- `project_type`: web-app/api-server/cli-tool
- `tech_stack`: 使用技術スタック
- `requirements`: 特別な要件

### 2. プロジェクトディレクトリ作成

必要なディレクトリ構造を作成：

```bash
mkdir -p .claude/agile-artifacts/{stories,iterations,reviews,tdd-logs}
```

### 3. プロジェクトタイプ別のモダン環境構築

**段階的に考えます：**

判定されたプロジェクトタイプに応じて2025年最新のモダン開発環境を構築：

#### Web アプリケーション（Vite + Vitest）
- `package.json` 作成（Vite + Vitest + TypeScript + Canvas）
- `vite.config.js` 設定
- `index.html` テンプレート
- `src/` ディレクトリ構造
- `.gitignore` (Node.js用)

#### API サーバー（Express + Jest/Vitest）
- `package.json` 作成（Express + Jest/Vitest + OpenAPI）
- 基本API構造とルーティング
- テスト用設定ファイル
- `.gitignore` (Node.js用)

#### CLI ツール（Node.js + Commander）
- `package.json` 作成（Commander.js + テストフレームワーク）
- CLI エントリポイント
- コマンド構造の雛形
- `.gitignore` (Node.js用)

### 4. 技術スタック別セットアップファイル作成

プロジェクトタイプに応じた初期ファイルを生成：

**Web アプリケーション例：**
- `package.json` - Vite/Vitest/TypeScript設定
- `vite.config.js` - テスト設定含む
- `index.html` - 基本HTMLテンプレート
- `src/main.js` - エントリポイント
- `tests/` - テスト用ディレクトリ

**共通設定：**
- Kent Beck TDD 原則に基づくテスト設定
- モダンなlint/format設定（ESLint + Prettier）
- 必要な dev dependencies

### 5. Git初期化と設定

プロジェクトが未初期化の場合：

```bash
git init
```

適切な `.gitignore` を作成（プロジェクトタイプ別）：
- 共通パターン（OS, IDE, ログファイル）
- プロジェクト特有パターン（node_modules等）
- TDD個人ログの除外（`.claude/agile-artifacts/tdd-logs/`）

### 6. プロジェクト固有CLAUDE.md生成

プロジェクト設定に基づいたCLAUDE.mdを作成：

- プロジェクトタイプ別のTDD戦略
- 技術スタック情報
- テスト実行コマンド
- ビルド/デプロイメント手順
- 品質基準とゲート

既存のCLAUDE.mdがある場合は、TDD関連部分のみ更新して既存設定を保持。

### 7. セッション管理ファイル

TDD実行追跡用のセッション管理ファイルを作成：

```json
{
  "initialized": "2025-XX-XX...",
  "project_type": "判定結果",
  "tech_stack": "選択された技術群",
  "sessions": [],
  "iterations": {}
}
```

### 8. 初期コミット

環境セットアップ完了後にコミット：

```bash
git add .
git commit -m "[BEHAVIOR] Setup modern TDD environment for [プロジェクトタイプ]"
```

## 完了報告

セットアップ完了後、以下の情報を表示：

```text
✅ モダンTDD開発環境を構築しました！

🎯 プロジェクト: [判定されたタイプ]
🛠️ 技術スタック: [選択された技術群]  
📁 作成内容:
  - 開発環境設定ファイル
  - TDD用ディレクトリ構造
  - プロジェクト固有CLAUDE.md
  - Git設定とignoreファイル

🚀 次のステップ: /tdd:plan 1
```

## 原則

- **最新技術**: 2025年の最新ベストプラクティスを適用
- **モダンツール**: 高速で開発者体験の良いツールを選択
- **Kent Beck TDD**: 厳格なRed→Green→Refactorサイクル
- **プロジェクト最適化**: 各プロジェクトタイプに最適化された設定
