---
description: "TDD開発環境の初期化とプロジェクト設定"
argument-hint: "[project-type] (例: web-app, cli-tool, api-server)"
allowed-tools: ["Bash", "Write", "Read", "LS"]
---

# TDD環境初期化

プロジェクトタイプ: $ARGUMENTS

## 指示

以下の手順でTDD開発環境を初期化してください：

### 1. プロジェクトタイプの判定

引数が指定されていない場合、現在のディレクトリから判定してください：
- `package.json` 存在 → web-app
- `requirements.txt` 存在 → cli-tool (Python)
- `Cargo.toml` 存在 → cli-tool (Rust)
- `go.mod` 存在 → api-server (Go)

### 2. アジャイル管理ディレクトリの作成

```bash
mkdir -p .claude/agile-artifacts/{stories,iterations,reviews,tdd-logs}
```

### 3. .gitignore の設定

個人用ログを除外し、チーム共有価値は含める：

```text
# TDD個人ログ（Git管理対象外）
.claude/agile-artifacts/tdd-logs/

# 一般的な除外項目
node_modules/
__pycache__/
.env
.DS_Store
```

### 4. Git リポジトリの初期化（必要な場合）

```bash
git init
git add .gitignore
git commit -m "[INIT] TDD environment setup with agile structure"
```

### 5. 基本テスト環境の確認

プロジェクトタイプに応じてテストコマンドを確認：

**JavaScript/TypeScript**:
```bash
# パッケージマネージャーの確認とテストスクリプト確認
if command -v bun &> /dev/null; then
  echo "推奨: bun を使用"
elif command -v pnpm &> /dev/null; then
  echo "推奨: pnpm を使用"
else
  echo "推奨: bun または pnpm のインストールを検討"
fi
```

**Python**:
```bash
# テストフレームワークの確認
python -c "import pytest" 2>/dev/null && echo "pytest 利用可能" || echo "pytest インストール推奨"
```

### 6. 初期化完了メッセージ

```text
✅ TDD環境初期化完了！

📁 作成された構造:
├── .claude/agile-artifacts/
│   ├── stories/          # ユーザーストーリー（Git管理）
│   ├── iterations/       # イテレーション計画（Git管理）
│   ├── reviews/          # レビューログ（Git管理）
│   └── tdd-logs/         # 個人実行ログ（Git除外）

🚀 次のステップ:
1. プロジェクト要望の明確化
2. MVPファーストストーリー作成

以下のコマンドでストーリー作成開始：
/tdd:story [作りたいもの]

例:
/tdd:story テトリスゲーム
/tdd:story 計算機アプリ
/tdd:story APIサーバー
```

## 完了条件

- ✅ .claude/agile-artifacts/ 構造が作成されている
- ✅ .gitignore が適切に設定されている  
- ✅ Git リポジトリが初期化されている（必要な場合）
- ✅ テスト環境の状態が確認されている
- ✅ 次のステップが明確に示されている