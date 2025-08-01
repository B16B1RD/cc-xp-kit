---
description: "アジャイル価値進捗ダッシュボード - ユーザー価値中心の状況確認"
argument-hint: "[-v for detailed | -metrics for analytics | -health for quality]"
allowed-tools: ["Read", "Bash", "LS", "TodoWrite"]
---

# アジャイル価値進捗ダッシュボード

表示モード: $ARGUMENTS

## 🎯 価値中心進捗管理（アジャイル原則準拠）

### 進捗哲学

**アジャイル宣言**: "動くソフトウェア > 包括的ドキュメント"

**Kent Beck**: "価値の実現こそが真の進捗である"

## 指示

以下の**価値中心ダッシュボード**を表示してください：

### 📊 Phase 1: ユーザー価値実現状況

#### 1. 価値提供サマリー

**現在の価値実現度**を確認してください：

```bash
echo "🎯 ユーザー価値実現ダッシュボード"
echo "=================================="
echo ""

# 実装済み機能の確認
BEHAVIOR_COMMITS=$(git log --oneline | grep -c '\[BEHAVIOR\]' 2>/dev/null || echo "0")
STRUCTURE_COMMITS=$(git log --oneline | grep -c '\[STRUCTURE\]' 2>/dev/null || echo "0")
TOTAL_COMMITS=$(git log --oneline | wc -l 2>/dev/null || echo "0")

echo "📈 価値創造メトリクス:"
echo "  ├─ 実装機能数: ${BEHAVIOR_COMMITS}個"
echo "  ├─ 構造改善数: ${STRUCTURE_COMMITS}個"
echo "  ├─ 価値密度: $((BEHAVIOR_COMMITS * 100 / (TOTAL_COMMITS + 1)))% (実装/総コミット)"
echo "  └─ TDD遵守度: $((((BEHAVIOR_COMMITS + STRUCTURE_COMMITS) * 100) / (TOTAL_COMMITS + 1)))%"
echo ""

# 最新の価値実現
echo "🚀 最新の価値実現:"
git log --oneline | grep '\[BEHAVIOR\]' | head -3 | while read commit; do
  feature=$(echo $commit | sed 's/.*\[BEHAVIOR\] //')
  echo "  ✅ $feature"
done
```

#### 2. ユーザーストーリー進捗

**ストーリー実現状況**を確認してください：

```bash
echo ""
echo "📋 ユーザーストーリー進捗:"
echo "=========================="

if [ -f .claude/agile-artifacts/stories/user-stories.md ]; then
  # ストーリー数の確認
  TOTAL_STORIES=$(grep -c "^#### Story" .claude/agile-artifacts/stories/user-stories.md 2>/dev/null || echo "0")
  MUST_HAVE=$(grep -c "Must Have" .claude/agile-artifacts/stories/user-stories.md 2>/dev/null || echo "0")
  SHOULD_HAVE=$(grep -c "Should Have" .claude/agile-artifacts/stories/user-stories.md 2>/dev/null || echo "0")
  
  echo "  ├─ 総ストーリー数: ${TOTAL_STORIES}個"
  echo "  ├─ Must Have: ${MUST_HAVE}個"
  echo "  ├─ Should Have: ${SHOULD_HAVE}個"
  echo "  └─ MVP完成度: [要確認]%"
  echo ""
  
  # 最新ストーリーの表示
  echo "📖 定義済みストーリー（最新5個）:"
  grep -A1 "^#### Story" .claude/agile-artifacts/stories/user-stories.md | head -10 | while read line; do
    if [[ $line == *"Story"* ]]; then
      echo "  • $(echo $line | sed 's/#### Story [0-9.]* //')"
    fi
  done
else
  echo "  ⚠️ ユーザーストーリー未作成"
  echo "  推奨: /tdd [要望] で統合開発開始"
fi
```

#### 3. 品質と技術健全性

**技術品質状況**を確認してください：

```bash
echo ""
echo "🔍 技術品質ダッシュボード:"
echo "=========================="

# テスト状況
TEST_FILES=$(find . -name "*.test.*" -o -name "*.spec.*" 2>/dev/null | wc -l)
echo "  ├─ テストファイル数: ${TEST_FILES}個"

# テスト実行状況
if command -v npm &> /dev/null; then
  echo "  ├─ テスト実行状況:"
  if npm test -- --watchAll=false --passWithNoTests --silent 2>/dev/null | grep -q "PASS\|Tests:"; then
    echo "  │   └─ ✅ テスト実行可能"
  else
    echo "  │   └─ ⚠️ テスト実行要確認"
  fi
fi

# コード品質
if command -v npm &> /dev/null && npm list --depth=0 2>/dev/null | grep -q "eslint"; then
  echo "  ├─ Lint状況:"
  if npm run lint 2>/dev/null | grep -q "✓\|All files pass"; then
    echo "  │   └─ ✅ コード品質良好"
  else
    echo "  │   └─ ⚠️ コード品質要改善"
  fi
fi

# Git健全性
UNCOMMITTED=$(git status --porcelain 2>/dev/null | wc -l)
echo "  └─ Git状況:"
if [ "$UNCOMMITTED" -eq 0 ]; then
  echo "      └─ ✅ コミット状態クリーン"
else
  echo "      └─ ⚠️ 未コミット変更: ${UNCOMMITTED}ファイル"
fi
```

