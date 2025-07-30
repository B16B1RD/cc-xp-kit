---
description: "プロジェクト設定を読み込んで、適切なモダンTDD開発環境をセットアップします。"
allowed-tools: ["Bash", "Write", "Read", "LS"]
---

# TDD開発環境の初期化

## 指示

以下を実行してください：

### 1. プロジェクト設定の確認
`.claude/agile-artifacts/project-config.json` が存在する場合は読み込んでください。
存在しない場合は、JavaScriptプロジェクトとしてbunを使用してください。

### 2. 必要なディレクトリを作成
以下のディレクトリ構造を作成してください：
```bash
mkdir -p .claude/agile-artifacts/{stories,iterations,reviews,tdd-logs}
```

### 3. 開発環境の構築
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

### 4. Git初期化
プロジェクトがGitリポジトリでない場合は初期化してください：
```bash
git init
```

### 5. .gitignoreファイルの作成
言語に適した.gitignoreファイルを作成してください。
重要：`.claude/agile-artifacts/tdd-logs/` は個人用なので除外してください。

### 6. 言語別CLAUDE.mdの更新
選択した技術スタックに基づいてCLAUDE.mdを更新してください。
既存のCLAUDE.mdがある場合は、TDD関連部分のみ更新してください。

### 7. 初期コミット
環境セットアップ完了後にコミットしてください：
```bash
git add .
git commit -m "[BEHAVIOR] Setup modern TDD environment"
```

## 完了後の報告

```text
✅ モダンTDD開発環境を構築しました！

🎯 プロジェクト: [判定されたタイプ]
🛠️ 技術スタック: [選択された技術群]  
📁 作成内容:
  - 開発環境設定ファイル
  - TDD用ディレクトリ構造
  - Git設定と.gitignoreファイル

🚀 次のステップ: /tdd:plan 1
```

## 原則

- **モダンツール優先**: npm/pipは避け、高速なツールを使用
- **必要最小限**: 今必要なもののみセットアップ
- **Git管理**: チーム共有価値の高い情報は管理対象に