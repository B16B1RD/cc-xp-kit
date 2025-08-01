#!/bin/bash

# YAML形式イテレーション追跡システム
# 90分イテレーションの詳細進捗管理とKent Beck TDDサイクル統合

set -euo pipefail

# カラー定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# イテレーション保存ディレクトリ
ITERATION_DIR=".claude/agile-artifacts/iterations"
TRACKING_DIR="$ITERATION_DIR/tracking"

# ディレクトリ作成
ensure_dirs() {
    mkdir -p "$ITERATION_DIR"
    mkdir -p "$TRACKING_DIR"
}

# 使用方法の表示
show_usage() {
    echo "使用方法: $0 <command> [options]"
    echo ""
    echo "コマンド:"
    echo "  start <iteration_id>                     - 新しいイテレーション開始"
    echo "  add-task <iteration_id> <task_name>      - タスク追加"
    echo "  update-task <iteration_id> <task_id> <phase> [anxiety] - タスク更新"
    echo "  complete-task <iteration_id> <task_id>   - タスク完了"
    echo "  status <iteration_id>                    - 進捗状況表示"
    echo "  report <iteration_id>                    - 詳細レポート生成"
    echo "  list                                     - 全イテレーション一覧"
    echo "  pause <iteration_id>                     - イテレーション一時停止"
    echo "  resume <iteration_id>                    - イテレーション再開"
    echo "  finish <iteration_id>                    - イテレーション完了"
    echo ""
    echo "TDDフェーズ:"
    echo "  red        - RED フェーズ（テスト作成）"
    echo "  green      - GREEN フェーズ（最小実装）"
    echo "  refactor   - REFACTOR フェーズ（構造改善）"
    echo ""
    echo "例:"
    echo "  $0 start \"1\""
    echo "  $0 add-task \"1\" \"ゲームボード表示\""
    echo "  $0 update-task \"1\" \"1.1\" \"green\" 3"
    echo "  $0 complete-task \"1\" \"1.1\""
    echo "  $0 status \"1\""
}

# 現在のUTCタイムスタンプ取得
get_timestamp() {
    date -u "+%Y-%m-%dT%H:%M:%SZ"
}

# 経過時間計算（分）
calculate_elapsed_minutes() {
    local start_time="$1"
    local end_time="${2:-$(get_timestamp)}"
    
    local start_epoch=$(date -d "$start_time" +%s 2>/dev/null || echo "0")
    local end_epoch=$(date -d "$end_time" +%s 2>/dev/null || date +%s)
    
    local elapsed_seconds=$((end_epoch - start_epoch))
    local elapsed_minutes=$((elapsed_seconds / 60))
    
    echo "$elapsed_minutes"
}

# イテレーション開始
start_iteration() {
    local iteration_id="$1"
    
    ensure_dirs
    
    local yaml_file="$TRACKING_DIR/iteration-$iteration_id.yaml"
    
    if [[ -f "$yaml_file" ]]; then
        echo -e "${YELLOW}⚠️  イテレーション $iteration_id は既に存在します${NC}"
        echo -e "継続する場合は resume コマンドを使用してください"
        return 1
    fi
    
    local start_time=$(get_timestamp)
    
    cat > "$yaml_file" << EOF
# Kent Beck流イテレーション追跡 - Iteration $iteration_id
iteration_id: "$iteration_id"
start_time: "$start_time"
duration_minutes: 90
status: "active"
created_by: "iteration-tracker.sh"
kent_beck_principles:
  - "Make it work, make it right, make it fast"
  - "Do the simplest thing that could possibly work"
  - "Red, Green, Refactor - and repeat"

# タスク一覧
tasks: []

# メトリクス（自動計算）
metrics:
  total_tasks: 0
  completed_tasks: 0
  in_progress_tasks: 0
  pending_tasks: 0
  completion_percentage: 0
  elapsed_time_minutes: 0
  remaining_time_minutes: 90
  average_task_time_minutes: 0
  tdd_cycles_completed: 0

# 進捗履歴
progress_history: []

# 不安度分析
anxiety_analysis:
  current_average: 0.0
  highest_anxiety_task: ""
  total_high_anxiety_tasks: 0
EOF
    
    echo -e "${GREEN}✅ イテレーション $iteration_id を開始しました${NC}"
    echo -e "   開始時刻: $start_time"
    echo -e "   予定時間: 90分"
    echo -e "   ファイル: $yaml_file"
    echo -e ""
    echo -e "${BOLD}🎯 Kent Beck原則に従い、最も不安なタスクから始めましょう${NC}"
}

