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

# cc-xp ファイル一覧
CC_XP_FILES=("plan.md" "story.md" "develop.md" "review.md" "retro.md")

# src/cc-xp/ ディレクトリの存在確認
if [ ! -d "$SCRIPT_HOME/src/cc-xp" ]; then
    echo -e "${RED}❌ src/cc-xp/ ディレクトリが見つかりません${NC}"
    exit 1
fi

# 各ファイルの存在確認
for file in "${CC_XP_FILES[@]}"; do
    if [ ! -f "$SCRIPT_HOME/src/cc-xp/$file" ]; then
        echo -e "${RED}❌ src/cc-xp/$file が見つかりません${NC}"
        exit 1
    fi
done

# 非対話モードでインストール
bash "$SCRIPT_HOME/install.sh" --project >/dev/null 2>&1

# 各cc-xpファイルの存在チェック
all_files_installed=true
for file in "${CC_XP_FILES[@]}"; do
    if [ -f ".claude/commands/$file" ]; then
        command_name="${file%.md}"
        echo -e "${GREEN}✅ cc-xp:${command_name} が正常にインストールされました${NC}"
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

# plan.md の内容確認
if grep -q "XP plan" ".claude/commands/plan.md" && grep -q "YAGNI原則" ".claude/commands/plan.md"; then
    echo -e "${GREEN}✅ plan.md の内容が正しいです${NC}"
else
    echo -e "${RED}❌ plan.md の内容が不正です${NC}"
    exit 1
fi

# story.md の内容確認
if grep -q "XP story" ".claude/commands/story.md" && grep -q "対話重視" ".claude/commands/story.md"; then
    echo -e "${GREEN}✅ story.md の内容が正しいです${NC}"
else
    echo -e "${RED}❌ story.md の内容が不正です${NC}"
    exit 1
fi

# develop.md の内容確認
if grep -q "XP develop" ".claude/commands/develop.md" && grep -q "Red→Green→Refactor" ".claude/commands/develop.md"; then
    echo -e "${GREEN}✅ develop.md の内容が正しいです${NC}"
else
    echo -e "${RED}❌ develop.md の内容が不正です${NC}"
    exit 1
fi

# review.md の内容確認
if grep -q "XP review" ".claude/commands/review.md" && grep -q "動作確認" ".claude/commands/review.md"; then
    echo -e "${GREEN}✅ review.md の内容が正しいです${NC}"
else
    echo -e "${RED}❌ review.md の内容が不正です${NC}"
    exit 1
fi

# retro.md の内容確認
if grep -q "XP retro" ".claude/commands/retro.md" && grep -q "継続的改善" ".claude/commands/retro.md"; then
    echo -e "${GREEN}✅ retro.md の内容が正しいです${NC}"
else
    echo -e "${RED}❌ retro.md の内容が不正です${NC}"
    exit 1
fi

# XPワークフロー整合性テスト
echo ""
echo -e "${BLUE}🔄 XPワークフロー整合性テスト...${NC}"

# 各ファイルに期待される次コマンドが記載されているかチェック
if grep -q "/cc-xp:story" ".claude/commands/plan.md"; then
    echo -e "${GREEN}✅ plan.md → story ワークフローが正しく記載されています${NC}"
fi

if grep -q "/cc-xp:develop" ".claude/commands/story.md"; then
    echo -e "${GREEN}✅ story → develop ワークフローが正しく記載されています${NC}"
fi

if grep -q "/cc-xp:review" ".claude/commands/develop.md"; then
    echo -e "${GREEN}✅ develop → review ワークフローが正しく記載されています${NC}"
fi

if grep -q "/cc-xp:retro" ".claude/commands/review.md"; then
    echo -e "${GREEN}✅ review → retro ワークフローが正しく記載されています${NC}"
fi

if grep -q "/cc-xp:plan" ".claude/commands/retro.md"; then
    echo -e "${GREEN}✅ retro → plan サイクルが正しく記載されています${NC}"
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

# 非対話モードテスト（--local）
echo ""
echo -e "${BLUE}📂 非対話モード（--local）テスト...${NC}"

# ローカルテスト用ディレクトリ
TEST_DIR_LOCAL="$SCRIPT_HOME/test-local-$$"
mkdir -p "$TEST_DIR_LOCAL"
cd "$TEST_DIR_LOCAL"

# cc-xp ファイルが正しくインストールされるかテスト
if bash "$SCRIPT_HOME/install.sh" --local >/dev/null 2>&1; then
    # 5つのファイルすべてがインストールされているかチェック
    local_test_success=true
    for file in "${CC_XP_FILES[@]}"; do
        if [ ! -f ".claude/commands/$file" ]; then
            echo -e "${RED}❌ --local インストールで $file が見つかりません${NC}"
            local_test_success=false
        fi
    done
    
    if [ "$local_test_success" = "true" ]; then
        echo -e "${GREEN}✅ --local オプションが正常に動作します（5ファイル確認）${NC}"
    else
        cd "$SCRIPT_HOME"
        rm -rf "$TEST_DIR_LOCAL"
        exit 1
    fi
else
    echo -e "${RED}❌ --local オプションでエラーが発生しました${NC}"
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
echo -e "${GREEN}5つのXPワークフローが正常にインストール・設定されています。${NC}"