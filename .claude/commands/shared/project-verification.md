# プロジェクトタイプ別動作確認

## 言語・プロジェクトタイプの自動検出
```bash
# 言語検出ロジックを読み込み
source ~/.claude/commands/shared/language-detector.md

# 現在のコンテキストを検出
CURRENT_CONTEXT=$(get_current_context)
CONTEXT_DIR=$(echo "$CURRENT_CONTEXT" | cut -d: -f1)
CONTEXT_LANG=$(echo "$CURRENT_CONTEXT" | cut -d: -f2)

echo "🔍 検証対象: $CONTEXT_DIR ($CONTEXT_LANG)"

# 適用するプラクティスファイルを決定
PRACTICE_FILE=$(resolve_practice_file "$CONTEXT_LANG" "user")
echo "📖 適用プラクティス: $PRACTICE_FILE"
```

## 🐍 Python プロジェクト

### 開発サーバー起動
```bash
# プラクティスファイルから実行コマンドを取得
RUN_CMD=$(grep '^run:' "$PRACTICE_FILE" | cut -d'"' -f2 2>/dev/null)
if [ -z "$RUN_CMD" ]; then
    # フォールバック
    if [ -f "pyproject.toml" ]; then
        RUN_CMD="uv run python -m $(basename $(pwd))"
    else
        RUN_CMD="python3 -m http.server 8000"
    fi
fi

echo "🚀 Python サーバー起動: $RUN_CMD"
eval "$RUN_CMD" &
SERVER_PID=$!
sleep 2
```

### 確認手順
```bash
# テスト実行
TEST_CMD=$(grep '^test:' "$PRACTICE_FILE" | cut -d'"' -f2 2>/dev/null || echo "python -m pytest")
echo "🧪 テスト実行: $TEST_CMD"
eval "$TEST_CMD" 2>&1 | head -10

# リント実行
LINT_CMD=$(grep '^lint:' "$PRACTICE_FILE" | cut -d'"' -f2 2>/dev/null || echo "echo 'リント未設定'")
echo "🔍 リント実行: $LINT_CMD"
eval "$LINT_CMD" 2>&1 | head -10
```

## 🟨 JavaScript/TypeScript プロジェクト

### 開発サーバー起動
```bash
# パッケージマネージャーの検出
if [ -f "pnpm-lock.yaml" ]; then
    PKG_MGR="pnpm"
elif [ -f "bun.lockb" ]; then
    PKG_MGR="bun"
elif [ -f "yarn.lock" ]; then
    PKG_MGR="yarn"
else
    PKG_MGR="npm"
fi

# 開発サーバー起動
DEV_CMD=$(grep '^dev:' "$PRACTICE_FILE" | cut -d'"' -f2 2>/dev/null || echo "$PKG_MGR run dev")
echo "🚀 開発サーバー起動: $DEV_CMD"

# ポートが使用中でなければ起動
if ! lsof -ti:3000,5173,8080 >/dev/null 2>&1; then
    eval "$DEV_CMD" > /dev/null 2>&1 &
    SERVER_PID=$!
    sleep 3
fi
```

### 確認手順
```bash
# テスト実行
TEST_CMD=$(grep '^test:' "$PRACTICE_FILE" | cut -d'"' -f2 2>/dev/null || echo "$PKG_MGR test")
echo "🧪 テスト実行: $TEST_CMD"
eval "$TEST_CMD" 2>&1 | head -10

# リント実行
LINT_CMD=$(grep '^lint:' "$PRACTICE_FILE" | cut -d'"' -f2 2>/dev/null || echo "$PKG_MGR run lint")
echo "🔍 リント実行: $LINT_CMD"
eval "$LINT_CMD" 2>&1 | head -10

# TypeScript チェック（該当する場合）
if [ -f "tsconfig.json" ]; then
    TYPECHECK_CMD=$(grep '^typecheck:' "$PRACTICE_FILE" | cut -d'"' -f2 2>/dev/null || echo "$PKG_MGR run typecheck")
    echo "🔧 型チェック: $TYPECHECK_CMD"
    eval "$TYPECHECK_CMD" 2>&1 | head -10
fi
```

## 🦀 Rust プロジェクト

### 確認手順
```bash
if [ ! -f "Cargo.toml" ]; then
    echo "❌ Cargo.toml が見つかりません"
    exit 1
fi

echo "🦀 Rust プロジェクト検証"

# ビルド確認
echo "🔨 ビルド実行: cargo build"
cargo build 2>&1 | head -15

# テスト実行
echo "🧪 テスト実行: cargo test"
cargo test 2>&1 | head -10

# リント実行
echo "🔍 Clippy実行: cargo clippy"
cargo clippy -- -D warnings 2>&1 | head -10

# フォーマット確認
echo "📝 フォーマット確認: cargo fmt --check"
cargo fmt --check 2>&1 | head -5
```

## 🐹 Go プロジェクト

### 確認手順
```bash
if [ ! -f "go.mod" ]; then
    echo "❌ go.mod が見つかりません"
    exit 1
fi

echo "🐹 Go プロジェクト検証"

# ビルド確認
echo "🔨 ビルド実行: go build"
go build ./... 2>&1 | head -10

# テスト実行
echo "🧪 テスト実行: go test"
go test ./... 2>&1 | head -10

# リント実行（golangci-lint が利用可能な場合）
if command -v golangci-lint >/dev/null 2>&1; then
    echo "🔍 リント実行: golangci-lint run"
    golangci-lint run 2>&1 | head -10
else
    echo "🔍 Vet実行: go vet"
    go vet ./... 2>&1 | head -10
fi
```

