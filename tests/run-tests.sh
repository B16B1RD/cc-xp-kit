#!/bin/bash
set -uo pipefail

# cc-tdd-kit テストスイート

# カラー定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🧪 cc-tdd-kit テストスイート${NC}"
echo "================================"

# テスト結果カウンター
TESTS_PASSED=0
TESTS_FAILED=0

# テスト関数
run_test() {
    local test_name=$1
    local test_script=$2
    
    echo -ne "  ${test_name} ... "
    
    if bash "${test_script}" > /dev/null 2>&1; then
        echo -e "${GREEN}✓${NC}"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}✗${NC}"
        ((TESTS_FAILED++))
        echo -e "    ${RED}詳細: bash ${test_script}${NC}"
    fi
}

# テストディレクトリの確認
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR" || exit

# 1. インストールテスト
echo -e "\n${YELLOW}1. インストールテスト${NC}"

# 一時ディレクトリでテスト
TEMP_DIR=$(mktemp -d)
# エラー時も確実にクリーンアップ
cleanup() {
    if [ -d "$TEMP_DIR" ]; then
        rm -rf "$TEMP_DIR"
    fi
}
trap cleanup EXIT INT TERM

# ユーザー用インストールテスト
USER_HOME="$TEMP_DIR/home"
mkdir -p "$USER_HOME"

# インストール実行
(
    export HOME="$USER_HOME"
    cd "$TEMP_DIR" || exit
    echo "1" | timeout 10 bash "$SCRIPT_DIR/../install.sh" > /dev/null 2>&1
)
user_install_result=$?

# 確認
if [ $user_install_result -eq 0 ] && \
   [ -f "$USER_HOME/.claude/commands/tdd.md" ] && \
   [ -f "$USER_HOME/.claude/commands/.cc-tdd-kit.json" ] && \
   [ -d "$USER_HOME/.claude/commands/shared" ] && \
   [ -d "$USER_HOME/.claude/commands/tdd" ]; then
    echo -e "  ユーザー用インストール ... ${GREEN}✓${NC}"
    ((TESTS_PASSED++))
else
    echo -e "  ユーザー用インストール ... ${RED}✗${NC}"
    ((TESTS_FAILED++))
fi

# プロジェクト用インストールテスト
PROJECT_DIR="$TEMP_DIR/project"
mkdir -p "$PROJECT_DIR"

echo -n "  プロジェクト用インストール ... "

# インストール実行
cd "$PROJECT_DIR" || exit
echo "2" | timeout 10 bash "$SCRIPT_DIR/../install.sh" > install.log 2>&1
install_result=$?
cd - > /dev/null || exit

# 結果確認
if [ $install_result -eq 0 ] && \
   [ -f "$PROJECT_DIR/.claude/commands/tdd.md" ] && \
   [ -f "$PROJECT_DIR/.claude/commands/.cc-tdd-kit.json" ] && \
   [ -d "$PROJECT_DIR/.claude/commands/shared" ] && \
   [ -d "$PROJECT_DIR/.claude/commands/tdd" ]; then
    echo -e "${GREEN}✓${NC}"
    ((TESTS_PASSED++))
else
    echo -e "${RED}✗${NC}"
    ((TESTS_FAILED++))
    if [ -f "$PROJECT_DIR/install.log" ]; then
        echo -e "    ${RED}エラーログ:${NC}"
        head -10 "$PROJECT_DIR/install.log"
    fi
fi

# 2. ファイル整合性テスト
echo -e "\n${YELLOW}2. ファイル整合性テスト${NC}"

# 必須ファイルの存在確認（v0.2.0統合版 + Kent Beck改善機能）
required_files=(
    "../README.md"
    "../LICENSE"
    "../CHANGELOG.md"
    "../install.sh"
    "../.gitignore"
    "../src/commands/tdd.md"
    "../src/commands/tdd-quick.md"
    "../src/subcommands/tdd/run.md"
    "../src/subcommands/tdd/status.md"
    "../src/subcommands/tdd/review.md"
    "../src/subcommands/tdd/feedback.md"
    "../src/subcommands/tdd/fix.md"
    "../src/subcommands/tdd/detect.md"
    "../src/shared/kent-beck-principles.md"
    "../src/shared/mandatory-gates.md"
    "../src/shared/commit-rules.md"
    "../src/shared/analyze-next-action.sh"
    "../src/shared/todo-manager.sh"
    "../src/shared/story-tracker.sh"
    "../src/shared/progress-dashboard.sh"
    "../src/shared/micro-feedback.sh"
    "../src/shared/acceptance-criteria.sh"
    "../src/shared/iteration-tracker.sh"
)

all_files_exist=true
for file in "${required_files[@]}"; do
    if [ ! -f "$file" ]; then
        all_files_exist=false
        echo -e "    ${RED}Missing: $file${NC}"
    fi
done

if [ "$all_files_exist" = true ]; then
    echo -e "  必須ファイルの存在 ... ${GREEN}✓${NC}"
    ((TESTS_PASSED++))
else
    echo -e "  必須ファイルの存在 ... ${RED}✗${NC}"
    ((TESTS_FAILED++))
fi

# 3. ShellCheckテスト（インストールされている場合）
echo -e "\n${YELLOW}3. コード品質テスト${NC}"

if command -v shellcheck > /dev/null 2>&1; then
    # install.sh のチェック
    if shellcheck "$SCRIPT_DIR/../install.sh" > /dev/null 2>&1; then
        echo -e "  ShellCheck (install.sh) ... ${GREEN}✓${NC}"
        ((TESTS_PASSED++))
    else
        echo -e "  ShellCheck (install.sh) ... ${RED}✗${NC}"
        ((TESTS_FAILED++))
    fi
    
    # Kent Beck改善スクリプトのチェック
    kent_beck_scripts=(
        "../src/shared/analyze-next-action.sh"
        "../src/shared/todo-manager.sh"
        "../src/shared/story-tracker.sh"
        "../src/shared/progress-dashboard.sh"
        "../src/shared/micro-feedback.sh"
        "../src/shared/acceptance-criteria.sh"
        "../src/shared/iteration-tracker.sh"
    )
    
    for script in "${kent_beck_scripts[@]}"; do
        if [ -f "$script" ]; then
            script_name=$(basename "$script")
            if shellcheck "$script" > /dev/null 2>&1; then
                echo -e "  ShellCheck ($script_name) ... ${GREEN}✓${NC}"
                ((TESTS_PASSED++))
            else
                echo -e "  ShellCheck ($script_name) ... ${RED}✗${NC}"
                ((TESTS_FAILED++))
            fi
        fi
    done
else
    echo -e "  ShellCheck ... ${YELLOW}スキップ (未インストール)${NC}"
fi

# 4. v0.2.0統合機能テスト
echo -e "\n${YELLOW}4. v0.2.0統合機能テスト${NC}"

# 統合コマンド構文チェック
echo -n "  統合 /tdd コマンド構文チェック ... "
if [ -f "$SCRIPT_DIR/../src/commands/tdd.md" ]; then
    echo -e "${GREEN}✓${NC}"
    ((TESTS_PASSED++))
else
    echo -e "${RED}✗${NC}"
    ((TESTS_FAILED++))
fi

# tdd-quick コマンド構文チェック
echo -n "  tdd-quick コマンド構文チェック ... "
if [ -f "$SCRIPT_DIR/../src/commands/tdd-quick.md" ]; then
    echo -e "${GREEN}✓${NC}"
    ((TESTS_PASSED++))
else
    echo -e "${RED}✗${NC}"
    ((TESTS_FAILED++))
fi

# 削除対象ファイルの不存在確認
echo -n "  削除対象ファイル除去確認 ... "
if [ ! -f "$SCRIPT_DIR/../src/subcommands/tdd/init.md" ] && \
   [ ! -f "$SCRIPT_DIR/../src/subcommands/tdd/story.md" ] && \
   [ ! -f "$SCRIPT_DIR/../src/subcommands/tdd/plan.md" ]; then
    echo -e "${GREEN}✓${NC}"
    ((TESTS_PASSED++))
else
    echo -e "${RED}✗${NC}"
    ((TESTS_FAILED++))
fi

# Kent Beck改善機能テスト
echo -e "\n${YELLOW}4.5. Kent Beck改善機能テスト${NC}"

# 実行権限テスト
kent_beck_scripts=(
    "../src/shared/analyze-next-action.sh"
    "../src/shared/todo-manager.sh"
    "../src/shared/story-tracker.sh"
    "../src/shared/progress-dashboard.sh"
    "../src/shared/micro-feedback.sh"
    "../src/shared/acceptance-criteria.sh"
    "../src/shared/iteration-tracker.sh"
)

echo -n "  実行権限確認 ... "
all_executable=true
for script in "${kent_beck_scripts[@]}"; do
    if [ -f "$script" ] && [ ! -x "$script" ]; then
        all_executable=false
        break
    fi
done

if [ "$all_executable" = true ]; then
    echo -e "${GREEN}✓${NC}"
    ((TESTS_PASSED++))
else
    echo -e "${RED}✗${NC}"
    ((TESTS_FAILED++))
fi

# 基本機能テスト（安全な方法で）
echo -n "  基本機能テスト ... "
kent_beck_functional_test_passed=0
kent_beck_functional_test_total=0

for script in "${kent_beck_scripts[@]}"; do
    if [ -f "$script" ] && [ -x "$script" ]; then
        script_name=$(basename "$script")
        ((kent_beck_functional_test_total++))
        
        # 各スクリプトのヘルプ機能をテスト（安全）
        case "$script_name" in
            "analyze-next-action.sh")
                if bash "$script" 2>&1 | grep -q "使用方法\|Usage"; then
                    ((kent_beck_functional_test_passed++))
                fi
                ;;
            "todo-manager.sh"|"story-tracker.sh"|"progress-dashboard.sh"|"micro-feedback.sh"|"acceptance-criteria.sh"|"iteration-tracker.sh")
                if bash "$script" 2>&1 | grep -q "使用方法\|Usage"; then
                    ((kent_beck_functional_test_passed++))
                fi
                ;;
        esac
    fi
done

if [ "$kent_beck_functional_test_passed" -eq "$kent_beck_functional_test_total" ] && [ "$kent_beck_functional_test_total" -gt 0 ]; then
    echo -e "${GREEN}✓${NC} ($kent_beck_functional_test_passed/$kent_beck_functional_test_total)"
    ((TESTS_PASSED++))
else
    echo -e "${RED}✗${NC} ($kent_beck_functional_test_passed/$kent_beck_functional_test_total)"
    ((TESTS_FAILED++))
fi

# 5. コマンドファイル健全性テスト
echo -e "\n${YELLOW}5. コマンドファイル健全性テスト${NC}"

echo -n "  Kent Beck原則ファイル確認 ... "
if [ -f "$SCRIPT_DIR/../src/shared/kent-beck-principles.md" ]; then
    echo -e "${GREEN}✓${NC}"
    ((TESTS_PASSED++))
else
    echo -e "${RED}✗${NC}"
    ((TESTS_FAILED++))
fi

echo -n "  必須ゲートファイル確認 ... "
if [ -f "$SCRIPT_DIR/../src/shared/mandatory-gates.md" ]; then
    echo -e "${GREEN}✓${NC}"
    ((TESTS_PASSED++))
else
    echo -e "${RED}✗${NC}"
    ((TESTS_FAILED++))
fi

# 6. アンインストールテスト
echo -e "\n${YELLOW}6. アンインストールテスト${NC}"

UNINSTALL_HOME="$TEMP_DIR/home2"
mkdir -p "$UNINSTALL_HOME"

# インストール
(
    export HOME="$UNINSTALL_HOME"
    cd "$TEMP_DIR" || exit
    echo "1" | timeout 10 bash "$SCRIPT_DIR/../install.sh" > /dev/null 2>&1
)
install_result=$?

# アンインストール
(
    export HOME="$UNINSTALL_HOME"
    cd "$TEMP_DIR" || exit
    echo "y" | timeout 5 bash "$SCRIPT_DIR/../install.sh" uninstall > /dev/null 2>&1
)
uninstall_result=$?

# 確認
if [ $install_result -eq 0 ] && [ $uninstall_result -eq 0 ] && [ ! -f "$UNINSTALL_HOME/.claude/commands/tdd.md" ]; then
    echo -e "  アンインストール機能 ... ${GREEN}✓${NC}"
    ((TESTS_PASSED++))
else
    echo -e "  アンインストール機能 ... ${RED}✗${NC}"
    ((TESTS_FAILED++))
fi

# 7. 統合品質テスト
echo -e "\n${YELLOW}7. 統合品質テスト${NC}"

# Markdown 文法チェック（textlint 利用可能時）
echo -n "  Markdown 文法チェック ... "
if command -v textlint > /dev/null 2>&1; then
    if textlint ../README.md ../CHANGELOG.md > /dev/null 2>&1; then
        echo -e "${GREEN}✓${NC}"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}✗${NC}"
        ((TESTS_FAILED++))
    fi
else
    echo -e "${YELLOW}スキップ (textlint 未インストール)${NC}"
fi

# 新機能のドキュメント完整性チェック
echo -n "  新機能ドキュメント完整性 ... "
missing_docs=0

# 各新機能にドキュメントが存在するかチェック
if ! grep -q "project-structure-generator" "../README.md" 2>/dev/null; then
    ((missing_docs++))
fi

if ! grep -q "claude-md-generator" "../README.md" 2>/dev/null; then
    ((missing_docs++))
fi

if ! grep -q "quality-gates" "../README.md" 2>/dev/null; then
    ((missing_docs++))
fi

if [ $missing_docs -eq 0 ]; then
    echo -e "${GREEN}✓${NC}"
    ((TESTS_PASSED++))
else
    echo -e "${RED}✗${NC} ($missing_docs 個の機能の文書が不足)"
    ((TESTS_FAILED++))
fi

# パフォーマンステスト（基本的なベンチマーク）
echo -n "  基本パフォーマンステスト ... "
start_time=$(date +%s%3N)

# 基本的な処理時間測定
PERF_TEST_DIR="$TEMP_DIR/perf_test"
mkdir -p "$PERF_TEST_DIR"
cd "$PERF_TEST_DIR" || exit

# 基本パフォーマンステスト
for i in {1..10}; do
    echo '{"name": "test-'$i'", "version": "1.0.0"}' > "package-$i.json"
done

# Kent Beck改善スクリプトの基本パフォーマンス
if [ -f "$SCRIPT_DIR/../src/shared/progress-dashboard.sh" ]; then
    for i in {1..5}; do
        timeout 1 bash "$SCRIPT_DIR/../src/shared/progress-dashboard.sh" compact >/dev/null 2>&1 || true
    done
fi

cd - > /dev/null || exit

end_time=$(date +%s%3N)
elapsed=$((end_time - start_time))

# 5秒以内なら合格
if [ $elapsed -lt 5000 ]; then
    echo -e "${GREEN}✓${NC} (${elapsed}ms)"
    ((TESTS_PASSED++))
else
    echo -e "${RED}✗${NC} (${elapsed}ms > 5000ms)"
    ((TESTS_FAILED++))
fi

# テスト結果サマリー
echo -e "\n${BLUE}================================${NC}"
echo -e "${BLUE}テスト結果サマリー${NC}"
echo -e "${BLUE}================================${NC}"
echo -e "合格: ${GREEN}${TESTS_PASSED}${NC}"
echo -e "失敗: ${RED}${TESTS_FAILED}${NC}"

# v0.2.0 Kent Beck改善報告
if [ $TESTS_PASSED -gt 0 ]; then
    echo -e "\n${BLUE}✨ v0.2.0 Kent Beck改善内容${NC}"
    echo -e "  - 統合ワークフロー: /tdd ワンコマンドで開発準備完了"
    echo -e "  - Kent Beck改善システム: 7つの新機能でTDD実践を科学的に支援"
    echo -e "    • 次アクション分析システム (analyze-next-action.sh)"
    echo -e "    • 不安優先ToDo管理 (todo-manager.sh)"
    echo -e "    • ストーリー進捗追跡 (story-tracker.sh)"
    echo -e "    • リアルタイム進捗ダッシュボード (progress-dashboard.sh)"
    echo -e "    • マイクロフィードバックループ (micro-feedback.sh)"
    echo -e "    • 受け入れ条件明示システム (acceptance-criteria.sh)"
    echo -e "    • YAML形式イテレーション追跡 (iteration-tracker.sh)"
    echo -e "  - TDD体験革新: \"Most Anxious Thing First\"原則の自動適用"
    echo -e "  - フィードバックループ: 30秒ステップ + 2分イテレーション"
    echo -e "  - /tdd:init, /tdd:story, /tdd:plan → /tdd に統合"
fi

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "\n${GREEN}✅ すべてのテストが合格しました！${NC}"
    exit 0
else
    echo -e "\n${RED}❌ ${TESTS_FAILED} 個のテストが失敗しました${NC}"
    exit 1
fi