#!/bin/bash
# cc-xp-kit インストールテスト

set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "🧪 cc-xp-kit インストールテストを開始"

# テスト用の一時ディレクトリ
SCRIPT_HOME="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEST_DIR="$SCRIPT_HOME/test-install-$$"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

# プロジェクト用インストールテスト
echo "📂 プロジェクト用インストールテスト..."

# xp ファイル一覧
XP_FILES=("discovery.md" "design.md" "scaffold.md" "tdd.md" "cicd.md" "preview.md" "review.md" "retro.md" "doc.md")

# src/.claude/commands/xp/ ディレクトリの存在確認
if [ ! -d "$SCRIPT_HOME/src/.claude/commands/xp" ]; then
    echo -e "${RED}❌ src/.claude/commands/xp/ ディレクトリが見つかりません${NC}"
    exit 1
fi

# 各ファイルの存在確認
for file in "${XP_FILES[@]}"; do
    if [ ! -f "$SCRIPT_HOME/src/.claude/commands/xp/$file" ]; then
        echo -e "${RED}❌ src/.claude/commands/xp/$file が見つかりません${NC}"
        exit 1
    fi
done

# 非対話モードでインストール
bash "$SCRIPT_HOME/install.sh" --project >/dev/null 2>&1

# 各xpファイルの存在チェック
all_files_installed=true
for file in "${XP_FILES[@]}"; do
    if [ -f ".claude/commands/xp/$file" ]; then
        command_name="${file%.md}"
        echo -e "${GREEN}✅ xp:${command_name} が正常にインストールされました${NC}"
    else
        echo -e "${RED}❌ $file のインストールに失敗しました${NC}"
        all_files_installed=false
    fi
done

if [ "$all_files_installed" = "false" ]; then
    exit 1
fi

# ファイル内容チェック（各ファイルのキーワード確認）
echo ""
echo -e "${BLUE}📋 ファイル内容チェック...${NC}"

# discovery.md の内容確認
if grep -q "Intent Model" ".claude/commands/xp/discovery.md" && grep -q "capabilities" ".claude/commands/xp/discovery.md"; then
    echo -e "${GREEN}✅ discovery.md の内容が正しいです${NC}"
else
    echo -e "${RED}❌ discovery.md の内容が不正です${NC}"
    exit 1
fi

# design.md の内容確認
if grep -q "C4" ".claude/commands/xp/design.md" && grep -q "ADR" ".claude/commands/xp/design.md"; then
    echo -e "${GREEN}✅ design.md の内容が正しいです${NC}"
else
    echo -e "${RED}❌ design.md の内容が不正です${NC}"
    exit 1
fi

# tdd.md の内容確認
if grep -q "Red→Green→Refactor" ".claude/commands/xp/tdd.md" && grep -q "TDD" ".claude/commands/xp/tdd.md"; then
    echo -e "${GREEN}✅ tdd.md の内容が正しいです${NC}"
else
    echo -e "${RED}❌ tdd.md の内容が不正です${NC}"
    exit 1
fi

# review.md の内容確認
if grep -q "レビュー" ".claude/commands/xp/review.md" && grep -q "accept" ".claude/commands/xp/review.md"; then
    echo -e "${GREEN}✅ review.md の内容が正しいです${NC}"
else
    echo -e "${RED}❌ review.md の内容が不正です${NC}"
    exit 1
fi

# retro.md の内容確認
if grep -q "振り返り" ".claude/commands/xp/retro.md" && grep -q "メトリクス" ".claude/commands/xp/retro.md"; then
    echo -e "${GREEN}✅ retro.md の内容が正しいです${NC}"
else
    echo -e "${RED}❌ retro.md の内容が不正です${NC}"
    exit 1
fi

# XPワークフロー整合性テスト
echo ""
echo -e "${BLUE}🔄 XPワークフロー整合性テスト...${NC}"

# 各ファイルに期待される次コマンドが記載されているかチェック
if grep -q "/xp:design" ".claude/commands/xp/discovery.md"; then
    echo -e "${GREEN}✅ discovery.md → design ワークフローが正しく記載されています${NC}"
fi

if grep -q "/xp:scaffold" ".claude/commands/xp/design.md"; then
    echo -e "${GREEN}✅ design → scaffold ワークフローが正しく記載されています${NC}"
fi

if grep -q "/xp:tdd" ".claude/commands/xp/scaffold.md"; then
    echo -e "${GREEN}✅ scaffold → tdd ワークフローが正しく記載されています${NC}"
fi

if grep -q "/xp:preview" ".claude/commands/xp/tdd.md"; then
    echo -e "${GREEN}✅ tdd → preview ワークフローが正しく記載されています${NC}"
fi

if grep -q "/xp:review" ".claude/commands/xp/preview.md"; then
    echo -e "${GREEN}✅ preview → review ワークフローが正しく記載されています${NC}"
fi

# インストーラー機能テスト
echo ""
echo -e "${BLUE}📋 インストーラー機能テスト...${NC}"

# ヘルプ表示テスト
if bash "$SCRIPT_HOME/install.sh" --help >/dev/null 2>&1; then
    echo -e "${GREEN}✅ ヘルプ表示が正常に動作します${NC}"
else
    echo -e "${RED}❌ ヘルプ表示でエラーが発生しました${NC}"
    exit 1
fi

# 無効な引数テスト
if bash "$SCRIPT_HOME/install.sh" --invalid-option 2>&1 | grep -q "不明なオプション"; then
    echo -e "${GREEN}✅ 無効な引数のエラーハンドリングが正常です${NC}"
else
    echo -e "${RED}❌ 無効な引数のエラーハンドリングに問題があります${NC}"
    exit 1
fi

# 非対話モードテスト（--project）
echo ""
echo -e "${BLUE}📂 非対話モード（--project）テスト...${NC}"

# ローカルテスト用ディレクトリ
TEST_DIR_LOCAL="$SCRIPT_HOME/test-local-$$"
mkdir -p "$TEST_DIR_LOCAL"
cd "$TEST_DIR_LOCAL"

# xp ファイルが正しくインストールされるかテスト
if bash "$SCRIPT_HOME/install.sh" --project >/dev/null 2>&1; then
    # 9つのファイルすべてがインストールされているかチェック
    local_test_success=true
    for file in "${XP_FILES[@]}"; do
        if [ ! -f ".claude/commands/xp/$file" ]; then
            echo -e "${RED}❌ --project インストールで $file が見つかりません${NC}"
            local_test_success=false
        fi
    done
    
    if [ "$local_test_success" = "true" ]; then
        echo -e "${GREEN}✅ --project オプションが正常に動作します（9ファイル確認）${NC}"
    else
        cd "$SCRIPT_HOME"
        rm -rf "$TEST_DIR_LOCAL"
        exit 1
    fi
else
    echo -e "${RED}❌ --project オプションでエラーが発生しました${NC}"
    cd "$SCRIPT_HOME"
    rm -rf "$TEST_DIR_LOCAL"
    exit 1
fi

cd "$SCRIPT_HOME"
rm -rf "$TEST_DIR_LOCAL"

# XPワークフローテストは最初のテストで実行済み

# クリーンアップ
cd "$SCRIPT_HOME"
rm -rf "$TEST_DIR"

echo ""
echo -e "${GREEN}🎉 cc-xp-kit のすべてのテストが通りました！${NC}"
echo -e "${GREEN}9つのXPワークフローが正常にインストール・設定されています。${NC}"