# タスク追加
add_task() {
    local iteration_id="$1"
    local task_name="$2"
    
    local yaml_file="$TRACKING_DIR/iteration-$iteration_id.yaml"
    
    if [[ ! -f "$yaml_file" ]]; then
        echo -e "${RED}❌ イテレーション $iteration_id が見つかりません${NC}"
        echo -e "まず start コマンドでイテレーションを開始してください"
        return 1
    fi
    
    # 現在のタスク数を取得
    local task_count=$(grep -c "^  - id:" "$yaml_file" 2>/dev/null || echo "0")
    local new_task_id="$iteration_id.$((task_count + 1))"
    local current_time=$(get_timestamp)
    
    # 不安度を質問
    echo -e "${BOLD}❓ タスク「$task_name」の不安度を入力してください（1-7）:${NC}"
    echo -e "   1 = 全く不安なし（完璧な確信）"
    echo -e "   2-3 = 軽い不安（小さな懸念）"
    echo -e "   4-5 = 中程度の不安（いくつかの課題）"
    echo -e "   6-7 = 高い不安（重要・重大な問題）"
    
    local anxiety_level=""
    while [[ ! "$anxiety_level" =~ ^[1-7]$ ]]; do
        read -p "不安度 (1-7): " anxiety_level
        if [[ ! "$anxiety_level" =~ ^[1-7]$ ]]; then
            echo -e "${RED}1-7の数値を入力してください${NC}"
        fi
    done
    
    # タスクをYAMLに追加
    local temp_file=$(mktemp)
    
    # tasks: []を見つけて置換
    if grep -q "^tasks: \[\]$" "$yaml_file"; then
        sed "s/^tasks: \[\]$/tasks:\n  - id: \"$new_task_id\"\n    name: \"$task_name\"\n    status: \"pending\"\n    tdd_phase: \"red\"\n    anxiety_level: $anxiety_level\n    created_time: \"$current_time\"/" "$yaml_file" > "$temp_file"
    else
        # 既存のタスクがある場合
        awk -v task_id="$new_task_id" -v task_name="$task_name" -v anxiety="$anxiety_level" -v timestamp="$current_time" '
        /^# メトリクス/ {
            print "  - id: \"" task_id "\""
            print "    name: \"" task_name "\""
            print "    status: \"pending\""
            print "    tdd_phase: \"red\""
            print "    anxiety_level: " anxiety
            print "    created_time: \"" timestamp "\""
            print ""
        }
        { print }
        ' "$yaml_file" > "$temp_file"
    fi
    
    mv "$temp_file" "$yaml_file"
    
    # メトリクス更新
    update_metrics "$iteration_id"
    
    echo -e "${GREEN}✅ タスク追加完了${NC}"
    echo -e "   ID: ${BOLD}$new_task_id${NC}"
    echo -e "   名前: $task_name"
    echo -e "   不安度: ${RED}$anxiety_level/7${NC}"
    echo -e "   初期フェーズ: ${RED}RED${NC}"
    
    if [[ "$anxiety_level" -ge 5 ]]; then
        echo -e ""
        echo -e "${RED}⚠️  高不安度タスクです！Kent Beck原則により最優先で取り組むことを推奨${NC}"
    fi
}

