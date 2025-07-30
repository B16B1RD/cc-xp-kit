# プロジェクト構造分析

現在のプロジェクトを詳細に分析し、言語・構造・推奨事項を表示します。

## 実行内容

### 1. 言語・プロジェクトタイプの詳細分析

**プロジェクト構造分析を実行**

Bashツールで以下を順次実行してプロジェクト情報を取得：

1. **言語検出ロジック読み込み**：
   ```
   source ~/.claude/commands/shared/language-detector.md
   ```

2. **プロジェクトタイプ検出**：
   ```
   PROJECT_TYPE=$(detect_project_type)
   echo "📊 プロジェクトタイプ: $PROJECT_TYPE"
   ```

3. **現在コンテキスト取得**：
   ```
   CURRENT_CONTEXT=$(get_current_context)
   CONTEXT_DIR=$(echo "$CURRENT_CONTEXT" | cut -d: -f1)
   CONTEXT_LANG=$(echo "$CURRENT_CONTEXT" | cut -d: -f2)
   echo "📍 現在のコンテキスト: $CONTEXT_DIR ($CONTEXT_LANG)"
   ```

4. **適用プラクティス決定**：
   ```
   PRACTICE_FILE=$(resolve_practice_file "$CONTEXT_LANG" "user")
   echo "📖 適用プラクティス: $PRACTICE_FILE"
   ```

### 2. ファイル構造の詳細表示

```bash
echo ""
echo "📁 ディレクトリ構造:"
echo "==================="

# プロジェクトタイプに応じた詳細表示
case "$PROJECT_TYPE" in
    monorepo)
        echo "🏗️ モノレポ構造"
        echo ""
        echo "サブプロジェクト:"
        detect_subprojects | while IFS=: read -r dir lang; do
            echo "  📂 $dir/"
            echo "     言語: $lang"
            practice_file=$(resolve_practice_file "$lang" "user")
            echo "     プラクティス: $practice_file"
            
            # 各サブプロジェクトの主要ファイル表示
            cd "$dir" 2>/dev/null || continue
            case "$lang" in
                python)
                    [ -f "pyproject.toml" ] && echo "     設定: pyproject.toml"
                    [ -f "requirements.txt" ] && echo "     依存: requirements.txt"
                    ;;
                javascript)
                    [ -f "package.json" ] && echo "     設定: package.json"
                    [ -f "tsconfig.json" ] && echo "     TypeScript: tsconfig.json"
                    ;;
                rust)
                    [ -f "Cargo.toml" ] && echo "     設定: Cargo.toml"
                    ;;
                go)
                    [ -f "go.mod" ] && echo "     設定: go.mod"
                    ;;
            esac
            cd - > /dev/null
            echo ""
        done
        ;;
    mixed)
        echo "🔀 混合言語プロジェクト"
        echo ""
        MIXED_LANGUAGES=($(get_mixed_languages))
        PRIMARY_LANG=$(get_primary_language "${MIXED_LANGUAGES[@]}")
        echo "プライマリ言語: $PRIMARY_LANG"
        echo "含まれる言語: ${MIXED_LANGUAGES[*]}"
        echo ""
        echo "各言語の設定ファイル:"
        for lang in "${MIXED_LANGUAGES[@]}"; do
            case "$lang" in
                python)
                    [ -f "pyproject.toml" ] && echo "  🐍 Python: pyproject.toml"
                    [ -f "requirements.txt" ] && echo "  📋 Python: requirements.txt"
                    ;;
                javascript)
                    [ -f "package.json" ] && echo "  🟨 JavaScript: package.json"
                    [ -f "tsconfig.json" ] && echo "  📝 TypeScript: tsconfig.json"
                    ;;
                rust)
                    [ -f "Cargo.toml" ] && echo "  🦀 Rust: Cargo.toml"
                    ;;
                go)
                    [ -f "go.mod" ] && echo "  🐹 Go: go.mod"
                    ;;
            esac
        done
        ;;
    *)
        # 単一言語プロジェクト
        echo "📦 単一言語プロジェクト ($PROJECT_TYPE)"
        echo ""
        echo "主要ファイル:"
        case "$PROJECT_TYPE" in
            python)
                [ -f "pyproject.toml" ] && echo "  ✅ pyproject.toml"
                [ -f "requirements.txt" ] && echo "  📋 requirements.txt"
                [ -f "setup.py" ] && echo "  ⚠️  setup.py (レガシー)"
                [ -d "src/" ] && echo "  📁 src/ (推奨構造)"
                [ -d "tests/" ] && echo "  🧪 tests/"
                ;;
            javascript)
                [ -f "package.json" ] && echo "  ✅ package.json"
                [ -f "tsconfig.json" ] && echo "  📝 tsconfig.json (TypeScript)"
                [ -f "vite.config.ts" ] && echo "  ⚡ vite.config.ts (Vite)"
                [ -f "webpack.config.js" ] && echo "  📦 webpack.config.js"
                [ -d "src/" ] && echo "  📁 src/"
                [ -d "tests/" ] && echo "  🧪 tests/"
                ;;
            rust)
                [ -f "Cargo.toml" ] && echo "  ✅ Cargo.toml"
                [ -f "Cargo.lock" ] && echo "  🔒 Cargo.lock"
                [ -d "src/" ] && echo "  📁 src/"
                [ -d "tests/" ] && echo "  🧪 tests/"
                [ -d "benches/" ] && echo "  ⚡ benches/"
                ;;
            go)
                [ -f "go.mod" ] && echo "  ✅ go.mod"
                [ -f "go.sum" ] && echo "  🔒 go.sum"
                [ -d "cmd/" ] && echo "  📁 cmd/ (推奨構造)"
                [ -d "internal/" ] && echo "  🔒 internal/"
                [ -d "pkg/" ] && echo "  📦 pkg/"
                ;;
        esac
        ;;
esac
```

### 3. 開発環境の確認

```bash
echo ""
echo "🔧 開発環境:"
echo "============="

case "$PROJECT_TYPE" in
    python|monorepo)
        if command -v python3 >/dev/null 2>&1; then
            echo "🐍 Python: $(python3 --version 2>&1)"
        fi
        if command -v uv >/dev/null 2>&1; then
            echo "⚡ uv: $(uv --version 2>&1)"
        elif command -v pip >/dev/null 2>&1; then
            echo "📦 pip: $(pip --version 2>&1)"
        fi
        ;;
    javascript|monorepo)
        if command -v node >/dev/null 2>&1; then
            echo "🟨 Node.js: $(node --version 2>&1)"
        fi
        if command -v pnpm >/dev/null 2>&1; then
            echo "📦 pnpm: $(pnpm --version 2>&1)"
        elif command -v npm >/dev/null 2>&1; then
            echo "📦 npm: $(npm --version 2>&1)"
        fi
        ;;
    rust|monorepo)
        if command -v rustc >/dev/null 2>&1; then
            echo "🦀 Rust: $(rustc --version 2>&1)"
        fi
        if command -v cargo >/dev/null 2>&1; then
            echo "📦 Cargo: $(cargo --version 2>&1)"
        fi
        ;;
    go|monorepo)
        if command -v go >/dev/null 2>&1; then
            echo "🐹 Go: $(go version 2>&1)"
        fi
        ;;
esac
```

### 4. 推奨事項の表示

```bash
echo ""
echo "💡 推奨事項:"
echo "============="

# TDD環境の確認
if [ ! -d ".claude/agile-artifacts" ]; then
    echo "⚠️  TDD環境が未初期化です"
    echo "   実行: /tdd:init"
    echo ""
fi

# プラクティスファイルから推奨コマンドを抽出
if [ -f "$PRACTICE_FILE" ]; then
    echo "📋 利用可能なコマンド:"
    
    # テストコマンド
    TEST_CMD=$(grep '^test:' "$PRACTICE_FILE" | cut -d'"' -f2 2>/dev/null)
    [ -n "$TEST_CMD" ] && echo "  🧪 テスト: $TEST_CMD"
    
    # リントコマンド
    LINT_CMD=$(grep '^lint:' "$PRACTICE_FILE" | cut -d'"' -f2 2>/dev/null)
    [ -n "$LINT_CMD" ] && echo "  🔍 リント: $LINT_CMD"
    
    # フォーマットコマンド
    FORMAT_CMD=$(grep '^format:' "$PRACTICE_FILE" | cut -d'"' -f2 2>/dev/null)
    [ -n "$FORMAT_CMD" ] && echo "  📝 フォーマット: $FORMAT_CMD"
    
    # ビルドコマンド
    BUILD_CMD=$(grep '^build:' "$PRACTICE_FILE" | cut -d'"' -f2 2>/dev/null)
    [ -n "$BUILD_CMD" ] && echo "  🔨 ビルド: $BUILD_CMD"
    
    # 実行コマンド
    RUN_CMD=$(grep '^run:' "$PRACTICE_FILE" | cut -d'"' -f2 2>/dev/null)
    [ -n "$RUN_CMD" ] && echo "  🚀 実行: $RUN_CMD"
fi

# カスタマイズファイルの確認
echo ""
if [ -f ".claude/language-practice.md" ]; then
    echo "✅ プロジェクト固有設定: .claude/language-practice.md"
else
    echo "💡 プロジェクト固有設定を作成できます:"
    echo "   touch .claude/language-practice.md"
fi
```

### 5. Git 状態の確認

```bash
echo ""
echo "📊 Git 状態:"
echo "============="

if [ -d ".git" ]; then
    echo "✅ Git リポジトリ初期化済み"
    echo "ブランチ: $(git branch --show-current 2>/dev/null || echo 'detached HEAD')"
    
    # 変更の有無確認
    if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
        echo "⚠️  未コミットの変更があります"
        git status --porcelain 2>/dev/null | head -5
    else
        echo "✅ 作業ディレクトリはクリーンです"
    fi
else
    echo "⚠️  Git リポジトリが未初期化です"
    echo "   実行: git init"
fi
```

## 完了メッセージ

```bash
echo ""
echo "🎯 次のステップ:"
echo "================="

if [ ! -d ".claude/agile-artifacts" ]; then
    echo "1. TDD環境の初期化: /tdd:init"
else
    echo "1. ストーリー作成: /tdd:story \"要件説明\""
    echo "2. イテレーション計画: /tdd:plan 1"
    echo "3. TDD実行: /tdd:run"
fi

echo ""
echo "💡 プロジェクトカスタマイズ:"
echo "  .claude/language-practice.md でプロジェクト固有の設定が可能"
echo ""
```
