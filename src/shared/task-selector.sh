#!/bin/bash
set -euo pipefail

# 🎯 TDD タスク自動選択システム
# Kent Beck "Most Anxious Thing First" 原則準拠
# 
# 使用方法:
#   bash task-selector.sh auto                    # 完全自動判定
#   bash task-selector.sh rank 1                  # 不安度ランキング1位
#   bash task-selector.sh story 1.1               # Story 1.1指定
#   bash task-selector.sh menu                    # インタラクティブメニュー

# カラー定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# 使用方法表示
show_usage() {
    echo "使用方法:"
    echo "  bash task-selector.sh [引数]           # 自動判定（引数パターンで判別）"
    echo "  bash task-selector.sh --name-only [引数]  # 機能名のみ出力"
    echo ""
    echo "引数パターン:"
    echo "  (空白)      # 自動判定"
    echo "  数値        # 不安度ランキング指定"
    echo "  x.y         # ストーリー番号指定"  
    echo "  文字列      # 機能名直接指定"
    echo ""
    echo "例:"
    echo "  bash task-selector.sh"
    echo "  bash task-selector.sh 1"
    echo "  bash task-selector.sh 1.1"
    echo "  bash task-selector.sh --name-only game-init"
}

# 🎯 メイン自動判定関数 - 選択理由含む出力
# Kent Beck "Most Anxious Thing First" 原則に基づく優先度判定
auto_determine_next_task() {
    local all_args="$*"
    local granularity="feature"  # デフォルト
    
    # 粒度判定
    if echo "$all_args" | grep -q "\--micro"; then
        granularity="micro"
    elif echo "$all_args" | grep -q "\--epic"; then
        granularity="epic"
    fi
    
    # 1. 最優先: 不安度5/7以上の項目 (Most Anxious Thing First)
    local high_anxiety_task=$(get_most_anxious_task "$granularity")
    if [ -n "$high_anxiety_task" ]; then
        echo "$high_anxiety_task (Kent Beck \"Most Anxious Thing First\" 原則適用)"
        return 0
    fi
    
    # 2. 継続中タスク検出 (フロー維持)
    local continuing_task=$(detect_continuing_task "$granularity")
    if [ -n "$continuing_task" ]; then
        echo "$continuing_task (前回コミットからの継続)"
        return 0
    fi
    
    # 3. Must Have ストーリーの次項目 (価値優先)
    local next_story=$(get_next_must_have_story "$granularity")
    if [ -n "$next_story" ]; then
        echo "$next_story (Must Have ストーリー優先)"
        return 0
    fi
    
    # 4. デフォルトタスク（粒度に応じた単位）
    local default_task=$(generate_default_task "$granularity")
    echo "$default_task (新タスク開始)"
}

# 🚨 最も不安度の高いタスクを取得（粒度対応版）
get_most_anxious_task() {
    local granularity="${1:-feature}"
    local todo_manager_path=""
    
    # todo-manager.sh のパスを検索
    if [ -f "src/shared/todo-manager.sh" ]; then
        todo_manager_path="src/shared/todo-manager.sh"
    else
        return 1
    fi
    
    # 高不安度項目（5/7以上）を取得（完了済みを除外）
    local raw_task=$(bash "$todo_manager_path" list high 2>/dev/null | \
    grep "^- \[ \]" | head -1 | \
    sed 's/^- \[ \] \*\*\[ID:[^]]*\]\*\* *//' | \
    head -c 50)
    
    # 完了済み項目が混入していないかチェック
    if [[ "$raw_task" == *"[DONE]"* ]]; then
        raw_task=""
    fi
    
    if [ -n "$raw_task" ]; then
        # 粒度に応じてタスクを拡張
        expand_to_granularity "$raw_task" "$granularity"
    else
        echo ""
    fi
}

# 🎛️ 粒度に応じたタスク拡張
expand_to_granularity() {
    local task="$1"
    local granularity="$2"
    
    case "$granularity" in
        "micro")
            # マイクロレベル: タスクをそのまま返す（単一関数レベル）
            echo "$task"
            ;;
        "epic")
            # エピックレベル: プロダクト全体に拡張
            expand_to_epic "$task"
            ;;
        *)
            # フィーチャーレベル（デフォルト）: 統合機能群に拡張
            expand_to_feature "$task"
            ;;
    esac
}