## 🏗️ モノレポプロジェクト

### サブプロジェクト検証
```bash
echo "🏗️ モノレポプロジェクト検証"

# サブプロジェクト一覧を取得
SUBPROJECTS=($(detect_subprojects))

for subproject in "${SUBPROJECTS[@]}"; do
    IFS=: read -r dir lang <<< "$subproject"
    
    echo ""
    echo "📂 検証中: $dir ($lang)"
    echo "──────────────────────────"
    
    cd "$dir"
    
    # 言語別の検証を実行
    case "$lang" in
        python)
            # Python固有の検証
            if [ -f "pyproject.toml" ]; then
                echo "🐍 Python環境確認"
                python --version 2>&1
                if command -v uv >/dev/null 2>&1; then
                    uv run pytest --version 2>&1 | head -3
                fi
            fi
            ;;
        javascript)
            # JavaScript固有の検証
            if [ -f "package.json" ]; then
                echo "🟨 Node.js環境確認"
                node --version 2>&1
                npm --version 2>&1
            fi
            ;;
        rust)
            # Rust固有の検証
            if [ -f "Cargo.toml" ]; then
                echo "🦀 Rust環境確認"
                rustc --version 2>&1
                cargo --version 2>&1
            fi
            ;;
        go)
            # Go固有の検証
            if [ -f "go.mod" ]; then
                echo "🐹 Go環境確認"
                go version 2>&1
            fi
            ;;
    esac
    
    cd - > /dev/null
done
```

## 🔀 混合言語プロジェクト

### 統合検証
```bash
echo "🔀 混合言語プロジェクト検証"

# 混合プロジェクトの言語一覧を取得
MIXED_LANGUAGES=($(get_mixed_languages))
PRIMARY_LANG=$(get_primary_language "${MIXED_LANGUAGES[@]}")

echo "プライマリ言語: $PRIMARY_LANG"
echo "含まれる言語: ${MIXED_LANGUAGES[*]}"
echo ""

# 各言語を順次検証
for lang in "${MIXED_LANGUAGES[@]}"; do
    echo "📋 $lang の検証:"
    echo "────────────────"
    
    # 言語別プラクティスファイルを取得
    lang_practice=$(resolve_practice_file "$lang" "user")
    
    case "$lang" in
        python)
            if [ -f "pyproject.toml" ] || [ -f "requirements.txt" ]; then
                # Python環境確認
                python --version 2>&1
                if command -v uv >/dev/null 2>&1; then
                    echo "✅ uv が利用可能"
                    uv --version 2>&1
                fi
                
                # テスト実行（ディレクトリ指定の可能性を考慮）
                test_cmd=$(grep '^test:' "$lang_practice" | cut -d'"' -f2 2>/dev/null)
                if [ -n "$test_cmd" ]; then
                    echo "🧪 Python テスト: $test_cmd"
                    eval "$test_cmd" 2>&1 | head -5
                fi
            fi
            ;;
        javascript)
            if [ -f "package.json" ]; then
                # Node.js環境確認
                node --version 2>&1
                npm --version 2>&1
                
                # テスト実行
                test_cmd=$(grep '^test:' "$lang_practice" | cut -d'"' -f2 2>/dev/null)
                if [ -n "$test_cmd" ]; then
                    echo "🧪 JavaScript テスト: $test_cmd"
                    eval "$test_cmd" 2>&1 | head -5
                fi
            fi
            ;;
        rust)
            if [ -f "Cargo.toml" ]; then
                cargo --version 2>&1
                echo "🧪 Rust テスト: cargo test"
                cargo test 2>&1 | head -5
            fi
            ;;
        go)
            if [ -f "go.mod" ]; then
                go version 2>&1
                echo "🧪 Go テスト: go test"
                go test ./... 2>&1 | head -5
            fi
            ;;
    esac
    echo ""
done

# 統合コマンドの確認（Makefile等）
if [ -f "Makefile" ]; then
    echo "🔧 統合コマンド (Makefile):"
    grep "^[a-zA-Z].*:" Makefile | head -5
elif [ -f "package.json" ]; then
    echo "🔧 統合コマンド (package.json scripts):"
    grep -A5 '"scripts"' package.json 2>/dev/null | head -5
fi
```

## 🌐 Webアプリケーション（レガシー）

### サーバー起動（バックグラウンド）
```bash
# Python HTTPサーバー
if ! lsof -ti:8000 >/dev/null 2>&1; then
  nohup python3 -m http.server 8000 > /dev/null 2>&1 & disown
fi

# Vite/Node.js
if ! lsof -ti:5173 >/dev/null 2>&1; then
  nohup npm run dev > /dev/null 2>&1 & disown
fi
```

### 確認手順
1. Playwright MCP で `http://localhost:8000` を開く
2. 0.5 秒待機して描画を待つ
3. スクリーンショットを取得
4. 受け入れ基準の視覚的要素を確認

## 🖥️ CLIツール

### 動作確認
```bash
# ヘルプ表示
timeout 3s ./my-tool --help 2>&1

# 実際のコマンド実行
timeout 5s ./my-tool command args 2>&1 | head -20
```

## 🔌 API

### エンドポイント確認
```bash
# ヘルスチェック
curl -m 2 http://localhost:3000/api/health 2>&1

# 実際のAPI呼び出し
curl -m 3 -X POST http://localhost:3000/api/items \
  -H "Content-Type: application/json" \
  -d '{"test": "data"}' 2>&1
```
