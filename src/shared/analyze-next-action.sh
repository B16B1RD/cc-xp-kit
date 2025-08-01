#!/bin/bash

# Kent Beck流次アクション分析システム
# TDDサイクル完了後に「次に何をすべきか」を自動判定・提案

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

# 使用方法の表示
show_usage() {
    echo "使用方法: $0 <current_step> <impl_type> <test_count> <story_progress>"
    echo ""
    echo "パラメータ:"
    echo "  current_step    : 現在のステップ (例: '1.1', '2.3')"
    echo "  impl_type       : 実装タイプ (fake_it|triangulation|general)"
    echo "  test_count      : テスト数 (数値)"
    echo "  story_progress  : ストーリー進捗% (0-100)"
    echo ""
    echo "例:"
    echo "  $0 '1.1' 'fake_it' 1 30"
    echo "  $0 '2.2' 'triangulation' 3 60"
}

# パラメータ検証
validate_params() {
    if [ $# -ne 4 ]; then
        echo -e "${RED}❌ エラー: パラメータが不正です${NC}"
        show_usage
        exit 1
    fi
    
    local impl_type="$2"
    local test_count="$3"
    local story_progress="$4"
    
    # impl_type の検証
    if [[ ! "$impl_type" =~ ^(fake_it|triangulation|general)$ ]]; then
        echo -e "${RED}❌ エラー: impl_type は fake_it, triangulation, general のいずれかである必要があります${NC}"
        exit 1
    fi
    
    # test_count の検証
    if ! [[ "$test_count" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}❌ エラー: test_count は数値である必要があります${NC}"
        exit 1
    fi
    
    # story_progress の検証
    if ! [[ "$story_progress" =~ ^[0-9]+$ ]] || [ "$story_progress" -lt 0 ] || [ "$story_progress" -gt 100 ]; then
        echo -e "${RED}❌ エラー: story_progress は 0-100 の数値である必要があります${NC}"
        exit 1
    fi
}

# 実装段階の判定
determine_implementation_stage() {
    local impl_type="$1"
    local test_count="$2"
    
    if [[ "$impl_type" == "fake_it" ]] && [[ "$test_count" -eq 1 ]]; then
        echo "fake_it_initial"
    elif [[ "$impl_type" == "fake_it" ]] && [[ "$test_count" -gt 1 ]]; then
        echo "triangulation_ready"
    elif [[ "$impl_type" == "triangulation" ]]; then
        echo "triangulation_active"
    elif [[ "$impl_type" == "general" ]]; then
        echo "generalized"
    else
        echo "unknown"
    fi
}

# フィーチャーレベルの推奨アクション
recommend_feature_level_actions() {
    local stage="$1"
    local anxiety_level="$2"
    local story_progress="$3"
    
    if [[ "$story_progress" -lt 30 ]]; then
        echo -e "${YELLOW}フィーチャー初期段階:${NC}"
        echo -e "- コア機能の基本実装に集中"
        echo -e "- 統合ポイントの早期確認"
        echo -e "- 2-4時間での最小動作版完成を目指す"
    elif [[ "$story_progress" -lt 70 ]]; then
        echo -e "${BLUE}フィーチャー中期段階:${NC}"
        echo -e "- 関連機能の統合実装"
        echo -e "- ユーザーフローの実現"
        echo -e "- エラーケースの考慮開始"
    else
        echo -e "${GREEN}フィーチャー後期段階:${NC}"
        echo -e "- ポリッシュと品質向上"
        echo -e "- 実使用シナリオでの検証"
        echo -e "- 次フィーチャーとの接続準備"
    fi
    
    # 不安度に基づく追加推奨
    if [[ "$anxiety_level" -ge 4 ]]; then
        echo -e "\n${RED}⚠️ 高不安度フィーチャー検出:${NC}"
        echo -e "- todo-manager.sh feature-anxiety で関連タスク確認"
        echo -e "- 最も不安な機能から着手（Kent Beck原則）"
        echo -e "- フィーチャー全体の設計見直しを検討"
    fi
}

# 不安度の分析（Kent Beck "Most Anxious Thing First"原則）
analyze_anxiety_level() {
    local impl_type="$1"
    local test_count="$2"
    local story_progress="$3"
    
    local anxiety_score=0
    
    # 実装タイプによる不安度
    case "$impl_type" in
        "fake_it")
            if [[ "$test_count" -eq 1 ]]; then
                anxiety_score=$((anxiety_score + 3))  # ハードコーディングは不安
            else
                anxiety_score=$((anxiety_score + 5))  # Triangulation待ちは高不安
            fi
            ;;
        "triangulation")
            anxiety_score=$((anxiety_score + 2))  # 一般化中は中程度の不安
            ;;
        "general")
            anxiety_score=$((anxiety_score + 1))  # 一般化済みは低不安
            ;;
    esac
    
    # ストーリー進捗による不安度
    if [[ "$story_progress" -lt 30 ]]; then
        anxiety_score=$((anxiety_score + 2))  # 進捗低は不安
    elif [[ "$story_progress" -lt 70 ]]; then
        anxiety_score=$((anxiety_score + 1))  # 中程度進捗は軽い不安
    fi
    
    # テスト数による不安度
    if [[ "$test_count" -eq 1 ]]; then
        anxiety_score=$((anxiety_score + 2))  # テスト1個は不安
    fi
    
    # 最大5に正規化
    if [[ "$anxiety_score" -gt 5 ]]; then
        anxiety_score=5
    fi
    
    echo "$anxiety_score"
}

# Kent Beck戦略の推奨
recommend_kent_beck_strategy() {
    local stage="$1"
    local anxiety_level="$2"
    
    case "$stage" in
        "fake_it_initial")
            echo -e "${YELLOW}🎯 Kent Beck推奨戦略: ${BOLD}Triangulation準備${NC}"
            echo -e "   ${BLUE}理由${NC}: Fake It完了、2つ目のテストで一般化を促す時期"
            echo -e "   ${GREEN}行動${NC}: 異なる入力値で同じ関数をテストする"
            ;;
        "triangulation_ready")
            echo -e "${YELLOW}🎯 Kent Beck推奨戦略: ${BOLD}Triangulation実行${NC}"
            echo -e "   ${BLUE}理由${NC}: ハードコーディングを破る段階"
            echo -e "   ${GREEN}行動${NC}: 既存のハードコードが機能しないテストを追加"
            ;;
        "triangulation_active")
            echo -e "${YELLOW}🎯 Kent Beck推奨戦略: ${BOLD}Generalization完了${NC}"
            echo -e "   ${BLUE}理由${NC}: パターンが見えた、一般化を完成させる時期"
            echo -e "   ${GREEN}行動${NC}: 重複を除去し、真の実装を完成"
            ;;
        "generalized")
            if [[ "$anxiety_level" -ge 3 ]]; then
                echo -e "${YELLOW}🎯 Kent Beck推奨戦略: ${BOLD}最も不安なことから着手${NC}"
                echo -e "   ${BLUE}理由${NC}: 不安度 $anxiety_level/5 - 重要な課題が残存"
                echo -e "   ${GREEN}行動${NC}: エラーハンドリングや境界条件のテスト追加"
            else
                echo -e "${YELLOW}🎯 Kent Beck推奨戦略: ${BOLD}次の機能へ進む${NC}"
                echo -e "   ${BLUE}理由${NC}: 不安度 $anxiety_level/5 - 現在の機能は安定"
                echo -e "   ${GREEN}行動${NC}: 次のユーザーストーリーへ移行"
            fi
            ;;
        *)
            echo -e "${RED}❌ 不明な実装段階: $stage${NC}"
            ;;
    esac
}

# 具体的な次アクションの提案
suggest_concrete_actions() {
    local current_step="$1"
    local stage="$2"
    local anxiety_level="$3"
    local story_progress="$4"
    
    echo -e "\n${BOLD}🚀 具体的な次のアクション提案:${NC}"
    
    case "$stage" in
        "fake_it_initial")
            echo -e "${GREEN}1. 【推奨】Triangulation用テスト追加${NC}"
            echo -e "   - 異なる入力値で同じ関数をテスト"
            echo -e "   - ハードコーディングが破綻することを確認"
            echo -e "   - 例: expect(add(1, 4)).toBe(5) // 既存が add(2,3)→5 の場合"
            echo ""
            echo -e "${BLUE}2. エッジケースのテスト追加${NC}"
            echo -e "   - ゼロ値、負数、境界値のテスト"
            echo -e "   - エラー条件のテスト"
            echo ""
            echo -e "${PURPLE}3. 関連機能の検討${NC}"
            echo -e "   - 現在の機能に関連する次の機能"
            echo -e "   - ユーザーストーリーの次の受け入れ基準"
            ;;
            
        "triangulation_ready"|"triangulation_active")
            echo -e "${GREEN}1. 【緊急】一般化実装の完成${NC}"
            echo -e "   - ハードコーディングを除去"
            echo -e "   - 全テストが通る真の実装"
            echo -e "   - リファクタリングでコード品質向上"
            echo ""
            echo -e "${BLUE}2. 追加テストケースの検討${NC}"
            echo -e "   - より多様な入力パターン"
            echo -e "   - 実装の堅牢性確認"
            ;;
            
        "generalized")
            if [[ "$anxiety_level" -ge 3 ]]; then
                echo -e "${RED}1. 【最優先】不安要素の解決${NC}"
                echo -e "   - エラーハンドリングの追加"
                echo -e "   - パフォーマンステスト"
                echo -e "   - セキュリティチェック"
                echo ""
                echo -e "${YELLOW}2. 品質向上${NC}"
                echo -e "   - コードレビュー実施"
                echo -e "   - ドキュメント整備"
            else
                echo -e "${GREEN}1. 【推奨】次のストーリーへ進行${NC}"
                echo -e "   - 現在のストーリー: $story_progress% 完了"
                echo -e "   - 次の受け入れ基準の実装"
                echo -e "   - 新しい機能のTDD開始"
                echo ""
                echo -e "${BLUE}2. 継続的改善${NC}"
                echo -e "   - ユーザーフィードバックの収集"
                echo -e "   - パフォーマンス最適化"
            fi
            ;;
    esac
    
    # ストーリー進捗に基づく追加提案
    if [[ "$story_progress" -lt 50 ]]; then
        echo -e "\n${CYAN}📋 フィーチャー進捗 ${story_progress}% - 継続フォーカス推奨${NC}"
        echo -e "   - 現在のフィーチャーの統合完成を優先"
        echo -e "   - 関連機能をまとめて実装（2-4時間単位）"
        echo -e "   - 新フィーチャーよりも既存フィーチャーの完成度向上"
    elif [[ "$story_progress" -ge 80 ]]; then
        echo -e "\n${CYAN}🎉 フィーチャー進捗 ${story_progress}% - 完成間近！${NC}"
        echo -e "   - End-to-End統合テスト実施"
        echo -e "   - 実使用シナリオでの動作確認"
        echo -e "   - 次のフィーチャー準備を検討"
    fi
    
    # フィーチャーレベルの推奨
    echo -e "\n${PURPLE}🎯 フィーチャー単位の推奨事項:${NC}"
    recommend_feature_level_actions "$stage" "$anxiety_level" "$story_progress"
}

# メイン分析関数
main() {
    local current_step="$1"
    local impl_type="$2"
    local test_count="$3" 
    local story_progress="$4"
    
    # パラメータ検証
    validate_params "$@"
    
    # 分析実行
    local stage=$(determine_implementation_stage "$impl_type" "$test_count")
    local anxiety_level=$(analyze_anxiety_level "$impl_type" "$test_count" "$story_progress")
    
    # 結果表示
    echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}🧠 Kent Beck流次アクション分析 - Step $current_step${NC}"
    echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    echo -e "\n${BOLD}📊 現在の状況分析:${NC}"
    echo -e "   実装段階: ${YELLOW}$stage${NC}"
    echo -e "   実装タイプ: ${GREEN}$impl_type${NC}"
    echo -e "   テスト数: ${BLUE}$test_count${NC}"
    echo -e "   ストーリー進捗: ${PURPLE}$story_progress%${NC}"
    echo -e "   不安度: ${RED}$anxiety_level/5${NC}"
    
    echo -e "\n${BOLD}🎯 Kent Beck戦略分析:${NC}"
    recommend_kent_beck_strategy "$stage" "$anxiety_level"
    
    suggest_concrete_actions "$current_step" "$stage" "$anxiety_level" "$story_progress"
    
    echo -e "\n${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}💡 Kent Beck智慧: \"Do the most anxiety-provoking thing first\"${NC}"
    echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# 直接実行の場合
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi