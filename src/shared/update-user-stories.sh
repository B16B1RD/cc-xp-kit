#!/bin/bash

# user-storiesチェックボックス自動更新ツール
# Usage: bash update-user-stories.sh [task-name] [status] [notes]

set -e

TASK_NAME=${1:-""}
STATUS=${2:-"completed"}
NOTES=${3:-""}
TIMESTAMP=$(date "+%Y-%m-%d %H:%M")

# 色定義
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo_green() {
    echo -e "${GREEN}✅ $1${NC}"
}

echo_yellow() {
    echo -e "${YELLOW}⚠️ $1${NC}"
}

echo_red() {
    echo -e "${RED}❌ $1${NC}"
}

# user-storiesファイルを自動検出
find_user_stories_file() {
    local possible_paths=(
        "docs/agile-artifacts/stories/user-stories-v1.0.md"
        "docs/agile-artifacts/stories/user-stories.md"
        ".claude/agile-artifacts/stories/user-stories-v1.0.md"
        ".claude/agile-artifacts/stories/user-stories.md"
        "user-stories.md"
    )
    
    for path in "${possible_paths[@]}"; do
        if [[ -f "$path" ]]; then
            echo "$path"
            return 0
        fi
    done
    
    return 1
}

# チェックボックスの状態を更新
update_checkbox() {
    local file_path="$1"
    local task_name="$2"
    local status="$3"
    local notes="$4"
    
    # バックアップ作成
    cp "$file_path" "${file_path}.backup.$(date +%s)"
    
    # タスク名に基づく検索パターンを作成
    local search_pattern="- \[ \].*${task_name}"
    local replacement=""
    
    case $status in
        "completed")
            if [[ -n "$notes" ]]; then
                replacement="- [x] **${task_name}** ✅ 完了 - ${TIMESTAMP} - ${notes}"
            else
                replacement="- [x] **${task_name}** ✅ 完了 - ${TIMESTAMP}"
            fi
            ;;
        "in_progress")
            replacement="- [ ] **${task_name}** 🔄 実装中 - ${TIMESTAMP}"
            ;;
        "pending")
            replacement="- [ ] **${task_name}** - 待機中"
            ;;
        *)
            echo_red "不明なステータス: $status"
            return 1
            ;;
    esac
    
    # sedで更新（macOS/Linux対応）
    if sed --version >/dev/null 2>&1; then
        # GNU sed (Linux)
        sed -i "s|${search_pattern}|${replacement}|g" "$file_path"
    else
        # BSD sed (macOS)
        sed -i '' "s|${search_pattern}|${replacement}|g" "$file_path"
    fi
    
    echo_green "チェックボックス更新完了: ${task_name}"
}

# 学習記録の追加
add_learning_record() {
    local file_path="$1"
    local task_name="$2"
    local notes="$3"
    
    if [[ -n "$notes" ]]; then
        echo "" >> "$file_path"
        echo "## 学習記録 - ${task_name} - ${TIMESTAMP}" >> "$file_path"
        echo "※ ${notes}" >> "$file_path"
        echo_green "学習記録追加完了"
    fi
}

# 進捗統計の更新
update_progress_stats() {
    local file_path="$1"
    
    # 完了タスク数をカウント
    local completed_count=$(grep -c "\[x\]" "$file_path" || echo "0")
    local total_count=$(grep -c "\[\s*\]" "$file_path" || echo "0")
    
    if [[ $total_count -gt 0 ]]; then
        local progress_percent=$((completed_count * 100 / total_count))
        echo_green "進捗状況: ${completed_count}/${total_count} (${progress_percent}%)"
    fi
}