### 🔄 Phase 2: TDD実践状況分析

#### 1. Kent Beck TDD原則遵守度

**TDD実践の健全性**を確認してください：

```bash
echo ""
echo "🔄 TDD実践ダッシュボード:"
echo "========================"

# TDDサイクル分析
echo "  📊 Red-Green-Refactor サイクル:"
TODAY_BEHAVIOR=$(git log --since="today" --oneline | grep -c '\[BEHAVIOR\]' 2>/dev/null || echo "0")
TODAY_STRUCTURE=$(git log --since="today" --oneline | grep -c '\[STRUCTURE\]' 2>/dev/null || echo "0")
TODAY_TOTAL=$(git log --since="today" --oneline | wc -l 2>/dev/null || echo "0")

echo "    ├─ 本日の機能実装: ${TODAY_BEHAVIOR}個"
echo "    ├─ 本日のリファクタリング: ${TODAY_STRUCTURE}個"
echo "    └─ 本日のTDD遵守度: $((((TODAY_BEHAVIOR + TODAY_STRUCTURE) * 100) / (TODAY_TOTAL + 1)))%"

# 戦略適用状況の推測（コードパターンから）
echo ""
echo "  🎯 Kent Beck戦略適用状況（推定）:"
if [ -d src ] || [ -d lib ]; then
  # ハードコーディングパターンの検出（Fake It戦略）
  HARDCODE_PATTERNS=$(find . -name "*.js" -o -name "*.ts" -o -name "*.py" 2>/dev/null | xargs grep -l "return [0-9]\|return '[^']*'\|return \"[^\"]*\"" 2>/dev/null | wc -l)
  echo "    ├─ Fake It戦略適用可能性: $((HARDCODE_PATTERNS > 0 ? 70 : 30))%"
  
  # 関数の抽象度（Triangulation戦略）
  ABSTRACT_FUNCTIONS=$(find . -name "*.js" -o -name "*.ts" 2>/dev/null | xargs grep -l "function.*{.*}" 2>/dev/null | wc -l)
  echo "    ├─ Triangulation戦略適用度: $((ABSTRACT_FUNCTIONS > 2 ? 80 : 40))%"
  
  echo "    └─ 戦略バランス: [要詳細分析]"
else
  echo "    └─ ソースコード未検出 - プロジェクト初期段階"
fi
```

#### 2. フィードバックループ健全性

**継続的改善の実施状況**を確認してください：

```bash
echo ""
echo "🔄 フィードバックループ状況:"
echo "============================"

# フィードバック実施状況
FEEDBACK_DIR=".claude/agile-artifacts/feedback"
if [ -d "$FEEDBACK_DIR" ]; then
  IMMEDIATE_FEEDBACK=$(find "$FEEDBACK_DIR" -name "immediate-*" 2>/dev/null | wc -l)
  DAILY_FEEDBACK=$(find "$FEEDBACK_DIR" -name "daily-*" 2>/dev/null | wc -l)
  WEEKLY_FEEDBACK=$(find "$FEEDBACK_DIR" -name "weekly-*" 2>/dev/null | wc -l)
  
  echo "  📈 フィードバック実施状況:"
  echo "    ├─ 即座フィードバック: ${IMMEDIATE_FEEDBACK}回"
  echo "    ├─ 日次振り返り: ${DAILY_FEEDBACK}回"
  echo "    ├─ 週次価値検証: ${WEEKLY_FEEDBACK}回"
  
  # フィードバック頻度の評価
  TOTAL_FEEDBACK=$((IMMEDIATE_FEEDBACK + DAILY_FEEDBACK + WEEKLY_FEEDBACK))
  if [ "$TOTAL_FEEDBACK" -gt 5 ]; then
    echo "    └─ ✅ フィードバック文化定着中"
  elif [ "$TOTAL_FEEDBACK" -gt 0 ]; then
    echo "    └─ ⚠️ フィードバック頻度要改善"
  else
    echo "    └─ 🚨 フィードバック未実施"
  fi
else
  echo "  ⚠️ フィードバックシステム未使用"
  echo "  推奨: /tdd:feedback immediate で開始"
fi

# 最新のフィードバック
echo ""
echo "  🎯 最新フィードバック:"
if [ -d "$FEEDBACK_DIR" ]; then
  LATEST_FEEDBACK=$(find "$FEEDBACK_DIR" -name "*.md" -type f 2>/dev/null | sort | tail -1)
  if [ -n "$LATEST_FEEDBACK" ] && [ -f "$LATEST_FEEDBACK" ]; then
    echo "    └─ $(basename "$LATEST_FEEDBACK" .md | sed 's/-/ /g')"
  else
    echo "    └─ フィードバック履歴なし"
  fi
else
  echo "    └─ フィードバック未設定"
fi
```

