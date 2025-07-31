---
description: "TDD開発の統合エントリーポイント - 要望からストーリー作成、環境構築まで一気通貫実行"
argument-hint: "作りたいものを説明してください（例: テトリスゲーム）"
allowed-tools: ["Write", "Read", "LS", "WebSearch", "Bash"]
---

# TDD開発スタート

要望: $ARGUMENTS

## 指示

以下を順次実行してください：

## Phase A: ユーザーストーリー作成

### 1. 要望を分析
**要望を分析**してプロジェクトタイプを判定してください（web-app/api-server/cli-tool）。

### 2. 技術スタックを選択
**技術スタックを選択**してください。重要な制約：
- **JavaScriptプロジェクト**: bunまたはpnpmを使用してください。**npmは避けてください**。
- **Pythonプロジェクト**: uvまたはpoetryを使用してください。**pipは避けてください**。
- **その他の言語**: 最新のモダンなツールを優先してください。

### 3. プロジェクト設定を保存
**`.claude/agile-artifacts/project-config.json`** を作成して選択した技術スタックを記録してください。

### 4. ユーザーストーリーを作成
**ユーザーストーリー**を3つのリリースに分けて作成してください：
- Release 0: 最初の30分で見えるもの（2-3ストーリー）
- Release 1: 基本的な価値（3-4ストーリー）
- Release 2: 継続的な価値（3-4ストーリー）

### 5. ストーリーを保存
**`.claude/agile-artifacts/stories/project-stories.md`** にストーリーを保存してください。

## Phase B: TDD開発環境構築

### 6. 必要なディレクトリを作成
以下のディレクトリ構造を作成してください：
```bash
mkdir -p .claude/agile-artifacts/{stories,iterations,reviews,tdd-logs}
```

### 7. 開発環境の構築
プロジェクトの言語に応じて環境を構築してください：

**JavaScript/TypeScript**:
- **bunまたはpnpmを使用**してください（npmは避ける）
- package.jsonがなければ作成
- 必要な開発依存関係をインストール（テストフレームワーク、リンター等）

**Python**:
- **uvまたはpoetryを使用**してください（pipは避ける）
- pyproject.tomlがなければ作成
- 仮想環境と必要な依存関係をセットアップ

**その他の言語**:
- その言語のモダンなツールを使用してください

### 8. Git初期化
プロジェクトがGitリポジトリでない場合は初期化してください：
```bash
git init
```

### 9. .gitignoreファイルの作成
言語に適した.gitignoreファイルを作成してください。
重要：`.claude/agile-artifacts/tdd-logs/` は個人用なので除外してください。

### 10. CLAUDE.mdの更新
選択した技術スタックに基づいてCLAUDE.mdを更新してください。
既存のCLAUDE.mdがある場合は、TDD関連部分のみ更新してください。

### 11. 初期コミット
環境セットアップ完了後にコミットしてください（コミット規則は @src/shared/commit-rules.md を参照）：
```bash
git add .
git commit -m "[INIT] TDD project setup with user stories and environment"
```

## 原則

- **YAGNI**: 今必要ない機能は含めない
- **検証可能**: 曖昧な基準を避ける（受け入れ基準は @~/.claude/commands/shared/mandatory-gates.md を参照）
- **段階的**: 小さく始めて大きく育てる
- **モダンツール優先**: npm/pipは避け、高速なツールを使用
- **必要最小限**: 今必要なもののみセットアップ
- **Git管理**: チーム共有価値の高い情報は管理対象に

## 完了後

```text
✅ プロジェクト準備が完了しました！

🎯 プロジェクト: [判定されたタイプ]
🛠️ 技術スタック: [選択された技術群]
📊 ストーリー総数: X個（3段階リリース）
🏗️ 環境構築: 完了（Git初期化済み）

📁 作成内容:
- ユーザーストーリーとプロジェクト設定
- TDD用ディレクトリ構造
- 開発環境設定ファイル
- Git設定と.gitignoreファイル

🚀 開発開始: 最初のイテレーションを計画してください
/tdd:plan 1
```