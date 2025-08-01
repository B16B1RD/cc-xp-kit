---
description: "アジャイル価値実現レビュー - 継続的改善と品質分析"
argument-hint: "[story-id|epic-id|全体]"
allowed-tools: ["Read", "Write", "Bash", "TodoWrite"]
---

# アジャイル価値実現レビュー

レビュー対象: $ARGUMENTS

## 🎯 アジャイル原則に基づく価値レビュー

### レビュー哲学

**アジャイル宣言**: "動くソフトウェア > 包括的ドキュメント"

**Kent Beck XP**: "勇気を持って変化に対応する"

## 指示

以下の**価値実現レビュー**を実行してください：

### 📊 Phase 1: ユーザー価値の定量評価

#### 1. 実装機能の価値測定

**現在の実装について**価値を測定してください：

1. **機能別価値スコア**:
   ```bash
   echo "📈 実装機能の価値分析:"
   echo ""
   
   # Gitログから実装機能を抽出
   git log --oneline | grep -E '\[BEHAVIOR\]' | head -10 | while read commit; do
     echo "機能: $(echo $commit | sed 's/.*\[BEHAVIOR\] //')"
     echo "  - ユーザー価値度: [1-10点で評価してください]"
     echo "  - 使用頻度予測: [高/中/低]"
     echo "  - 実装品質: [良好/改善必要/要修正]"
     echo ""
   done
   ```

2. **ユーザーストーリー達成度**:
   ```bash
   # ユーザーストーリーファイルの確認
   if [ -f .claude/agile-artifacts/stories/user-stories.md ]; then
     echo "📋 ユーザーストーリー実現状況:"
     grep -n "Story.*:" .claude/agile-artifacts/stories/user-stories.md | head -5
     echo ""
     echo "✅ 各ストーリーの達成状況を確認してください:"
     echo "  - Definition of Done完了率: [%]"
     echo "  - Acceptance Criteria達成率: [%]"
     echo "  - ユーザー満足度: [1-10点]"
   else
     echo "⚠️ ユーザーストーリーファイルが見つかりません"
   fi
   ```

3. **品質メトリクス**:
   ```bash
   echo "🔍 品質指標分析:"
   
   # テスト実行状況
   if command -v npm &> /dev/null; then
     echo "  - テスト実行: 実施中..."
     npm test -- --watchAll=false --passWithNoTests 2>&1 | grep -E "Tests:|passed|failed|PASS|FAIL" | head -3
   fi
   
   # リンター結果
   if command -v npm &> /dev/null && npm list --depth=0 | grep -q "eslint"; then
     echo "  - コード品質: 確認中..."
     npm run lint 2>/dev/null | grep -E "error|warning|✓" | head -3 || echo "    品質チェック完了"
   fi
   
   # Gitコミット品質
   echo "  - コミット品質:"
   echo "    - [BEHAVIOR]コミット: $(git log --oneline | grep -c '\[BEHAVIOR\]')個"
   echo "    - [STRUCTURE]コミット: $(git log --oneline | grep -c '\[STRUCTURE\]')個"
   echo "    - Tidy First原則遵守率: $(($(git log --oneline | grep -c '\[BEHAVIOR\]\|\[STRUCTURE\]') * 100 / $(git log --oneline | wc -l)))%"
   ```

### 🎯 Phase 2: Kent Beck TDD実践評価

#### 1. TDD原則遵守度の分析

**TDD実践について**詳細に分析してください：

1. **TDD三大戦略の適用状況**:
   ```text
   TDD戦略実践評価：
   
   Fake It戦略の使用:
   Q1: ハードコーディングから開始できましたか？ (Yes/No)
   Q2: 恥ずかしさを感じながらも最小実装できましたか？ (Yes/No)
   Q3: Fake Itにより設計の複雑さを回避できましたか？ (Yes/No)
   
   Triangulation戦略の使用:
   Q4: 2つ目のテストで一般化を促進できましたか？ (Yes/No)
   Q5: ハードコーディングを自然に破ることができましたか？ (Yes/No)
   
   Obvious Implementation戦略の使用:
   Q6: 明白な実装のみに限定できましたか？ (Yes/No)
   Q7: 確信がない場合にFake Itを選択できましたか？ (Yes/No)
   ```

2. **Red-Green-Refactorサイクル評価**:
   ```bash
   echo "🔄 TDDサイクル実践度:"
   
   # テストファイルの存在確認
   find . -name "*.test.*" -o -name "*.spec.*" 2>/dev/null | head -5 | while read test_file; do
     echo "  テストファイル: $(basename $test_file)"
     echo "    - テスト数: $(grep -c "test\|it\|describe" "$test_file" 2>/dev/null)個"
   done
   
   echo ""
   echo "📊 サイクル遵守度自己評価:"
   echo "  - RED段階でテストが失敗することを確認: [常に/時々/稀に]"
   echo "  - GREEN段階で最小実装を心がける: [常に/時々/稀に]"
   echo "  - REFACTOR段階で構造改善を実施: [常に/時々/稀に]"
   ```

