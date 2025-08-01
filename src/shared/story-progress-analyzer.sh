#!/bin/bash

# ユーザーストーリー進捗解析スクリプト
# 使用法: bash story-progress-analyzer.sh [stories-file-path] [output-format]

STORIES_FILE=${1:-"docs/agile-artifacts/stories/user-stories-v1.0.md"}
OUTPUT_FORMAT=${2:-"summary"}  # summary, detailed, json

# ストーリー情報を解析
analyze_stories() {
    local stories_file="$1"
    
    if [ ! -f "$stories_file" ]; then
        echo "ストーリーファイルが見つかりません: $stories_file" >&2
        return 1
    fi
    
    # Story行を抽出（## Story X: で始まる行）
    local story_lines=$(grep -n "^## Story [0-9]\+:" "$stories_file")
    local total_stories=$(echo "$story_lines" | wc -l)
    
    if [ "$total_stories" -eq 0 ]; then
        echo "Storyが見つかりません" >&2
        return 1
    fi
    
    local completed_count=0
    local in_progress_count=0
    local pending_count=0
    local completed_stories=""
    local current_story=""
    local next_story=""
    
    # 各Storyの状態を分析
    while IFS= read -r story_line; do
        if [ -z "$story_line" ]; then
            continue
        fi
        
        local line_num=$(echo "$story_line" | cut -d: -f1)
        local story_title=$(echo "$story_line" | cut -d: -f2-)
        local story_num=$(echo "$story_title" | grep -o "Story [0-9]\+" | grep -o "[0-9]\+")
        local story_name=$(echo "$story_title" | sed 's/^## Story [0-9]\+: *[^-]* - *//')
        
        # そのStoryセクションの内容を抽出（次の20行程度）
        local story_content=$(sed -n "${line_num},$((line_num + 20))p" "$stories_file")
        
        # チェックボックスの状態を確認
        local checked_boxes=$(echo "$story_content" | grep -c "\[x\]")
        local total_boxes=$(echo "$story_content" | grep -c "\[\(x\|\s\)\]")
        
        # 状態判定
        if [ "$total_boxes" -gt 0 ]; then
            if [ "$checked_boxes" -eq "$total_boxes" ]; then
                # 全てチェック済み = 完了
                completed_count=$((completed_count + 1))
                if [ -n "$completed_stories" ]; then
                    completed_stories="$completed_stories, Story $story_num"
                else
                    completed_stories="Story $story_num"
                fi
            elif [ "$checked_boxes" -gt 0 ]; then
                # 一部チェック済み = 進行中
                in_progress_count=$((in_progress_count + 1))
                current_story="Story $story_num: $story_name"
            else
                # チェックなし = 未着手
                pending_count=$((pending_count + 1))
                if [ -z "$next_story" ]; then
                    next_story="Story $story_num: $story_name"
                fi
            fi
        else
            # チェックボックスがない場合は未着手扱い
            pending_count=$((pending_count + 1))
        fi
    done <<< "$story_lines"
    
    # 進捗率計算
    local progress_percent=0
    if [ "$total_stories" -gt 0 ]; then
        progress_percent=$((completed_count * 100 / total_stories))
    fi
    
    # 現在のStoryが空の場合、次のStoryを現在として扱う
    if [ -z "$current_story" ] && [ -n "$next_story" ]; then
        current_story="$next_story"
        next_story=""
    fi
    
    # 結果を環境変数として設定（他のスクリプトから利用可能）
    export TOTAL_STORIES="$total_stories"
    export COMPLETED_STORIES_COUNT="$completed_count"
    export IN_PROGRESS_COUNT="$in_progress_count" 
    export PENDING_COUNT="$pending_count"
    export COMPLETED_STORIES_LIST="$completed_stories"
    export CURRENT_STORY="$current_story"
    export NEXT_STORY="$next_story"
    export PROGRESS_PERCENT="$progress_percent"
}

# 進捗サマリーを生成
generate_progress_summary() {
    local format="$1"
    
    case "$format" in
        "summary")
            echo "進捗: ${PROGRESS_PERCENT}% (${COMPLETED_STORIES_COUNT}/${TOTAL_STORIES} Story完了)"
            ;;
        "detailed")
            echo "📊 詳細進捗:"
            echo "  完了: ${COMPLETED_STORIES_COUNT}/${TOTAL_STORIES} Story"
            echo "  進行中: ${IN_PROGRESS_COUNT} Story" 
            echo "  未着手: ${PENDING_COUNT} Story"
            echo "  進捗率: ${PROGRESS_PERCENT}%"
            ;;
        "visual")
            local i=1
            while [ $i -le $TOTAL_STORIES ]; do
                if [ $i -le $COMPLETED_STORIES_COUNT ]; then
                    echo "Story $i: ✅ 完了"
                elif [ $i -eq $((COMPLETED_STORIES_COUNT + 1)) ] && [ $IN_PROGRESS_COUNT -gt 0 ]; then
                    echo "Story $i: ⏳ 進行中"
                else
                    echo "Story $i: ⭕ 未実装"
                fi
                i=$((i + 1))
            done
            echo ""
            echo "進捗: ${PROGRESS_PERCENT}% (${COMPLETED_STORIES_COUNT}/${TOTAL_STORIES} Story完了)"
            ;;
        "json")
            cat << EOF
{
  "total_stories": $TOTAL_STORIES,
  "completed": $COMPLETED_STORIES_COUNT,
  "in_progress": $IN_PROGRESS_COUNT,
  "pending": $PENDING_COUNT,
  "progress_percent": $PROGRESS_PERCENT,
  "completed_stories": "$COMPLETED_STORIES_LIST",
  "current_story": "$CURRENT_STORY",
  "next_story": "$NEXT_STORY"
}
EOF
            ;;
    esac
}

# メイン実行
main() {
    if [ ! -f "$STORIES_FILE" ]; then
        echo "ストーリーファイルが見つかりません: $STORIES_FILE"
        return 1
    fi
    
    # ストーリー解析を実行
    analyze_stories "$STORIES_FILE"
    
    # 指定された形式で出力
    generate_progress_summary "$OUTPUT_FORMAT"
}

# スクリプトとして実行された場合
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi