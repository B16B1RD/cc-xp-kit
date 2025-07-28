---
allowed-tools:
  - Bash(find . -type f -name "*.json" -o -name "*.md" -o -name "*.yml" -o -name "*.yaml" | grep -E "(package|README|config)" | head -20)
  - Bash(ls -la)
  - Bash(git remote -v)
  - Bash(git branch -a)
  - Bash(find . -type f -name "*.js" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" | wc -l)
  - Bash(find . -type d -name node_modules -prune -o -type d -print | head -20)
  - Read(README.md)
  - Read(package.json)
  - Read(CLAUDE.md)
  - LS
description: プロジェクトの全体像を素早く把握
argument-hint: "[focus-area]"
---

# 🔍 プロジェクトコンテキスト収集

フォーカスエリア: $ARGUMENTS

## 📁 プロジェクト構造

### ルートディレクトリ

!`ls -la`

### 主要なディレクトリ構造

```text
!`find . -type d -name node_modules -prune -o -type d -print | head -20`
```text

### 設定ファイル

!`find . -type f -name "*.json" -o -name "*.md" -o -name "*.yml" \|
  grep -E "(package|README|config)" | head -20`

## 📊 コード統計

- JavaScript/TypeScriptファイル数:
  !`find . -type f -name "*.js" -o -name "*.ts" -o -name "*.jsx" \|
    wc -l`

## 📚 ドキュメント

### README.md

@README.md

### CLAUDE.md（存在する場合）

@CLAUDE.md

### package.json

@package.json

## 🌐 Git情報

### リモートリポジトリ

!`git remote -v`

### ブランチ一覧

!`git branch -a`

## 🎯 コンテキスト分析

収集した情報から以下を判断してください:

1. **プロジェクトタイプ**:
   - フレームワーク（React, Vue, Express等）
   - 言語（JavaScript, TypeScript）
   - ビルドツール（Webpack, Vite等）

2. **開発環境**:
   - 依存関係
   - スクリプト
   - 設定

3. **プロジェクト規模**:
   - ファイル数
   - ディレクトリ構造の複雑さ

4. **重要な注意点**:
   - 特殊な設定
   - カスタムスクリプト
   - 開発ガイドライン

## 💡 次のステップ

このコンテキストを基に:

- 適切な開発アプローチを提案
- 必要なツールやコマンドを特定
- 潜在的な問題点を指摘

---

**注**: 特定の領域に焦点を当てたい場合は、引数を指定してください。
例: `/context-gather frontend`, `/context-gather testing`