### 📋 Phase 3: 次のアクション推奨

#### アジャイル原則に基づく推奨アクション

**現在の状況に基づいた**推奨アクションを表示してください：

```bash
echo ""
echo "🚀 推奨アクション:"
echo "=================="

# 状況に応じた推奨アクション
if [ "$BEHAVIOR_COMMITS" -eq 0 ]; then
  echo "  🎯 開発開始推奨:"
  echo "    ├─ /tdd [要望] で統合開発開始"
  echo "    └─ /tdd:run [機能名] で実装開始"
elif [ "$TODAY_BEHAVIOR" -eq 0 ]; then
  echo "  📈 価値創造推奨:"
  echo "    ├─ /tdd:run [新機能] で価値追加"
  echo "    ├─ /tdd:feedback immediate で価値確認"
  echo "    └─ 既存機能の改善検討"
else
  echo "  🔄 継続的改善推奨:"
  echo "    ├─ /tdd:feedback immediate で今日の成果確認"
  echo "    ├─ /tdd:review で品質分析"
  echo "    └─ 次の高価値機能の計画"
fi

# 品質改善推奨
if [ "$TEST_FILES" -eq 0 ]; then
  echo ""
  echo "  🧪 品質向上推奨:"
  echo "    ├─ テストファーストの実践"
  echo "    ├─ Kent Beck TDD原則の適用"
  echo "    └─ Red-Green-Refactorサイクル開始"
fi

# フィードバック推奨
TOTAL_FEEDBACK=$(($(find .claude/agile-artifacts/feedback -name "*.md" 2>/dev/null | wc -l)))
if [ "$TOTAL_FEEDBACK" -lt 3 ]; then
  echo ""
  echo "  💬 フィードバック強化推奨:"
  echo "    ├─ /tdd:feedback immediate で即座確認"
  echo "    ├─ ユーザーからの直接フィードバック収集"
  echo "    └─ 定期的な価値検証の実施"
fi
```

### 🎯 Phase 4: 詳細分析（-v オプション時）

**詳細表示要求時**の追加分析：

```bash
if [[ "$ARGUMENTS" == *"-v"* ]] || [[ "$ARGUMENTS" == *"detailed"* ]]; then
  echo ""
  echo "🔍 詳細分析:"
  echo "============"
  
  # 詳細なコミット履歴
  echo ""
  echo "📝 最近のコミット履歴（詳細）:"
  git log --oneline -10 | while read commit; do
    if [[ $commit == *"[BEHAVIOR]"* ]]; then
      echo "  ✨ $commit"
    elif [[ $commit == *"[STRUCTURE]"* ]]; then
      echo "  🔧 $commit"
    else
      echo "  📋 $commit"
    fi
  done
  
  # プロジェクト構造
  echo ""
  echo "📁 プロジェクト構造:"
  if [ -d src ]; then
    echo "  └─ src/"
    find src -name "*.js" -o -name "*.ts" -o -name "*.py" 2>/dev/null | head -5 | while read file; do
      echo "      ├─ $(basename $file)"
    done
  fi
  
  if [ -d .claude/agile-artifacts ]; then
    echo "  └─ .claude/agile-artifacts/"
    find .claude/agile-artifacts -name "*.md" 2>/dev/null | head -5 | while read file; do
      echo "      ├─ $(basename $file)"
    done
  fi
fi
```

## 🎯 価値進捗ダッシュボード完了

```text
✅ アジャイル価値進捗ダッシュボード表示完了！

📊 確認項目:
- ユーザー価値実現状況の可視化
- TDD実践健全性の分析
- フィードバックループ状況の確認
- 次のアクション推奨

🎯 表示モード:
- 標準: 価値中心の基本情報
- -v: 詳細な技術分析
- -metrics: メトリクス重点表示
- -health: 品質健全性分析

🚀 推奨アクション確認:

フィードバック実施:
/tdd:feedback immediate

価値分析:
/tdd:review

継続開発:
/tdd:run [機能名]

詳細分析:
/tdd:status -v
```

## 完了時の必須案内

ステータス確認完了後は、**必ず次のステップを案内**してください：

🔄 **次のステップ（忘れずに実行）**:
```
/tdd:run  # TDD継続（自動判定）
```

**重要**: ステータス確認で現在の状況を把握した後は、実際の開発作業を継続することをユーザーに促してください。状況確認は次のアクションを決めるための情報収集です。

**真のアジャイル進捗管理**は、技術的完成度ではなく**ユーザー価値の実現度**で測定されます。