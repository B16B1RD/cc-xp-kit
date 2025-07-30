# 品質ゲート統合システム

## 概要

プロジェクトタイプと技術スタックに応じた自動品質チェック機能を提供します。

## 基本品質ゲート

### 必須チェック項目

```bash
run_quality_gates() {
    local project_type="$1"
    local current_phase="$2"  # red, green, refactor, commit
    
    echo "🔍 品質ゲートを実行中..."
    
    # 基本チェック（全プロジェクト共通）
    run_basic_quality_checks
    
    # プロジェクト固有チェック
    case "$project_type" in
        web-app)
            run_web_app_quality_checks "$current_phase"
            ;;
        api-server)
            run_api_server_quality_checks "$current_phase"
            ;;
        cli-tool)
            run_cli_tool_quality_checks "$current_phase"
            ;;
        monorepo)
            run_monorepo_quality_checks "$current_phase"
            ;;
        mixed)
            run_mixed_project_quality_checks "$current_phase"
            ;;
    esac
    
    # フェーズ固有チェック
    case "$current_phase" in
        red)
            run_red_phase_checks
            ;;
        green)
            run_green_phase_checks
            ;;
        refactor)
            run_refactor_phase_checks
            ;;
        commit)
            run_commit_phase_checks
            ;;
    esac
}
```

### 基本品質チェック

```bash
run_basic_quality_checks() {
    local errors=0
    
    echo "📋 基本品質チェック実行中..."
    
    # Git状態確認
    if [ -d .git ]; then
        if ! git diff --quiet; then
            echo "⚠️  未コミットの変更があります"
            git status --porcelain
        fi
        
        # 未追跡ファイル確認
        local untracked=$(git ls-files --others --exclude-standard)
        if [ -n "$untracked" ]; then
            echo "📁 未追跡ファイル:"
            echo "$untracked"
        fi
    fi
    
    # 基本ファイル存在確認
    check_essential_files
    
    # ディスク容量確認
    check_disk_space
    
    return $errors
}

check_essential_files() {
    local essential_files=("CLAUDE.md" ".claude/agile-artifacts")
    
    for file in "${essential_files[@]}"; do
        if [ ! -e "$file" ]; then
            echo "❌ 必須ファイルが不足: $file"
            echo "   /tdd:init を実行して環境を初期化してください"
            return 1
        fi
    done
    
    echo "✅ 必須ファイル確認完了"
    return 0
}

check_disk_space() {
    local available_space=$(df . | awk 'NR==2 {print $4}')
    local min_space=1048576  # 1GB in KB
    
    if [ "$available_space" -lt "$min_space" ]; then
        echo "⚠️  ディスク容量不足 (${available_space}KB < ${min_space}KB)"
        echo "   プロジェクトの継続にはより多くの容量が必要です"
        return 1
    fi
    
    return 0
}
```

### Web App 品質チェック