# タスク更新
update_task() {
    local iteration_id="$1"
    local task_id="$2"
    local new_phase="$3"
    local new_anxiety="${4:-}"
    
    local yaml_file="$TRACKING_DIR/iteration-$iteration_id.yaml"
    
    if [[ ! -f "$yaml_file" ]]; then
        echo -e "${RED}❌ イテレーション $iteration_id が見つかりません${NC}"
        return 1
    fi
    
    local current_time=$(get_timestamp)
    local temp_file=$(mktemp)
    
    # タスクのステータスとフェーズを更新
    awk -v task_id="$task_id" -v phase="$new_phase" -v anxiety="$new_anxiety" -v timestamp="$current_time" '
    BEGIN { in_task = 0; task_found = 0 }
    
    /^  - id: / {
        if ($0 ~ "\"" task_id "\"") {
            in_task = 1
            task_found = 1
            print $0
            next
        } else {
            in_task = 0
        }
    }
    
    in_task && /^    status:/ {
        if (phase == "red" || phase == "green" || phase == "refactor") {
            print "    status: \"in_progress\""
        } else {
            print $0
        }
        next
    }
    
    in_task && /^    tdd_phase:/ {
        print "    tdd_phase: \"" phase "\""
        next
    }
    
    in_task && /^    anxiety_level:/ && anxiety != "" {
        print "    anxiety_level: " anxiety
        next
    }
    
    in_task && /^    last_updated:/ {
        print "    last_updated: \"" timestamp "\""
        next
    }
    
    in_task && /^    created_time:/ {
        print $0
        print "    last_updated: \"" timestamp "\""
        next
    }
    
    { print }
    
    END {
        if (!task_found) {
            print "ERROR: Task " task_id " not found" > "/dev/stderr"
            exit 1
        }
    }
    ' "$yaml_file" > "$temp_file"
    
    if [[ $? -eq 0 ]]; then
        mv "$temp_file" "$yaml_file"
        update_metrics "$iteration_id"
        
        echo -e "${GREEN}✅ タスク更新完了${NC}"
        echo -e "   ID: ${BOLD}$task_id${NC}"
        echo -e "   フェーズ: $(get_phase_display "$new_phase")"
        if [[ -n "$new_anxiety" ]]; then
            echo -e "   不安度: ${RED}$new_anxiety/7${NC}"
        fi
        echo -e "   更新時刻: $current_time"
    else
        rm -f "$temp_file"
        echo -e "${RED}❌ タスク $task_id が見つかりません${NC}"
        return 1
    fi
}

# タスク完了
complete_task() {
    local iteration_id="$1"
    local task_id="$2"
    
    local yaml_file="$TRACKING_DIR/iteration-$iteration_id.yaml"
    
    if [[ ! -f "$yaml_file" ]]; then
        echo -e "${RED}❌ イテレーション $iteration_id が見つかりません${NC}"
        return 1
    fi
    
    local current_time=$(get_timestamp)
    local temp_file=$(mktemp)
    
    # タスクを完了状態に更新
    awk -v task_id="$task_id" -v timestamp="$current_time" '
    BEGIN { in_task = 0; task_found = 0 }
    
    /^  - id: / {
        if ($0 ~ "\"" task_id "\"") {
            in_task = 1
            task_found = 1
            print $0
            next
        } else {
            in_task = 0
        }
    }
    
    in_task && /^    status:/ {
        print "    status: \"completed\""
        next
    }
    
    in_task && /^    completed_time:/ {
        print "    completed_time: \"" timestamp "\""
        next
    }
    
    in_task && /^    last_updated:/ {
        print "    completed_time: \"" timestamp "\""
        print "    last_updated: \"" timestamp "\""
        next
    }
    
    in_task && /^    created_time:/ {
        print $0
        print "    completed_time: \"" timestamp "\""
        next
    }
    
    { print }
    
    END {
        if (!task_found) {
            print "ERROR: Task " task_id " not found" > "/dev/stderr"
            exit 1
        }
    }
    ' "$yaml_file" > "$temp_file"
    
    if [[ $? -eq 0 ]]; then
        mv "$temp_file" "$yaml_file"
        update_metrics "$iteration_id"
        
        echo -e "${GREEN}✅ タスク完了${NC}"
        echo -e "   ID: ${BOLD}$task_id${NC}"
        echo -e "   完了時刻: $current_time"
        
        # TDDサイクル完了の確認
        local tdd_phase=$(grep -A 10 "id: \"$task_id\"" "$yaml_file" | grep "tdd_phase:" | head -1 | sed 's/.*tdd_phase: "\([^"]*\)".*/\1/')
        if [[ "$tdd_phase" == "refactor" ]]; then
            echo -e "${PURPLE}🎉 TDDサイクル完了！次のタスクのREDフェーズへ${NC}"
        fi
    else
        rm -f "$temp_file"
        echo -e "${RED}❌ タスク $task_id が見つかりません${NC}"
        return 1
    fi
}

