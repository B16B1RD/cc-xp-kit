# Python モダンプラクティス

## パッケージ管理

```yaml
primary: uv          # 10-100倍高速な次世代パッケージマネージャー
fallback: pip        # uvが利用不可の場合
lockfile: uv.lock    # 依存関係のロックファイル
```

## プロジェクト構造

```text
project/
├── src/
│   └── project_name/    # パッケージ本体
│       ├── __init__.py
│       └── main.py
├── tests/               # テストコード
│   ├── __init__.py
│   └── test_*.py
├── docs/                # ドキュメント
├── scripts/             # ユーティリティスクリプト
├── pyproject.toml       # プロジェクト設定
├── uv.lock             # 依存関係ロック
└── .python-version     # Python バージョン指定
```

## テストフレームワーク

```yaml
primary: pytest
options: --cov=src --cov-report=term-missing
alternatives:
  - unittest
  - nose2
```

## 開発ツール

```yaml
linter: ruff          # 高速な Python リンター
formatter: ruff       # コードフォーマッター機能も内蔵
type_checker: mypy    # 静的型チェック
docstring: pydocstyle # docstring スタイルチェック
```

## 実行コマンド

```bash
# 環境セットアップ
init: "uv venv && uv pip install -e ."

# テスト実行
test: "uv run pytest"
test_watch: "uv run pytest-watch"
test_coverage: "uv run pytest --cov=src --cov-report=html"

# コード品質
lint: "uv run ruff check ."
format: "uv run ruff format ."
typecheck: "uv run mypy src"

# ビルド・実行
run: "uv run python -m project_name"
build: "uv build"

# 依存関係管理
add_dep: "uv add"
add_dev_dep: "uv add --dev"
update_deps: "uv lock --upgrade"
```

## Git 無視パターン

```gitignore
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
.uv/
.venv/
env/
venv/
ENV/

# テスト・カバレッジ
.coverage
.pytest_cache/
htmlcov/
.tox/
.nox/

# 型チェック
.mypy_cache/
.dmypy.json
dmypy.json
.pyre/
.pytype/

# 配布
build/
dist/
*.egg-info/
```

## ベストプラクティス

- **src レイアウト**: テストと本体コードを明確に分離
- **型ヒント**: Python 3.9+ の型アノテーションを積極的に使用
- **仮想環境**: uvが自動的に管理（.venv/）
- **設定ファイル**: pyproject.toml に全ての設定を集約
- **インポート**: 絶対インポートを推奨
