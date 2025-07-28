# 混合言語プロジェクト プラクティス

## プロジェクトタイプ
```yaml
type: mixed
structure: single-project-multi-language
management: unified-root
```

## 一般的な構成例
```yaml
common_patterns:
  - "Python + TypeScript (FastAPI + React)"
  - "Python + JavaScript (Django + Vue)"
  - "Rust + TypeScript (Tauri + React)"
  - "Go + TypeScript (API + Frontend)"
  - "Python + Go (ML + Backend)"
```

## 推奨ディレクトリ構造
```
project/
├── backend/              # バックエンド言語
│   ├── pyproject.toml   # Python の場合
│   ├── main.py
│   └── tests/
├── frontend/             # フロントエンド言語
│   ├── package.json     # TypeScript/JavaScript の場合
│   ├── src/
│   └── tests/
├── shared/               # 共有リソース
│   ├── types/           # 型定義
│   ├── schemas/         # APIスキーマ
│   └── docs/
├── scripts/              # ビルド・デプロイスクリプト
├── docker-compose.yml    # 開発環境
├── Makefile             # 統合タスク
└── README.md
```

## 統合コマンド（Makefile例）
```makefile
.PHONY: install test lint build dev clean

# 全言語の依存関係インストール
install:
	cd backend && uv install
	cd frontend && pnpm install

# 全言語のテスト実行
test:
	cd backend && uv run pytest
	cd frontend && pnpm test

# 全言語のリント実行
lint:
	cd backend && uv run ruff check
	cd frontend && pnpm lint

# 型チェック（該当言語のみ）
typecheck:
	cd backend && uv run mypy .
	cd frontend && pnpm typecheck

# 開発サーバー起動（並列）
dev:
	docker-compose up -d || \
	(cd backend && uv run uvicorn main:app --reload --port 8000 &) && \
	(cd frontend && pnpm dev --port 3000 &)

# ビルド
build:
	cd backend && uv build
	cd frontend && pnpm build

# クリーンアップ
clean:
	cd backend && rm -rf dist/ .pytest_cache/ __pycache__/
	cd frontend && rm -rf dist/ node_modules/.cache/
```

## 言語別設定

### Python (Backend)
```yaml
directory: ./backend
package_manager: uv
test_framework: pytest
lint: ruff
type_check: mypy
config_files:
  - pyproject.toml
  - .python-version
```

### TypeScript/JavaScript (Frontend)
```yaml
directory: ./frontend
package_manager: pnpm
bundler: vite
test_framework: vitest
lint: eslint
type_check: tsc
config_files:
  - package.json
  - tsconfig.json
  - vite.config.ts
```

## 実行コマンドパターン
```bash
# 言語別実行（プライマリ言語を自動選択）
test: "cd backend && uv run pytest"
lint: "cd backend && uv run ruff check"
build: "make build"
dev: "make dev"

# 複合コマンド
test_all: "make test"
lint_all: "make lint"
typecheck_all: "make typecheck"
```

## Git 管理
```gitignore
# Python
backend/__pycache__/
backend/.venv/
backend/dist/
backend/.pytest_cache/
backend/.coverage

# JavaScript/TypeScript
frontend/node_modules/
frontend/dist/
frontend/.next/
frontend/coverage/
frontend/.turbo/

# 共通
.env
.env.local
*.log
.DS_Store
```

## プライマリ言語の決定
```yaml
priority_order:
  1. python      # ML/Data系で多用
  2. javascript  # Web系で多用
  3. rust        # システム系
  4. go          # インフラ系
  5. default
```

## 開発フロー
1. **初期化**: 各言語ディレクトリで個別にセットアップ
2. **開発**: Make/スクリプトで統合コマンド実行
3. **テスト**: 各言語のテストを統合実行
4. **CI/CD**: 変更検出で必要な言語のみビルド

## ベストプラクティス
- **統合Makefile**: 全言語のタスクを統一インターフェースで管理
- **Docker Compose**: 開発環境の統合管理
- **共有スキーマ**: API仕様やデータ型を共有ディレクトリで管理
- **段階的実行**: 言語間の依存関係を考慮した実行順序
- **独立デプロイ**: 各言語コンポーネントは独立してデプロイ可能に