```bash
run_web_app_quality_checks() {
    local phase="$1"
    local errors=0
    
    echo "🌐 Web アプリケーション品質チェック..."
    
    # package.json 存在確認
    if [ ! -f package.json ]; then
        echo "❌ package.json が見つかりません"
        ((errors++))
    else
        # 依存関係チェック
        if ! npm ls >/dev/null 2>&1; then
            echo "⚠️  依存関係に問題があります"
            echo "   npm install を実行してください"
            ((errors++))
        fi
        
        # セキュリティ監査
        if command -v npm >/dev/null 2>&1; then
            local audit_result=$(npm audit --audit-level=high 2>/dev/null | \
                              grep "found.*vulnerabilities" || echo "0 vulnerabilities")
            echo "🔒 セキュリティ監査: $audit_result"
            
            if echo "$audit_result" | grep -q "high\|critical"; then
                echo "⚠️  高リスクの脆弱性が検出されました"
                echo "   npm audit fix を実行することを推奨します"
            fi
        fi
    fi
    
    # テストファイル構造確認
    check_test_structure "web-app"
    
    # ビルド可能性確認（Greenフェーズ以降）
    if [ "$phase" != "red" ]; then
        check_build_capability "web-app"
    fi
    
    # パフォーマンスチェック（Refactorフェーズ）
    if [ "$phase" = "refactor" ]; then
        check_web_performance
    fi
    
    return $errors
}

check_web_performance() {
    echo "⚡ パフォーマンスチェック..."
    
    # バンドルサイズ確認（ビルド後）
    if [ -d dist ]; then
        local bundle_size=$(du -sh dist 2>/dev/null | cut -f1)
        echo "📦 バンドルサイズ: $bundle_size"
        
        # 大きすぎる場合は警告
        local size_kb=$(du -k dist 2>/dev/null | cut -f1)
        if [ "$size_kb" -gt 1024 ]; then # 1MB以上
            echo "⚠️  バンドルサイズが大きいです (${bundle_size})"
            echo "   コード分割や最適化を検討してください"
        fi
    fi
    
    # 未使用ファイル検出
    if command -v find >/dev/null 2>&1; then
        local unused_files=$(find src -name "*.js" -o -name "*.ts" | while read -r file; do
            if ! grep -r "$(basename "$file" .js | sed 's/.ts$//')" src \
                        --exclude="$file" >/dev/null 2>&1; then
                echo "$file"
            fi
        done)
        
        if [ -n "$unused_files" ]; then
            echo "🗑️  未使用ファイルの可能性:"
            echo "$unused_files"
        fi
    fi
}
```

### API Server 品質チェック

```bash
run_api_server_quality_checks() {
    local phase="$1"
    local errors=0
    
    echo "🔌 API サーバー品質チェック..."
    
    # サーバー設定確認
    check_server_configuration
    
    # セキュリティ設定確認
    check_api_security
    
    # エンドポイント文書化確認
    check_api_documentation
    
    # パフォーマンステスト（Greenフェーズ以降）
    if [ "$phase" != "red" ]; then
        check_api_performance
    fi
    
    return $errors
}

check_server_configuration() {
    echo "⚙️  サーバー設定確認..."
    
    # 環境変数テンプレート確認
    if [ ! -f .env.example ] && [ -f .env ]; then
        echo "⚠️  .env.example がありません"
        echo "   セキュ:ティのため .env.example を作成することを推奨します"
    fi
    
    # ポート設定確認
    if [ -f src/server.js ] || [ -f src/app.js ]; then
        local server_file=$(find src -name "server.js" -o -name "app.js" | head -1)
        if ! grep -q "process.env.PORT" "$server_file" 2>/dev/null; then
            echo "⚠️  ポート設定が環境変数化されていません"
        fi
    fi
}

check_api_security() {
    echo "🔒 API セキュリティチェック..."
    
    # セキュリティヘッダー確認
    local security_packages=("helmet" "cors" "express-rate-limit")
    for package in "${security_packages[@]}"; do
        if [ -f package.json ] && ! grep -q "\"$package\"" package.json; then
            echo "⚠️  セキュリティパッケージが不足: $package"
        fi
    done
    
    # ハードコードされたシークレット検出
    if command -v grep >/dev/null 2>&1; then
        local secrets=$(grep -r "password\|secret\|key.*=" src \
                            --include="*.js" --include="*.ts" 2>/dev/null | \
                            grep -v "process.env" | head -5)
        if [ -n "$secrets" ]; then
            echo "🚨 ハードコードされた機密情報の可能性:"
            echo "$secrets"
            echo "   環境変数の使用を検討してください"
        fi
    fi
}

check_api_documentation() {
    echo "📚 API ドキュメントチェック..."
    
    # OpenAPI/Swagger設定確認
    if [ -f package.json ]; then
        if grep -q "swagger\|openapi" package.json; then
            echo "✅ API文書化ツールが設定されています"
        else
            echo "💡 API文書化ツール (Swagger/OpenAPI) の導入を推奨します"
        fi
    fi
    
    # README にエンドポイント情報があるか確認
    if [ -f README.md ]; then
        if grep -q "endpoint\|API\|GET\|POST" README.md; then
            echo "✅ README にAPI情報が記載されています"
        else
            echo "💡 README にAPIエンドポイント情報の追加を推奨します"
        fi
    fi
}

check_api_performance() {
    echo "⚡ API パフォーマンスチェック..."
    
    # 接続プール設定確認
    if [ -f package.json ]; then
        local db_packages=$(grep -o '"[^"]*":\s*"[^"]*"' package.json | \
                             grep -E "mysql|postgres|mongo|redis" | head -3)
        if [ -n "$db_packages" ]; then
            echo "🗄️  データベースパッケージ: $db_packages"
            echo "💡 接続プール設定が適切に行われているか確認してください"
        fi
    fi
}
```

### CLI Tool 品質チェック

```bash
run_cli_tool_quality_checks() {
    local phase="$1"
    local errors=0
    
    echo "🖥️  CLI ツール品質チェック..."
    
    # バイナリ実行可能性確認
    check_cli_executable
    
    # ヘルプシステム確認
    check_cli_help_system
    
    # クロスプラットフォーム対応確認
    check_cross_platform_compatibility
    
    return $errors
}

check_cli_executable() {
    echo "🔧 CLI実行可能性チェック..."
    
    # main CLIファイル確認
    local cli_file=$(find src -name "cli.js" -o -name "index.js" | head -1)
    if [ -n "$cli_file" ]; then
        if [ ! -x "$cli_file" ]; then
            echo "⚠️  CLIファイルに実行権限がありません: $cli_file"
            echo "   chmod +x $cli_file を実行してください"
        fi
        
        # Shebang確認
        if ! head -1 "$cli_file" | grep -q "#!"; then
            echo "⚠️  Shebang行がありません: $cli_file"
            echo "   #!/usr/bin/env node を追加してください"
        fi
    fi
}

check_cli_help_system() {
    echo "❓ ヘルプシステムチェック..."
    
    # Commander.js や yargs の使用確認
    if [ -f package.json ]; then
        if grep -q "commander\|yargs\|meow" package.json; then
            echo "✅ CLI フレームワークが設定されています"
        else
            echo "💡 CLI フレームワーク (Commander.js/yargs) の使用を推奨します"
        fi
    fi
}
```

### フェーズ固有チェック

```bash
run_red_phase_checks() {
    echo "🔴 Red フェーズ品質チェック..."
    
    # テストの失敗確認
    if run_tests_silent; then
        echo "⚠️  テストが通っています（Redフェーズでは失敗すべき）"
        echo "   失敗するテストを先に書いてください"
        return 1
    else
        echo "✅ テストが失敗しています（Red フェーズ正常）"
    fi
    
    return 0
}

run_green_phase_checks() {
    echo "🟢 Green フェーズ品質チェック..."
    
    # 全テスト通過確認
    if ! run_tests_with_output; then
        echo "❌ テストが失敗しています"
        echo "   Green フェーズでは全テストが通る必要があります"
        return 1
    fi
    
    # 最小限実装確認
    check_minimal_implementation
    
    return 0
}

run_refactor_phase_checks() {
    echo "🔵 Refactor フェーズ品質チェック..."
    
    # テスト通過維持確認
    if ! run_tests_with_output; then
        echo "❌ リファクタ後にテストが失敗しています"
        echo "   リファクタリングは振る舞いを変更してはいけません"
        return 1
    fi
    
    # コード品質改善確認
    check_code_quality_improvement
    
    return 0
}

run_commit_phase_checks() {
    echo "💾 Commit フェーズ品質チェック..."
    
    # 最終品質確認
    run_comprehensive_quality_check
    
    # コミットメッセージ品質確認
    check_commit_message_quality
    
    return 0
}
```

### テスト実行関数

