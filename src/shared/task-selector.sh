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
    # 1. 最優先: 不安度5/7以上の項目 (Most Anxious Thing First)
    local high_anxiety_task=$(get_most_anxious_task)
    if [ -n "$high_anxiety_task" ]; then
        echo "$high_anxiety_task (Kent Beck \"Most Anxious Thing First\" 原則適用)"
        return 0
    fi
    
    # 2. 継続中タスク検出 (フロー維持)
    local continuing_task=$(detect_continuing_task)
    if [ -n "$continuing_task" ]; then
        echo "$continuing_task (前回コミットからの継続)"
        return 0
    fi
    
    # 3. Must Have ストーリーの次項目 (価値優先)
    local next_story=$(get_next_must_have_story)
    if [ -n "$next_story" ]; then
        echo "$next_story (Must Have ストーリー優先)"
        return 0
    fi
    
    # 4. デフォルト新機能
    local default_task="new-feature-$(date +%H%M%S)"
    echo "$default_task (新機能開始)"
}

# 🚨 最も不安度の高いタスクを取得
get_most_anxious_task() {
    local todo_manager_path=""
    
    # todo-manager.sh のパスを検索
    if [ -f "src/shared/todo-manager.sh" ]; then
        todo_manager_path="src/shared/todo-manager.sh"
    else
        return 1
    fi
    
    # 高不安度項目（5/7以上）を取得
    # todo-manager.sh list high の出力から実際のタスク名を抽出
    bash "$todo_manager_path" list high 2>/dev/null | \
    grep "^- \[ \]" | head -1 | \
    sed 's/^- \[ \] \*\*\[ID:[^]]*\]\*\* *//' | \
    head -c 50 || echo ""
}

# 🔄 継続中タスクの検出
# 最新のBEHAVIORコミットから機能名を抽出
detect_continuing_task() {
    if ! git rev-parse --git-dir >/dev/null 2>&1; then
        return 1
    fi
    
    # 最新のBEHAVIORコミットから機能名を抽出
    local behavior_commit=$(git log --oneline --grep='\[BEHAVIOR\]' -1 2>/dev/null | head -1)
    
    if [ -n "$behavior_commit" ]; then
        # パターン: [BEHAVIOR] Add feature-name: description
        echo "$behavior_commit" | \
        sed -n 's/.*\[BEHAVIOR\][^:]*Add \([^:]*\):.*/\1/p' | \
        sed 's/^ *//;s/ *$//' | \
        head -c 50 || echo ""
    fi
}

# 📋 Must Have ストーリーの次項目を取得
get_next_must_have_story() {
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
    if [ -z "$input" ]; then
        # 引数が空の場合は自動判定
        result=$(auto_determine_next_task)
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