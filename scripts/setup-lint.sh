#!/bin/bash
set -e

# cc-tdd-kit Lint環境セットアップスクリプト

# カラー定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔧 cc-tdd-kit Lint環境をセットアップ中...${NC}"

# Node.js の存在確認
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js が見つかりません。Node.js をインストールしてください。${NC}"
    exit 1
fi

# npm の存在確認
if ! command -v npm &> /dev/null; then
    echo -e "${RED}❌ npm が見つかりません。npm をインストールしてください。${NC}"
    exit 1
fi

# 依存関係のインストール
echo -e "${BLUE}📦 依存関係をインストール中...${NC}"
npm install

# pre-commitフックのセットアップ
echo -e "${BLUE}🪝 pre-commitフックをセットアップ中...${NC}"
if [ ! -f ".git/hooks/pre-commit" ]; then
    cp scripts/pre-commit-template .git/hooks/pre-commit
    chmod +x .git/hooks/pre-commit
    echo -e "${GREEN}✅ pre-commitフックを作成しました${NC}"
else
    echo -e "${YELLOW}⚠️  pre-commitフックは既に存在します${NC}"
fi

# 初回lint実行
echo -e "\n${BLUE}🔍 初回lintチェックを実行中...${NC}"
if npm run lint; then
    echo -e "${GREEN}✅ すべてのlintチェックが通りました！${NC}"
else
    echo -e "${YELLOW}⚠️  lintエラーが検出されました。以下のコマンドで修正できる場合があります:${NC}"
    echo -e "  ${BLUE}npm run lint:fix${NC}"
    echo -e "\n手動修正が必要な場合は、個別に対応してください。"
fi

echo -e "\n${GREEN}🎉 Lint環境のセットアップが完了しました！${NC}"
echo
echo -e "${BLUE}利用可能なコマンド:${NC}"
echo -e "  ${YELLOW}npm run lint${NC}        - 全lintチェック実行"
echo -e "  ${YELLOW}npm run lint:md${NC}     - Markdownlintのみ実行"
echo -e "  ${YELLOW}npm run lint:text${NC}   - textlintのみ実行"
echo -e "  ${YELLOW}npm run lint:fix${NC}    - 自動修正可能な問題を修正"
echo
echo -e "${BLUE}注意:${NC} 今後のコミット時は自動的にlintチェックが実行されます。"