# メトリクス更新
update_metrics() {
    local iteration_id="$1"
    local yaml_file="$TRACKING_DIR/iteration-$iteration_id.yaml"
    
    if [[ ! -f "$yaml_file" ]]; then
        return 1
    fi
    
    # 各種カウントを計算
    local total_tasks=$(grep -c "^  - id:" "$yaml_file" 2>/dev/null || echo "0")
    local completed_tasks=$(grep -A 5 "^  - id:" "$yaml_file" | grep -c "status: \"completed\"" 2>/dev/null || echo "0")
    local in_progress_tasks=$(grep -A 5 "^  - id:" "$yaml_file" | grep -c "status: \"in_progress\"" 2>/dev/null || echo "0")
    local pending_tasks=$(grep -A 5 "^  - id:" "$yaml_file" | grep -c "status: \"pending\"" 2>/dev/null || echo "0")
    
    local completion_percentage=0
    if [[ "$total_tasks" -gt 0 ]]; then
        completion_percentage=$((completed_tasks * 100 / total_tasks))
    fi
    
    # 経過時間計算
    local start_time=$(grep "start_time:" "$yaml_file" | sed 's/.*start_time: "\([^"]*\)".*/\1/')
    local elapsed_minutes=$(calculate_elapsed_minutes "$start_time")
    local remaining_minutes=$((90 - elapsed_minutes))
    
    if [[ "$remaining_minutes" -lt 0 ]]; then
        remaining_minutes=0
    fi
    
    # 平均タスク時間計算
    local average_task_time=0
    if [[ "$completed_tasks" -gt 0 ]]; then
        average_task_time=$((elapsed_minutes / completed_tasks))
    fi
    
    # TDDサイクル完了数（REFACTORフェーズで完了したタスク数）
    local tdd_cycles=$(grep -A 10 "status: \"completed\"" "$yaml_file" | grep -c "tdd_phase: \"refactor\"" 2>/dev/null || echo "0")
    
    # 不安度分析
    local anxiety_values=$(grep -A 5 "^  - id:" "$yaml_file" | grep "anxiety_level:" | sed 's/.*anxiety_level: \([0-9]*\).*/\1/' | tr '\n' ' ')
    local anxiety_sum=0
    local anxiety_count=0
    local highest_anxiety=0
    local high_anxiety_count=0
    
    for anxiety in $anxiety_values; do
        if [[ "$anxiety" =~ ^[0-9]+$ ]]; then
            anxiety_sum=$((anxiety_sum + anxiety))
            anxiety_count=$((anxiety_count + 1))
            if [[ "$anxiety" -gt "$highest_anxiety" ]]; then
                highest_anxiety="$anxiety"
            fi
            if [[ "$anxiety" -ge 5 ]]; then
                high_anxiety_count=$((high_anxiety_count + 1))
            fi
        fi
    done
    
    local current_average=0.0
    if [[ "$anxiety_count" -gt 0 ]]; then
        current_average=$(echo "scale=1; $anxiety_sum / $anxiety_count" | bc 2>/dev/null || echo "0.0")
    fi
    
    # メトリクスセクションを更新
    local temp_file=$(mktemp)
    
    awk -v total="$total_tasks" -v completed="$completed_tasks" -v progress="$in_progress_tasks" \
        -v pending="$pending_tasks" -v percentage="$completion_percentage" \
        -v elapsed="$elapsed_minutes" -v remaining="$remaining_minutes" \
        -v avg_time="$average_task_time" -v tdd_cycles="$tdd_cycles" \
        -v avg_anxiety="$current_average" -v high_anxiety_count="$high_anxiety_count" '
    /^# メトリクス/ { in_metrics = 1 }
    /^metrics:/ && in_metrics {
        print "metrics:"
        print "  total_tasks: " total
        print "  completed_tasks: " completed
        print "  in_progress_tasks: " progress
        print "  pending_tasks: " pending
        print "  completion_percentage: " percentage
        print "  elapsed_time_minutes: " elapsed
        print "  remaining_time_minutes: " remaining
        print "  average_task_time_minutes: " avg_time
        print "  tdd_cycles_completed: " tdd_cycles
        skip_until_next_section = 1
        next
    }
    /^# / && skip_until_next_section {
        skip_until_next_section = 0
    }
    /^anxiety_analysis:/ && !skip_until_next_section {
        print "anxiety_analysis:"
        print "  current_average: " avg_anxiety
        print "  highest_anxiety_task: \"\""
        print "  total_high_anxiety_tasks: " high_anxiety_count
        skip_until_end = 1
        next
    }
    !skip_until_next_section && !skip_until_end { print }
    ' "$yaml_file" > "$temp_file"
    
    mv "$temp_file" "$yaml_file"
}

# フェーズ表示用
get_phase_display() {
    local phase="$1"
    case "$phase" in
        "red") echo "${RED}🔴 RED${NC}" ;;
        "green") echo "${GREEN}🟢 GREEN${NC}" ;;
        "refactor") echo "${BLUE}🔵 REFACTOR${NC}" ;;
        *) echo "$phase" ;;
    esac
}

# ステータス表示
show_status() {
    local iteration_id="$1"
    local yaml_file="$TRACKING_DIR/iteration-$iteration_id.yaml"
    
    if [[ ! -f "$yaml_file" ]]; then
        echo -e "${RED}❌ イテレーション $iteration_id が見つかりません${NC}"
        return 1
    fi
    
    echo -e "${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}⏱️  イテレーション $iteration_id ステータス${NC}"
    echo -e "${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    # 基本情報
    local start_time=$(grep "start_time:" "$yaml_file" | sed 's/.*start_time: "\([^"]*\)".*/\1/')
    local status=$(grep "status:" "$yaml_file" | head -1 | sed 's/.*status: "\([^"]*\)".*/\1/')
    
    echo -e "\n${BOLD}📊 基本情報:${NC}"
    echo -e "   開始時刻: $start_time"
    echo -e "   ステータス: $(get_status_display "$status")"
    
    # メトリクス情報の読み取り
    local total_tasks=$(grep "total_tasks:" "$yaml_file" | sed 's/.*total_tasks: \([0-9]*\).*/\1/')
    local completed_tasks=$(grep "completed_tasks:" "$yaml_file" | sed 's/.*completed_tasks: \([0-9]*\).*/\1/')
    local completion_percentage=$(grep "completion_percentage:" "$yaml_file" | sed 's/.*completion_percentage: \([0-9]*\).*/\1/')
    local elapsed_minutes=$(grep "elapsed_time_minutes:" "$yaml_file" | sed 's/.*elapsed_time_minutes: \([0-9]*\).*/\1/')
    local remaining_minutes=$(grep "remaining_time_minutes:" "$yaml_file" | sed 's/.*remaining_time_minutes: \([0-9]*\).*/\1/')
    
    echo -e "\n${BOLD}📈 進捗情報:${NC}"
    echo -e "   総タスク数: ${CYAN}$total_tasks${NC}"
    echo -e "   完了タスク: ${GREEN}$completed_tasks${NC}"
    echo -e "   完了率: ${BOLD}$completion_percentage%${NC}"
    
    # プログレスバー
    local bar_length=20
    local completed_bars=$((completion_percentage * bar_length / 100))
    local remaining_bars=$((bar_length - completed_bars))
    
    echo -ne "   進捗: ["
    for ((i=0; i<completed_bars; i++)); do echo -ne "${GREEN}■${NC}"; done
    for ((i=0; i<remaining_bars; i++)); do echo -ne "□"; done
    echo -e "] ${BOLD}$completion_percentage%${NC}"
    
    echo -e "\n${BOLD}⏰ 時間情報:${NC}"
    echo -e "   経過時間: ${YELLOW}${elapsed_minutes}分${NC}"
    echo -e "   残り時間: ${BLUE}${remaining_minutes}分${NC}"
    
    if [[ "$remaining_minutes" -le 10 ]]; then
        echo -e "${RED}⚠️  残り時間が少なくなっています！${NC}"
    fi
    
    # 現在のタスク一覧
    echo -e "\n${BOLD}📋 タスク一覧:${NC}"
    
    local temp_file=$(mktemp)
    grep -A 6 "^  - id:" "$yaml_file" > "$temp_file"
    
    local current_task=""
    local task_name=""
    local task_status=""
    local task_phase=""
    local task_anxiety=""
    
    while IFS= read -r line; do
        if [[ "$line" =~ ^[[:space:]]*-[[:space:]]*id: ]]; then
            if [[ -n "$current_task" ]]; then
                # 前のタスクを表示
                display_task_info "$current_task" "$task_name" "$task_status" "$task_phase" "$task_anxiety"
            fi
            current_task=$(echo "$line" | sed 's/.*id: "\([^"]*\)".*/\1/')
            task_name=""
            task_status=""
            task_phase=""
            task_anxiety=""
        elif [[ "$line" =~ ^[[:space:]]*name: ]]; then
            task_name=$(echo "$line" | sed 's/.*name: "\([^"]*\)".*/\1/')
        elif [[ "$line" =~ ^[[:space:]]*status: ]]; then
            task_status=$(echo "$line" | sed 's/.*status: "\([^"]*\)".*/\1/')
        elif [[ "$line" =~ ^[[:space:]]*tdd_phase: ]]; then
            task_phase=$(echo "$line" | sed 's/.*tdd_phase: "\([^"]*\)".*/\1/')
        elif [[ "$line" =~ ^[[:space:]]*anxiety_level: ]]; then
            task_anxiety=$(echo "$line" | sed 's/.*anxiety_level: \([0-9]*\).*/\1/')
        fi
    done < "$temp_file"
    
    # 最後のタスクを表示
    if [[ -n "$current_task" ]]; then
        display_task_info "$current_task" "$task_name" "$task_status" "$task_phase" "$task_anxiety"
    fi
    
    rm -f "$temp_file"
    
    # 推奨アクション
    echo -e "\n${BOLD}🎯 推奨アクション:${NC}"
    
    local high_anxiety_count=$(grep "total_high_anxiety_tasks:" "$yaml_file" | sed 's/.*total_high_anxiety_tasks: \([0-9]*\).*/\1/')
    
    if [[ "$high_anxiety_count" -gt 0 ]]; then
        echo -e "   ${RED}高不安度タスク $high_anxiety_count 個が存在${NC}"
        echo -e "   ${BOLD}→ Kent Beck原則: 最も不安なタスクから着手${NC}"
    elif [[ "$remaining_minutes" -le 15 ]]; then
        echo -e "   ${YELLOW}時間が少なくなっています${NC}"
        echo -e "   ${BOLD}→ 残りタスクの優先順位を再評価${NC}"
    elif [[ "$completion_percentage" -ge 80 ]]; then
        echo -e "   ${GREEN}順調に進行中${NC}"
        echo -e "   ${BOLD}→ 品質確保とリファクタリングに集中${NC}"
    else
        echo -e "   ${BLUE}通常の進行${NC}"
        echo -e "   ${BOLD}→ 次の高優先度タスクに着手${NC}"
    fi
}