# 🏗️ 単一タスクをフィーチャー単位に拡張
expand_to_feature() {
    local task="$1"
    
    # タスクの性質に応じてフィーチャー単位に拡張
    case "$task" in
        *"エラー"*|*"バグ"*|*"修正"*)
            echo "${task}を含む品質保証システム (error-handling, logging, testing)"
            ;;
        *"認証"*|*"ログイン"*|*"ユーザー"*)
            echo "${task}を含むユーザー管理システム (authentication, authorization, profile)"
            ;;
        *"データ"*|*"保存"*|*"取得"*)
            echo "${task}を含むデータ基盤システム (storage, retrieval, validation)"
            ;;
        *"UI"*|*"画面"*|*"表示"*)
            echo "${task}を含むユーザーインターフェース群 (components, layout, interaction)"
            ;;
        *"API"*|*"通信"*|*"リクエスト"*)
            echo "${task}を含む通信システム (api-integration, data-sync, error-recovery)"
            ;;
        *)
            # デフォルト: タスク名 + 関連機能群
            echo "${task}を含む機能群 (core-implementation, integration, testing)"
            ;;
    esac
}

# 🏛️ 単一タスクをエピック単位に拡張
expand_to_epic() {
    local task="$1"
    
    # タスクの性質に応じてエピック単位（プロダクト全体）に拡張
    case "$task" in
        *"エラー"*|*"バグ"*|*"修正"*)
            echo "${task}を含むプロダクト品質向上プロジェクト (monitoring, testing, reliability, performance)"
            ;;
        *"認証"*|*"ログイン"*|*"ユーザー"*)
            echo "${task}を含むユーザー体験プラットフォーム (auth, profile, social, personalization)"
            ;;
        *"データ"*|*"保存"*|*"取得"*)
            echo "${task}を含むデータドリブンプラットフォーム (storage, analytics, insights, automation)"
            ;;
        *"UI"*|*"画面"*|*"表示"*)
            echo "${task}を含むユーザーエクスペリエンス革新 (interface, interaction, accessibility, mobile)"
            ;;
        *"API"*|*"通信"*|*"リクエスト"*)
            echo "${task}を含む接続プラットフォーム (integration, sync, real-time, scalability)"
            ;;
        *)
            # デフォルト: プロダクト全体
            echo "${task}を含むプロダクト全体構築 (core-platform, integrations, user-experience, operations)"
            ;;
    esac
}

# 🔄 継続中タスクの検出（粒度対応版）
detect_continuing_task() {
    local granularity="${1:-feature}"
    if ! git rev-parse --git-dir >/dev/null 2>&1; then
        return 1
    fi
    
    # 最新のBEHAVIORコミットから機能名を抽出
    local behavior_commit=$(git log --oneline --grep='\[BEHAVIOR\]' -1 2>/dev/null | head -1)
    
    if [ -n "$behavior_commit" ]; then
        # パターン: [BEHAVIOR] Add feature-name: description
        local raw_task=$(echo "$behavior_commit" | \
        sed -n 's/.*\[BEHAVIOR\][^:]*Add \([^:]*\):.*/\1/p' | \
        sed 's/^ *//;s/ *$//' | \
        head -c 50)
        
        if [ -n "$raw_task" ]; then
            # 粒度に応じて拡張（継続の場合は軽量化）
            case "$granularity" in
                "micro")
                    echo "${raw_task}継続 (refinement, edge-cases)"
                    ;;
                "epic")
                    echo "${raw_task}関連プロダクト継続 (platform-extension, integration, scaling)"
                    ;;
                *)
                    echo "${raw_task}関連フィーチャー継続 (extension, refinement, integration)"
                    ;;
            esac
        fi
    fi
}

