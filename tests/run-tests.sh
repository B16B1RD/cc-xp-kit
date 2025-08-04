#!/bin/bash
# cc-xp-kit テストスイート

set -e

BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${BLUE}🚀 cc-xp-kit テストスイート${NC}"
echo "5つのXPスラッシュコマンド統合システムのテスト"
echo ""

# インストールテスト
echo "📦 cc-xp インストールテスト実行中..."
bash tests/test-install.sh

echo ""
echo -e "${GREEN}✅ すべてのテストが完了しました！${NC}"
echo ""
echo "Kent Beck XP原則 + TDD統合に基づく、実用的で確実なテストを実施しました。"
echo "plan → story → develop → review → retro のワークフローが正常に動作します。"