```bash
run_tests_silent() {
    local project_type=$(detect_project_type)
    
    case "$project_type" in
        javascript)
            npm test >/dev/null 2>&1
            ;;
        python)
            python -m pytest >/dev/null 2>&1 || python -m unittest discover >/dev/null 2>&1
            ;;
        rust)
            cargo test >/dev/null 2>&1
            ;;
        go)
            go test ./... >/dev/null 2>&1
            ;;
        *)
            echo "Unknown project type for testing: $project_type"
            return 1
            ;;
    esac
}

run_tests_with_output() {
    local project_type=$(detect_project_type)
    
    echo "🧪 テスト実行中..."
    
    case "$project_type" in
        javascript)
            if [ -f package.json ]; then
                npm test
            else
                echo "package.json not found"
                return 1
            fi
            ;;
        python)
            if [ -f pyproject.toml ] || [ -f requirements.txt ]; then
                python -m pytest -v || python -m unittest discover -v
            else
                echo "Python project files not found"
                return 1
            fi
            ;;
        rust)
            if [ -f Cargo.toml ]; then
                cargo test
            else
                echo "Cargo.toml not found"
                return 1
            fi
            ;;
        go)
            if [ -f go.mod ]; then
                go test -v ./...
            else
                echo "go.mod not found"
                return 1
            fi
            ;;
        *)
            echo "Unknown project type: $project_type"
            return 1
            ;;
    esac
}
```

### 包括品質チェック

```bash
run_comprehensive_quality_check() {
    echo "🎯 包括的品質チェック実行中..."
    
    local total_errors=0
    
    # テストカバレッジ確認
    check_test_coverage
    ((total_errors += $?))
    
    # コード複雑度確認
    check_code_complexity
    ((total_errors += $?))
    
    # 静的解析実行
    run_static_analysis
    ((total_errors += $?))
    
    # パフォーマンステスト
    run_performance_tests
    ((total_errors += $?))
    
    if [ $total_errors -eq 0 ]; then
        echo "✅ 包括的品質チェック完了 - 品質基準を満たしています"
    else
        echo "⚠️  品質チェックで $total_errors 個の問題が見つかりました"
    fi
    
    return $total_errors
}

check_test_coverage() {
    echo "📊 テストカバレッジ確認..."
    
    local project_type=$(detect_project_type)
    
    case "$project_type" in
        javascript)
            if command -v npm >/dev/null 2>&1 && grep -q "coverage" package.json; then
                npm run test:coverage 2>/dev/null || npm test -- --coverage 2>/dev/null
            fi
            ;;
        python)
            if command -v coverage >/dev/null 2>&1; then
                coverage run -m pytest && coverage report
            fi
            ;;
    esac
}

check_code_complexity() {
    echo "🧮 コード複雑度確認..."
    
    # 簡易的な複雑度チェック（行数ベース）
    local large_files=$(find src -name "*.js" -o -name "*.ts" -o -name "*.py" \
                             -o -name "*.rs" -o -name "*.go" 2>/dev/null | \
                         xargs wc -l 2>/dev/null | \
                         awk '$1 > 200 {print $2 " (" $1 " lines)"}')
    
    if [ -n "$large_files" ]; then
        echo "⚠️  大きなファイルが検出されました:"
        echo "$large_files"
        echo "   ファイル分割を検討してください"
    fi
}

run_static_analysis() {
    echo "🔍 静的解析実行..."
    
    local project_type=$(detect_project_type)
    
    case "$project_type" in
        javascript)
            if command -v npm >/dev/null 2>&1 && grep -q "eslint" package.json; then
                npm run lint 2>/dev/null || npx eslint src 2>/dev/null
            fi
            ;;
        python)
            if command -v flake8 >/dev/null 2>&1; then
                flake8 src 2>/dev/null
            elif command -v pylint >/dev/null 2>&1; then
                pylint src 2>/dev/null
            fi
            ;;
        rust)
            if command -v cargo >/dev/null 2>&1; then
                cargo clippy 2>/dev/null
            fi
            ;;
    esac
}
```

## 使用方法

```bash
# 基本的な使用
run_quality_gates "web-app" "green"

# 段階的チェック
run_red_phase_checks
run_green_phase_checks  
run_refactor_phase_checks
run_commit_phase_checks

# 包括的チェック
run_comprehensive_quality_check
```