# インタラクティブモード
interactive_mode() {
    local user_stories_file="$1"
    
    echo "📝 user-stories チェックボックス更新ツール"
    echo "=========================================="
    echo
    
    echo "📄 対象ファイル: $user_stories_file"
    echo
    
    # 未完了タスクの一覧表示
    echo "📋 未完了タスク一覧:"
    grep -n "\[ \]" "$user_stories_file" | head -10 | sed 's/^/  /'
    echo
    
    read -p "更新するタスク名を入力: " task_name
    if [[ -z "$task_name" ]]; then
        echo_red "タスク名が入力されませんでした"
        exit 1
    fi
    
    echo "ステータス選択:"
    echo "1) completed (完了)"
    echo "2) in_progress (実装中)"
    echo "3) pending (待機中)"
    read -p "選択 (1-3): " status_choice
    
    case $status_choice in
        1) status="completed" ;;
        2) status="in_progress" ;;
        3) status="pending" ;;
        *) echo_red "無効な選択"; exit 1 ;;
    esac
    
    if [[ "$status" == "completed" ]]; then
        read -p "学習記録・メモ (オプション): " notes
    fi
    
    update_checkbox "$user_stories_file" "$task_name" "$status" "$notes"
    
    if [[ "$status" == "completed" && -n "$notes" ]]; then
        add_learning_record "$user_stories_file" "$task_name" "$notes"
    fi
    
    update_progress_stats "$user_stories_file"
}

# コマンドラインモード
command_line_mode() {
    local user_stories_file="$1"
    local task_name="$2"
    local status="$3"
    local notes="$4"
    
    echo "📝 user-stories更新実行中..."
    echo "ファイル: $user_stories_file"
    echo "タスク: $task_name"
    echo "ステータス: $status"
    
    update_checkbox "$user_stories_file" "$task_name" "$status" "$notes"
    
    if [[ "$status" == "completed" && -n "$notes" ]]; then
        add_learning_record "$user_stories_file" "$task_name" "$notes"
    fi
    
    update_progress_stats "$user_stories_file"
}

# TDDサイクル連携モード
tdd_integration_mode() {
    local user_stories_file="$1"
    local task_name="$2"
    local phase="$3"  # red, green, refactor, completed
    
    case $phase in
        "red")
            update_checkbox "$user_stories_file" "$task_name" "in_progress" "Red: テスト作成中"
            ;;
        "green")
            update_checkbox "$user_stories_file" "$task_name" "in_progress" "Green: 実装中"
            ;;
        "refactor")
            update_checkbox "$user_stories_file" "$task_name" "in_progress" "Refactor: 改善中"
            ;;
        "completed")
            read -p "実装時間 (分): " duration
            read -p "重要な学習・発見: " learning
            local notes="完了 - ${duration}分 - ※${learning}"
            update_checkbox "$user_stories_file" "$task_name" "completed" "$notes"
            add_learning_record "$user_stories_file" "$task_name" "$learning"
            ;;
    esac
}

# メイン処理
main() {
    # user-storiesファイルを検索
    local user_stories_file
    if ! user_stories_file=$(find_user_stories_file); then
        echo_red "user-storiesファイルが見つかりません"
        echo "以下のパスに配置してください:"
        echo "  docs/agile-artifacts/stories/user-stories-v1.0.md"
        exit 1
    fi
    
    echo_green "user-storiesファイル見つかりました: $user_stories_file"
    
    # 引数に基づく処理分岐
    if [[ $# -eq 0 ]]; then
        # インタラクティブモード
        interactive_mode "$user_stories_file"
    elif [[ $# -eq 3 && "$2" =~ ^(red|green|refactor|completed)$ ]]; then
        # TDD連携モード
        tdd_integration_mode "$user_stories_file" "$1" "$2"
    else
        # コマンドラインモード
        if [[ -z "$TASK_NAME" ]]; then
            echo "使用法:"
            echo "  bash update-user-stories.sh                    # インタラクティブモード"
            echo "  bash update-user-stories.sh \"タスク名\" completed \"メモ\"  # 完了マーク"
            echo "  bash update-user-stories.sh \"タスク名\" red            # TDD連携"
            exit 1
        fi
        command_line_mode "$user_stories_file" "$TASK_NAME" "$STATUS" "$NOTES"
    fi
    
    echo
    echo_green "user-stories更新完了!"
}

main "$@"