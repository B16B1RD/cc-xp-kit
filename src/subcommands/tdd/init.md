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

2. **プロジェクト用ディレクトリの作成**
```bash
mkdir -p .claude/agile-artifacts/{stories,iterations,reviews,tdd-logs}
```

3. **CLAUDE.mdの作成/更新**
```bash
# 言語別プラクティスファイルを読み込み
PRACTICE_FILE=$(resolve_practice_file "$PROJECT_TYPE" "user")
echo "📖 適用するプラクティス: $PRACTICE_FILE"

# CLAUDE.md の内容を生成
generate_claude_md() {
    cat << 'EOF'
# TDD開発環境

Kent BeckのTDD哲学に基づいた開発環境です。

## プロジェクト情報
EOF
    echo "- **プロジェクトタイプ**: $PROJECT_TYPE"
    echo "- **適用プラクティス**: $PRACTICE_FILE"
    
    case "$PROJECT_TYPE" in
        monorepo)
            echo ""
            echo "### サブプロジェクト"
            detect_subprojects | while IFS=: read -r dir lang; do
                practice_file=$(resolve_practice_file "$lang" "user")
                echo "- \`$dir\` - $lang (参照: $practice_file)"
            done
            ;;
        mixed)
            echo ""
            echo "### 混合言語構成"
            MIXED_LANGUAGES=($(get_mixed_languages))
            PRIMARY_LANG=$(get_primary_language "${MIXED_LANGUAGES[@]}")
            echo "- **プライマリ言語**: $PRIMARY_LANG"
            echo "- **含まれる言語**: ${MIXED_LANGUAGES[*]}"
            for lang in "${MIXED_LANGUAGES[@]}"; do
                practice_file=$(resolve_practice_file "$lang" "user")
                echo "- $lang プラクティス: $practice_file"
            done
            ;;
    esac
    
    cat << 'EOF'

## 開発理念
「シンプルさ」「フィードバック」「勇気」「尊重」「コミュニケーション」

[共通リソースの参照]
- TDD原則: ~/.claude/commands/shared/kent-beck-principles.md
- 必須ゲート: ~/.claude/commands/shared/mandatory-gates.md
- コミット規則: ~/.claude/commands/shared/commit-rules.md
- 言語プラクティス: ~/.claude/commands/shared/language-practices/

## 利用可能なコマンド
- `/tdd:init` - 環境初期化
- `/tdd:story` - ストーリー作成
- `/tdd:plan` - イテレーション計画
- `/tdd:run` - TDD実行
- `/tdd:status` - 進捗確認
- `/tdd:review` - レビュー
- `/tdd:detect` - プロジェクト構造分析
- `/tdd-quick` - クイックスタート

EOF
}

# 既存のCLAUDE.mdがあれば保持
if [ -f CLAUDE.md ]; then
    # 一時ファイルに新しい内容を生成
    generate_claude_md > .claude_new.md
    echo "" >> .claude_new.md
    echo "---" >> .claude_new.md
    echo "" >> .claude_new.md
    # 既存の内容を追加（# TDD開発環境セクション以外）
    sed '/^# TDD開発環境/,/^---$/d' CLAUDE.md >> .claude_new.md
    mv .claude_new.md CLAUDE.md
else
    generate_claude_md > CLAUDE.md
fi
```

4. **セッション管理ファイル**
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

5. **Git初期化と言語別設定**
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
