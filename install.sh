#!/bin/bash
# cc-xp-kit installer - Intent Model駆動XPワークフローのインストーラー

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
    echo "9つのXPスラッシュコマンドによるIntent Model駆動開発"
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
echo -e "${BLUE}Intent Model駆動XP: discovery → design → scaffold → tdd → cicd → preview → review → retro${NC}"
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
mkdir -p "$INSTALL_DIR/xp"
mkdir -p "$INSTALL_DIR/../agents"

# xp コマンドをインストール
echo -e "${BLUE}9つのXPコマンドをインストール中...${NC}"

# インストール用のソースディレクトリを特定
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# xp コマンドファイル一覧
XP_FILES=("discovery.md" "design.md" "scaffold.md" "tdd.md" "cicd.md" "preview.md" "review.md" "retro.md" "doc.md")
AGENT_FILES=("intake-classifier.md" "architect.md" "scaffolder.md" "tdd-dev.md" "devops.md" "previewer.md" "reviewer.md" "requirements-engineer.md")

if [ -d "$SCRIPT_DIR/src/.claude/commands/xp" ]; then
    # ローカルファイルからコピー
    for file in "${XP_FILES[@]}"; do
        if [ -f "$SCRIPT_DIR/src/.claude/commands/xp/$file" ]; then
            cp "$SCRIPT_DIR/src/.claude/commands/xp/$file" "$INSTALL_DIR/xp/"
            echo -e "${BLUE}  ✓ xp:${file%.md} をコピーしました${NC}"
        else
            echo -e "${YELLOW}  ⚠️ $file が見つかりません${NC}"
        fi
    done
    
    # サブエージェントファイルをコピー
    for file in "${AGENT_FILES[@]}"; do
        if [ -f "$SCRIPT_DIR/src/.claude/agents/$file" ]; then
            cp "$SCRIPT_DIR/src/.claude/agents/$file" "$INSTALL_DIR/../agents/"
            echo -e "${BLUE}  ✓ agent:${file%.md} をコピーしました${NC}"
        else
            echo -e "${YELLOW}  ⚠️ $file が見つかりません${NC}"
        fi
    done
    
elif [ -d "$(pwd)/src/.claude/commands/xp" ]; then
    # カレントディレクトリからコピー
    for file in "${XP_FILES[@]}"; do
        if [ -f "$(pwd)/src/.claude/commands/xp/$file" ]; then
            cp "$(pwd)/src/.claude/commands/xp/$file" "$INSTALL_DIR/xp/"
            echo -e "${BLUE}  ✓ xp:${file%.md} をコピーしました${NC}"
        else
            echo -e "${YELLOW}  ⚠️ $file が見つかりません${NC}"
        fi
    done
    
    # サブエージェントファイルをコピー
    for file in "${AGENT_FILES[@]}"; do
        if [ -f "$(pwd)/src/.claude/agents/$file" ]; then
            cp "$(pwd)/src/.claude/agents/$file" "$INSTALL_DIR/../agents/"
            echo -e "${BLUE}  ✓ agent:${file%.md} をコピーしました${NC}"
        else
            echo -e "${YELLOW}  ⚠️ $file が見つかりません${NC}"
        fi
    done
else
    # GitHub raw URLから直接ダウンロード
    echo -e "${BLUE}GitHubからダウンロード中...${NC}"
    BASE_URL="https://raw.githubusercontent.com/B16B1RD/cc-xp-kit/${BRANCH}/src/.claude/commands/xp"
    AGENT_URL="https://raw.githubusercontent.com/B16B1RD/cc-xp-kit/${BRANCH}/src/.claude/agents"
    
    if [ "$BRANCH" != "$DEFAULT_BRANCH" ]; then
        echo -e "${YELLOW}📁 ブランチ: $BRANCH${NC}"
    fi
    
    # ブランチ存在確認と各ファイルダウンロード
    download_success=true
    
    # XPコマンドファイルをダウンロード
    for file in "${XP_FILES[@]}"; do
        if curl -fsSL --head "$BASE_URL/$file" >/dev/null 2>&1; then
            curl -fsSL "$BASE_URL/$file" -o "$INSTALL_DIR/xp/$file"
            
            if [ ! -f "$INSTALL_DIR/xp/$file" ] || [ ! -s "$INSTALL_DIR/xp/$file" ]; then
                echo -e "${RED}❌ $file のダウンロードに失敗しました${NC}"
                download_success=false
            else
                echo -e "${BLUE}  ✓ xp:${file%.md} をダウンロードしました${NC}"
            fi
        else
            echo -e "${YELLOW}⚠️ $file が見つかりません（スキップ）${NC}"
        fi
    done
    
    # サブエージェントファイルをダウンロード
    for file in "${AGENT_FILES[@]}"; do
        if curl -fsSL --head "$AGENT_URL/$file" >/dev/null 2>&1; then
            curl -fsSL "$AGENT_URL/$file" -o "$INSTALL_DIR/../agents/$file"
            
            if [ ! -f "$INSTALL_DIR/../agents/$file" ] || [ ! -s "$INSTALL_DIR/../agents/$file" ]; then
                echo -e "${RED}❌ $file のダウンロードに失敗しました${NC}"
                download_success=false
            else
                echo -e "${BLUE}  ✓ agent:${file%.md} をダウンロードしました${NC}"
            fi
        else
            echo -e "${YELLOW}⚠️ $file が見つかりません（スキップ）${NC}"
        fi
    done
    
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
echo "📋 インストールされた9つのXPコマンド："
for file in "${XP_FILES[@]}"; do
    if [ -f "$INSTALL_DIR/xp/$file" ]; then
        command_name="${file%.md}"
        echo -e "${BLUE}  ✓ /xp:${command_name}${NC}"
    fi
done
echo ""
echo "🤖 サブエージェント："
for file in "${AGENT_FILES[@]}"; do
    if [ -f "$INSTALL_DIR/../agents/$file" ]; then
        agent_name="${file%.md}"
        echo -e "${BLUE}  ✓ ${agent_name}${NC}"
    fi
done
echo ""
echo "🔄 Intent Model駆動XPワークフロー："
echo -e "${BLUE}1. /xp:discovery \"曖昧要件\"${NC}        → Intent Model構造化"
echo -e "${BLUE}2. /xp:design${NC}                       → C4アーキテクチャ・ADR生成"
echo -e "${BLUE}3. /xp:scaffold${NC}                     → プロジェクト足場構築"
echo -e "${BLUE}4. /xp:tdd \"story\"${NC}                 → TDD実装（Red→Green→Refactor）"
echo -e "${BLUE}5. /xp:cicd${NC}                         → CI/CDパイプライン設定"
echo -e "${BLUE}6. /xp:preview${NC}                      → 動作確認・デモ"
echo -e "${BLUE}7. /xp:review${NC}                       → レビュー資料生成"
echo -e "${BLUE}8. /xp:retro${NC}                        → メトリクス分析・振り返り"
echo -e "${BLUE}9. /xp:doc <テンプレ名>${NC}               → テンプレート展開"
echo ""
echo "💡 使用例："
echo "  /xp:discovery \"ウェブブラウザで遊べるテトリスが欲しい\""
echo "  /xp:design"
echo "  /xp:scaffold"
echo "  /xp:tdd \"ユーザーがテトリスを操作できる\""
echo "  /xp:cicd"
echo "  /xp:preview"
echo "  /xp:review"
echo "  /xp:retro"
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
echo -e "${GREEN}Intent Model駆動XP開発を実践しましょう！${NC}"
echo -e "${GREEN}曖昧要件からMVPへ、構造化された意図で継続的な価値を。${NC}"