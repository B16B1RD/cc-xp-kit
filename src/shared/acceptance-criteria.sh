#!/bin/bash

# 受け入れ条件明示システム
# 各TDDフェーズの完了条件を明確化・インタラクティブ確認

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
    echo "使用方法: $0 <command> [options]"
    echo ""
    echo "コマンド:"
    echo "  show <phase> <step> <feature>    - フェーズ別受け入れ条件表示"
    echo "  check <phase> <step> <feature>   - インタラクティブ確認"
    echo "  list                             - 全フェーズの条件一覧"
    echo ""
    echo "フェーズ:"
    echo "  red        - RED フェーズ（テスト作成）"
    echo "  green      - GREEN フェーズ（最小実装）"
    echo "  refactor   - REFACTOR フェーズ（構造改善）"
    echo ""
    echo "例:"
    echo "  $0 show red \"1.1\" \"ゲームボード表示\""
    echo "  $0 check green \"1.2\" \"ブロック移動\""
    echo "  $0 list"
}

# REDフェーズの受け入れ条件
show_red_criteria() {
    local step="$1"
    local feature="$2"
    
    echo -e "${BOLD}${RED}🔴 RED フェーズ受け入れ条件 - Step $step${NC}"
    echo -e "${BOLD}機能: ${GREEN}$feature${NC}${BOLD}"
    echo ""
    
    echo -e "${BOLD}📋 必須完了条件:${NC}"
    echo -e "   ${RED}1. テストファースト厳守${NC}"
    echo -e "      ✓ 実装コードより先にテストコード作成"
    echo -e "      ✓ テストが実際に失敗することを確認"
    echo -e "      ✓ 失敗理由が期待通り（関数未定義等）"
    echo ""
    echo -e "   ${RED}2. 最小限のテスト作成${NC}"
    echo -e "      ✓ 1つの具体的な例のみテスト"
    echo -e "      ✓ 複雑なロジックではなく単純な入出力"
    echo -e "      ✓ Kent Beck「最小の失敗するテスト」原則"
    echo ""
    echo -e "   ${RED}3. テスト実行で失敗確認${NC}"
    echo -e "      ✓ テストランナーで赤（失敗）を確認"
    echo -e "      ✓ エラーメッセージが理解可能"
    echo -e "      ✓ コンパイルエラーではなく論理エラー"
    echo ""
    
    echo -e "${BOLD}🎯 Kent Beck品質基準:${NC}"
    echo -e "   • ${CYAN}「最小の失敗するテストを書く」${NC}"
    echo -e "   • ${CYAN}「一度に1つのテストのみ作成」${NC}"
    echo -e "   • ${CYAN}「実装の詳細ではなく振る舞いをテスト」${NC}"
    echo ""
    
    echo -e "${BOLD}❌ 避けるべきこと:${NC}"
    echo -e "   • 複数のテストケース同時作成"
    echo -e "   • 実装方法を決め打ちしたテスト"
    echo -e "   • 実装コードを先に書いてからテスト作成"
    echo ""
    
    echo -e "${BOLD}✅ 完了判定チェックリスト:${NC}"
    echo -e "   [ ] テストコードが存在する"
    echo -e "   [ ] テスト実行で失敗する"
    echo -e "   [ ] 失敗理由が明確"
    echo -e "   [ ] 1つの具体例のみテスト"
    echo -e "   [ ] コンパイルエラーなし"
}

# GREENフェーズの受け入れ条件
show_green_criteria() {
    local step="$1"
    local feature="$2"
    
    echo -e "${BOLD}${GREEN}🟢 GREEN フェーズ受け入れ条件 - Step $step${NC}"
    echo -e "${BOLD}機能: ${GREEN}$feature${NC}${BOLD}"
    echo ""
    
    echo -e "${BOLD}📋 必須完了条件:${NC}"
    echo -e "   ${GREEN}1. 最小実装でテスト通過${NC}"
    echo -e "      ✓ 最小限の変更でテスト通過"
    echo -e "      ✓ Kent Beck三大戦略の適用"
    echo -e "      ✓ 全既存テストも通過"
    echo ""
    echo -e "   ${GREEN}2. Kent Beck戦略の適用${NC}"
    echo -e "      ✓ ${BOLD}Fake It${NC}: ハードコーディング（推奨）"
    echo -e "      ✓ ${BOLD}Triangulation${NC}: 2つ目のテストで一般化"
    echo -e "      ✓ ${BOLD}Obvious Implementation${NC}: 明白な場合のみ"
    echo ""
    echo -e "   ${GREEN}3. 品質確認${NC}"
    echo -e "      ✓ コンパイルエラーなし"
    echo -e "      ✓ リンターエラーなし"
    echo -e "      ✓ 実際の動作確認済み"
    echo ""
    
    echo -e "${BOLD}🎯 Kent Beck戦略詳細:${NC}"
    echo -e "   ${YELLOW}Fake It戦略（60%以上で使用）:${NC}"
    echo -e "   • テストの期待値をそのままハードコーディング"
    echo -e "   • 引数を一切使用しない実装"
    echo -e "   • 「恥ずかしい」実装を恐れない"
    echo ""
    echo -e "   ${BLUE}Triangulation戦略:${NC}"
    echo -e "   • 2つ目のテストでハードコードを破る"
    echo -e "   • 異なる入力値で同じ期待値を試す場合"
    echo -e "   • 一般化実装への自然な誘導"
    echo ""
    echo -e "   ${PURPLE}Obvious Implementation戦略:${NC}"
    echo -e "   • 数学的に自明な場合のみ（square, abs等）"
    echo -e "   • 1行で完結する簡単な処理"
    echo -e "   • 確信がない場合はFake Itを使用"
    echo ""
    
    echo -e "${BOLD}❌ 避けるべきこと:${NC}"
    echo -e "   • 一度に完璧な実装を目指す"
    echo -e "   • 将来の拡張性を考慮した過度な設計"
    echo -e "   • テストが通らない状態での実装継続"
    echo ""
    
    echo -e "${BOLD}✅ 完了判定チェックリスト:${NC}"
    echo -e "   [ ] 新しいテストが通過"
    echo -e "   [ ] 全既存テストが通過"
    echo -e "   [ ] Kent Beck戦略を適用"
    echo -e "   [ ] コンパイル・リンターエラーなし"
    echo -e "   [ ] 実際の動作確認済み"
}

# REFACTORフェーズの受け入れ条件
show_refactor_criteria() {
    local step="$1"
    local feature="$2"
    
    echo -e "${BOLD}${BLUE}🔵 REFACTOR フェーズ受け入れ条件 - Step $step${NC}"
    echo -e "${BOLD}機能: ${GREEN}$feature${NC}${BOLD}"
    echo ""
    
    echo -e "${BOLD}📋 必須完了条件:${NC}"
    echo -e "   ${BLUE}1. 振る舞い保護${NC}"
    echo -e "      ✓ 全テストが緑のまま"
    echo -e "      ✓ 機能・動作に変更なし"
    echo -e "      ✓ 外部インターフェース不変"
    echo ""
    echo -e "   ${BLUE}2. 構造改善のみ実施${NC}"
    echo -e "      ✓ 変数・関数名の改善"
    echo -e "      ✓ 重複コードの除去"
    echo -e "      ✓ 可読性の向上"
    echo ""
    echo -e "   ${BLUE}3. Tidy First原則遵守${NC}"
    echo -e "      ✓ 構造変更と振る舞い変更の分離"
    echo -e "      ✓ [STRUCTURE]コミットでの記録"
    echo -e "      ✓ 小さな改善の積み重ね"
    echo ""
    
    echo -e "${BOLD}🎯 リファクタリング対象:${NC}"
    echo -e "   ${CYAN}命名改善:${NC}"
    echo -e "   • 変数名の意図明確化"
    echo -e "   • 関数名の動作説明"
    echo -e "   • クラス名の責任明確化"
    echo ""
    echo -e "   ${CYAN}構造改善:${NC}"
    echo -e "   • 長い関数の分割"
    echo -e "   • 重複コードの共通化"
    echo -e "   • 複雑な条件式の簡素化"
    echo ""
    echo -e "   ${CYAN}可読性向上:${NC}"
    echo -e "   • コメントによる意図説明"
    echo -e "   • マジックナンバーの定数化"
    echo -e "   • インデントの統一"
    echo ""
    
    echo -e "${BOLD}❌ 避けるべきこと:${NC}"
    echo -e "   • 新機能の追加"
    echo -e "   • 動作の変更"
    echo -e "   • テストが失敗する変更"
    echo -e "   • 大規模な設計変更"
    echo ""
    
    echo -e "${BOLD}✅ 完了判定チェックリスト:${NC}"
    echo -e "   [ ] 全テストが緑を維持"
    echo -e "   [ ] 振る舞いが変化していない"
    echo -e "   [ ] コードの可読性が向上"
    echo -e "   [ ] 重複が削減されている"
    echo -e "   [ ] [STRUCTURE]コミット完了"
}

# インタラクティブな受け入れ条件確認
interactive_criteria_check() {
    local phase="$1"
    local step="$2"
    local feature="$3"
    
    echo -e "${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}📋 受け入れ条件インタラクティブ確認${NC}"
    echo -e "${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    # フェーズ別条件表示
    case "$phase" in
        "red")
            show_red_criteria "$step" "$feature"
            ;;
        "green")
            show_green_criteria "$step" "$feature"
            ;;
        "refactor")
            show_refactor_criteria "$step" "$feature"
            ;;
        *)
            echo -e "${RED}❌ 不明なフェーズ: $phase${NC}"
            return 1
            ;;
    esac
    
    echo -e "\n${BOLD}🔍 完了確認チェック:${NC}"
    
    # チェックリスト項目の抽出と確認
    local checklist_items=()
    case "$phase" in
        "red")
            checklist_items=(
                "テストコードが存在する"
                "テスト実行で失敗する"
                "失敗理由が明確"
                "1つの具体例のみテスト"
                "コンパイルエラーなし"
            )
            ;;
        "green")
            checklist_items=(
                "新しいテストが通過"
                "全既存テストが通過"
                "Kent Beck戦略を適用"
                "コンパイル・リンターエラーなし"
                "実際の動作確認済み"
            )
            ;;
        "refactor")
            checklist_items=(
                "全テストが緑を維持"
                "振る舞いが変化していない"
                "コードの可読性が向上"
                "重複が削減されている"
                "[STRUCTURE]コミット完了"
            )
            ;;
    esac
    
    local completed_count=0
    local total_count=${#checklist_items[@]}
    
    echo -e "${BOLD}各項目について確認してください（y/n）:${NC}"
    
    for i in "${!checklist_items[@]}"; do
        local item="${checklist_items[$i]}"
        echo ""
        echo -e "${CYAN}$((i+1)). $item${NC}"
        
        local response=""
        while [[ ! "$response" =~ ^[yn]$ ]]; do
            read -p "完了していますか？ (y/n): " response
            if [[ ! "$response" =~ ^[yn]$ ]]; then
                echo -e "${RED}y または n を入力してください${NC}"
            fi
        done
        
        if [[ "$response" == "y" ]]; then
            echo -e "   ${GREEN}✅ 完了${NC}"
            ((completed_count++))
        else
            echo -e "   ${RED}❌ 未完了${NC}"
            
            # 未完了項目への対応提案
            echo -e "${YELLOW}   💡 対応提案:${NC}"
            case "$i" in
                0)
                    case "$phase" in
                        "red") echo -e "      テストファイルを作成し、具体的なテストケースを記述" ;;
                        "green") echo -e "      テスト実行コマンドを実行し、緑（成功）を確認" ;;
                        "refactor") echo -e "      リファクタリング後にテストを再実行" ;;
                    esac
                    ;;
                1)
                    case "$phase" in
                        "red") echo -e "      テストランナーを実行し、赤（失敗）ステータスを確認" ;;
                        "green") echo -e "      全テストスイートを実行し、既存テストが壊れていないか確認" ;;
                        "refactor") echo -e "      機能テストを実行し、振る舞い変更がないか確認" ;;
                    esac
                    ;;
                2)
                    case "$phase" in
                        "red") echo -e "      エラーメッセージを読み、期待通りの失敗理由か確認" ;;
                        "green") echo -e "      Fake It/Triangulation/Obvious のいずれかを適用" ;;
                        "refactor") echo -e "      変数名、関数名、構造の改善を実施" ;;
                    esac
                    ;;
                3)
                    case "$phase" in
                        "red") echo -e "      複数テストケースがある場合は1つに絞る" ;;
                        "green") echo -e "      リンター（ESLint, Pylint等）を実行しエラー修正" ;;
                        "refactor") echo -e "      重複コードを関数・モジュール化で共通化" ;;
                    esac
                    ;;
                4)
                    case "$phase" in
                        "red") echo -e "      構文エラーを修正し、コンパイル可能な状態にする" ;;
                        "green") echo -e "      実際にアプリケーションを起動し、機能動作を確認" ;;
                        "refactor") echo -e "      git commit -m \"[STRUCTURE] ...\" でコミット" ;;
                    esac
                    ;;
            esac
        fi
    done
    
    # 完了率の計算と表示
    local completion_percentage=$((completed_count * 100 / total_count))
    
    echo -e "\n${BOLD}📊 完了状況:${NC}"
    echo -e "   完了項目: ${GREEN}$completed_count${NC}/$total_count"
    echo -e "   完了率: ${CYAN}$completion_percentage%${NC}"
    
    # プログレスバー表示
    local bar_length=10
    local completed_bars=$((completion_percentage * bar_length / 100))
    local remaining_bars=$((bar_length - completed_bars))
    
    echo -ne "   進捗: ["
    for ((i=0; i<completed_bars; i++)); do echo -ne "${GREEN}■${NC}"; done
    for ((i=0; i<remaining_bars; i++)); do echo -ne "□"; done
    echo -e "] ${BOLD}$completion_percentage%${NC}"
    
    # 判定結果
    echo -e "\n${BOLD}🎯 判定結果:${NC}"
    if [[ "$completion_percentage" -eq 100 ]]; then
        case "$phase" in
            "red")
                echo -e "${GREEN}✅ RED フェーズ完了！${NC}"
                echo -e "   次のステップ: ${YELLOW}GREEN フェーズ（最小実装）${NC}"
                ;;
            "green")
                echo -e "${GREEN}✅ GREEN フェーズ完了！${NC}"
                echo -e "   次のステップ: ${BLUE}REFACTOR フェーズ（構造改善）${NC}"
                ;;
            "refactor")
                echo -e "${GREEN}✅ REFACTOR フェーズ完了！${NC}"
                echo -e "   次のステップ: ${PURPLE}次の機能のRED フェーズ${NC}"
                ;;
        esac
        echo -e "   Kent Beck TDDサイクル: ${BOLD}正常に進行中${NC}"
    elif [[ "$completion_percentage" -ge 80 ]]; then
        echo -e "${YELLOW}⚠️  ほぼ完了（$completion_percentage%）${NC}"
        echo -e "   残りの項目完了後、次のフェーズへ進んでください"
    else
        echo -e "${RED}❌ 不完全（$completion_percentage%）${NC}"
        echo -e "   未完了項目を先に完了してください"
        echo -e "   Kent Beck原則: 各フェーズの完了条件厳守"
    fi
    
    # 品質保証メッセージ
    if [[ "$completed_count" -eq "$total_count" ]]; then
        echo -e "\n${BOLD}🏆 品質保証:${NC}"
        echo -e "   ${GREEN}Kent Beck TDD原則に準拠した高品質実装${NC}"
        echo -e "   ${BLUE}継続的フィードバックループが機能${NC}"
        echo -e "   ${PURPLE}次のフェーズへの安全な移行が可能${NC}"
    fi
}

# 全フェーズの条件一覧表示
show_all_criteria() {
    echo -e "${BOLD}${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}📚 Kent Beck TDD 全フェーズ受け入れ条件${NC}"
    echo -e "${BOLD}${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    echo -e "\n${BOLD}🔄 TDDサイクル概要:${NC}"
    echo -e "   ${RED}RED${NC} → ${GREEN}GREEN${NC} → ${BLUE}REFACTOR${NC} → 繰り返し"
    echo -e "   各フェーズで厳格な受け入れ条件をクリア"
    
    echo -e "\n${BOLD}${RED}🔴 RED フェーズ（テスト作成）:${NC}"
    echo -e "   ✓ テストファースト厳守"
    echo -e "   ✓ 最小限のテスト作成"
    echo -e "   ✓ テスト実行で失敗確認"
    echo -e "   ✓ 1つの具体例のみ"
    echo -e "   ✓ コンパイルエラーなし"
    
    echo -e "\n${BOLD}${GREEN}🟢 GREEN フェーズ（最小実装）:${NC}"
    echo -e "   ✓ 最小実装でテスト通過"
    echo -e "   ✓ Kent Beck戦略適用（Fake It推奨）"
    echo -e "   ✓ 全既存テスト通過"
    echo -e "   ✓ 品質チェック（コンパイル・リンター）"
    echo -e "   ✓ 実際の動作確認"
    
    echo -e "\n${BOLD}${BLUE}🔵 REFACTOR フェーズ（構造改善）:${NC}"
    echo -e "   ✓ 振る舞い保護（全テスト緑維持）"
    echo -e "   ✓ 構造改善のみ実施"
    echo -e "   ✓ Tidy First原則遵守"
    echo -e "   ✓ 可読性・保守性向上"
    echo -e "   ✓ [STRUCTURE]コミット"
    
    echo -e "\n${BOLD}🎯 Kent Beck核心原則:${NC}"
    echo -e "   • ${CYAN}\"Make it work, make it right, make it fast\"${NC}"
    echo -e "   • ${CYAN}\"Do the simplest thing that could possibly work\"${NC}"
    echo -e "   • ${CYAN}\"You aren't gonna need it\" (YAGNI)${NC}"
    echo -e "   • ${CYAN}\"Red, Green, Refactor - and repeat\"${NC}"
    
    echo -e "\n${BOLD}📊 品質指標:${NC}"
    echo -e "   🏆 各フェーズ100%完了 = Kent Beck基準準拠"
    echo -e "   ✅ 80%以上完了 = 基本的品質確保"
    echo -e "   ⚠️  80%未満 = 品質リスク有り"
}

# メイン関数
main() {
    local command="${1:-}"
    
    case "$command" in
        "show")
            if [[ $# -lt 4 ]]; then
                echo -e "${RED}❌ エラー: フェーズ、ステップ、機能名を指定してください${NC}"
                show_usage
                exit 1
            fi
            
            case "$2" in
                "red")
                    show_red_criteria "$3" "$4"
                    ;;
                "green")
                    show_green_criteria "$3" "$4"
                    ;;
                "refactor")
                    show_refactor_criteria "$3" "$4"
                    ;;
                *)
                    echo -e "${RED}❌ 不明なフェーズ: $2${NC}"
                    echo -e "   利用可能: red, green, refactor"
                    exit 1
                    ;;
            esac
            ;;
        "check")
            if [[ $# -lt 4 ]]; then
                echo -e "${RED}❌ エラー: フェーズ、ステップ、機能名を指定してください${NC}"
                show_usage
                exit 1
            fi
            interactive_criteria_check "$2" "$3" "$4"
            ;;
        "list")
            show_all_criteria
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