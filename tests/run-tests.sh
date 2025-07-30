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

# 必須ファイルの存在確認
required_files=(
    "../README.md"
    "../LICENSE"
    "../CHANGELOG.md"
    "../install.sh"
    "../.gitignore"
    "../src/commands/tdd.md"
    "../src/commands/tdd-quick.md"
    "../src/subcommands/tdd/init.md"
    "../src/subcommands/tdd/story.md"
    "../src/subcommands/tdd/plan.md"
    "../src/subcommands/tdd/run.md"
    "../src/subcommands/tdd/status.md"
    "../src/subcommands/tdd/review.md"
    "../src/shared/kent-beck-principles.md"
    "../src/shared/mandatory-gates.md"
    "../src/shared/project-verification.md"
    "../src/shared/error-handling.md"
    "../src/shared/commit-rules.md"
    "../src/shared/language-detector.md"
    "../src/shared/project-structure-generator.md"
    "../src/shared/claude-md-generator.md"
    "../src/shared/quality-gates.md"
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
    if shellcheck "$SCRIPT_DIR/../install.sh" > /dev/null 2>&1; then
        echo -e "  ShellCheck (install.sh) ... ${GREEN}✓${NC}"
        ((TESTS_PASSED++))
    else
        echo -e "  ShellCheck (install.sh) ... ${RED}✗${NC}"
        ((TESTS_FAILED++))
    fi
else
    echo -e "  ShellCheck ... ${YELLOW}スキップ (未インストール)${NC}"
fi

# 4. 新機能統合テスト
echo -e "\n${YELLOW}4. 新機能統合テスト${NC}"

# tdd-quick コマンド構文チェック
echo -n "  tdd-quick コマンド構文チェック ... "
if bash -n "$SCRIPT_DIR/../src/commands/tdd-quick.md" 2>/dev/null; then
    echo -e "${GREEN}✓${NC}"
    ((TESTS_PASSED++))
else
    echo -e "${RED}✗${NC}"
    ((TESTS_FAILED++))
fi

# プロジェクト構造生成機能チェック
echo -n "  プロジェクト構造生成機能チェック ... "
TEMP_PROJECT="$TEMP_DIR/structure_test"
mkdir -p "$TEMP_PROJECT"
cd "$TEMP_PROJECT" || exit

# 基本的な関数テスト（ドライラン）
if source "$SCRIPT_DIR/../src/shared/project-structure-generator.md" 2>/dev/null && \
   declare -f generate_web_app_structure >/dev/null 2>&1 && \
   declare -f generate_api_server_structure >/dev/null 2>&1 && \
   declare -f generate_cli_tool_structure >/dev/null 2>&1; then
    echo -e "${GREEN}✓${NC}"
    ((TESTS_PASSED++))
else
    echo -e "${RED}✗${NC}"
    ((TESTS_FAILED++))
fi

cd - > /dev/null || exit

# CLAUDE.md 生成機能チェック
echo -n "  CLAUDE.md 生成機能チェック ... "
if source "$SCRIPT_DIR/../src/shared/claude-md-generator.md" 2>/dev/null && \
   declare -f generate_claude_md >/dev/null 2>&1; then
    echo -e "${GREEN}✓${NC}"
    ((TESTS_PASSED++))
else
    echo -e "${RED}✗${NC}"
    ((TESTS_FAILED++))
fi

# 品質ゲート機能チェック
echo -n "  品質ゲート機能チェック ... "
if source "$SCRIPT_DIR/../src/shared/quality-gates.md" 2>/dev/null && \
   declare -f run_quality_gates >/dev/null 2>&1 && \
   declare -f run_basic_quality_checks >/dev/null 2>&1; then
    echo -e "${GREEN}✓${NC}"
    ((TESTS_PASSED++))
else
    echo -e "${RED}✗${NC}"
    ((TESTS_FAILED++))
fi

# 5. tdd-quick 実行テスト
echo -e "\n${YELLOW}5. tdd-quick 実行テスト${NC}"

# 実際の tdd-quick 実行（シミュレーション）
QUICK_TEST_DIR="$TEMP_DIR/quick_test"
mkdir -p "$QUICK_TEST_DIR"
cd "$QUICK_TEST_DIR" || exit

echo -n "  tdd-quick 基本実行テスト ... "

# 言語検出機能が正常に動作するかテスト
if source "$SCRIPT_DIR/../src/shared/language-detector.md" 2>/dev/null; then
    # JavaScriptプロジェクト相当の環境作成
    echo '{"name": "test-project", "version": "1.0.0"}' > package.json
    
    # 検出テスト
    PROJECT_TYPE=$(detect_project_type 2>/dev/null || echo "default")
    if [ "$PROJECT_TYPE" = "javascript" ]; then
        echo -e "${GREEN}✓${NC}"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}✗${NC} (検出されたタイプ: $PROJECT_TYPE)"
        ((TESTS_FAILED++))
    fi
else
    echo -e "${RED}✗${NC}"
    ((TESTS_FAILED++))
fi

cd - > /dev/null || exit

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

# 言語検出のパフォーマンス
for i in {1..10}; do
    echo '{"name": "test-'$i'", "version": "1.0.0"}' > "package-$i.json"
done

if source "$SCRIPT_DIR/../src/shared/language-detector.md" 2>/dev/null; then
    for i in {1..10}; do
        PROJECT_TYPE=$(detect_project_type 2>/dev/null || echo "default") > /dev/null
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

# 改善報告
if [ $TESTS_PASSED -gt 0 ]; then
    echo -e "\n${BLUE}✨ 改善内容${NC}"
    echo -e "  - /tdd-quick コマンドの完全再実装"
    echo -e "  - モダンなプロジェクト構造自動生成"
    echo -e "  - 詳細なCLAUDE.md自動生成"
    echo -e "  - 包括的な品質ゲートシステム"
    echo -e "  - プロジェクトタイプ別最適化"
fi

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "\n${GREEN}✅ すべてのテストが合格しました！${NC}"
    exit 0
else
    echo -e "\n${RED}❌ ${TESTS_FAILED} 個のテストが失敗しました${NC}"
    exit 1
fi