# タスク情報表示
display_task_info() {
    local task_id="$1"
    local task_name="$2"
    local task_status="$3"
    local task_phase="$4"
    local task_anxiety="$5"
    
    local status_display=""
    case "$task_status" in
        "pending") status_display="${YELLOW}⏳ 未着手${NC}" ;;
        "in_progress") status_display="${BLUE}🔄 進行中${NC}" ;;
        "completed") status_display="${GREEN}✅ 完了${NC}" ;;
        *) status_display="$task_status" ;;
    esac
    
    local phase_display=$(get_phase_display "$task_phase")
    
    echo -e "   ${BOLD}$task_id${NC}: $task_name"
    echo -e "      ステータス: $status_display | フェーズ: $phase_display | 不安度: ${RED}$task_anxiety/7${NC}"
}

# ステータス表示用
get_status_display() {
    local status="$1"
    case "$status" in
        "active") echo "${GREEN}🟢 アクティブ${NC}" ;;
        "completed") echo "${BLUE}✅ 完了${NC}" ;;
        "paused") echo "${YELLOW}⏸️  一時停止${NC}" ;;
        *) echo "$status" ;;
    esac
}

# イテレーション一覧表示
list_iterations() {
    ensure_dirs
    
    echo -e "${BOLD}${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}📚 イテレーション一覧${NC}"
    echo -e "${BOLD}${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    if [[ ! -d "$TRACKING_DIR" ]] || [[ -z "$(ls -A "$TRACKING_DIR" 2>/dev/null)" ]]; then
        echo -e "\n${YELLOW}📝 イテレーションが見つかりません${NC}"
        echo -e "   新しいイテレーションを開始: ${CYAN}$0 start \"1\"${NC}"
        return
    fi
    
    echo -e "\n${BOLD}ID      ステータス     進捗率    経過時間    タスク数${NC}"
    echo -e "────────────────────────────────────────────────────"
    
    for yaml_file in "$TRACKING_DIR"/iteration-*.yaml; do
        if [[ -f "$yaml_file" ]]; then
            local iter_id=$(basename "$yaml_file" .yaml | sed 's/iteration-//')
            local status=$(grep "status:" "$yaml_file" | head -1 | sed 's/.*status: "\([^"]*\)".*/\1/')
            local completion=$(grep "completion_percentage:" "$yaml_file" | sed 's/.*completion_percentage: \([0-9]*\).*/\1/')
            local elapsed=$(grep "elapsed_time_minutes:" "$yaml_file" | sed 's/.*elapsed_time_minutes: \([0-9]*\).*/\1/')
            local total_tasks=$(grep "total_tasks:" "$yaml_file" | sed 's/.*total_tasks: \([0-9]*\).*/\1/')
            
            local status_display=""
            case "$status" in
                "active") status_display="${GREEN}アクティブ${NC}" ;;
                "completed") status_display="${BLUE}完了${NC}" ;;
                "paused") status_display="${YELLOW}一時停止${NC}" ;;
                *) status_display="$status" ;;
            esac
            
            printf "%-8s %-15s %6s%%    %7s分    %6s\n" \
                "$iter_id" "$status_display" "$completion" "$elapsed" "$total_tasks"
        fi
    done
}

