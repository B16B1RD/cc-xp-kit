#!/bin/bash

# Kent Beck流To-Do管理システム
# "Most Anxious Thing First" 原則に基づく自動優先度判定

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

# ToDo保存ディレクトリ
TODO_DIR=".claude/agile-artifacts/tdd-logs"
TODO_FILE="$TODO_DIR/todo-list.md"

# ディレクトリ作成
ensure_todo_dir() {
    mkdir -p "$TODO_DIR"
}

# 使用方法の表示
show_usage() {
    echo "使用方法: $0 <command> [options]"
    echo ""
    echo "コマンド:"
    echo "  add <content> [priority] [context]  - ToDo追加（優先度自動判定）"
    echo "  list [priority]                     - ToDo一覧表示"
    echo "  complete <id>                       - ToDo完了"
    echo "  remove <id>                         - ToDo削除"
    echo "  anxiety                             - 不安度分析表示"
    echo "  feature-anxiety                     - フィーチャーレベル不安度分析"
    echo ""
    echo "優先度:"
    echo "  high    - システム安定性（エラー、クラッシュ、セキュリティ）"
    echo "  medium  - 品質保証（テスト、検証、パフォーマンス）" 
    echo "  low     - 将来改善（最適化、リファクタ、機能拡張）"
    echo ""
    echo "例:"
    echo "  $0 add \"エラーハンドリング追加\""
    echo "  $0 add \"テストケース追加\" medium \"Step 1.2\""
    echo "  $0 list high"
    echo "  $0 complete 1"
}

# 自動優先度判定（Kent Beck "Most Anxious Thing First"）
auto_detect_priority() {
    local content="$1"
    local priority="auto"
    
    # 高優先度キーワード（システム安定性）
    if echo "$content" | grep -iE "(エラー|error|例外|exception|クラッシュ|crash|バグ|bug|セキュリティ|security|脆弱性|vulnerability|メモリリーク|memory.*leak|デッドロック|deadlock)" > /dev/null; then
        priority="high"
    # 中優先度キーワード（品質保証）
    elif echo "$content" | grep -iE "(テスト|test|検証|validation|パフォーマンス|performance|速度|speed|最適化|optimization|リファクタ|refactor|品質|quality)" > /dev/null; then
        priority="medium"
    # 低優先度キーワード（将来改善）
    elif echo "$content" | grep -iE "(機能拡張|enhancement|新機能|new.*feature|UI改善|ui.*improvement|ドキュメント|document|コメント|comment)" > /dev/null; then
        priority="low"
    # デフォルトは中優先度
    else
        priority="medium"
    fi
    
    echo "$priority"
}

# フィーチャー検出（同じ機能群のタスクを識別）
detect_feature_group() {
    local content="$1"
    local feature=""
    
    # フィーチャーキーワードによるグループ化
    if echo "$content" | grep -iE "(認証|auth|ログイン|login|ユーザー|user|セッション|session)" > /dev/null; then
        feature="authentication-system"
    elif echo "$content" | grep -iE "(データ|data|保存|save|storage|取得|retrieve|永続|persist)" > /dev/null; then
        feature="data-management"
    elif echo "$content" | grep -iE "(UI|画面|view|表示|display|コンポーネント|component)" > /dev/null; then
        feature="user-interface"
    elif echo "$content" | grep -iE "(API|通信|request|response|エンドポイント|endpoint)" > /dev/null; then
        feature="api-integration"
    elif echo "$content" | grep -iE "(テスト|test|検証|validation|品質|quality)" > /dev/null; then
        feature="quality-assurance"
    else
        feature="general-feature"
    fi
    
    echo "$feature"
}

# 不安度スコア計算（フィーチャーレベル考慮）
calculate_anxiety_score() {
    local priority="$1"
    local content="$2"
    local feature="${3:-}"
    
    local score=0
    
    # 優先度による基本スコア
    case "$priority" in
        "high") score=5 ;;
        "medium") score=3 ;;
        "low") score=1 ;;
    esac
    
    # 緊急性キーワードによる加算
    if echo "$content" | grep -iE "(緊急|urgent|即座|immediate|重要|critical|必須|required)" > /dev/null; then
        score=$((score + 2))
    fi
    
    # 不確実性キーワードによる加算
    if echo "$content" | grep -iE "(不明|unknown|調査|investigate|確認|check|検討|consider)" > /dev/null; then
        score=$((score + 1))
    fi
    
    # フィーチャーレベルの影響度加算
    if [[ -n "$feature" ]] && [[ "$feature" != "general-feature" ]]; then
        # 認証やデータ管理など重要フィーチャーは+1
        if [[ "$feature" == "authentication-system" ]] || [[ "$feature" == "data-management" ]]; then
            score=$((score + 1))
        fi
    fi
    
    # 最大7に制限
    if [[ "$score" -gt 7 ]]; then
        score=7
    fi
    
    echo "$score"
}

# ToDo追加
add_todo() {
    local content="$1"
    local priority="${2:-auto}"
    local context="${3:-}"
    
    ensure_todo_dir
    
    # 優先度の自動判定
    if [[ "$priority" == "auto" ]]; then
        priority=$(auto_detect_priority "$content")
    fi
    
    # フィーチャーグループ検出
    local feature_group=$(detect_feature_group "$content")
    
    # 不安度スコア計算（フィーチャーレベル考慮）
    local anxiety_score=$(calculate_anxiety_score "$priority" "$content" "$feature_group")
    
    # ID生成（タイムスタンプベース）
    local todo_id=$(date +%s)
    
    # ToDoファイルが存在しない場合は初期化
    if [[ ! -f "$TODO_FILE" ]]; then
        cat > "$TODO_FILE" << 'EOF'
# Kent Beck流 ToDo リスト

生成日時: $(date)
原則: "Do the most anxious thing first"

## 🔥 高優先度 (システム安定性)
## 🟡 中優先度 (品質保証)
## 🔵 低優先度 (将来改善)
EOF
    fi
    
    # ToDoエントリの追加
    local timestamp=$(date "+%Y-%m-%d %H:%M")
    local priority_icon=""
    local priority_section=""
    
    case "$priority" in
        "high")
            priority_icon="🔥"
            priority_section="## 🔥 高優先度 (システム安定性)"
            ;;
        "medium")
            priority_icon="🟡"
            priority_section="## 🟡 中優先度 (品質保証)"
            ;;
        "low")
            priority_icon="🔵"
            priority_section="## 🔵 低優先度 (将来改善)"
            ;;
    esac
    
    # ファイルの該当セクションに追加
    local temp_file=$(mktemp)
    local in_section=false
    
    while IFS= read -r line || [[ -n "$line" ]]; do
        echo "$line" >> "$temp_file"
        
        if [[ "$line" == "$priority_section" ]]; then
            in_section=true
        elif [[ "$line" =~ ^##.*$ ]] && [[ "$in_section" == true ]]; then
            # 新しいセクションに入ったので、前のセクションに追加
            echo "" >> "$temp_file"
            echo "- [ ] **[ID:$todo_id]** $content" >> "$temp_file"
            echo "  - 不安度: $anxiety_score/7" >> "$temp_file"
            echo "  - フィーチャー: $feature_group" >> "$temp_file"
            echo "  - 作成: $timestamp" >> "$temp_file"
            if [[ -n "$context" ]]; then
                echo "  - コンテキスト: $context" >> "$temp_file"
            fi
            echo "" >> "$temp_file"
            in_section=false
        fi
    done < "$TODO_FILE"
    
    # 最後のセクションの場合
    if [[ "$in_section" == true ]]; then
        echo "" >> "$temp_file"
        echo "- [ ] **[ID:$todo_id]** $content" >> "$temp_file"
        echo "  - 不安度: $anxiety_score/7" >> "$temp_file"
        echo "  - フィーチャー: $feature_group" >> "$temp_file"
        echo "  - 作成: $timestamp" >> "$temp_file"
        if [[ -n "$context" ]]; then
            echo "  - コンテキスト: $context" >> "$temp_file"
        fi
        echo "" >> "$temp_file"
    fi
    
    mv "$temp_file" "$TODO_FILE"
    
    echo -e "${GREEN}✅ ToDo追加完了${NC}"
    echo -e "   ID: ${BOLD}$todo_id${NC}"
    echo -e "   内容: $content"
    echo -e "   優先度: $priority_icon $priority"
    echo -e "   不安度: ${RED}$anxiety_score/7${NC}"
    echo -e "   フィーチャー: ${CYAN}$feature_group${NC}"
    
    if [[ "$anxiety_score" -ge 5 ]]; then
        echo -e "\n${RED}⚠️  高不安度項目です！Kent Beck原則により最優先で取り組むことを推奨${NC}"
    fi
}

# ToDo一覧表示
list_todos() {
    local filter_priority="${1:-all}"
    
    ensure_todo_dir
    
    if [[ ! -f "$TODO_FILE" ]]; then
        echo -e "${YELLOW}📝 ToDoリストが空です${NC}"
        echo -e "   新しいToDoを追加: ${CYAN}$0 add \"内容\"${NC}"
        return
    fi
    
    echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}📋 Kent Beck流 ToDo リスト${NC}"
    echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    # 高不安度項目の抽出と表示
    echo -e "\n${RED}🚨 最高不安度項目（最優先）:${NC}"
    if grep -A 20 "不安度: [6-7]/7" "$TODO_FILE" 2>/dev/null | head -10 | grep -v "^$" > /dev/null; then
        grep -B 1 -A 3 "不安度: [6-7]/7" "$TODO_FILE" | grep -E "^- \[ \]|不安度:|コンテキスト:" | head -10
    else
        echo -e "   ${GREEN}なし（良好な状態）${NC}"
    fi
    
    # 優先度別表示
    if [[ "$filter_priority" == "all" ]] || [[ "$filter_priority" == "high" ]]; then
        echo -e "\n${RED}🔥 高優先度（システム安定性）:${NC}"
        display_priority_section "high"
    fi
    
    if [[ "$filter_priority" == "all" ]] || [[ "$filter_priority" == "medium" ]]; then
        echo -e "\n${YELLOW}🟡 中優先度（品質保証）:${NC}"
        display_priority_section "medium"
    fi
    
    if [[ "$filter_priority" == "all" ]] || [[ "$filter_priority" == "low" ]]; then
        echo -e "\n${BLUE}🔵 低優先度（将来改善）:${NC}"
        display_priority_section "low"
    fi
    
    # 統計情報
    local total_todos=$(grep -c "^- \[ \]" "$TODO_FILE" 2>/dev/null || echo "0")
    local high_anxiety=$(grep -c "不安度: [5-7]/7" "$TODO_FILE" 2>/dev/null || echo "0")
    
    echo -e "\n${BOLD}📊 統計:${NC}"
    echo -e "   総ToDo数: ${CYAN}$total_todos${NC}"
    echo -e "   高不安度項目: ${RED}$high_anxiety${NC}"
    
    if [[ "$high_anxiety" -gt 0 ]]; then
        echo -e "\n${BOLD}💡 Kent Beck原則: 高不安度項目から着手することを強く推奨${NC}"
    fi
}

# 優先度セクションの表示
display_priority_section() {
    local priority="$1"
    local section_marker=""
    
    case "$priority" in
        "high") section_marker="## 🔥 高優先度" ;;
        "medium") section_marker="## 🟡 中優先度" ;;
        "low") section_marker="## 🔵 低優先度" ;;
    esac
    
    # セクション内のToDoを抽出
    local temp_file=$(mktemp)
    local in_section=false
    
    while IFS= read -r line || [[ -n "$line" ]]; do
        if [[ "$line" =~ ^$section_marker ]]; then
            in_section=true
            continue
        elif [[ "$line" =~ ^##.*$ ]] && [[ "$in_section" == true ]]; then
            break
        elif [[ "$in_section" == true ]] && [[ -n "$line" ]]; then
            echo "$line" >> "$temp_file"
        fi
    done < "$TODO_FILE"
    
    if [[ -s "$temp_file" ]]; then
        # 不安度でソート（降順）
        local sorted_file=$(mktemp)
        
        # 各ToDoエントリを不安度でソート
        awk '
        BEGIN { RS = "\n\n"; FS = "\n" }
        /^- \[ \]/ {
            anxiety = 0
            for (i = 1; i <= NF; i++) {
                if ($i ~ /不安度: [0-9]\/7/) {
                    match($i, /不安度: ([0-9])\/7/, arr)
                    anxiety = arr[1]
                    break
                }
            }
            print anxiety "|||" $0
        }
        ' "$temp_file" | sort -nr -t'|' -k1,1 | cut -d'|' -f4- > "$sorted_file"
        
        if [[ -s "$sorted_file" ]]; then
            cat "$sorted_file"
        else
            echo -e "   ${GREEN}なし${NC}"
        fi
        
        rm -f "$sorted_file"
    else
        echo -e "   ${GREEN}なし${NC}"
    fi
    
    rm -f "$temp_file"
}

# ToDo完了
complete_todo() {
    local todo_id="$1"
    
    ensure_todo_dir
    
    if [[ ! -f "$TODO_FILE" ]]; then
        echo -e "${RED}❌ ToDoファイルが存在しません${NC}"
        return 1
    fi
    
    # ToDo完了マーク
    if sed -i.bak "s/\*\*\[ID:$todo_id\]\*\*/[DONE] **[ID:$todo_id]**/g" "$TODO_FILE"; then
        echo -e "${GREEN}✅ ToDo完了: ID $todo_id${NC}"
        rm -f "$TODO_FILE.bak"
    else
        echo -e "${RED}❌ ToDo ID $todo_id が見つかりません${NC}"
        rm -f "$TODO_FILE.bak"
        return 1
    fi
}

# 不安度分析
analyze_anxiety() {
    ensure_todo_dir
    
    if [[ ! -f "$TODO_FILE" ]]; then
        echo -e "${YELLOW}📝 ToDoリストが空です${NC}"
        return
    fi
    
    echo -e "${BOLD}${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}🧠 Kent Beck流不安度分析${NC}"
    echo -e "${BOLD}${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    # 不安度分布
    local anxiety_7=$(grep -c "不安度: 7/7" "$TODO_FILE" 2>/dev/null || echo "0")
    local anxiety_6=$(grep -c "不安度: 6/7" "$TODO_FILE" 2>/dev/null || echo "0") 
    local anxiety_5=$(grep -c "不安度: 5/7" "$TODO_FILE" 2>/dev/null || echo "0")
    local anxiety_4=$(grep -c "不安度: 4/7" "$TODO_FILE" 2>/dev/null || echo "0")
    local anxiety_3=$(grep -c "不安度: 3/7" "$TODO_FILE" 2>/dev/null || echo "0")
    local anxiety_low=$(grep -c "不安度: [1-2]/7" "$TODO_FILE" 2>/dev/null || echo "0")
    
    echo -e "\n${BOLD}📊 不安度分布:${NC}"
    echo -e "   ${RED}■■■ 7/7 (最高): $anxiety_7 項目${NC}"
    echo -e "   ${RED}■■  6/7 (高):   $anxiety_6 項目${NC}"
    echo -e "   ${YELLOW}■   5/7 (中高): $anxiety_5 項目${NC}"
    echo -e "   ${YELLOW}    4/7 (中):   $anxiety_4 項目${NC}"
    echo -e "   ${BLUE}    3/7 (中低): $anxiety_3 項目${NC}"
    echo -e "   ${GREEN}    1-2/7 (低): $anxiety_low 項目${NC}"
    
    local total_high_anxiety=$((anxiety_7 + anxiety_6 + anxiety_5))
    
    echo -e "\n${BOLD}🎯 推奨アクション:${NC}"
    if [[ "$total_high_anxiety" -gt 0 ]]; then
        echo -e "${RED}⚠️  高不安度項目 $total_high_anxiety 個が存在${NC}"
        echo -e "${BOLD}→ Kent Beck原則: 最も不安な項目から即座に着手${NC}"
        
        # 最高不安度項目の表示
        echo -e "\n${RED}🚨 最優先項目:${NC}"
        grep -B 1 -A 1 "不安度: [6-7]/7" "$TODO_FILE" | grep "^- \[ \]" | head -3
    else
        echo -e "${GREEN}✅ 高不安度項目なし - 良好な状態${NC}"
        echo -e "→ 通常の優先度順で進行可能"
    fi
}

# フィーチャーレベル不安度分析
analyze_feature_anxiety() {
    ensure_todo_dir
    
    if [[ ! -f "$TODO_FILE" ]]; then
        echo -e "${YELLOW}📝 ToDoリストが空です${NC}"
        return
    fi
    
    echo -e "${BOLD}${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}🎯 フィーチャーレベル不安度分析${NC}"
    echo -e "${BOLD}${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    # フィーチャーごとの不安度集計
    declare -A feature_scores
    declare -A feature_counts
    declare -A feature_high_items
    
    # ToDoファイルからフィーチャー情報を抽出
    local current_id=""
    local current_score=""
    local current_feature=""
    local in_todo_item=false
    
    while IFS= read -r line; do
        if [[ "$line" =~ ^-\ \[\ \]\ \*\*\[ID:[0-9]+\]\*\*.*$ ]]; then
            # 新しいToDoアイテムの開始
            in_todo_item=true
            current_id=$(echo "$line" | sed -n 's/.*\[ID:\([0-9]*\)\].*/\1/p')
            current_score=""
            current_feature=""
        elif [[ "$in_todo_item" == true ]]; then
            if [[ "$line" =~ ^[[:space:]]*-[[:space:]]*不安度:[[:space:]]*([0-9])/7$ ]]; then
                current_score="${BASH_REMATCH[1]}"
            elif [[ "$line" =~ ^[[:space:]]*-[[:space:]]*フィーチャー:[[:space:]]*(.+)$ ]]; then
                current_feature="${BASH_REMATCH[1]}"
            elif [[ -z "$line" ]] || [[ "$line" =~ ^## ]]; then
                # ToDoアイテムの終了
                if [[ -n "$current_feature" ]] && [[ -n "$current_score" ]]; then
                    feature_counts["$current_feature"]=$((${feature_counts["$current_feature"]:-0} + 1))
                    feature_scores["$current_feature"]=$((${feature_scores["$current_feature"]:-0} + current_score))
                    if [[ "$current_score" -ge 5 ]]; then
                        feature_high_items["$current_feature"]=$((${feature_high_items["$current_feature"]:-0} + 1))
                    fi
                fi
                in_todo_item=false
                current_feature=""
                current_score=""
            fi
        fi
    done < "$TODO_FILE"
    
    # 最後のアイテムの処理
    if [[ "$in_todo_item" == true ]] && [[ -n "$current_feature" ]] && [[ -n "$current_score" ]]; then
        feature_counts["$current_feature"]=$((${feature_counts["$current_feature"]:-0} + 1))
        feature_scores["$current_feature"]=$((${feature_scores["$current_feature"]:-0} + current_score))
        if [[ "$current_score" -ge 5 ]]; then
            feature_high_items["$current_feature"]=$((${feature_high_items["$current_feature"]:-0} + 1))
        fi
    fi
    
    # フィーチャーごとの平均不安度でソート
    echo -e "\n${BOLD}📊 フィーチャー別不安度ランキング:${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    # ソートして表示
    for feature in "${!feature_scores[@]}"; do
        count="${feature_counts[$feature]}"
        total_score="${feature_scores[$feature]}"
        high_items="${feature_high_items[$feature]:-0}"
        avg_score=$(awk "BEGIN {printf \"%.1f\", $total_score / $count}")
        
        echo "$avg_score|$feature|$count|$total_score|$high_items"
    done | sort -nr | while IFS='|' read -r avg feature count total high; do
        # 色分け（小数点を整数に変換して比較）
        avg_int=$(echo "$avg" | awk '{print int($1 + 0.5)}')  # 四捨五入
        if [[ "$avg_int" -ge 5 ]]; then
            color="$RED"
        elif [[ "$avg_int" -ge 3 ]]; then
            color="$YELLOW"
        else
            color="$GREEN"
        fi
        
        echo -e "${color}${feature}${NC}"
        echo -e "  平均不安度: ${color}${avg}/7${NC} (タスク数: ${count})"
        if [[ "$high" -gt 0 ]]; then
            echo -e "  ${RED}⚠️  高不安度タスク: ${high}個${NC}"
        fi
        echo ""
    done
    
    echo -e "${BOLD}💡 推奨事項:${NC}"
    echo -e "- 平均不安度5以上のフィーチャーから着手"
    echo -e "- 同一フィーチャー内のタスクはまとめて実装（2-4時間）"
    echo -e "- 高不安度タスクが多いフィーチャーを優先"
}

# メイン関数
main() {
    local command="${1:-}"
    
    case "$command" in
        "add")
            if [[ $# -lt 2 ]]; then
                echo -e "${RED}❌ エラー: 内容を指定してください${NC}"
                show_usage
                exit 1
            fi
            add_todo "${2}" "${3:-auto}" "${4:-}"
            ;;
        "list")
            list_todos "${2:-all}"
            ;;
        "complete")
            if [[ $# -lt 2 ]]; then
                echo -e "${RED}❌ エラー: ToDo IDを指定してください${NC}"
                show_usage
                exit 1
            fi
            complete_todo "$2"
            ;;
        "anxiety")
            analyze_anxiety
            ;;
        "feature-anxiety")
            analyze_feature_anxiety
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