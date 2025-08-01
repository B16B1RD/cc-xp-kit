#!/bin/bash

# リアルタイム進捗ダッシュボード
# プロジェクト全体の状況をコンパクトに可視化

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

# プロジェクト情報の収集
collect_project_info() {
    local info=()
    
    # ストーリーファイルの検索
    local story_file=""
    if [[ -d ".claude/agile-artifacts/stories" ]]; then
        story_file=$(find ".claude/agile-artifacts/stories" -name "*.md" -type f | sort -V | tail -1)
    fi
    
    # イテレーションファイルの検索
    local iteration_file=""
    if [[ -d ".claude/agile-artifacts/iterations" ]]; then
        iteration_file=$(find ".claude/agile-artifacts/iterations" -name "*.md" -type f | sort -V | tail -1)
    fi
    
    # ToDoファイルの検索
    local todo_file=""
    if [[ -f ".claude/agile-artifacts/tdd-logs/todo-list.md" ]]; then
        todo_file=".claude/agile-artifacts/tdd-logs/todo-list.md"
    fi
    
    # プロジェクト名の取得
    local project_name="Unknown Project"
    if [[ -n "$story_file" ]] && [[ -f "$story_file" ]]; then
        project_name=$(grep "^\*\*プロジェクト\*\*:" "$story_file" | head -1 | sed 's/^\*\*プロジェクト\*\*:[[:space:]]*//' | sed 's/[[:space:]]*$//')
        if [[ -z "$project_name" ]]; then
            project_name=$(basename "$(pwd)")
        fi
    else
        project_name=$(basename "$(pwd)")
    fi
    
    info=("$project_name" "$story_file" "$iteration_file" "$todo_file")
    printf '%s\n' "${info[@]}"
}

# ストーリー進捗の計算
calculate_story_progress() {
    local story_file="$1"
    
    if [[ -z "$story_file" ]] || [[ ! -f "$story_file" ]]; then
        echo "0 0 0"
        return
    fi
    
    local completed_count=$(grep -c "^[[:space:]]*-[[:space:]]*\[x\]" "$story_file" 2>/dev/null || echo "0")
    local total_count=$(grep -c "^[[:space:]]*-[[:space:]]*\[[[:space:]x]*\]" "$story_file" 2>/dev/null || echo "0")
    local progress_percentage=0
    
    if [[ "$total_count" -gt 0 ]]; then
        progress_percentage=$((completed_count * 100 / total_count))
    fi
    
    echo "$completed_count $total_count $progress_percentage"
}

# ToDo状況の分析
analyze_todo_status() {
    local todo_file="$1"
    
    if [[ -z "$todo_file" ]] || [[ ! -f "$todo_file" ]]; then
        echo "0 0 0"
        return
    fi
    
    local total_todos=$(grep -c "^- \[ \]" "$todo_file" 2>/dev/null || echo "0")
    local high_anxiety=$(grep -c "不安度: [5-7]/7" "$todo_file" 2>/dev/null || echo "0")
    local high_priority=$(grep -A 10 "## 🔥 高優先度" "$todo_file" | grep -c "^- \[ \]" 2>/dev/null || echo "0")
    
    echo "$total_todos $high_anxiety $high_priority"
}

# 開発フェーズの判定
determine_development_phase() {
    local story_progress="$1"
    local has_story_file="$2"
    local has_iteration_file="$3"
    
    if [[ "$has_story_file" == "false" ]]; then
        echo "setup"
    elif [[ "$has_iteration_file" == "false" ]]; then
        echo "planning"
    elif [[ "$story_progress" -lt 20 ]]; then
        echo "initial"
    elif [[ "$story_progress" -lt 50 ]]; then
        echo "development"
    elif [[ "$story_progress" -lt 80 ]]; then
        echo "advanced"
    elif [[ "$story_progress" -lt 95 ]]; then
        echo "finishing"
    else
        echo "completed"
    fi
}

# 推奨アクションの生成
generate_recommendations() {
    local phase="$1"
    local story_progress="$2"
    local high_anxiety_todos="$3"
    local high_priority_todos="$4"
    
    echo -e "${BOLD}🎯 推奨アクション:${NC}"
    
    case "$phase" in
        "setup")
            echo -e "   ${RED}1. ストーリーファイル作成${NC} - /tdd:story で要望を整理"
            echo -e "   ${BLUE}2. プロジェクト構造確認${NC} - 基本ディレクトリの準備"
            ;;
        "planning")
            echo -e "   ${RED}1. イテレーション計画作成${NC} - /tdd:plan で90分計画"
            echo -e "   ${BLUE}2. 技術スタック確認${NC} - テスト環境の準備"
            ;;
        "initial")
            echo -e "   ${RED}1. 基本機能のTDD実装${NC} - /tdd:run で核心機能"
            echo -e "   ${BLUE}2. Fake It戦略活用${NC} - ハードコーディングから開始"
            if [[ "$high_anxiety_todos" -gt 0 ]]; then
                echo -e "   ${YELLOW}3. 高不安度項目対処${NC} - $high_anxiety_todos 個要対応"
            fi
            ;;
        "development")
            echo -e "   ${GREEN}1. 機能実装継続${NC} - 残り ${YELLOW}$((100-story_progress))%${NC}"
            echo -e "   ${BLUE}2. Triangulation適用${NC} - 2つ目のテストで一般化"
            if [[ "$high_priority_todos" -gt 0 ]]; then
                echo -e "   ${RED}3. 高優先度ToDo処理${NC} - $high_priority_todos 個要対応"
            fi
            ;;
        "advanced")
            echo -e "   ${GREEN}1. 品質向上フェーズ${NC} - エッジケース追加"
            echo -e "   ${BLUE}2. リファクタリング実施${NC} - 構造改善"
            echo -e "   ${PURPLE}3. パフォーマンス最適化${NC} - 速度・効率改善"
            ;;
        "finishing")  
            echo -e "   ${GREEN}1. 最終テスト実施${NC} - 完全性確認"
            echo -e "   ${BLUE}2. ドキュメント整備${NC} - 使用方法記載"
            echo -e "   ${PURPLE}3. ユーザーフィードバック収集${NC} - 価値確認"
            ;;
        "completed")
            echo -e "   ${GREEN}1. 🎉 開発完了！${NC} - 品質レビュー実施"
            echo -e "   ${BLUE}2. 次のストーリー検討${NC} - 新機能企画"
            echo -e "   ${PURPLE}3. 振り返り実施${NC} - 学習内容整理"
            ;;
    esac
}

# コンパクトダッシュボード表示
show_compact_dashboard() {
    local info=($(collect_project_info))
    local project_name="${info[0]}"
    local story_file="${info[1]}"
    local iteration_file="${info[2]}"
    local todo_file="${info[3]}"
    
    # ストーリー進捗の計算
    local story_stats=($(calculate_story_progress "$story_file"))
    local completed_criteria="${story_stats[0]}"
    local total_criteria="${story_stats[1]}"
    local story_progress="${story_stats[2]}"
    
    # ToDo状況の分析
    local todo_stats=($(analyze_todo_status "$todo_file"))
    local total_todos="${todo_stats[0]}"
    local high_anxiety_todos="${todo_stats[1]}"
    local high_priority_todos="${todo_stats[2]}"
    
    # 開発フェーズの判定
    local has_story=$([[ -n "$story_file" ]] && echo "true" || echo "false")
    local has_iteration=$([[ -n "$iteration_file" ]] && echo "true" || echo "false")
    local phase=$(determine_development_phase "$story_progress" "$has_story" "$has_iteration")
    
    # コンパクト表示
    echo -e "${BOLD}${CYAN}🚀 $project_name - クイック状況${NC}"
    
    # フェーズ表示
    local phase_icon=""
    local phase_text=""
    case "$phase" in
        "setup") phase_icon="🔧"; phase_text="セットアップ期" ;;
        "planning") phase_icon="📋"; phase_text="計画策定期" ;;
        "initial") phase_icon="🔥"; phase_text="初期開発期" ;;
        "development") phase_icon="⚡"; phase_text="開発加速期" ;;
        "advanced") phase_icon="🔧"; phase_text="品質向上期" ;;
        "finishing") phase_icon="🎯"; phase_text="仕上げ期" ;;
        "completed") phase_icon="🎉"; phase_text="完成" ;;
    esac
    
    echo -e "フェーズ: $phase_icon ${BOLD}$phase_text${NC}"
    
    # 進捗バー
    if [[ "$total_criteria" -gt 0 ]]; then
        local bar_length=10
        local completed_bars=$((story_progress * bar_length / 100))
        local remaining_bars=$((bar_length - completed_bars))
        
        echo -ne "進捗: ["
        for ((i=0; i<completed_bars; i++)); do echo -ne "${GREEN}■${NC}"; done
        for ((i=0; i<remaining_bars; i++)); do echo -ne "□"; done
        echo -e "] ${BOLD}$story_progress%${NC} ($completed_criteria/$total_criteria)"
    else
        echo -e "進捗: ${YELLOW}ストーリー未作成${NC}"
    fi
    
    # 重要指標
    local indicators=()
    if [[ "$high_anxiety_todos" -gt 0 ]]; then
        indicators+=("${RED}高不安:$high_anxiety_todos${NC}")
    fi
    if [[ "$high_priority_todos" -gt 0 ]]; then
        indicators+=("${YELLOW}高優先:$high_priority_todos${NC}")
    fi
    if [[ "$total_todos" -gt 0 ]]; then
        indicators+=("${BLUE}ToDo:$total_todos${NC}")
    fi
    
    if [[ ${#indicators[@]} -gt 0 ]]; then
        echo -e "注意: ${indicators[*]}"
    fi
    
    # 最重要アクション1つ
    echo -ne "次: "
    case "$phase" in
        "setup") echo -e "${RED}/tdd:story${NC} でストーリー作成" ;;
        "planning") echo -e "${RED}/tdd:plan${NC} で90分計画" ;;
        "initial"|"development") 
            if [[ "$high_anxiety_todos" -gt 0 ]]; then
                echo -e "${RED}高不安度ToDo対処${NC}"
            else
                echo -e "${GREEN}/tdd:run${NC} で機能実装"
            fi
            ;;
        "advanced") echo -e "${BLUE}品質向上${NC}・リファクタリング" ;;
        "finishing") echo -e "${PURPLE}最終テスト${NC}・ドキュメント" ;;
        "completed") echo -e "${GREEN}🎉 完成！${NC} レビュー実施" ;;
    esac
}

# 詳細ダッシュボード表示
show_detailed_dashboard() {
    local info=($(collect_project_info))
    local project_name="${info[0]}"
    local story_file="${info[1]}"
    local iteration_file="${info[2]}"
    local todo_file="${info[3]}"
    
    echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}📊 プロジェクト詳細ダッシュボード${NC}"
    echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    echo -e "\n${BOLD}🎯 プロジェクト: ${GREEN}$project_name${NC}${BOLD}"
    echo -e "📅 最終更新: $(date '+%Y-%m-%d %H:%M')${NC}"
    
    # ストーリー進捗詳細
    echo -e "\n${BOLD}📖 ストーリー進捗:${NC}"
    if [[ -n "$story_file" ]] && [[ -f "$story_file" ]]; then
        local story_stats=($(calculate_story_progress "$story_file"))
        local completed_criteria="${story_stats[0]}"
        local total_criteria="${story_stats[1]}"
        local story_progress="${story_stats[2]}"
        
        echo -e "   ファイル: $(basename "$story_file")"
        echo -e "   受け入れ基準: $completed_criteria/$total_criteria 完了 (${BOLD}$story_progress%${NC})"
        
        # 詳細プログレスバー
        local bar_length=20
        local completed_bars=$((story_progress * bar_length / 100))
        local remaining_bars=$((bar_length - completed_bars))
        
        echo -ne "   進捗: ["
        for ((i=0; i<completed_bars; i++)); do echo -ne "${GREEN}■${NC}"; done
        for ((i=0; i<remaining_bars; i++)); do echo -ne "□"; done
        echo -e "] ${BOLD}$story_progress%${NC}"
        
    else
        echo -e "   ${RED}ストーリーファイル未作成${NC}"
        echo -e "   推奨: /tdd:story でストーリー作成"
    fi
    
    # イテレーション情報
    echo -e "\n${BOLD}📋 イテレーション:${NC}"
    if [[ -n "$iteration_file" ]] && [[ -f "$iteration_file" ]]; then
        echo -e "   ファイル: $(basename "$iteration_file")"
        echo -e "   更新日: $(date -r "$iteration_file" '+%Y-%m-%d %H:%M')"
        
        # 現在のタスク数を概算
        local total_tasks=$(grep -c "^### Task" "$iteration_file" 2>/dev/null || echo "0")
        if [[ "$total_tasks" -gt 0 ]]; then
            echo -e "   タスク数: $total_tasks 個"
        fi
    else
        echo -e "   ${RED}イテレーション計画未作成${NC}"
        echo -e "   推奨: /tdd:plan でイテレーション計画"
    fi
    
    # ToDo分析詳細
    echo -e "\n${BOLD}📝 ToDo分析:${NC}"
    if [[ -n "$todo_file" ]] && [[ -f "$todo_file" ]]; then
        local todo_stats=($(analyze_todo_status "$todo_file"))
        local total_todos="${todo_stats[0]}"
        local high_anxiety_todos="${todo_stats[1]}"
        local high_priority_todos="${todo_stats[2]}"
        
        echo -e "   総ToDo数: $total_todos"
        
        if [[ "$high_anxiety_todos" -gt 0 ]]; then
            echo -e "   ${RED}高不安度項目: $high_anxiety_todos 個${NC} ⚠️"
        fi
        
        if [[ "$high_priority_todos" -gt 0 ]]; then
            echo -e "   ${YELLOW}高優先度項目: $high_priority_todos 個${NC}"
        fi
        
        # 不安度分布
        local anxiety_7=$(grep -c "不安度: 7/7" "$todo_file" 2>/dev/null || echo "0")
        local anxiety_6=$(grep -c "不安度: 6/7" "$todo_file" 2>/dev/null || echo "0")
        local anxiety_5=$(grep -c "不安度: 5/7" "$todo_file" 2>/dev/null || echo "0")
        
        if [[ "$((anxiety_7 + anxiety_6 + anxiety_5))" -gt 0 ]]; then
            echo -e "   不安度分布: ${RED}7:$anxiety_7${NC} ${RED}6:$anxiety_6${NC} ${YELLOW}5:$anxiety_5${NC}"
        fi
        
    else
        echo -e "   ${GREEN}ToDo なし${NC}"
    fi
    
    # Git情報（利用可能時）
    if git rev-parse --git-dir > /dev/null 2>&1; then
        echo -e "\n${BOLD}📊 Git情報:${NC}"
        local current_branch=$(git branch --show-current 2>/dev/null || echo "unknown")
        local commit_count=$(git rev-list --count HEAD 2>/dev/null || echo "0")
        local last_commit=$(git log -1 --pretty=format:"%h %s (%ar)" 2>/dev/null || echo "コミットなし")
        
        echo -e "   ブランチ: $current_branch"
        echo -e "   コミット数: $commit_count"
        echo -e "   最新コミット: $last_commit"
    fi
    
    # 開発フェーズと推奨アクション
    local story_progress=0
    if [[ -n "$story_file" ]] && [[ -f "$story_file" ]]; then
        local story_stats=($(calculate_story_progress "$story_file"))
        story_progress="${story_stats[2]}"
    fi
    
    local has_story=$([[ -n "$story_file" ]] && echo "true" || echo "false")
    local has_iteration=$([[ -n "$iteration_file" ]] && echo "true" || echo "false")
    local phase=$(determine_development_phase "$story_progress" "$has_story" "$has_iteration")
    
    echo -e "\n${BOLD}🎯 現在のフェーズ:${NC}"
    case "$phase" in
        "setup") echo -e "   ${RED}🔧 セットアップ期${NC} - 基盤準備" ;;
        "planning") echo -e "   ${BLUE}📋 計画策定期${NC} - イテレーション設計" ;;
        "initial") echo -e "   ${RED}🔥 初期開発期${NC} - 核心機能実装" ;;
        "development") echo -e "   ${YELLOW}⚡ 開発加速期${NC} - 機能拡張" ;;
        "advanced") echo -e "   ${BLUE}🔧 品質向上期${NC} - 仕上げ作業" ;;
        "finishing") echo -e "   ${PURPLE}🎯 仕上げ期${NC} - 最終調整" ;;
        "completed") echo -e "   ${GREEN}🎉 完成${NC} - 開発完了" ;;
    esac
    
    echo -e "\n$(generate_recommendations "$phase" "$story_progress" "${todo_stats[1]}" "${todo_stats[2]}")"
    
    # 品質指標
    echo -e "\n${BOLD}📈 品質指標:${NC}"
    local quality_score=0
    local indicators=()
    
    # ストーリー進捗による加点
    if [[ "$story_progress" -ge 80 ]]; then
        quality_score=$((quality_score + 3))
        indicators+=("${GREEN}高進捗${NC}")
    elif [[ "$story_progress" -ge 50 ]]; then
        quality_score=$((quality_score + 2))
        indicators+=("${YELLOW}中進捗${NC}")
    fi
    
    # 不安度による減点
    if [[ "${todo_stats[1]}" -eq 0 ]]; then
        quality_score=$((quality_score + 2))
        indicators+=("${GREEN}低不安${NC}")
    elif [[ "${todo_stats[1]}" -le 2 ]]; then
        quality_score=$((quality_score + 1))
        indicators+=("${YELLOW}中不安${NC}")
    else
        indicators+=("${RED}高不安${NC}")
    fi
    
    # Git使用による加点
    if git rev-parse --git-dir > /dev/null 2>&1; then
        quality_score=$((quality_score + 1))
        indicators+=("${BLUE}Git管理${NC}")
    fi
    
    echo -e "   スコア: ${BOLD}$quality_score/6${NC}"
    echo -e "   要素: ${indicators[*]}"
}

# 使用方法の表示
show_usage() {
    echo "使用方法: $0 <mode>"
    echo ""
    echo "モード:"
    echo "  compact   - コンパクト表示（デフォルト）"
    echo "  detailed  - 詳細ダッシュボード表示"
    echo ""
    echo "例:"
    echo "  $0 compact"
    echo "  $0 detailed"
}

# メイン関数
main() {
    local mode="${1:-compact}"
    
    case "$mode" in
        "compact")
            show_compact_dashboard
            ;;
        "detailed")
            show_detailed_dashboard
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