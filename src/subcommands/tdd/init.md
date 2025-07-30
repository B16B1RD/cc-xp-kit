---
description: "現在のプロジェクトにTDD開発環境をセットアップ。言語検出、ディレクトリ作成、CLAUDE.md生成、Git初期化を実行します。"
allowed-tools: ["Bash", "Write", "Read", "LS"]
---

# TDD開発環境の初期化

現在のプロジェクトに TDD 開発環境をセットアップします。

## 実行内容

1. **言語・プロジェクトタイプの検出**

```bash
# 言語検出ロジックを読み込み
source ~/.claude/commands/shared/language-detector.md

# プロジェクトタイプを検出
PROJECT_TYPE=$(detect_project_type)
echo "🔍 検出されたプロジェクトタイプ: $PROJECT_TYPE"

# プロジェクトタイプ別の詳細情報表示
case "$PROJECT_TYPE" in
    monorepo)
        echo "📂 サブプロジェクト:"
        detect_subprojects | while IFS=: read -r dir lang; do
            echo "  - $dir ($lang)"
        done
        ;;
    mixed)
        echo "🔀 混合言語プロジェクト:"
        MIXED_LANGUAGES=($(get_mixed_languages))
        PRIMARY_LANG=$(get_primary_language "${MIXED_LANGUAGES[@]}")
        echo "  - プライマリ: $PRIMARY_LANG"
        echo "  - 含まれる言語: ${MIXED_LANGUAGES[*]}"
        ;;
esac
```

1. **プロジェクト用ディレクトリの作成**

```bash
mkdir -p .claude/agile-artifacts/{stories,iterations,reviews,tdd-logs}
```

1. **CLAUDE.mdの作成/更新**

```bash
# 言語別プラクティスファイルを読み込み
PRACTICE_FILE=$(resolve_practice_file "$PROJECT_TYPE" "user")
echo "📖 適用するプラクティス: $PRACTICE_FILE"

# 新しい CLAUDE.md 生成機能を読み込み
source ~/.claude/commands/shared/claude-md-generator.md

# 技術スタック情報を取得
TECH_STACK_INFO=$(get_tech_stack_info "$PROJECT_TYPE")

# プロジェクト固有の詳細なCLAUDE.mdを生成
generate_project_claude_md() {
    # メイン生成関数を呼び出し
    generate_claude_md "$PROJECT_TYPE" "$TECH_STACK_INFO"
    
    # プロジェクト固有の追加情報
    case "$PROJECT_TYPE" in
        monorepo)
            echo ""
            echo "## モノレポ固有の設定"
            echo ""
            echo "### サブプロジェクト構成"
            detect_subprojects | while IFS=: read -r dir lang; do
                practice_file=$(resolve_practice_file "$lang" "user")
                echo "- **\`$dir\`** - $lang"
                echo "  - プラクティス: $practice_file"
                echo "  - 個別TDD実行: \`/tdd:run --subproject=$dir\`"
                echo ""
            done
            
            echo "### 統合テスト戦略"
            echo "- サブプロジェクト間の依存関係テスト"
            echo "- 統合CI/CDパイプライン"
            echo "- 共有ライブラリのバージョン管理"
            ;;
        mixed)
            echo ""
            echo "## 混合言語プロジェクト設定"
            echo ""
            MIXED_LANGUAGES=($(get_mixed_languages))
            PRIMARY_LANG=$(get_primary_language "${MIXED_LANGUAGES[@]}")
            echo "### プライマリ言語: $PRIMARY_LANG"
            echo ""
            echo "### 含まれる言語:"
            for lang in "${MIXED_LANGUAGES[@]}"; do
                practice_file=$(resolve_practice_file "$lang" "user")
                echo "- **$lang**"
                echo "  - プラクティス: $practice_file"
                echo "  - 個別テスト: 言語固有のテストコマンド"
                echo ""
            done
            
            echo "### 統合開発戦略"
            echo "- 言語間のインターフェース定義"
            echo "- 統合テストの実行順序"
            echo "- 依存関係の管理方針"
            ;;
    esac
    
    # カスタム設定の読み込み案内
    echo ""
    echo "## カスタマイズ"
    echo ""
    echo "このファイルはプロジェクト固有の設定です。"
    echo "必要に応じて以下をカスタマイズしてください："
    echo ""
    echo "- テストコマンドの調整"
    echo "- 品質基準の変更"
    echo "- プロジェクト固有のルールの追加"
    echo "- デプロイメント戦略の定義"
    echo ""
    echo "---"
    echo ""
    echo "このファイルは \`/tdd:init\` により自動生成されました。"
    echo "最終更新: $(date '+%Y-%m-%d %H:%M:%S')"
}

get_tech_stack_info() {
    local project_type="$1"
    
    case "$project_type" in
        javascript)
            echo "HTML5 + CSS3 + Vanilla JavaScript (ES6+) with Vite"
            ;;
        python)
            echo "Python 3.11+ with pytest and modern tooling"
            ;;
        rust)
            echo "Rust with Cargo and built-in testing"
            ;;
        go)
            echo "Go with built-in testing and go modules"
            ;;
        monorepo)
            echo "Multi-language monorepo with unified tooling"
            ;;
        mixed)
            local mixed_langs=($(get_mixed_languages))
            echo "Mixed: ${mixed_langs[*]}"
            ;;
        *)
            echo "Custom technology stack"
            ;;
    esac
}

# 既存のCLAUDE.mdがあれば保持してマージ
if [ -f CLAUDE.md ]; then
    echo "🔄 既存のCLAUDE.mdを更新中..."
    
    # バックアップを作成
    cp CLAUDE.md CLAUDE.md.backup
    
    # TDD固有セクションのみ更新（既存のカスタム内容は保持）
    # 一時ファイルにTDD設定を生成
    generate_project_claude_md > .claude_tdd_section.md
    
    # 既存ファイルからTDD設定以外を抽出
    if grep -q "^# TDD開発環境\|^# CLAUDE.md" CLAUDE.md; then
        # TDD設定セクションを新しい内容で置き換え
        sed '/^# TDD開発環境/,/^---$/c\
# TDD開発環境の設定は更新されました。新しい内容は下記をご確認ください。' CLAUDE.md > .claude_existing.md
        
        # 新しいTDD設定を先頭に、既存の内容を後に配置
        {
            cat .claude_tdd_section.md
            echo ""
            echo "---"
            echo "## 既存のプロジェクト設定"
            echo ""
            cat .claude_existing.md
        } > CLAUDE.md
    else
        # TDD設定セクションがない場合は先頭に追加
        {
            cat .claude_tdd_section.md
            echo ""
            echo "---"
            echo "## 既存のプロジェクト設定"
            echo ""
            cat CLAUDE.md
        } > CLAUDE.md.new
        mv CLAUDE.md.new CLAUDE.md
    fi
    
    # 一時ファイルを削除
    rm -f .claude_tdd_section.md .claude_existing.md
    
    echo "✅ CLAUDE.mdを既存内容を保持して更新しました"
    echo "📋 バックアップ: CLAUDE.md.backup"
else
    echo "📝 新規CLAUDE.mdを作成中..."
    generate_project_claude_md > CLAUDE.md
    echo "✅ CLAUDE.mdを作成しました"
fi
```

