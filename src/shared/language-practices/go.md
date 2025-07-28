# Go モダンプラクティス

## パッケージ管理
```yaml
primary: "go modules"   # Go 1.11+ の標準
vendoring: optional     # 依存関係のベンダリング
lockfile: go.sum        # チェックサムによる整合性確認
```

## プロジェクト構造
```
project/
├── cmd/                 # メインアプリケーション
│   ├── api/            # API サーバー
│   │   └── main.go
│   └── cli/            # CLI ツール
│       └── main.go
├── internal/            # プライベートコード
│   ├── config/         # 設定管理
│   ├── handler/        # HTTP ハンドラー
│   ├── service/        # ビジネスロジック
│   └── repository/     # データアクセス層
├── pkg/                 # 公開ライブラリコード
│   └── utils/
├── api/                 # API 定義（OpenAPI など）
├── scripts/             # ビルド・デプロイスクリプト
├── test/                # 追加のテストファイル
├── go.mod              # モジュール定義
├── go.sum              # 依存関係チェックサム
├── Makefile            # ビルドタスク
└── .golangci.yml      # リンター設定
```

## テストフレームワーク
```yaml
unit_test: "標準 testing パッケージ"
assertion: testify/assert  # アサーションライブラリ
mock: gomock              # モックフレームワーク
integration: "testing + docker"
benchmark: "testing.B"
```

## 開発ツール
```yaml
formatter: gofmt         # 標準フォーマッター
imports: goimports       # import 文の整理
linter: golangci-lint    # 統合リンター
race_detector: "go test -race"
```

## 実行コマンド
```bash
# ビルド・実行
build: "go build -o bin/app ./cmd/api"
run: "go run ./cmd/api"
install: "go install ./cmd/..."

# テスト実行
test: "go test ./..."
test_verbose: "go test -v ./..."
test_coverage: "go test -cover ./..."
test_race: "go test -race ./..."
bench: "go test -bench=. ./..."

# コード品質
fmt: "go fmt ./..."
imports: "goimports -w ."
lint: "golangci-lint run"
vet: "go vet ./..."

# 依存関係管理
mod_init: "go mod init"
mod_tidy: "go mod tidy"
mod_download: "go mod download"
mod_vendor: "go mod vendor"
mod_verify: "go mod verify"

# その他
generate: "go generate ./..."
clean: "go clean -cache -testcache"
```

## Git 無視パターン
```gitignore
# バイナリ
*.exe
*.exe~
*.dll
*.so
*.dylib
bin/

# テスト
*.test
*.out
coverage.txt
coverage.html

# 依存関係
vendor/

# エディタ
.idea/
.vscode/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# 環境変数
.env
.env.local
```

## ベストプラクティス
- **パッケージ設計**: 小さく焦点を絞ったパッケージ
- **インターフェース**: 実装ではなくインターフェースに依存
- **エラーハンドリング**: エラーは値として扱う
- **並行性**: goroutine と channel を適切に使用
- **コンテキスト**: context.Context でキャンセレーションを管理
- **構造体タグ**: JSON/XML シリアライゼーション用のタグ
- **埋め込み**: 継承の代わりに埋め込みを使用

## Makefile テンプレート
```makefile
.PHONY: build test lint clean

build:
	go build -ldflags="-s -w" -o bin/app ./cmd/api

test:
	go test -v -race -coverprofile=coverage.out ./...

lint:
	golangci-lint run

clean:
	rm -rf bin/ coverage.out
```

## プロジェクト初期化
```bash
# 新規プロジェクト
go mod init github.com/user/project
mkdir -p cmd/api internal pkg
echo "package main" > cmd/api/main.go
```