---
description: "プロジェクト設定を読み込んで、適切なモダンTDD開発環境をセットアップします。"
allowed-tools: ["Bash", "Write", "Read", "LS"]
---

# TDD開発環境の初期化

**段階的に考えます：**

## 実行内容

### 1. プロジェクト設定の読み込み

最初に `/tdd:story` で作成されたプロジェクト設定を読み込みます：

`.claude/agile-artifacts/project-config.json` を読み取り、以下の情報を取得：

- `project_type`: web-app/api-server/cli-tool
- `selected_stack.package_manager`: bun/pnpm/uv/poetry（**デフォルト：最速ツール**）
- `selected_stack.build_tool`: esbuild/vite/rye/hatch
- `selected_stack.test_framework`: vitest/jest/pytest
- `selected_stack.language`: javascript/python/rust/go

**⚠️ フォールバック処理**：
- project-config.jsonが存在しない場合：JavaScript + bun をデフォルト使用
- package_managerが未指定の場合：言語別デフォルト（JS→bun, Python→uv）を適用
- npm/pipは明示的指定がない限り使用しない

### 2. プロジェクトディレクトリ作成

必要なディレクトリ構造を作成：

```bash
mkdir -p .claude/agile-artifacts/{stories,iterations,reviews,tdd-logs}
```

### 3. 動的技術スタック環境構築

**段階的に考えます：**

project-config.jsonから選択された技術スタックに基づいて、適切な開発環境を構築：

#### JavaScript/TypeScript プロジェクト

**パッケージマネージャー選択ロジック:**

1. **設定ファイル読み込み**: `selected_stack.package_manager` を確認
2. **デフォルト適用**: 未指定または不正値の場合は `bun` を使用
3. **環境構築実行**: 選択されたツールで初期化

**パッケージマネージャー別対応（優先順位順）:**

- **bun** ⚡: `bun init` → Bunfile設定 → 依存関係インストール（**デフォルト**）
- **pnpm** 🚀: `pnpm init` → `pnpm-workspace.yaml` → 依存関係インストール（高速・効率的）
- **npm** 📦: `npm init` → `package.json` → 依存関係インストール（**明示的選択時のみ**）

**プロジェクトタイプ別設定:**

- Web App: ビルドツール(Vite/Turbo) + テスト(Vitest/Jest) + 型(TypeScript)
- API Server: フレームワーク(Express/Fastify) + テスト + OpenAPI
- CLI Tool: CLI frameworks + テスト + 実行可能ファイル設定

#### Python プロジェクト

**パッケージマネージャー選択ロジック:**

1. **設定ファイル読み込み**: `selected_stack.package_manager` を確認
2. **デフォルト適用**: 未指定または不正値の場合は `uv` を使用
3. **環境構築実行**: 選択されたツールで初期化

**パッケージマネージャー別対応（優先順位順）:**

- **uv** ⚡: `uv init` → `pyproject.toml` → 仮想環境 + 依存関係（**デフォルト**）
- **poetry** 🚀: `poetry init` → `pyproject.toml` → 仮想環境構築（モダンな依存関係管理）
- **pip** 📦: `pip` → `requirements.txt` → venv設定（**明示的選択時のみ**）

**プロジェクトタイプ別設定:**

- Web App: FastAPI/Flask + pytest + ruff/black
- Data Analysis: Jupyter + pandas/numpy + pytest
- CLI Tool: Click/Typer + pytest + パッケージング

#### Rust プロジェクト

**Cargo標準構成:**

- `cargo init` → `Cargo.toml` → 基本プロジェクト構造
- プロジェクトタイプ別依存関係追加
- 標準テスト環境設定

#### Go プロジェクト  

**Go modules標準構成:**

- `go mod init` → `go.mod` → 基本構造
- プロジェクトタイプ別パッケージ追加
- 標準テスト環境設定

#### その他言語対応

**設定ファイルベース:**

- プロジェクト設定から言語を判定
- 該当言語の標準的なプロジェクト初期化
- 言語固有のベストプラクティス適用

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

### 5. Git初期化と言語別設定

プロジェクトが未初期化の場合：

```bash
git init
```

**言語・技術スタック別 `.gitignore` 作成:**

プロジェクト設定から判定した言語に応じて適切な.gitignoreを生成：

- **JavaScript/TypeScript**: node_modules, dist, .env, coverage, pnpm-lock.yaml等
- **Python**: \_\_pycache\_\_, .venv, \*.pyc, .pytest_cache, .coverage等
- **Rust**: target/, *.rs.bk, Cargo.lock(ライブラリでは除外)等
- **Go**: bin/, *.exe, vendor/, go.sum(場合による)等
- **Java**: build/, *.class, .gradle/, target/等
- **C#**: bin/, obj/, *.user, packages/等

**共通パターン:**

- OS生成ファイル (.DS_Store, Thumbs.db)
- IDE設定 (.vscode/, .idea/)
- TDD個人ログ (.claude/agile-artifacts/tdd-logs/)
- 環境設定 (.env, .env.local)

### 6. 言語・技術スタック別CLAUDE.md生成

選択された技術スタックに基づいたCLAUDE.mdを作成：

**言語別TDD戦略とコマンド:**

- **JavaScript/TypeScript**: 選択されたパッケージマネージャー(bun/pnpm/npm)のコマンド
- **Python**: 選択されたツール(uv/poetry/pip)のテスト・実行コマンド
- **Rust**: cargo test, cargo build等の標準コマンド
- **Go**: go test, go build等の標準コマンド

**含む内容:**

- プロジェクトタイプ別のTDD戦略
- 選択された技術スタック詳細
- 言語固有のテスト実行コマンド
- ビルド/デプロイメント手順
- 言語別品質基準とゲート

**既存ファイルの処理:**
既存のCLAUDE.mdがある場合は、TDD関連部分のみ更新して既存設定を保持。

### 7. セッション管理ファイル

TDD実行追跡用のセッション管理ファイルを作成：

```json
{
  "initialized": "{現在年}-XX-XX...",
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

- **最新技術**: 現在年の最新ベストプラクティスを適用
- **モダンツール**: 高速で開発者体験の良いツールを選択
- **Kent Beck TDD**: 厳格なRed→Green→Refactorサイクル
- **プロジェクト最適化**: 各プロジェクトタイプに最適化された設定
