#!/bin/bash

# Kent Beck流マイクロフィードバックループ
# 30秒ステップフィードバック + 2分イテレーションフィードバック

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

# フィードバック保存ディレクトリ
FEEDBACK_DIR=".claude/agile-artifacts/reviews"

# ディレクトリ作成
ensure_feedback_dir() {
    mkdir -p "$FEEDBACK_DIR"
}

# 使用方法の表示
show_usage() {
    echo "使用方法: $0 <type> [parameters]"
    echo ""
    echo "フィードバックタイプ:"
    echo "  step <step_id> <feature>     - 30秒ステップフィードバック"
    echo "  iteration <iteration_id>     - 2分イテレーションフィードバック"
    echo "  anxiety                      - 不安度分析のみ"
    echo ""
    echo "例:"
    echo "  $0 step \"1.1\" \"ゲームボード表示\""
    echo "  $0 iteration \"1\""
}

# 不安度測定（Kent Beck "anxiety" concept）
measure_anxiety() {
    local context="$1"
    local feature="${2:-}"
    
    echo -e "${BOLD}${RED}🧠 Kent Beck流不安度測定${NC}"
    echo -e "コンテキスト: ${CYAN}$context${NC}"
    if [[ -n "$feature" ]]; then
        echo -e "実装機能: ${GREEN}$feature${NC}"
    fi
    echo ""
    
    echo -e "${BOLD}❓ 現在、この実装について何が最も不安ですか？${NC}"
    echo -e "   1 = 全く不安なし（完璧な確信）"
    echo -e "   2 = 軽い不安（小さな懸念）"
    echo -e "   3 = 中程度の不安（いくつかの課題）"
    echo -e "   4 = 高い不安（重要な問題）"
    echo -e "   5 = 非常に高い不安（重大な問題）"
    echo ""
    
    local anxiety_level=""
    while [[ ! "$anxiety_level" =~ ^[1-5]$ ]]; do
        read -p "不安度 (1-5): " anxiety_level
        if [[ ! "$anxiety_level" =~ ^[1-5]$ ]]; then
            echo -e "${RED}1-5の数値を入力してください${NC}"
        fi
    done
    
    echo ""
    echo -e "${BOLD}❓ 具体的な不安要素は何ですか？${NC}"
    echo -e "   (例: \"エラーハンドリングが不完全\", \"パフォーマンスが心配\", \"テストケースが不足\")"
    read -p "不安要素: " anxiety_details
    
    # 不安度に基づく推奨アクション
    echo -e "\n${BOLD}📊 不安度分析結果:${NC}"
    echo -e "   レベル: ${RED}$anxiety_level/5${NC}"
    
    case "$anxiety_level" in
        "1")
            echo -e "   状態: ${GREEN}✅ 優秀 - 高い確信${NC}"
            echo -e "   推奨: 次の機能へ進む"
            ;;
        "2")
            echo -e "   状態: ${BLUE}🔵 良好 - 軽微な懸念${NC}"
            echo -e "   推奨: 小さな改善を検討"
            ;;
        "3")
            echo -e "   状態: ${YELLOW}🟡 注意 - 中程度の課題${NC}"
            echo -e "   推奨: 課題解決を優先"
            ;;
        "4")
            echo -e "   状態: ${RED}🔴 警告 - 重要な問題${NC}"
            echo -e "   推奨: ${BOLD}Kent Beck原則: 最も不安なことから着手${NC}"
            ;;
        "5")
            echo -e "   状態: ${RED}🚨 緊急 - 重大な問題${NC}"
            echo -e "   推奨: ${BOLD}即座に問題解決に集中${NC}"
            ;;
    esac
    
    if [[ -n "$anxiety_details" ]]; then
        echo -e "   要素: $anxiety_details"
    fi
    
    # 不安度3以上の場合、ToDo追加を推奨
    if [[ "$anxiety_level" -ge 3 ]] && [[ -n "$anxiety_details" ]]; then
        echo -e "\n${YELLOW}💡 高不安度項目をToDoリストに追加することを推奨${NC}"
        echo -e "   コマンド: ${CYAN}bash ~/.claude/commands/shared/todo-manager.sh add \"$anxiety_details\"${NC}"
    fi
    
    # 結果を返す（他の関数で使用）
    echo "$anxiety_level|$anxiety_details"
}

# 30秒ステップフィードバック
step_feedback() {
    local step_id="$1"
    local feature="$2"
    
    ensure_feedback_dir
    
    echo -e "${BOLD}${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}⚡ 30秒ステップフィードバック - Step $step_id${NC}"
    echo -e "${BOLD}${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    local start_time=$(date +%s)
    
    echo -e "\n${BOLD}🎯 実装機能: ${GREEN}$feature${NC}${BOLD}"
    
    # Kent Beck の核心的な3つの質問
    echo -e "\n${BOLD}📝 Kent Beck流3つの核心質問 (30秒で回答):${NC}"
    
    # 質問1: 価値実現
    echo -e "\n${BOLD}1. ❓ この実装でユーザーに価値を提供できましたか？${NC}"
    echo -e "   (y) はい、価値を実現"
    echo -e "   (n) いいえ、まだ価値不足"
    echo -e "   (p) 部分的に価値実現"
    
    local value_delivered=""
    while [[ ! "$value_delivered" =~ ^[ynp]$ ]]; do
        read -p "価値実現 (y/n/p): " value_delivered
        if [[ ! "$value_delivered" =~ ^[ynp]$ ]]; then
            echo -e "${RED}y, n, p のいずれかを入力してください${NC}"
        fi
    done
    
    # 質問2: 学習・発見
    echo -e "\n${BOLD}2. ❓ 何を学びましたか？何を発見しましたか？${NC}"
    echo -e "   (1文で答えてください)"
    read -p "学習・発見: " learning_discovery
    
    # 質問3: 次の一歩
    echo -e "\n${BOLD}3. ❓ 次に最も重要な一歩は何ですか？${NC}"
    echo -e "   (具体的なアクション1つ)"
    read -p "次の一歩: " next_action
    
    # 不安度測定
    echo -e "\n${BOLD}🧠 不安度測定:${NC}"
    local anxiety_result=$(measure_anxiety "Step $step_id" "$feature")
    local anxiety_level=$(echo "$anxiety_result" | cut -d'|' -f1)
    local anxiety_details=$(echo "$anxiety_result" | cut -d'|' -f2)
    
    # 経過時間の計算
    local end_time=$(date +%s)
    local elapsed_time=$((end_time - start_time))
    
    # フィードバック保存
    local feedback_file="$FEEDBACK_DIR/step-feedback-$step_id.md"
    cat > "$feedback_file" << EOF
# Step $step_id フィードバック

**実装機能**: $feature
**日時**: $(date "+%Y-%m-%d %H:%M:%S")
**所要時間**: ${elapsed_time}秒

## Kent Beck流3つの核心質問

### 1. 価値実現
**状況**: $value_delivered
$(case "$value_delivered" in
    "y") echo "✅ 価値を実現 - ユーザーにとって意味のある進歩" ;;
    "n") echo "❌ 価値不足 - より価値のある実装が必要" ;;
    "p") echo "🔄 部分的実現 - 価値の完全な実現に向けて継続" ;;
esac)

### 2. 学習・発見
$learning_discovery

### 3. 次の一歩
$next_action

## 不安度分析
**レベル**: $anxiety_level/5
**詳細**: $anxiety_details

## 推奨アクション
$(if [[ "$anxiety_level" -ge 4 ]]; then
    echo "🚨 **緊急**: 不安要素の即座解決"
elif [[ "$anxiety_level" -ge 3 ]]; then
    echo "⚠️  **注意**: 課題解決を優先"
elif [[ "$value_delivered" == "n" ]]; then
    echo "🔄 **継続**: 価値実現まで実装継続"
else
    echo "✅ **進行**: 次のステップへ進む"
fi)
EOF
    
    # 結果サマリー表示
    echo -e "\n${BOLD}📊 30秒フィードバック完了:${NC}"
    echo -e "   価値実現: $(case "$value_delivered" in
        "y") echo "${GREEN}✅ Yes${NC}" ;;
        "n") echo "${RED}❌ No${NC}" ;;
        "p") echo "${YELLOW}🔄 Partial${NC}" ;;
    esac)"
    echo -e "   不安度: ${RED}$anxiety_level/5${NC}"
    echo -e "   所要時間: ${elapsed_time}秒"
    echo -e "   保存先: $feedback_file"
    
    # 30秒を超過した場合の警告
    if [[ "$elapsed_time" -gt 30 ]]; then
        echo -e "\n${YELLOW}⏰ 注意: 30秒を超過しました（${elapsed_time}秒）${NC}"
        echo -e "   Kent Beck推奨: より迅速な振り返りを心がけましょう"
    fi
}

# 2分イテレーションフィードバック
iteration_feedback() {
    local iteration_id="$1"
    
    ensure_feedback_dir
    
    echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}🔄 2分イテレーションフィードバック - Iteration $iteration_id${NC}"
    echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    local start_time=$(date +%s)
    
    # Kent Beck XP原則に基づく質問
    echo -e "\n${BOLD}📋 Kent Beck XP原則チェック (2分で完了):${NC}"
    
    # Communication
    echo -e "\n${BOLD}1. 💬 Communication (コミュニケーション)${NC}"
    echo -e "❓ この実装をチームメンバーや他の人が理解できますか？"
    echo -e "   (1-5: 1=理解困難, 5=完全に明確)"
    
    local communication_score=""
    while [[ ! "$communication_score" =~ ^[1-5]$ ]]; do
        read -p "コミュニケーション度 (1-5): " communication_score
    done
    
    read -p "理由・改善点: " communication_notes
    
    # Simplicity
    echo -e "\n${BOLD}2. ✨ Simplicity (シンプルさ)${NC}"
    echo -e "❓ 実装は必要最小限でシンプルですか？"
    echo -e "   (1-5: 1=複雑すぎ, 5=完璧にシンプル)"
    
    local simplicity_score=""
    while [[ ! "$simplicity_score" =~ ^[1-5]$ ]]; do
        read -p "シンプルさ度 (1-5): " simplicity_score
    done
    
    read -p "理由・改善点: " simplicity_notes
    
    # Feedback
    echo -e "\n${BOLD}3. 🔄 Feedback (フィードバック)${NC}"
    echo -e "❓ 実装から即座にフィードバックを得られますか？"
    echo -e "   (1-5: 1=フィードバック遅延, 5=即座フィードバック)"
    
    local feedback_score=""
    while [[ ! "$feedback_score" =~ ^[1-5]$ ]]; do
        read -p "フィードバック度 (1-5): " feedback_score
    done
    
    read -p "理由・改善点: " feedback_notes
    
    # Courage
    echo -e "\n${BOLD}4. 💪 Courage (勇気)${NC}"
    echo -e "❓ 必要な変更を恐れずに実施できましたか？"
    echo -e "   (1-5: 1=変更を躊躇, 5=勇気を持って変更)"
    
    local courage_score=""
    while [[ ! "$courage_score" =~ ^[1-5]$ ]]; do
        read -p "勇気度 (1-5): " courage_score
    done
    
    read -p "理由・改善点: " courage_notes
    
    # 全体的な不安度
    echo -e "\n${BOLD}🧠 イテレーション全体の不安度:${NC}"
    local iteration_anxiety=$(measure_anxiety "Iteration $iteration_id")
    local anxiety_level=$(echo "$iteration_anxiety" | cut -d'|' -f1)
    local anxiety_details=$(echo "$iteration_anxiety" | cut -d'|' -f2)
    
    # 学習と改善点
    echo -e "\n${BOLD}📚 今回のイテレーションで学んだ最も重要なこと:${NC}"
    read -p "重要な学習: " key_learning
    
    echo -e "\n${BOLD}🎯 次のイテレーションで最初に取り組むべきこと:${NC}"
    read -p "次の最優先事項: " next_priority
    
    # 経過時間の計算
    local end_time=$(date +%s)
    local elapsed_time=$((end_time - start_time))
    
    # XP価値のスコア計算
    local total_xp_score=$((communication_score + simplicity_score + feedback_score + courage_score))
    local avg_xp_score=$((total_xp_score * 100 / 20))  # 20点満点を100%に変換
    
    # フィードバック保存
    local feedback_file="$FEEDBACK_DIR/iteration-$iteration_id-feedback.md"
    cat > "$feedback_file" << EOF
# Iteration $iteration_id フィードバック

**日時**: $(date "+%Y-%m-%d %H:%M:%S")
**所要時間**: ${elapsed_time}秒

## Kent Beck XP価値評価

### Communication (コミュニケーション): $communication_score/5
$communication_notes

### Simplicity (シンプルさ): $simplicity_score/5
$simplicity_notes

### Feedback (フィードバック): $feedback_score/5
$feedback_notes

### Courage (勇気): $courage_score/5
$courage_notes

**XP価値総合スコア**: $avg_xp_score/100

## 不安度分析
**レベル**: $anxiety_level/5
**詳細**: $anxiety_details

## 学習と改善
**重要な学習**: $key_learning
**次の最優先事項**: $next_priority

## 推奨アクション
$(if [[ "$anxiety_level" -ge 4 ]]; then
    echo "🚨 **緊急**: 不安要素の解決を最優先"
elif [[ "$avg_xp_score" -lt 60 ]]; then
    echo "⚠️  **改善必要**: XP価値の向上に集中"
else
    echo "✅ **良好**: 次のイテレーション計画へ進む"
fi)

## 品質レベル判定
$(if [[ "$avg_xp_score" -ge 80 ]] && [[ "$anxiety_level" -le 2 ]]; then
    echo "🏆 **優秀**: Kent Beck基準を満たす高品質実装"
elif [[ "$avg_xp_score" -ge 60 ]] && [[ "$anxiety_level" -le 3 ]]; then
    echo "✅ **良好**: XP原則に準拠した実装"
else
    echo "🔄 **改善中**: XP原則の更なる適用が必要"
fi)
EOF
    
    # 結果サマリー表示
    echo -e "\n${BOLD}📊 2分イテレーションフィードバック完了:${NC}"
    echo -e "   XP価値スコア: ${CYAN}$avg_xp_score/100${NC}"
    echo -e "   不安度: ${RED}$anxiety_level/5${NC}"
    echo -e "   所要時間: ${elapsed_time}秒"
    echo -e "   保存先: $feedback_file"
    
    # 品質レベルの表示
    if [[ "$avg_xp_score" -ge 80 ]] && [[ "$anxiety_level" -le 2 ]]; then
        echo -e "\n${GREEN}🏆 優秀: Kent Beck基準を満たす高品質実装${NC}"
    elif [[ "$avg_xp_score" -ge 60 ]] && [[ "$anxiety_level" -le 3 ]]; then
        echo -e "\n${BLUE}✅ 良好: XP原則に準拠した実装${NC}"
    else
        echo -e "\n${YELLOW}🔄 改善中: XP原則の更なる適用が必要${NC}"
    fi
    
    # 2分を超過した場合の警告
    if [[ "$elapsed_time" -gt 120 ]]; then
        echo -e "\n${YELLOW}⏰ 注意: 2分を超過しました（${elapsed_time}秒）${NC}"
        echo -e "   Kent Beck推奨: より効率的な振り返りを心がけましょう"
    fi
    
    # 次のアクション提案
    echo -e "\n${BOLD}🎯 推奨次アクション:${NC}"
    if [[ "$anxiety_level" -ge 4 ]]; then
        echo -e "   ${RED}1. 不安要素の解決${NC}: $anxiety_details"
        echo -e "   ${BLUE}2. ToDo追加推奨${NC}: bash ~/.claude/commands/shared/todo-manager.sh add \"$anxiety_details\""
    elif [[ "$avg_xp_score" -lt 60 ]]; then
        echo -e "   ${YELLOW}1. XP価値の向上${NC}: 最も低いスコアの改善"
        echo -e "   ${BLUE}2. リファクタリング${NC}: シンプルさ・コミュニケーション向上"
    else
        echo -e "   ${GREEN}1. 次のイテレーション計画${NC}: /tdd:plan で次の90分計画"
        echo -e "   ${BLUE}2. 学習の活用${NC}: $key_learning を次の実装に適用"
    fi
}

# 不安度分析のみ
anxiety_analysis() {
    echo -e "${BOLD}${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}🧠 Kent Beck流不安度分析${NC}"
    echo -e "${BOLD}${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    local anxiety_result=$(measure_anxiety "一般的な不安度チェック")
    local anxiety_level=$(echo "$anxiety_result" | cut -d'|' -f1)
    local anxiety_details=$(echo "$anxiety_result" | cut -d'|' -f2)
    
    echo -e "\n${BOLD}📋 Kent Beck「不安」概念の活用:${NC}"
    echo -e "   ${BLUE}\"Anxiety is the engine of software development.\"${NC}"
    echo -e "   ${BLUE}\"Do the most anxiety-provoking thing first.\"${NC}"
    
    if [[ "$anxiety_level" -ge 3 ]]; then
        echo -e "\n${BOLD}💡 推奨アプローチ:${NC}"
        echo -e "   1. 不安要素を具体的なタスクに分解"
        echo -e "   2. 最も不安な部分から着手"
        echo -e "   3. 小さなステップで不安を解消"
        echo -e "   4. 早期フィードバックで確信を得る"
    fi
}

# メイン関数
main() {
    local feedback_type="${1:-}"
    
    case "$feedback_type" in
        "step")
            if [[ $# -lt 3 ]]; then
                echo -e "${RED}❌ エラー: ステップIDと機能名を指定してください${NC}"
                show_usage
                exit 1
            fi
            step_feedback "$2" "$3"
            ;;
        "iteration")
            if [[ $# -lt 2 ]]; then
                echo -e "${RED}❌ エラー: イテレーションIDを指定してください${NC}"
                show_usage
                exit 1
            fi
            iteration_feedback "$2"
            ;;
        "anxiety")
            anxiety_analysis
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