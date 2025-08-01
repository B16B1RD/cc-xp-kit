#!/bin/bash

# MVP検証ゲート循環実行スクリプト
# Usage: bash mvp-gate-loop.sh [stories-file]

set -e

STORIES_FILE=${1:-""}
MAX_RETRIES=${2:-3}
TIMESTAMP=$(date "+%Y-%m-%d %H:%M")

# 色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo_red() {
    echo -e "${RED}🔴 $1${NC}"
}

echo_green() {
    echo -e "${GREEN}🟢 $1${NC}"
}

echo_yellow() {
    echo -e "${YELLOW}🟡 $1${NC}"
}

echo_blue() {
    echo -e "${BLUE}🔵 $1${NC}"
}

# ストーリーファイル自動検出
find_stories_file() {
    local possible_paths=(
        "docs/agile-artifacts/stories/user-stories-v1.0.md"
        "docs/agile-artifacts/stories/user-stories.md"
        ".claude/agile-artifacts/stories/user-stories-v1.0.md"
        ".claude/agile-artifacts/stories/user-stories.md"
    )
    
    for path in "${possible_paths[@]}"; do
        if [[ -f "$path" ]]; then
            echo "$path"
            return 0
        fi
    done
    
    return 1
}

# MVP検証の実行
execute_mvp_validation() {
    local stories_file="$1"
    
    echo_blue "Phase 3.6: MVP検証ゲート実行中..."
    echo "==========================================="
    
    # 実際のMVP検証ロジック（簡略化版）
    # 本来はより複雑な検証ロジックが必要
    
    # Story 1の必須要素チェック
    local missing_features=()
    
    if ! grep -q "ハードドロップ" "$stories_file"; then
        missing_features+=("ハードドロップ機能")
    fi
    
    # Hold機能は Story 2 の追加機能として扱う（MVP必須ではない）
    # if ! grep -q "Hold機能\|一時保留" "$stories_file"; then
    #     missing_features+=("Hold機能")
    # fi
    
    if ! grep -q "レベル.*速度\|速度.*システム" "$stories_file"; then
        missing_features+=("レベル・速度システム")
    fi
    
    if ! grep -q "SRS\|回転システム" "$stories_file"; then
        missing_features+=("SRS回転システム")
    fi
    
    # 受け入れ基準の現実性チェック
    local weak_criteria=()
    
    if ! grep -q "5分間.*緊張感\|緊張感.*5分" "$stories_file"; then
        weak_criteria+=("継続プレイ体験の基準不足")
    fi
    
    if ! grep -q "瞬間.*配置\|配置.*瞬間" "$stories_file"; then
        weak_criteria+=("操作性能の基準不足")
    fi
    
    # 検証結果の判定
    if [[ ${#missing_features[@]} -gt 0 ]] || [[ ${#weak_criteria[@]} -gt 0 ]]; then
        echo_red "❌ MVP検証失敗"
        echo ""
        echo "🚨 欠落している必須要素:"
        for feature in "${missing_features[@]}"; do
            echo "  - $feature"
        done
        
        if [[ ${#weak_criteria[@]} -gt 0 ]]; then
            echo ""
            echo "⚠️ 改善が必要な受け入れ基準:"
            for criteria in "${weak_criteria[@]}"; do
                echo "  - $criteria"
            done
        fi
        
        return 1
    else
        echo_green "✅ MVP検証合格"
        return 0
    fi
}

# 自動修正の実行
execute_auto_fix() {
    local stories_file="$1"
    
    echo_yellow "Phase 3: 自動修正実行中..."
    echo "=================================="
    
    # story-auto-fix.jsを実行
    local script_path="$HOME/.claude/commands/shared/story-auto-fix.js"
    local dev_path="/home/autum/Projects/personal/cc-tdd-kit/src/shared/story-auto-fix.js"
    
    if [[ -f "$script_path" ]]; then
        echo "🔧 ストーリー自動修正ツール実行中... (インストール版)"
        node "$script_path" "$stories_file"
    elif [[ -f "$dev_path" ]]; then
        echo "🔧 ストーリー自動修正ツール実行中... (開発版)"
        node "$dev_path" "$stories_file"
        
        if [[ $? -eq 0 ]]; then
            echo_green "✅ 自動修正完了"
            return 0
        else
            echo_red "❌ 自動修正失敗"
            return 1
        fi
    else
        echo_red "❌ 自動修正ツールが見つかりません"
        echo "パス: ~/.claude/commands/shared/story-auto-fix.js"
        return 1
    fi
}

# Phase 4への自動進行
proceed_to_phase4() {
    echo_green "🚀 Phase 4への自動進行"
    echo "======================"
    
    echo "✅ MVP検証合格 - TDD統合実装を開始します"
    echo ""
    echo "📋 次の実行推奨コマンド:"
    echo "  /tdd:run     # TDD統合実装の開始"
    echo ""
    echo "🎯 Kent Beck TDD原則に従った実装:"
    echo "  - Red: 失敗するテスト作成"
    echo "  - Green: 最小実装（Fake It戦略60%+）"
    echo "  - Refactor: 構造改善"
    echo ""
}

# メイン循環ロジック
main_loop() {
    local stories_file="$1"
    local retry_count=0
    
    echo_blue "MVP検証ゲート循環実行開始"
    echo "=========================="
    echo "📄 対象ファイル: $stories_file"
    echo "🔄 最大試行回数: $MAX_RETRIES"
    echo "⏰ 実行時刻: $TIMESTAMP"
    echo ""
    
    while [[ $retry_count -lt $MAX_RETRIES ]]; do
        echo_blue "🔄 試行 $(($retry_count + 1))/$MAX_RETRIES"
        echo ""
        
        # MVP検証実行
        if execute_mvp_validation "$stories_file"; then
            # 検証合格 - Phase 4へ進行
            proceed_to_phase4
            return 0
        else
            # 検証失敗 - 自動修正実行
            echo ""
            echo_yellow "🔧 自動修正を実行します..."
            echo ""
            
            if execute_auto_fix "$stories_file"; then
                echo ""
                echo_green "✅ 修正完了 - 再検証します"
                echo ""
                retry_count=$(($retry_count + 1))
                
                # 1秒待機（ファイル更新の確実な反映）
                sleep 1
            else
                echo_red "❌ 自動修正失敗 - 手動介入が必要です"
                echo ""
                echo "🔍 対処方法:"
                echo "1. $stories_file を手動で確認・修正"
                echo "2. 再度このスクリプトを実行"
                echo "3. または /tdd コマンドでPhase 3から再開"
                return 1
            fi
        fi
    done
    
    # 最大試行回数に達した場合
    echo_red "❌ 最大試行回数に達しました"
    echo ""
    echo "🚨 手動介入が必要:"
    echo "1. $stories_file の内容を詳細確認"
    echo "2. MVP要件の根本的見直し"
    echo "3. プロジェクト規模の再評価"
    echo ""
    echo "💡 Kent Beck: \"勇気を持って現実を受け入れ、必要な変更を恐れるな\""
    
    return 1
}

# 実行前チェック
pre_execution_check() {
    echo_blue "実行前環境チェック"
    echo "=================="
    
    # Node.js確認
    if ! command -v node >/dev/null 2>&1; then
        echo_red "❌ Node.jsが見つかりません"
        return 1
    fi
    
    # 自動修正ツール確認
    local script_path="$HOME/.claude/commands/shared/story-auto-fix.js"
    local dev_path="/home/autum/Projects/personal/cc-tdd-kit/src/shared/story-auto-fix.js"
    
    if [[ -f "$script_path" ]]; then
        echo_green "✅ 自動修正ツール確認 (インストール版): $script_path"
    elif [[ -f "$dev_path" ]]; then
        echo_green "✅ 自動修正ツール確認 (開発版): $dev_path"
    else
        echo_yellow "⚠️ 自動修正ツールが見つかりません"
        echo "パス: $script_path または $dev_path"
        echo "手動修正モードで実行します"
    fi
    
    echo_green "✅ 環境チェック完了"
    echo ""
}

# メイン実行
main() {
    # 実行前チェック
    pre_execution_check
    
    # ストーリーファイル検索
    if [[ -z "$STORIES_FILE" ]]; then
        if ! STORIES_FILE=$(find_stories_file); then
            echo_red "❌ ユーザーストーリーファイルが見つかりません"
            echo ""
            echo "以下のパスに配置してください:"
            echo "  docs/agile-artifacts/stories/user-stories-v1.0.md"
            echo "  docs/agile-artifacts/stories/user-stories.md"
            echo "  .claude/agile-artifacts/stories/user-stories-v1.0.md"
            echo "  .claude/agile-artifacts/stories/user-stories.md"
            exit 1
        fi
    fi
    
    echo_green "📄 ストーリーファイル確認: $STORIES_FILE"
    echo ""
    
    # メイン循環実行
    main_loop "$STORIES_FILE"
    
    exit_code=$?
    echo ""
    
    if [[ $exit_code -eq 0 ]]; then
        echo_green "🎉 MVP検証ゲート循環実行完了!"
        echo "Phase 4: TDD統合実装へ進行可能です"
    else
        echo_red "💥 MVP検証ゲート循環実行失敗"
        echo "手動介入または設定見直しが必要です"
    fi
    
    exit $exit_code
}

main "$@"