1. **セッション管理ファイル**

```bash
# セッション管理ファイルの作成
cat > .claude/agile-artifacts/tdd-logs/session.json << EOF
{
  "initialized": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "project_type": "$PROJECT_TYPE",
  "practice_file": "$PRACTICE_FILE",
  "sessions": [],
  "iterations": {},
  "mandatory_checks": {
    "enabled": true
  }
}
EOF
```

1. **Git初期化と言語別設定**

```bash
# 未初期化の場合のみ
if [ ! -d .git ]; then
  git init
fi

# 言語別.gitignoreの生成
generate_gitignore() {
    # 共通の.gitignore
    cat << 'EOF'
# OS generated files
.DS_Store
Thumbs.db
*.swp
*~

# IDE
.idea/
.vscode/
*.sublime-*

# TDD個人ログのみ除外
.claude/agile-artifacts/tdd-logs/

# Logs
*.log
logs/

# Environment
.env
.env.local
EOF

    # 言語別の.gitignore追加
    case "$PROJECT_TYPE" in
        python)
            cat << 'EOF'

# Python
__pycache__/
*.py[cod]
*$py.class
.uv/
.venv/
env/
venv/
.coverage
.pytest_cache/
htmlcov/
build/
dist/
*.egg-info/
EOF
            ;;
        javascript)
            cat << 'EOF'

# JavaScript/Node.js
node_modules/
.pnpm-store/
dist/
build/
.next/
out/
.cache/
.parcel-cache/
.turbo/
coverage/
.nyc_output/
npm-debug.log*
pnpm-debug.log*
yarn-debug.log*
EOF
            ;;
        rust)
            cat << 'EOF'

# Rust
/target/
**/*.rs.bk
*.pdb
*.orig
EOF
            ;;
        go)
            cat << 'EOF'

# Go
*.exe
*.exe~
*.dll
*.so
*.dylib
bin/
*.test
*.out
coverage.txt
coverage.html
vendor/
EOF
            ;;
        monorepo)
            cat << 'EOF'

# Monorepo - Common patterns
node_modules/
target/
dist/
build/
.venv/
__pycache__/
vendor/
bin/
coverage/
*.test
*.log
EOF
            ;;
    esac
}

# .gitignoreの作成（既存の場合は言語別パターンのみ追加）
if [ ! -f .gitignore ]; then
    generate_gitignore > .gitignore
else
    echo "" >> .gitignore
    echo "# TDD Kit - Language specific patterns for $PROJECT_TYPE" >> .gitignore
    generate_gitignore | tail -n +8 >> .gitignore  # 共通部分をスキップ
fi

# 初期コミット
git add .
git commit -m "[INIT] TDD development environment setup ($PROJECT_TYPE)"
```

## 完了メッセージ

```bash
echo ""
echo "✅ TDD開発環境を初期化しました！"
echo ""
echo "📊 プロジェクト情報:"
echo "  - タイプ: $PROJECT_TYPE"
echo "  - プラクティス: $PRACTICE_FILE"
echo ""
echo "📁 作成内容:"
echo "  - .claude/agile-artifacts/ (TDD文書管理)"
echo "  - CLAUDE.md (プロジェクト知識)"
echo "  - セッション管理"
echo "  - 言語別Git設定"
echo ""

case "$PROJECT_TYPE" in
    monorepo)
        echo "🏗️ 検出されたサブプロジェクト:"
        detect_subprojects | while IFS=: read -r dir lang; do
            echo "  - $dir ($lang)"
        done
        echo ""
        ;;
    mixed)
        echo "🔀 混合言語構成:"
        MIXED_LANGUAGES=($(get_mixed_languages))
        PRIMARY_LANG=$(get_primary_language "${MIXED_LANGUAGES[@]}")
        echo "  - プライマリ: $PRIMARY_LANG"
        echo "  - 全言語: ${MIXED_LANGUAGES[*]}"
        echo ""
        ;;
esac

echo "🚀 次のステップ:"
echo "  /tdd:story \"作りたいものの説明\""
echo ""
echo "💡 プロジェクト構造の詳細確認:"
echo "  /tdd:detect"
```