3. **設計品質の進化**:
   ```text
   設計品質評価：
   
   Q1: TDDによって使いやすいAPIが生まれましたか？
   Q2: テストが設計を駆動していると感じられましたか？
   Q3: 複雑性が早期に発見・除去されましたか？
   Q4: シンプルな設計が維持できていますか？
   Q5: リファクタリングを安心して実施できましたか？
   ```

### 🔄 Phase 3: 継続的改善計画

#### 1. 改善点の特定と計画

**現在の状況から**具体的な改善計画を策定してください：

1. **技術的改善点**:
   ```text
   技術改善計画：
   
   TDD実践の改善:
   - [ ] テストファーストの徹底度向上
   - [ ] Kent Beck戦略の効果的活用
   - [ ] リファクタリング頻度の増加
   
   品質向上:
   - [ ] テストカバレッジの向上
   - [ ] コード品質指標の改善
   - [ ] 継続的統合の強化
   ```

2. **ユーザー価値向上**:
   ```text
   価値向上計画：
   
   ユーザー体験:
   - [ ] 価値の低い機能の見直し・削除
   - [ ] 高価値機能の優先的改善
   - [ ] ユーザビリティの向上
   
   フィードバック強化:
   - [ ] ユーザーからの直接フィードバック収集
   - [ ] デモ頻度の増加
   - [ ] A/Bテストの実施
   ```

3. **プロセス改善**:
   ```text
   プロセス改善計画：
   
   アジャイル実践:
   - [ ] フィードバックサイクルの短縮
   - [ ] ペアプログラミングの導入
   - [ ] 継続的デリバリーの実現
   
   チーム協働:
   - [ ] 集団所有の促進
   - [ ] 知識共有の活性化
   - [ ] レトロスペクティブの定期実施
   ```

### 📋 Phase 4: レビュー結果の記録

#### 完全なレビューレポート作成

`.claude/agile-artifacts/reviews/review-$(date +%Y%m%d-%H%M).md` にレビュー結果を記録：

```markdown
# アジャイル価値実現レビュー - $(date '+%Y-%m-%d %H:%M')

## レビュー対象
$ARGUMENTS

## ユーザー価値評価

### 実装機能価値スコア
[各機能の評価結果]

### ユーザーストーリー達成度
- Definition of Done完了率: [%]
- Acceptance Criteria達成率: [%]
- ユーザー満足度: [1-10点]

### 品質メトリクス
- テスト実行結果: [状況]
- コード品質: [状況]
- Tidy First原則遵守率: [%]

## TDD実践評価

### 三大戦略適用状況
- Fake It戦略: [評価]
- Triangulation戦略: [評価]
- Obvious Implementation戦略: [評価]

### Red-Green-Refactorサイクル
- サイクル遵守度: [評価]
- 設計品質の進化: [評価]

## 改善計画

### 技術的改善
[具体的な改善項目]

### ユーザー価値向上
[価値向上の計画]

### プロセス改善
[プロセス改善項目]

## 次のアクション
- [ ] 高優先改善項目の実施
- [ ] ユーザーフィードバック収集
- [ ] 次回レビュー日程の設定

## 学習ポイント
[このレビューから得られた洞察]
```

## 🎯 レビュー完了と次のステップ

### ✅ レビュー成功基準

**以下がすべて完了していることを確認**:
- [ ] ユーザー価値の定量評価完了
- [ ] TDD実践度の客観的分析完了
- [ ] 具体的改善計画の策定完了
- [ ] レビュー結果の文書化完了

### 🚀 継続的改善の実行

**レビュー後の推奨アクション**:

1. **即座改善** - 緊急度の高い問題の修正
2. **計画改善** - 中長期改善計画の実施
3. **学習促進** - 新しい技術・手法の習得
4. **フィードバック収集** - ユーザーからの継続的意見収集

```text
✅ アジャイル価値実現レビュー完了！

📊 評価結果:
- ユーザー価値: 定量的に測定・評価完了
- TDD実践度: Kent Beck原則準拠度を分析
- 品質指標: 技術的品質を客観的に確認

🎯 改善計画:
- 技術改善: TDD実践度向上計画
- 価値向上: ユーザー価値最大化計画  
- プロセス改善: アジャイル実践強化計画

🚀 次のアクション:

継続的フィードバック:
/tdd:feedback immediate

改善実施:
/tdd:run [改善対象機能]

次回レビュー:
/tdd:review [next-target]
```

**真のアジャイル開発**は、継続的なレビューと改善によって価値を最大化します。