# メイン関数
main() {
    local command="${1:-}"
    
    case "$command" in
        "start")
            if [[ $# -lt 2 ]]; then
                echo -e "${RED}❌ エラー: イテレーションIDを指定してください${NC}"
                show_usage
                exit 1
            fi
            start_iteration "$2"
            ;;
        "add-task")
            if [[ $# -lt 3 ]]; then
                echo -e "${RED}❌ エラー: イテレーションIDとタスク名を指定してください${NC}"
                show_usage
                exit 1
            fi
            add_task "$2" "$3"
            ;;
        "update-task")
            if [[ $# -lt 4 ]]; then
                echo -e "${RED}❌ エラー: イテレーションID、タスクID、フェーズを指定してください${NC}"
                show_usage
                exit 1
            fi
            update_task "$2" "$3" "$4" "${5:-}"
            ;;
        "complete-task")
            if [[ $# -lt 3 ]]; then
                echo -e "${RED}❌ エラー: イテレーションIDとタスクIDを指定してください${NC}"
                show_usage
                exit 1
            fi
            complete_task "$2" "$3"
            ;;
        "status")
            if [[ $# -lt 2 ]]; then
                echo -e "${RED}❌ エラー: イテレーションIDを指定してください${NC}"
                show_usage
                exit 1
            fi
            update_metrics "$2"  # 最新情報に更新
            show_status "$2"
            ;;
        "list")
            list_iterations
            ;;
        *)
            show_usage
            ;;
    esac
}

# 直接実行の場合
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi