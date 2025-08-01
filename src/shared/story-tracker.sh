#!/bin/bash

# ストーリー進捗追跡システム
# 実装内容から受け入れ基準を自動検出・更新

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

# ストーリーファイルの検索
find_story_file() {
    local story_file=""
    
    # .claude/agile-artifacts/stories/ ディレクトリから最新のストーリーファイルを検索
    if [[ -d ".claude/agile-artifacts/stories" ]]; then
        story_file=$(find ".claude/agile-artifacts/stories" -name "*.md" -type f | sort -V | tail -1)
    fi
    
    if [[ -n "$story_file" ]] && [[ -f "$story_file" ]]; then
        echo "$story_file"
    else
        echo ""
    fi
}

# 使用方法の表示
show_usage() {
    echo "使用方法: $0 <command> [options]"
    echo ""
    echo "コマンド:"
    echo "  check <feature> <result>     - 受け入れ基準チェック（インタラクティブ）"
    echo "  progress                     - 進捗状況表示"
    echo "  update <criteria_id>         - 特定の受け入れ基準を完了マーク"
    echo "  detect <feature> <result>    - 実装から受け入れ基準を自動検出"
    echo "  status                       - ストーリー全体の状況表示"
    echo ""
    echo "例:"
    echo "  $0 check \"ゲームボード表示\" \"黒い背景に300x600のキャンバス表示\""
    echo "  $0 progress"
    echo "  $0 update 1"
}

# 実装内容から受け入れ基準を自動検出
detect_acceptance_criteria() {
    local feature="$1"
    local result="$2"
    
    echo -e "${BOLD}🔍 受け入れ基準自動検出システム${NC}"
    echo -e "実装機能: ${GREEN}$feature${NC}"
    echo -e "テスト結果: ${BLUE}$result${NC}"
    echo ""
    
    # キーワードベースの自動検出
    local detected_criteria=()
    
    # UI/表示関連の検出
    if echo "$result" | grep -iE "(表示|display|画面|screen|キャンバス|canvas|背景|background)" > /dev/null; then
        detected_criteria+=("表示機能が正常に動作する")
        
        # 具体的な表示内容の検出
        if echo "$result" | grep -iE "([0-9]+x[0-9]+|サイズ|size)" > /dev/null; then
            detected_criteria+=("指定されたサイズで表示される")
        fi
        
        if echo "$result" | grep -iE "(色|color|黒|白|赤|青|緑)" > /dev/null; then
            detected_criteria+=("適切な色・スタイルで表示される")
        fi
    fi
    
    # 操作・インタラクション関連の検出
    if echo "$result" | grep -iE "(クリック|click|キー|key|操作|operation)" > /dev/null; then
        detected_criteria+=("ユーザー操作に正しく応答する")
    fi
    
    # データ処理関連の検出
    if echo "$result" | grep -iE "(計算|calculation|結果|result|値|value)" > /dev/null; then
        detected_criteria+=("正確な計算・処理結果を返す")
    fi
    
    # パフォーマンス関連の検出
    if echo "$result" | grep -iE "(速度|speed|時間|time|遅延|delay)" > /dev/null; then
        detected_criteria+=("適切な応答速度で動作する")
    fi
    
    # 基本的な動作確認
    if echo "$result" | grep -iE "(動作|work|機能|function|成功|success)" > /dev/null; then
        detected_criteria+=("基本機能が期待通り動作する")
    fi
    
    # 検出結果の表示
    if [[ ${#detected_criteria[@]} -gt 0 ]]; then
        echo -e "${GREEN}✅ 以下の受け入れ基準が検出されました:${NC}"
        for i in "${!detected_criteria[@]}"; do
            echo -e "   $((i+1)). ${detected_criteria[$i]}"
        done
    else
        echo -e "${YELLOW}⚠️  自動検出できませんでした。手動で受け入れ基準を確認してください。${NC}"
    fi
    
    echo ""
    return 0
}

# インタラクティブな受け入れ基準チェック
interactive_criteria_check() {
    local feature="$1"
    local result="$2"
    local story_file=$(find_story_file)
    
    if [[ -z "$story_file" ]]; then
        echo -e "${RED}❌ ストーリーファイルが見つかりません${NC}"
        echo -e "   .claude/agile-artifacts/stories/ ディレクトリにストーリーファイルを作成してください"
        return 1
    fi
    
    echo -e "${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}📋 受け入れ基準インタラクティブチェック${NC}"
    echo -e "${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    echo -e "\n${BLUE}実装機能:${NC} $feature"
    echo -e "${BLUE}テスト結果:${NC} $result"
    
    # 自動検出実行
    echo -e "\n${BOLD}🔍 自動検出を実行中...${NC}"
    detect_acceptance_criteria "$feature" "$result"
    
    echo -e "\n${BOLD}📝 ストーリーファイルから未完了の受け入れ基準を抽出中...${NC}"
    
    # 未完了の受け入れ基準を抽出
    local uncompleted_criteria=()
    local criteria_lines=()
    
    while IFS= read -r line || [[ -n "$line" ]]; do
        if [[ "$line" =~ ^[[:space:]]*-[[:space:]]*\[[[:space:]]*\][[:space:]]* ]]; then
            uncompleted_criteria+=("$line")
            criteria_lines+=($(grep -n "^[[:space:]]*-[[:space:]]*\[[[:space:]]*\][[:space:]]*" "$story_file" | head -${#uncompleted_criteria[@]} | tail -1 | cut -d: -f1))
        fi
    done < "$story_file"
    
    if [[ ${#uncompleted_criteria[@]} -eq 0 ]]; then
        echo -e "${GREEN}🎉 すべての受け入れ基準が完了済みです！${NC}"
        return 0
    fi
    
    echo -e "\n${YELLOW}📋 未完了の受け入れ基準:${NC}"
    for i in "${!uncompleted_criteria[@]}"; do
        echo -e "   $((i+1)). ${uncompleted_criteria[$i]}"
    done
    
    echo -e "\n${BOLD}❓ 今回の実装で完了した受け入れ基準はありますか？${NC}"
    echo -e "   完了した基準の番号を入力してください（複数可、カンマ区切り）"
    echo -e "   完了したものがない場合はEnterを押してください"
    
    read -p "完了した基準: " completed_numbers
    
    if [[ -n "$completed_numbers" ]]; then
        # カンマ区切りで分割
        IFS=',' read -ra numbers <<< "$completed_numbers"
        
        local temp_file=$(mktemp)
        cp "$story_file" "$temp_file"
        
        # 各番号に対してチェックマークを付ける
        for num_str in "${numbers[@]}"; do
            local num=$(echo "$num_str" | tr -d ' ')  # 空白を除去
            
            if [[ "$num" =~ ^[0-9]+$ ]] && [[ "$num" -ge 1 ]] && [[ "$num" -le ${#uncompleted_criteria[@]} ]]; then
                local line_num=${criteria_lines[$((num-1))]}
                local criteria_text="${uncompleted_criteria[$((num-1))]}"
                
                # [ ] を [x] に変更
                sed -i "${line_num}s/\[ \]/[x]/" "$temp_file"
                
                echo -e "${GREEN}✅ 完了マーク追加: ${NC}$(echo "$criteria_text" | sed 's/^[[:space:]]*-[[:space:]]*\[[[:space:]]*\][[:space:]]*//')"
            else
                echo -e "${RED}❌ 無効な番号: $num${NC}"
            fi
        done
        
        # ファイルを更新
        mv "$temp_file" "$story_file"
        
        echo -e "\n${GREEN}📝 ストーリーファイルが更新されました${NC}"
        
        # 進捗状況を表示
        show_progress
    else
        echo -e "${BLUE}ℹ️  受け入れ基準の更新はスキップされました${NC}"
    fi
}

# 進捗状況表示
show_progress() {
    local story_file=$(find_story_file)
    
    if [[ -z "$story_file" ]]; then
        echo -e "${RED}❌ ストーリーファイルが見つかりません${NC}"
        return 1
    fi
    
    echo -e "${BOLD}${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}📊 ストーリー進捗状況${NC}"
    echo -e "${BOLD}${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    # 完了・未完了の受け入れ基準をカウント
    local completed_count=$(grep -c "^[[:space:]]*-[[:space:]]*\[x\]" "$story_file" 2>/dev/null || echo "0")
    local total_count=$(grep -c "^[[:space:]]*-[[:space:]]*\[[[:space:]x]*\]" "$story_file" 2>/dev/null || echo "0")
    local uncompleted_count=$((total_count - completed_count))
    
    if [[ "$total_count" -eq 0 ]]; then
        echo -e "${YELLOW}⚠️  受け入れ基準が見つかりません${NC}"
        return 1
    fi
    
    # 進捗率計算
    local progress_percentage=0
    if [[ "$total_count" -gt 0 ]]; then
        progress_percentage=$((completed_count * 100 / total_count))
    fi
    
    echo -e "\n${BOLD}📈 進捗サマリー:${NC}"
    echo -e "   総受け入れ基準数: ${CYAN}$total_count${NC}"
    echo -e "   完了済み: ${GREEN}$completed_count${NC}"
    echo -e "   未完了: ${YELLOW}$uncompleted_count${NC}"
    echo -e "   進捗率: ${BOLD}$progress_percentage%${NC}"
    
    # プログレスバー表示
    local bar_length=20
    local completed_bars=$((progress_percentage * bar_length / 100))
    local remaining_bars=$((bar_length - completed_bars))
    
    echo -ne "\n   進捗: ["
    for ((i=0; i<completed_bars; i++)); do echo -ne "${GREEN}■${NC}"; done
    for ((i=0; i<remaining_bars; i++)); do echo -ne "□"; done
    echo -e "] ${BOLD}$progress_percentage%${NC}"
    
    # 完了した基準の表示
    if [[ "$completed_count" -gt 0 ]]; then
        echo -e "\n${GREEN}✅ 完了済み受け入れ基準:${NC}"
        grep "^[[:space:]]*-[[:space:]]*\[x\]" "$story_file" | sed 's/^[[:space:]]*-[[:space:]]*\[x\][[:space:]]*/   ✓ /'
    fi
    
    # 未完了の基準の表示
    if [[ "$uncompleted_count" -gt 0 ]]; then
        echo -e "\n${YELLOW}📋 未完了受け入れ基準:${NC}"
        grep "^[[:space:]]*-[[:space:]]*\[[[:space:]]*\]" "$story_file" | sed 's/^[[:space:]]*-[[:space:]]*\[[[:space:]]*\][[:space:]]*/   ○ /'
    fi
    
    # 次のアクション提案
    echo -e "\n${BOLD}🎯 次のアクション:${NC}"
    if [[ "$progress_percentage" -lt 30 ]]; then
        echo -e "   ${RED}🔥 初期段階 - 基本機能の実装に集中${NC}"
    elif [[ "$progress_percentage" -lt 70 ]]; then
        echo -e "   ${YELLOW}⚡ 開発加速期 - 残りの核心機能を追加${NC}"
    elif [[ "$progress_percentage" -lt 90 ]]; then
        echo -e "   ${BLUE}🔧 仕上げ期 - 品質向上と細部調整${NC}"
    else
        echo -e "   ${GREEN}🎉 完成間近 - 最終テストとレビュー${NC}"
    fi
}

# 特定の受け入れ基準を完了マーク
update_criteria() {
    local criteria_id="$1"
    local story_file=$(find_story_file)
    
    if [[ -z "$story_file" ]]; then
        echo -e "${RED}❌ ストーリーファイルが見つかりません${NC}"
        return 1
    fi
    
    # N番目の未完了基準を検索
    local line_num=$(grep -n "^[[:space:]]*-[[:space:]]*\[[[:space:]]*\]" "$story_file" | sed -n "${criteria_id}p" | cut -d: -f1)
    
    if [[ -n "$line_num" ]]; then
        sed -i "${line_num}s/\[ \]/[x]/" "$story_file"
        echo -e "${GREEN}✅ 受け入れ基準 $criteria_id を完了マークしました${NC}"
        show_progress
    else
        echo -e "${RED}❌ 受け入れ基準 ID $criteria_id が見つかりません${NC}"
        return 1
    fi
}

# ストーリー全体の状況表示
show_status() {
    local story_file=$(find_story_file)
    
    if [[ -z "$story_file" ]]; then
        echo -e "${RED}❌ ストーリーファイルが見つかりません${NC}"
        return 1
    fi
    
    echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}📖 ストーリー全体状況${NC}"
    echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    echo -e "\n${BOLD}📄 ストーリーファイル:${NC} $(basename "$story_file")"
    echo -e "${BOLD}📅 最終更新:${NC} $(date -r "$story_file" "+%Y-%m-%d %H:%M")"
    
    # ストーリータイトルの抽出
    local story_title=$(grep "^# " "$story_file" | head -1 | sed 's/^# //')
    if [[ -n "$story_title" ]]; then
        echo -e "${BOLD}📝 タイトル:${NC} $story_title"
    fi
    
    # プロジェクト情報の抽出
    local project_info=$(grep "^\*\*プロジェクト\*\*:" "$story_file" | head -1 | sed 's/^\*\*プロジェクト\*\*:[[:space:]]*//')
    if [[ -n "$project_info" ]]; then
        echo -e "${BOLD}🎯 プロジェクト:${NC} $project_info"
    fi
    
    # 進捗状況の表示
    show_progress
    
    # 最近の更新履歴（Git使用時）
    if git rev-parse --git-dir > /dev/null 2>&1; then
        echo -e "\n${BOLD}📊 最近の更新:${NC}"
        git log --oneline -3 --pretty=format:"   %h %s (%ar)" -- "$story_file" 2>/dev/null || echo "   更新履歴なし"
    fi
}

# メイン関数
main() {
    local command="${1:-}"
    
    case "$command" in
        "check")
            if [[ $# -lt 3 ]]; then
                echo -e "${RED}❌ エラー: 機能名と結果を指定してください${NC}"
                show_usage
                exit 1
            fi
            interactive_criteria_check "$2" "$3"
            ;;
        "progress")
            show_progress
            ;;
        "update")
            if [[ $# -lt 2 ]]; then
                echo -e "${RED}❌ エラー: 基準IDを指定してください${NC}"
                show_usage
                exit 1
            fi
            update_criteria "$2"
            ;;
        "detect")
            if [[ $# -lt 3 ]]; then
                echo -e "${RED}❌ エラー: 機能名と結果を指定してください${NC}"
                show_usage
                exit 1
            fi
            detect_acceptance_criteria "$2" "$3"
            ;;
        "status")
            show_status
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