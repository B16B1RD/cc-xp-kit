# モノレポ プラクティス

## プロジェクトタイプ

```yaml
type: monorepo
structure: multi-language
management: unified
```

## 検出パターン

```yaml
language_markers:
  - "**/package.json"      # JavaScript/TypeScript
  - "**/pyproject.toml"    # Python
  - "**/Cargo.toml"        # Rust
  - "**/go.mod"            # Go
  - "**/pom.xml"           # Java (Maven)
  - "**/build.gradle"      # Java (Gradle)
  - "**/*.csproj"          # C#/.NET
  - "**/Gemfile"           # Ruby
```

## 推奨ディレクトリ構造

```text
monorepo/
├── .claude/
│   ├── language-practice.md    # ルートレベル共通設定
│   └── agile-artifacts/        # プロジェクト全体のアジャイル文書
├── apps/                       # アプリケーション
│   ├── web/                   # フロントエンド (React/Vue/etc)
│   │   ├── package.json
│   │   └── .claude/
│   │       └── language-practice.md
│   ├── mobile/                # モバイルアプリ
│   └── desktop/               # デスクトップアプリ
├── services/                   # バックエンドサービス
│   ├── api/                   # メインAPI (Go)
│   │   ├── go.mod
│   │   └── .claude/
│   ├── auth/                  # 認証サービス (Python)
│   │   ├── pyproject.toml
│   │   └── .claude/
│   └── worker/                # ワーカー (Rust)
│       ├── Cargo.toml
│       └── .claude/
├── packages/                   # 共有パッケージ
│   ├── ui-components/         # UI コンポーネントライブラリ
│   ├── utils/                 # ユーティリティ関数
│   └── types/                 # 共有型定義
├── tools/                      # 開発ツール
│   ├── scripts/               # ビルド・デプロイスクリプト
│   └── cli/                   # 内部CLIツール
├── docs/                       # ドキュメント
├── .github/                    # GitHub Actions
│   └── workflows/
└── Makefile                    # ルートレベルのタスク
```

## ルートレベルコマンド

```bash
# 全体操作
install_all: "make install-all"
test_all: "make test-all"
lint_all: "make lint-all"
build_all: "make build-all"

# サービス個別操作
test_service: "cd services/$SERVICE && make test"
dev_service: "cd services/$SERVICE && make dev"

# 依存関係グラフ
deps_graph: "make deps-graph"
```

## Makefile テンプレート（ルート）

```makefile
.PHONY: install-all test-all lint-all build-all

# すべてのサブプロジェクトを検出
APPS := $(wildcard apps/*)
SERVICES := $(wildcard services/*)
PACKAGES := $(wildcard packages/*)

install-all:
    @for dir in $(APPS) $(SERVICES) $(PACKAGES); do \
        echo "Installing $$dir..."; \
        $(MAKE) -C $$dir install || exit 1; \
    done

test-all:
    @for dir in $(APPS) $(SERVICES) $(PACKAGES); do \
        echo "Testing $$dir..."; \
        $(MAKE) -C $$dir test || exit 1; \
    done

lint-all:
    @for dir in $(APPS) $(SERVICES) $(PACKAGES); do \
        echo "Linting $$dir..."; \
        $(MAKE) -C $$dir lint || exit 1; \
    done
```

## 言語混在時の設定継承

```yaml
inheritance_chain:
  1: "~/.claude/commands/shared/language-practices/{language}.md"
  2: "{monorepo_root}/.claude/language-practice.md"
  3: "{subproject}/.claude/language-practice.md"
```

## CI/CD 戦略

```yaml
strategy: "影響を受けたサービスのみビルド・デプロイ"
change_detection:
  - git diff による変更検出
  - 依存関係グラフによる影響範囲特定
parallel_execution: true
```

## 共通設定

```yaml
# Git
commit_convention: conventional
branch_strategy: git-flow
pr_checks:
  - すべての影響を受けるテストが通ること
  - リントエラーがないこと
  - ビルドが成功すること

# 開発環境
node_version: ".nvmrc で統一"
python_version: ".python-version で統一"
rust_toolchain: "rust-toolchain.toml で統一"
```

## ベストプラクティス

- **依存関係の明確化**: 各サービス間の依存を最小限に
- **共通コードの抽出**: packages/ に共有コードを配置
- **独立したデプロイ**: 各サービスは独立してデプロイ可能に
- **統一されたツール**: ルートレベルで開発ツールを統一
- **並列実行**: 可能な限りタスクを並列実行
- **キャッシュ活用**: ビルドキャッシュで高速化
