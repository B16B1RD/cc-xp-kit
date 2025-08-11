#!/bin/bash
# cc-xp-kit installer - Kent Beck哲学 + XPワークフローのインストーラー

set -e

# カラー定義
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# デフォルト設定
DEFAULT_BRANCH="main"
BRANCH=${CC_TDD_BRANCH:-$DEFAULT_BRANCH}
NON_INTERACTIVE=false
INSTALL_DIR=""
INSTALL_TYPE=""

# ヘルプ表示
show_help() {
    echo -e "${BLUE}🚀 cc-xp-kit インストーラー${NC}"
    echo ""
    echo "6つのXPスラッシュコマンドによる統合開発ワークフロー"
    echo ""
    echo "使用方法："
    echo "  bash install.sh [オプション]"
    echo ""
    echo "インストール先オプション："
    echo "  --project          プロジェクト用インストール (.claude/commands/)"
    echo "  --user             ユーザー用インストール (~/.claude/commands/)"
    echo "  --local, --dev     ローカル開発用 (.claude/commands/ のエイリアス)"
    echo ""
    echo "その他のオプション："
    echo "  -b, --branch BRANCH    インストール元のブランチを指定 (デフォルト: main)"
    echo "  -h, --help            このヘルプを表示"
    echo ""
    echo "環境変数："
    echo "  CC_TDD_BRANCH         インストール元のブランチ"
    echo ""
    echo "例："
    echo "  bash install.sh                          # インタラクティブ選択"
    echo "  bash install.sh --local                  # ローカル開発用（非対話）"
    echo "  bash install.sh --user                   # ユーザー用（非対話）"
    echo "  bash install.sh --local --branch develop # ブランチ指定と組み合わせ"
    echo "  CC_TDD_BRANCH=feature bash install.sh    # 環境変数でブランチ指定"
    echo ""
}

# 引数解析
while [[ $# -gt 0 ]]; do
    case $1 in
        -b|--branch)
            BRANCH="$2"
            shift 2
            ;;
        --user)
            INSTALL_DIR="$HOME/.claude/commands"
            INSTALL_TYPE="user"
            NON_INTERACTIVE=true
            shift
            ;;
        --project)
            INSTALL_DIR=".claude/commands"
            INSTALL_TYPE="project"
            NON_INTERACTIVE=true
            shift
            ;;
        --local|--dev)
            INSTALL_DIR=".claude/commands"
            INSTALL_TYPE="project"
            NON_INTERACTIVE=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo -e "${RED}❌ 不明なオプション: $1${NC}"
            echo "ヘルプを表示するには --help を使用してください。"
            exit 1
            ;;
    esac
done

echo -e "${BLUE}🚀 cc-xp-kit インストーラー${NC}"
echo -e "${BLUE}XP統合ワークフロー: plan → story → research → develop → review → retro${NC}"
if [ "$BRANCH" != "$DEFAULT_BRANCH" ]; then
    echo -e "${YELLOW}📋 ブランチ: $BRANCH${NC}"
fi
if [ "$NON_INTERACTIVE" = "true" ]; then
    echo -e "${BLUE}📁 インストール先: $INSTALL_TYPE${NC}"
fi
echo ""

# インストール先の選択（非対話モードでない場合のみ）
if [ "$NON_INTERACTIVE" != "true" ]; then
    echo "インストール先を選んでください："
    echo "1) プロジェクト用 (.claude/commands/) - 推奨"
    echo "2) ユーザー用 (~/.claude/commands/)"
    echo ""
    # パイプ実行対応: タイムアウトとデフォルト選択を追加
    read -t 10 -p "選択 (1 or 2) [デフォルト: 1]: " choice
    
    # 空入力またはタイムアウト時はデフォルト（プロジェクト用）を選択
    if [ -z "$choice" ]; then
        choice="1"
        echo "プロジェクト用インストールを選択しました"
    fi

    case $choice in
        1)
            INSTALL_DIR=".claude/commands"
            INSTALL_TYPE="project"
            ;;
        2)
            INSTALL_DIR="$HOME/.claude/commands"
            INSTALL_TYPE="user"
            ;;
        *)
            echo -e "${RED}無効な選択です: $choice${NC}"
            echo -e "${YELLOW}有効な選択肢: 1 (プロジェクト用) または 2 (ユーザー用)${NC}"
            echo -e "${YELLOW}デフォルトでプロジェクト用を選択します${NC}"
            INSTALL_DIR=".claude/commands"
            INSTALL_TYPE="project"
            ;;
    esac
fi

# ディレクトリ作成
echo -e "${BLUE}ディレクトリを作成中...${NC}"
mkdir -p "$INSTALL_DIR/cc-xp"

# cc-xp コマンドをインストール
echo -e "${BLUE}6つのXPコマンドをインストール中...${NC}"

# インストール用のソースディレクトリを特定
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# cc-xp コマンドファイル一覧
CC_XP_FILES=("plan.md" "story.md" "research.md" "develop.md" "review.md" "retro.md")

if [ -d "$SCRIPT_DIR/src/cc-xp" ]; then
    # ローカルファイルからコピー
    for file in "${CC_XP_FILES[@]}"; do
        if [ -f "$SCRIPT_DIR/src/cc-xp/$file" ]; then
            cp "$SCRIPT_DIR/src/cc-xp/$file" "$INSTALL_DIR/cc-xp/"
            echo -e "${BLUE}  ✓ cc-xp:${file%.md} をコピーしました${NC}"
        else
            echo -e "${YELLOW}  ⚠️ $file が見つかりません${NC}"
        fi
    done
    
    # テンプレートディレクトリをコピー
    if [ -d "$SCRIPT_DIR/src/cc-xp/templates" ]; then
        mkdir -p "$INSTALL_DIR/cc-xp/templates"
        cp -r "$SCRIPT_DIR/src/cc-xp/templates/"* "$INSTALL_DIR/cc-xp/templates/"
        echo -e "${BLUE}  ✓ 調査記録テンプレートをコピーしました${NC}"
    fi
    
elif [ -d "$(pwd)/src/cc-xp" ]; then
    # カレントディレクトリからコピー
    for file in "${CC_XP_FILES[@]}"; do
        if [ -f "$(pwd)/src/cc-xp/$file" ]; then
            cp "$(pwd)/src/cc-xp/$file" "$INSTALL_DIR/cc-xp/"
            echo -e "${BLUE}  ✓ cc-xp:${file%.md} をコピーしました${NC}"
        else
            echo -e "${YELLOW}  ⚠️ $file が見つかりません${NC}"
        fi
    done
    
    # テンプレートディレクトリをコピー
    if [ -d "$(pwd)/src/cc-xp/templates" ]; then
        mkdir -p "$INSTALL_DIR/cc-xp/templates"
        cp -r "$(pwd)/src/cc-xp/templates/"* "$INSTALL_DIR/cc-xp/templates/"
        echo -e "${BLUE}  ✓ 調査記録テンプレートをコピーしました${NC}"
    fi
else
    # GitHub raw URLから直接ダウンロード
    echo -e "${BLUE}GitHubからダウンロード中...${NC}"
    BASE_URL="https://raw.githubusercontent.com/B16B1RD/cc-xp-kit/${BRANCH}/src/cc-xp"
    
    if [ "$BRANCH" != "$DEFAULT_BRANCH" ]; then
        echo -e "${YELLOW}📁 ブランチ: $BRANCH${NC}"
    fi
    
    # ブランチ存在確認と各ファイルダウンロード
    download_success=true
    
    for file in "${CC_XP_FILES[@]}"; do
        if curl -fsSL --head "$BASE_URL/$file" >/dev/null 2>&1; then
            curl -fsSL "$BASE_URL/$file" -o "$INSTALL_DIR/cc-xp/$file"
            
            if [ ! -f "$INSTALL_DIR/cc-xp/$file" ] || [ ! -s "$INSTALL_DIR/cc-xp/$file" ]; then
                echo -e "${RED}❌ $file のダウンロードに失敗しました${NC}"
                download_success=false
            else
                echo -e "${BLUE}  ✓ cc-xp:${file%.md} をダウンロードしました${NC}"
            fi
        else
            echo -e "${YELLOW}⚠️ $file が見つかりません（スキップ）${NC}"
        fi
    done
    
    # テンプレートディレクトリをダウンロード
    echo -e "${BLUE}調査記録テンプレートをダウンロード中...${NC}"
    TEMPLATE_FILES=("research-specifications.md" "research-implementation.md" "research-references.md" "research-decisions.md")
    TEMPLATE_URL="https://raw.githubusercontent.com/B16B1RD/cc-xp-kit/${BRANCH}/src/cc-xp/templates"
    
    mkdir -p "$INSTALL_DIR/cc-xp/templates"
    template_success=true
    
    for template in "${TEMPLATE_FILES[@]}"; do
        if curl -fsSL --head "$TEMPLATE_URL/$template" >/dev/null 2>&1; then
            curl -fsSL "$TEMPLATE_URL/$template" -o "$INSTALL_DIR/cc-xp/templates/$template"
            
            if [ -f "$INSTALL_DIR/cc-xp/templates/$template" ] && [ -s "$INSTALL_DIR/cc-xp/templates/$template" ]; then
                echo -e "${BLUE}  ✓ $template をダウンロードしました${NC}"
            else
                echo -e "${YELLOW}  ⚠️ $template のダウンロードに失敗しました${NC}"
                template_success=false
            fi
        else
            echo -e "${YELLOW}  ⚠️ $template が見つかりません（スキップ）${NC}"
        fi
    done
    
    if [ "$template_success" = "true" ]; then
        echo -e "${BLUE}  ✓ 調査記録テンプレートをダウンロードしました${NC}"
    fi
    
    if [ "$download_success" = "false" ]; then
        echo -e "${RED}❌ 一部ファイルのダウンロードに失敗しました${NC}"
        echo -e "${YELLOW}💡 ブランチ '$BRANCH' を確認してください${NC}"
        echo "   例: main, develop, feature/branch-name"
        exit 1
    fi
fi

# 完了メッセージ
echo ""
echo -e "${GREEN}✅ cc-xp-kit インストール完了！${NC}"
echo ""
echo "📋 インストールされた6つのXPコマンド："
for file in "${CC_XP_FILES[@]}"; do
    if [ -f "$INSTALL_DIR/cc-xp/$file" ]; then
        command_name="${file%.md}"
        echo -e "${BLUE}  ✓ /cc-xp:${command_name}${NC}"
    fi
done
echo ""
echo "🔄 XP統合ワークフロー："
echo -e "${BLUE}1. /cc-xp:plan \"作りたいもの\"${NC}     → 計画立案（YAGNI原則）"
echo -e "${BLUE}2. /cc-xp:story${NC}                  → ユーザーストーリー詳細化"
echo -e "${BLUE}3. /cc-xp:research${NC}               → 技術調査・仕様確認（新機能）"
echo -e "${BLUE}4. /cc-xp:develop${NC}                → TDD実装（Red→Green→Refactor）"
echo -e "${BLUE}5. /cc-xp:review [accept/reject]${NC}  → 動作確認とフィードバック"
echo -e "${BLUE}6. /cc-xp:retro${NC}                  → 振り返りと継続的改善"
echo ""
echo "💡 使用例："
echo "  /cc-xp:plan \"ウェブブラウザで遊べるテトリスが欲しい\""
echo "  /cc-xp:story"
echo "  /cc-xp:research"
echo "  /cc-xp:develop"
echo "  /cc-xp:review accept"
echo "  /cc-xp:retro"
echo ""
echo "🛠️ モダンツールチェーン対応："
echo "  JavaScript/TypeScript: Bun, pnpm + Vite"
echo "  Python: uv + Ruff + pytest"
echo "  Rust: Cargo, Go: Go modules"
echo ""
if [ "$BRANCH" != "$DEFAULT_BRANCH" ]; then
    echo -e "${YELLOW}📋 インストール元: $BRANCH ブランチ${NC}"
    echo ""
fi
echo -e "${GREEN}Kent Beck XP + TDD統合開発を実践しましょう！${NC}"
echo -e "${GREEN}小さく始めて、継続的にフィードバックを得る。それがXPの本質です。${NC}"