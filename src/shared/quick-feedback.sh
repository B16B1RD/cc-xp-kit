#!/bin/bash

# Phase 3.6 クイックフィードバック収集スクリプト
# Usage: bash quick-feedback.sh [Phase名] [user-storiesファイルパス]

set -e

PHASE_NAME=${1:-"Phase"}
STORIES_FILE=${2:-"docs/agile-artifacts/stories/user-stories-v1.0.md"}
TIMESTAMP=$(date "+%Y-%m-%d %H:%M")

echo "🔄 Phase 3.6: 即座学習記録 (5分以内完了)"
echo "==========================================="

# 必須確認
if [ ! -f "$STORIES_FILE" ]; then
    echo "❌ エラー: user-storiesファイルが見つかりません: $STORIES_FILE"
    echo "正しいパスを指定してください："
    echo "bash quick-feedback.sh $PHASE_NAME <正しいパス>"
    exit 1
fi

echo "📝 対象ファイル: $STORIES_FILE"
echo "⏰ $PHASE_NAME 完了時刻: $TIMESTAMP"
echo ""

# 質問1: 予想との違い
echo "質問1: 予想との違い (2分以内回答)"
echo "選択肢: 1)想定より難しかった 2)想定より簡単だった 3)予想通り"
read -p "選択 [1-3]: " choice1
case $choice1 in
    1) diff_answer="想定より難しかった" ;;
    2) diff_answer="想定より簡単だった" ;;
    3) diff_answer="予想通り" ;;
    *) diff_answer="予想通り" ;;
esac
read -p "理由を1行で: " reason1

# 質問2: 重要な発見
echo ""
echo "質問2: 重要な発見 (2分以内回答)"
echo "例: 新技術の習得、プロセスの改善点、価値の発見"
read -p "発見を1行で: " discovery

# 質問3: 次の優先度
echo ""
echo "質問3: 次の優先度変更 (1分以内回答)"
echo "選択肢: 1)変わらない 2)変更あり"
read -p "選択 [1-2]: " choice3
if [ "$choice3" = "2" ]; then
    read -p "新しい優先度を1行で: " priority_change
    priority_answer="変更あり - $priority_change"
else
    priority_answer="変わらない"
fi

# user-storiesファイルに追記
echo "" >> "$STORIES_FILE"
echo "## 学習記録 - $PHASE_NAME - $TIMESTAMP" >> "$STORIES_FILE"
echo "1. 予想との違い: $diff_answer - $reason1" >> "$STORIES_FILE"
echo "2. 重要な発見: $discovery" >> "$STORIES_FILE"
echo "3. 次の優先度: $priority_answer" >> "$STORIES_FILE"

echo ""
echo "✅ フィードバック記録完了！"
echo "📍 記録場所: $STORIES_FILE"
echo ""
echo "🎯 次の作業:"
echo "  1. user-storiesのチェックボックスを✅に更新"
echo "  2. 発見事項を該当箇所に※追記"
echo "  3. 必要に応じて優先度調整"
echo ""
echo "⏭️  次のPhaseに進んでください"