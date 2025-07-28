#!/bin/bash
set -e

# cc-tdd-kit リリーススクリプト
# 使用方法: ./scripts/release.sh <version>
# 例: ./scripts/release.sh 0.2.0

# カラー定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# バージョンの検証
if [ $# -ne 1 ]; then
    echo -e "${RED}使用方法: $0 <version>${NC}"
    echo "例: $0 0.2.0"
    exit 1
fi

NEW_VERSION="$1"

# セマンティックバージョンの形式チェック
if ! echo "$NEW_VERSION" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$'; then
    echo -e "${RED}エラー: バージョンはSemantic Versioning形式 (x.y.z) で指定してください${NC}"
    exit 1
fi

echo -e "${BLUE}🚀 cc-tdd-kit v${NEW_VERSION} のリリースを開始します${NC}"

# 現在のバージョンを取得
CURRENT_VERSION=$(grep 'VERSION=' install.sh | cut -d'"' -f2)
echo -e "現在のバージョン: ${YELLOW}${CURRENT_VERSION}${NC}"
echo -e "新しいバージョン: ${GREEN}${NEW_VERSION}${NC}"

# 確認
echo
read -p "リリースを続行しますか? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "リリースをキャンセルしました。"
    exit 1
fi

# 1. バージョン更新
echo -e "\n${BLUE}📝 バージョン更新中...${NC}"
sed -i.bak "s/VERSION=\"${CURRENT_VERSION}\"/VERSION=\"${NEW_VERSION}\"/" install.sh
rm -f install.sh.bak
echo -e "${GREEN}✅ install.sh のバージョンを更新しました${NC}"

# 2. CHANGELOG.md の更新準備
echo -e "\n${BLUE}📚 CHANGELOG.md の更新準備...${NC}"
RELEASE_DATE=$(date +"%Y-%m-%d")

# CHANGELOGの更新（手動編集用のメッセージ）
echo -e "${YELLOW}⚠️  手動作業が必要です:${NC}"
echo "1. CHANGELOG.md を編集してください"
echo "   - [Unreleased] の内容を [${NEW_VERSION}] - ${RELEASE_DATE} に移動"
echo "   - 新しい [Unreleased] セクションを作成"
echo "2. 編集完了後、Enterキーを押してください"
read -p "CHANGELOG.md の編集が完了しましたか? (Enter で続行): "

# 3. Git操作
echo -e "\n${BLUE}📦 Git操作を実行中...${NC}"

# ステージング
git add install.sh CHANGELOG.md

# コミット
git commit -m "[RELEASE] Prepare for version ${NEW_VERSION}

- Update version in install.sh to ${NEW_VERSION}
- Update CHANGELOG.md with release notes"

echo -e "${GREEN}✅ リリースコミットを作成しました${NC}"

# タグ作成
git tag -a "v${NEW_VERSION}" -m "Release version ${NEW_VERSION}"
echo -e "${GREEN}✅ Git タグ v${NEW_VERSION} を作成しました${NC}"

# 4. 確認
echo -e "\n${BLUE}🔍 リリース内容の確認${NC}"
echo "バージョン: v${NEW_VERSION}"
echo "リリース日: ${RELEASE_DATE}"
echo

# 5. プッシュの確認
echo -e "${YELLOW}⚠️  次の操作を手動で実行してください:${NC}"
echo "1. mainブランチにマージ:"
echo "   git checkout main"
echo "   git merge feature/improve-slash-commands"
echo
echo "2. リモートにプッシュ:"
echo "   git push origin main"
echo "   git push origin v${NEW_VERSION}"
echo
echo "3. GitHub Releases でリリースノートを作成"
echo
echo "4. インストールスクリプトのテスト:"
echo "   curl -fsSL https://raw.githubusercontent.com/B16B1RD/cc-tdd-kit/main/install.sh | bash"

echo -e "\n${GREEN}🎉 リリース準備が完了しました！${NC}"
echo -e "上記の手動作業を完了してリリースを確定してください。"