#!/bin/bash

# Red-Green-Refactorサイクル実行支援ツール
# Usage: bash tdd-cycle.sh [phase] [description]

set -e

PHASE=${1:-"red"}
DESCRIPTION=${2:-"feature"}
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

# Kent Beck原則チェック
check_tdd_principles() {
    echo_blue "Kent Beck TDD原則チェック"
    echo "=============================="
    echo
    
    echo "✅ 以下を確認してください:"
    echo "1. [ ] 失敗するテストを書きましたか？"
    echo "2. [ ] そのテストが正確に失敗することを確認しましたか？"
    echo "3. [ ] 最小限の実装のみ書く予定ですか？"
    echo "4. [ ] 1度の実装は10行以下ですか？"
    echo "5. [ ] Fake It戦略を使う準備はできていますか？"
    echo
    
    read -p "全てチェック済みですか？ (y/n): " confirmed
    if [[ $confirmed != "y" ]]; then
        echo "❌ TDD原則を確認してから再実行してください"
        exit 1
    fi
}

# Redフェーズ: 失敗するテスト作成
red_phase() {
    echo_red "Phase: RED - 失敗するテスト作成"
    echo "================================="
    echo
    
    echo "📝 ${DESCRIPTION} のテスト作成中..."
    echo
    
    # テストファイルの確認
    if [[ ! -d "tests" ]]; then
        mkdir -p tests
        echo "✅ testsディレクトリを作成しました"
    fi
    
    # Kent Beck戦略の提案
    echo "💡 Kent Beck戦略の提案:"
    node ~/.claude/commands/shared/kent-beck-strategy.js "${DESCRIPTION}" 2>/dev/null || echo "（戦略判定ツールが利用できません）"
    echo
    
    echo "⚠️  重要: テストを作成したら必ず実行して失敗することを確認してください"
    echo
    echo "🏃 テスト実行コマンド:"
    echo "  bun test"
    echo "  または"
    echo "  npm test"
    echo
    echo "✅ テスト作成完了後、次のコマンドでGreenフェーズへ:"
    echo "  bash ~/.claude/commands/shared/tdd-cycle.sh green \"${DESCRIPTION}\""
}

# Greenフェーズ: 最小実装
green_phase() {
    echo_green "Phase: GREEN - 最小実装"
    echo "========================"
    echo
    
    echo "🛠️ ${DESCRIPTION} の最小実装中..."
    echo
    
    echo "🎯 Fake It戦略のガイドライン:"
    echo "1. ハードコーディングで良い"
    echo "2. 完璧を目指さない"
    echo "3. テストが通る最小限のコード"
    echo "4. 汚いコードでも良い（Refactorで改善）"
    echo
    
    echo "❌ やってはいけないこと:"
    echo "- 一度に複数の機能を実装"
    echo "- 完璧な実装を目指す"
    echo "- まだ必要でない機能の追加"
    echo
    
    echo "✅ 実装完了後、テスト実行:"
    echo "  bun test"
    echo
    echo "🟢 テスト通過後、次のコマンドでRefactorフェーズへ:"
    echo "  bash ~/.claude/commands/shared/tdd-cycle.sh refactor \"${DESCRIPTION}\""
}

# Refactorフェーズ: コード改善
refactor_phase() {
    echo_yellow "Phase: REFACTOR - コード改善"
    echo "============================="
    echo
    
    echo "🔧 ${DESCRIPTION} のリファクタリング中..."
    echo
    
    echo "🎯 リファクタリングのポイント:"
    echo "1. 変数名の改善"
    echo "2. 重複コードの除去"
    echo "3. メソッドの分離"
    echo "4. 定数の抽出"
    echo "5. コメントの追加"
    echo
    
    echo "⚠️  重要: リファクタリング中は機能を追加しない"
    echo "   - 動作を変えずに構造のみ改善"
    echo "   - 各変更後にテストを実行"
    echo
    
    echo "✅ リファクタリング完了後:"
    echo "1. 全テストが通ることを確認"
    echo "2. コミット: [BEHAVIOR] ${DESCRIPTION}"
    echo "3. 次のサイクルまたは機能に進む"
    echo
    
    echo "🔄 次のTDDサイクル開始:"
    echo "  bash ~/.claude/commands/shared/tdd-cycle.sh red \"次の機能名\""
}

# コミット支援
commit_phase() {
    echo_blue "Phase: COMMIT - 変更の記録"
    echo "=========================="
    echo
    
    echo "📝 コミット準備中..."
    echo
    
    # Git状態確認
    if git rev-parse --git-dir > /dev/null 2>&1; then
        echo "📊 現在のGit状態:"
        git status --porcelain
        echo
        
        echo "💡 推奨コミットメッセージ:"
        echo "  [BEHAVIOR] Add ${DESCRIPTION}"
        echo "  [BEHAVIOR] Fix ${DESCRIPTION}"
        echo "  [STRUCTURE] Refactor ${DESCRIPTION}"
        echo
        
        read -p "コミットを実行しますか？ (y/n): " do_commit
        if [[ $do_commit == "y" ]]; then
            read -p "コミットメッセージを入力: " commit_message
            git add .
            git commit -m "${commit_message}"
            echo "✅ コミット完了!"
        fi
    else
        echo "⚠️ Gitリポジトリではありません"
    fi
}

# TDDサマリー表示
show_summary() {
    echo_blue "TDDサイクル完了サマリー"
    echo "======================="
    echo
    echo "🎯 実装した機能: ${DESCRIPTION}"
    echo "⏰ 完了時刻: ${TIMESTAMP}"
    echo
    echo "📊 完了したステップ:"
    echo "  ✅ Red: 失敗するテスト作成"
    echo "  ✅ Green: 最小実装"
    echo "  ✅ Refactor: コード改善"
    echo "  ✅ Commit: 変更記録"
    echo
    echo "🚀 次のアクション:"
    echo "1. user-storiesのチェックボックス更新"
    echo "2. 学習記録の実行:"
    echo "   bash ~/.claude/commands/shared/quick-feedback.sh \"${DESCRIPTION}\""
    echo "3. 次の機能のTDDサイクル開始"
}

# メイン処理
main() {
    case $PHASE in
        "red")
            check_tdd_principles
            red_phase
            ;;
        "green")
            green_phase
            ;;
        "refactor")
            refactor_phase
            ;;
        "commit")
            commit_phase
            ;;
        "summary")
            show_summary
            ;;
        *)
            echo "使用法: bash tdd-cycle.sh [red|green|refactor|commit|summary] [description]"
            echo
            echo "例:"
            echo "  bash tdd-cycle.sh red \"ゲームボード描画\""
            echo "  bash tdd-cycle.sh green \"ゲームボード描画\""
            echo "  bash tdd-cycle.sh refactor \"ゲームボード描画\""
            echo "  bash tdd-cycle.sh commit \"ゲームボード描画\""
            exit 1
            ;;
    esac
}

main