# 📋 Must Have ストーリーの次項目を取得
get_next_must_have_story() {
    local granularity="${1:-feature}"
    local story_file=".claude/agile-artifacts/stories/user-stories.md"
    
    if [ ! -f "$story_file" ]; then
        return 1
    fi
    
    # Must Have セクションから未完了のストーリーを検出
    awk '/^### Must Have/ { in_must_have = 1; next } 
         /^### (Should Have|Could Have|Wont Have)/ { in_must_have = 0; next } 
         in_must_have && /^#### Story [0-9.]+:/ { 
             gsub(/^#### Story [0-9.]+: */, ""); 
             print; 
             exit 
         }' "$story_file" | head -1 | head -c 50 || echo ""
}

# 🏗️ デフォルトタスク生成（粒度対応）
generate_default_task() {
    local granularity="${1:-feature}"
    local project_type=$(detect_project_type)
    local time_suffix=$(date +%H%M)
    
    case "$granularity" in
        "micro")
            generate_default_micro "$project_type" "$time_suffix"
            ;;
        "epic")
            generate_default_epic "$project_type" "$time_suffix"
            ;;
        *)
            generate_default_feature "$project_type" "$time_suffix"
            ;;
    esac
}

# 🔬 マイクロレベルデフォルト生成
generate_default_micro() {
    local project_type="$1"
    local time_suffix="$2"
    
    case "$project_type" in
        "web"|"game"|"api"|"cli"|"mobile")
            echo "基本関数実装 (single-function) [$time_suffix]"
            ;;
        *)
            echo "単一機能実装 (core-function) [$time_suffix]"
            ;;
    esac
}

# 🏛️ エピックレベルデフォルト生成
generate_default_epic() {
    local project_type="$1"
    local time_suffix="$2"
    
    case "$project_type" in
        "web")
            echo "Webプラットフォーム全体構築 (frontend, backend, deployment, monitoring) [$time_suffix]"
            ;;
        "game")
            echo "ゲームプロダクト全体開発 (game-engine, content, monetization, community) [$time_suffix]"
            ;;
        "api")
            echo "APIプラットフォーム全体構築 (services, gateway, auth, analytics) [$time_suffix]"
            ;;
        "cli")
            echo "CLI製品全体開発 (core-tools, ecosystem, documentation, distribution) [$time_suffix]"
            ;;
        "mobile")
            echo "モバイルアプリ全体開発 (app, backend, store-release, analytics) [$time_suffix]"
            ;;
        *)
            echo "プロダクト全体構築 (platform, integrations, operations, growth) [$time_suffix]"
            ;;
    esac
}

# 🏗️ デフォルトフィーチャー生成（実用的な単位）
generate_default_feature() {
    local project_type="${1:-$(detect_project_type)}"
    local time_suffix="${2:-$(date +%H%M)}"
    # プロジェクトの性質を推測してフィーチャー単位を提案
    
    case "$project_type" in
        "web")
            echo "ユーザー認証システム (login, signup, session-management) [$time_suffix]"
            ;;
        "game")
            echo "ゲーム基盤システム (game-board, piece-movement, scoring) [$time_suffix]"
            ;;
        "api")
            echo "RESTful API基盤 (routing, validation, error-handling) [$time_suffix]"
            ;;
        "cli")
            echo "CLI基本機能 (argument-parsing, help-system, output-formatting) [$time_suffix]"
            ;;
        "mobile")
            echo "画面遷移システム (navigation, state-management, ui-components) [$time_suffix]"
            ;;
        *)
            echo "コア機能群 (core-logic, data-handling, user-interface) [$time_suffix]"
            ;;
    esac
}

# プロジェクトタイプ推測
detect_project_type() {
    # package.json や設定ファイルからプロジェクトタイプを推測
    if [ -f "package.json" ]; then
        if grep -q "react\|vue\|angular" package.json 2>/dev/null; then
            echo "web"
        elif grep -q "express\|koa\|fastify" package.json 2>/dev/null; then
            echo "api"
        elif grep -q "react-native\|expo" package.json 2>/dev/null; then
            echo "mobile" 
        elif grep -q "phaser\|three.js\|pixi" package.json 2>/dev/null; then
            echo "game"
        else
            echo "web"
        fi
    elif [ -f "Cargo.toml" ]; then
        if grep -q "clap\|structopt" Cargo.toml 2>/dev/null; then
            echo "cli"
        else
            echo "api"
        fi
    elif [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
        if grep -q "django\|flask\|fastapi" requirements.txt pyproject.toml 2>/dev/null; then
            echo "api"
        elif grep -q "pygame\|arcade" requirements.txt pyproject.toml 2>/dev/null; then
            echo "game"
        else
            echo "api"
        fi
    else
        echo "generic"
    fi
}

# 🔢 不安度ランキング指定によるタスク取得
get_task_by_ranking() {
    local rank="$1"
    
    if ! [[ "$rank" =~ ^[0-9]+$ ]] || [ "$rank" -lt 1 ]; then
        echo "エラー: ランキングは1以上の数値を指定してください" >&2
        return 1
    fi
    
    if [ -f "src/shared/todo-manager.sh" ]; then
        # 不安度順でタスクを取得し、指定されたランキングの項目を返す
        local task=$(bash "src/shared/todo-manager.sh" anxiety 2>/dev/null | \
        sed -n "${rank}p" | \
        sed 's/^[^:]*: *//' | head -c 50)
        
        if [ -n "$task" ]; then
            echo "$task (不安度ランキング ${rank}位)"
        else
            echo "new-feature-$(date +%H%M%S) (ランキング範囲外のため新機能)"
        fi
    else
        echo "エラー: todo-manager.sh が見つかりません" >&2
        return 1
    fi
}

# 📖 ストーリー番号指定によるタスク取得
get_task_by_story_number() {
    local story_number="$1"
    local story_file=".claude/agile-artifacts/stories/user-stories.md"
    
    if ! [[ "$story_number" =~ ^[0-9]+\.[0-9]+$ ]]; then
        echo "エラー: ストーリー番号は x.y 形式で指定してください (例: 1.1)" >&2
        return 1
    fi
    
    if [ ! -f "$story_file" ]; then
        echo "new-feature-$(date +%H%M%S) (ストーリーファイル未作成のため新機能)"
        return 0
    fi
    
    # 指定されたストーリー番号の機能名を抽出
    local task=$(grep "^#### Story $story_number:" "$story_file" 2>/dev/null | \
    sed "s/^#### Story $story_number: *//" | \
    head -1 | head -c 50)
    
    if [ -n "$task" ]; then
        echo "$task (Story $story_number 指定)"
    else
        echo "new-feature-$(date +%H%M%S) (Story $story_number が見つからないため新機能)"
    fi
}

# メイン処理 - 直接引数処理対応
main() {
    local name_only=false
    local input=""
    local all_args="$*"
    
    # --name-only オプションの処理
    if [ "${1:-}" = "--name-only" ]; then
        name_only=true
        input="${2:-}"
    else
        input="${1:-}"
    fi
    
    # ヘルプ要求の処理
    case "$input" in
        "help"|"-h"|"--help")
            show_usage
            return 0
            ;;
    esac
    
    # タスク選択の実行
    local result=""
    if [ -z "$input" ] || [[ "$input" =~ ^--.*$ ]]; then
        # 引数が空またはオプションのみの場合は自動判定
        result=$(auto_determine_next_task "$all_args")
    elif [[ "$input" =~ ^[0-9]+$ ]]; then
        # 純粋な数値 → 不安度ランキング指定
        result=$(get_task_by_ranking "$input")
    elif [[ "$input" =~ ^[0-9]+\.[0-9]+$ ]]; then
        # x.y形式 → ストーリー番号指定
        result=$(get_task_by_story_number "$input")
    else
        # その他 → 文字列として機能名指定
        result="$input (機能名直接指定)"
    fi
    
    # 出力形式の選択
    if [ "$name_only" = true ]; then
        # 機能名のみ出力（理由部分を除去）
        echo "$result" | sed 's/ (.*)$//'
    else
        # 理由付きで出力
        echo "$result"
    fi
}

# スクリプト直接実行時のみメイン処理を実行
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi