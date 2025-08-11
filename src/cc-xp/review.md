---
description: XP review – 価値×技術の二軸評価と判定（accept/reject/skipで指定）+ 価値体験確認
argument-hint: '[accept|reject|skip] [理由（rejectの場合）] [--skip-demo] [--skip-e2e]'
allowed-tools: Bash(git:*), Bash(date), Bash(test), Bash(kill:*), Bash(cat), Bash(bun:*), Bash(npm:*), Bash(pnpm:*), Bash(python:*), Bash(cargo:*), Bash(go:*), Bash(bundle:*), Bash(dotnet:*), Bash(gradle:*), Bash(http-server:*), Bash(lsof:*), Bash(netstat:*), Bash(npx:*), ReadFile, WriteFile, mcp__playwright__*
---

# XP Review - 価値×技術 二軸評価

## ゴール

実際に価値を体験してユーザー視点で評価し、価値実現度と技術品質の二軸で承認/却下を判定する。**1回のコマンドで完結**。

## XP原則

- **価値あるソフトウェア**: 実際に価値を体験できるものが最高のフィードバック
- **オンサイトカスタマー**: ユーザーの価値体験視点で即座に判断
- **素早いフィードバック**: 価値確認から判定まで一気通貫
- **継続的な価値提供**: 承認後は即座にユーザーの価値提供

## Git リポジトリ確認（必須）

**🚨 最初に必ず実行してください 🚨**

```bash
# Git Repository Check
echo "=== Git リポジトリ確認 ==="
if [ ! -d ".git" ]; then
    echo "❌ エラー: Gitリポジトリが初期化されていません"
    echo ""
    echo "🔧 解決方法:"
    echo "1. 新規プロジェクトの場合:"
    echo "   git init"
    echo "   git add ."
    echo "   git commit -m \"Initial commit\""
    echo ""
    echo "🚫 処理を中止します"
    exit 1
fi

# Git設定確認
if ! git config user.name > /dev/null 2>&1 || ! git config user.email > /dev/null 2>&1; then
    echo "⚠️  警告: Git設定が不完全です"
    echo "🔧 以下のコマンドでGit設定を行ってください:"
    echo "   git config --global user.name \"Your Name\""
    echo "   git config --global user.email \"your.email@example.com\""
    echo ""
    echo "🚫 処理を中止します"
    exit 1
fi

echo "✅ Git リポジトリ確認完了"
echo ""
```

## ステータス遷移ルール

**重要**: ステータスの正しい遷移を厳守してください。

```
selected (plan) → in-progress (story) → testing (develop) → done (review accept のみ)
                                               ↓ (reject)
                                          in-progress
```

- `done` にできるのは **`/cc-xp:review accept` のみ**
- `reject` の場合は `in-progress` に戻す
- すでに `done` のストーリーは変更不可

## 現在の状態確認

### 価値実現中心のストーリー情報取得

@docs/cc-xp/backlog.yaml から `testing` ステータスのストーリーを確認し、**価値実現に必要な全情報**を取得してください：

#### 基本情報

- ストーリーID, タイトル, created_at, updated_at

#### 価値実現項目（評価の核心）

- **core_value**: 実現すべき本質価値
- **minimum_experience**: 最小価値体験
- **value_story**: 価値体験を中心としたストーリー
- **success_metrics**: 価値体験可能性の測定方法
- **value_realization_status**: 価値実現状況（realized/partial/failed）

#### 戦略的評価情報  

- **business_value**, **user_value**: 価値スコア
- **user_persona**: 対象ユーザー
- **competition_analysis**: 競合差別化要因
- **development_notes**: 開発時の仮説検証メモ

#### 従来情報

- 受け入れ条件（@docs/cc-xp/stories/[ID].md）
- フィードバック履歴（@docs/cc-xp/stories/[ID]-feedback.md）

**重要なバリデーション**：
- `testing` ステータスのストーリーがない場合は、「先に `/cc-xp:develop` を実行してください」と案内
- すでに `done` のストーリーは対象外（再レビュー不可）

**仮説検証レビューサイクルの確認**：
- フィードバックファイルから何回目のレビューかをカウント
- 前回の KPI 測定結果と改善状況を確認
- 仮説検証の進捗状況を評価

**重要**: 戦略的情報が存在しない場合は旧形式として扱い、基本レビューのみ実行してください。

### 既存プロセスの確認

- サーバー稼働確認: !test -f .server.pid
- 現在のブランチ: !git branch --show-current

## Phase 1: デモ起動（--skip-demoがない場合）

### プロジェクトタイプの判定と起動

プロジェクトの構成ファイルを確認し、適切な方法でアプリケーションを起動してください：

**検出方法：**
- package.json → Node.js/JavaScript
- requirements.txt/pyproject.toml → Python
- Cargo.toml → Rust
- go.mod → Go
- Gemfile → Ruby
- 単独の HTML ファイル → 静的サイト

**起動コマンドの例：**
- Web アプリ: 開発サーバーを起動（npm run dev, python manage.py runserver 等）
- CLI ツール: ヘルプとデモコマンドを表示
- API: エンドポイント一覧とテスト方法を表示
- 静的 HTML: http-server や Python の SimpleHTTPServer で起動

起動後は以下を実行してください：
1. プロセス ID を `.server.pid` に保存
2. アクセス URL を表示
3. ログファイルの確認方法を案内

## Phase 2: E2E自動テスト実行（--skip-e2eがない場合）

### E2E戦略の確認

ストーリーファイル（@docs/cc-xp/stories/[ID].md）の`e2e_strategy`を確認：

**e2e-required または e2e-optional の場合のみ実行**

#### MCP Playwright利用時の自動E2E実行

```javascript
// 受け入れ条件を自動的にE2Eテストに変換
const story = readStoryFile(storyId);
for (const scenario of story.acceptanceCriteria) {
  await mcp__playwright__browser_navigate(serverUrl);
  await executeScenario(scenario);
  await mcp__playwright__browser_snapshot();
}
```

実行結果を表示：
```
🌐 E2Eテスト実行結果
==================
✅ シナリオ1: ログインフォーム表示
✅ シナリオ2: 正常ログイン処理  
✅ シナリオ3: エラーハンドリング

スクリーンショット: 3枚保存
実行時間: 12.3秒
```

#### 通常Playwright利用時

```bash
npx playwright test --headed --reporter=html
```

#### E2E非対応環境またはunit-onlyの場合

この段階をスキップし、Phase 3 へ進む。

**重要**: E2E テストの実行結果（成功/失敗/スキップ）に関わらず、必ず Phase 3（動作確認ガイド表示）に進みます。テスト結果による自動判定は行いません。

## Phase 3: 価値×技術の二軸評価

**価値実現度**と**技術品質**の二軸で総合的に評価してください：

### 🎯 第1軸：価値実現度評価 (70%重み)

**Core Value実現確認**:
- 本質価値が実際に体験できるか？
- 最小価値体験が提供されているか？
- ユーザーが「楽しい」「便利」と感じるか？

**価値実現度スコア** (1-10):
- 9-10: ★★★ 期待を超える価値体験
- 7-8: ★★ 期待通りの価値体験
- 5-6: ★ 最小限の価値体験
- 1-4: ❌ 価値体験不十分

### 🔧 第2軸：技術品質評価 (30%重み)

**技術的安定性確認**:
- エラーなく動作するか？
- パフォーマンスは適切か？
- コード品質は許容レベルか？

**技術品質スコア** (1-10):
- 9-10: ★★★ 高品質・保守可能
- 7-8: ★★ 実用レベルの品質
- 5-6: ★ 最低限の品質
- 1-4: ❌ 品質不十分

### 📈 総合評価マトリクス

**承認基準** (価値実現度 × 0.7 + 技術品質 × 0.3):

| 価値実現度 \\ 技術品質 | 9-10★★★ | 7-8★★ | 5-6★ | 1-4❌ |
|---|---|---|---|---|
| **9-10★★★** | 🎆**Accept** | 🎆**Accept** | ✅Accept | ⚠️Reject |
| **7-8★★** | 🎆**Accept** | ✅Accept | ✅Accept | ⚠️Reject |
| **5-6★** | ✅Accept | ✅Accept | 🔄Review | ⚠️Reject |
| **1-4❌** | ⚠️Reject | ⚠️Reject | ⚠️Reject | ❌**Reject** |

**判定ルール**:
- **価値実現度 < 5**: 自動 Reject (価値が体験できない)
- **技術品質 < 5**: 自動 Reject (動作しない)
- **価値実現度 ≥ 7**: 優先 Accept (ユーザーに価値提供)
- **総合スコア ≥ 6.0**: Accept

### 📈 技術中心から価値中心への転換

**従来の確認** (技術中心)：
- テトリス盤面が 10x20 で表示されるか？　→ 技術的完全性
- テトリミノが正常に落下するか？　→ 機能的正確性
- ライン消去が動作するか？　→ アルゴリズムの正確性

**価値中心の確認** (本修正後)：
- プレイヤーが実際にゲームを楽しめるか？　→ 本質価値
- 操作が直感的でストレスなくできるか？　→ 体験品質  
- もう一度プレイしたくなるか？　→ 継続意欲

## Phase 4: 動作確認と判定

**重要**: まず引数をチェックし、引数がない場合は判定ガイダンス表示のみで終了する。

### 引数チェック

$ARGUMENTS の最初の単語を確認：
- 引数なし: ガイダンス表示のみで終了（Phase 5 は実行しない）
- `accept`: Phase 5 の Accept 処理を実行
- `reject`: Phase 5 の Reject 処理を実行（理由は引数の残り部分）
- `skip`: Phase 5 の Skip 処理を実行

### 引数なしの場合（デフォルト） - 仮説検証ガイダンス表示

ストーリーの仮説検証状況と KPI 実績を表示し、以下のガイダンスを提供：

```
🎯 仮説検証レビューガイド
========================
ストーリー: [タイトル]
ブランチ: story-[ID]  
ステータス: testing
レビュー回数: [X]回目

💼 ビジネス価値実現状況:
- 事業価値スコア: [business_value]/10
- ユーザー価値スコア: [user_value]/10
- 優先度スコア: [priority_score]

🎲 核心仮説検証:
仮説: "[hypothesis]"
成功指標: "[kpi_target]"
実装状況: [hypothesis_status]

📊 KPI達成状況:
[kpi_measurementsの結果をわかりやすく表示]
□ [metric1]: [target] → [actual] ([達成率%])
□ [metric2]: [target] → [actual] ([達成率%])

👤 ユーザー体験確認:
対象: "[user_persona]"
競合優位性: "[competition_analysis]"

🎮 実体験確認手順:
1. [ペルソナ視点での操作確認]
2. [KPI実測とdevelop結果の検証]
3. [競合サービスとの比較評価]

デモURL: [起動したURL]

E2Eテスト結果:
🌐 E2Eテスト: [✅成功/❌失敗/➖スキップ]

全体進捗:
- 完了ストーリー: [X]/[総数] 
- 現在のイテレーション時間: [経過時間]
- 仮説検証成功率: [X%]
```

フィードバックファイルが存在する場合は追加表示：
```
🔄 修正サイクル情報（[何回目]）
==============================
前回の問題: [前回の却下理由の要約]
詳細: docs/cc-xp/stories/[ID]-feedback.md

🔍 修正確認の重点ポイント:
• [前回のKPI未達成項目の改善状況]
• [仮説検証の精度向上]
• [ユーザー価値実現の改善度]
• [新たな問題が発生していないか]
```

動作確認後、最後に必ず以下を表示：

```
🎯 仮説検証重視の判定方法
========================
仮説が検証され、KPI目標を達成している場合:
→ /cc-xp:review accept

KPI未達成または仮説検証不十分な場合:
→ /cc-xp:review reject "具体的なKPI課題"

判定を保留する場合:
→ /cc-xp:review skip

💡 判定の重点ポイント（優先順位順）
-----------------------------
1. 核心仮説の検証完了とKPI達成
2. 対象ペルソナにとっての価値実現
3. 競合優位性の確保
4. 受け入れ条件の技術的満足
```

**重要**: 引数なしの場合、ここで処理が終了します。E2E テストの結果に関わらず、自動判定は行いません。

### 引数で判定が指定された場合

$ARGUMENTS の最初の単語を確認：
- `accept`: Phase 5 の Accept 処理を実行
- `reject`: Phase 5 の Reject 処理を実行（理由は引数の残り部分）
- `skip`: Phase 5 の Skip 処理を実行

## Phase 5: 判定に基づく処理

**重要**: この Phase は、ユーザーが明示的に引数（accept/reject/skip）を指定した場合のみ実行されます。

判定に応じて以下の処理を実行し、**必ず最後に次のコマンドを明確に表示**してください。

### Accept を選択した場合

**重要**: この処理でのみステータスを `done` に変更し、**仮説検証結果を永続記録**します。

1. **仮説検証成功の記録**

   @docs/cc-xp/backlog.yaml の該当ストーリーに以下を追加記録：
   ```yaml
   # 完了処理
   status: testing → done
   completed_at: [現在時刻]
   
   # 仮説検証結果（新規追加）
   hypothesis_validation:
     status: "validated" # validated/partial/failed
     kpi_final_results:
       - metric: "game_startup_time"
         target: "< 3000ms"
         achieved: [2850, 2920, 2780] 
         success_rate: 100%
     business_value_realized: [8/10の実現度評価]
     user_value_realized: [8/10の実現度評価] 
     competitive_advantage: "confirmed" # confirmed/partial/failed
     review_notes: |
       仮説「3秒以内でゲーム開始可能」を完全検証。
       平均起動時間2.85秒で目標を上回る成果。
       忙しいビジネスパーソンのニーズを満たす体験を実現。
   ```

2. **拡張メトリクス記録**

   @docs/cc-xp/metrics.json に仮説検証成功データを追加：
   ```json
   {
     "completedStories": += 1,
     "hypothesisDriven": {
       "validatedHypotheses": += 1,
       "kpiSuccessRate": "[計算値]%",
       "businessValueRealized": += [business_value_score],
       "competitiveAdvantages": ["quick_start", "persona_focused"]
     },
     "lastSuccessfulValidation": "[現在時刻]"
   }
   ```

3. **Gitマージ処理**
   ```bash
   # テスト実行（プロジェクトに応じたコマンド）
   
   # Safe Git Operations
   echo "=== Git マージ・タグ処理 ==="
   STORY_BRANCH="story-[ID]"
   STORY_ID="[ID]"
   STORY_TITLE="[タイトル]"
   
   # mainブランチへ切り替え
   echo "🔄 mainブランチに切り替え..."
   if ! git checkout main; then
       echo "❌ エラー: mainブランチへの切り替えに失敗しました"
       echo "確認事項:"
       echo "- mainブランチが存在するか"
       echo "- 未コミットの変更がないか"
       exit 1
   fi
   
   # ブランチをマージ
   echo "🔀 ブランチをマージ..."
   if ! git merge --no-ff "$STORY_BRANCH" -m "merge: ストーリー $STORY_ID - $STORY_TITLE"; then
       echo "❌ エラー: マージに失敗しました"
       echo "確認事項:"
       echo "- マージコンフリクトが発生していないか"
       echo "- ブランチ '$STORY_BRANCH' が存在するか"
       exit 1
   fi
   
   # タグ付け
   echo "🏷️  タグを作成..."
   if ! git tag -a "$STORY_ID-done" -m "完了: $STORY_TITLE"; then
       echo "❌ エラー: タグ作成に失敗しました"
       echo "確認事項:"
       echo "- 同名のタグが既に存在しないか"
       exit 1
   fi
   
   echo "✅ Git操作完了"
   ```

4. **サーバー停止**（.server.pid がある場合）
   ```bash
   kill $(cat .server.pid)
   rm .server.pid
   ```

5. **完了メッセージ**
   ```
   ✨ ストーリー完了！
   ==================
   
   マージ済み: story-[ID] → main
   タグ: story-[ID]-done
   ```

6. **次のコマンド案内**（重要：必ず最後に明確に表示）
   ```
   🚀 次のステップ
   ================
   
   【選択肢1】振り返りを実施:
   → /cc-xp:retro
   （完了ストーリーが複数ある場合は特に推奨）
   
   【選択肢2】次のストーリーを開始:
   → /cc-xp:story
   （まだ selected ストーリーがある場合）
   
   【選択肢3】新しいイテレーション計画:
   → /cc-xp:plan "新しい要望"
   （すべてのストーリーが完了した場合）
   
   💡 推奨
   -------
   • 2-3個のストーリー完了ごとに振り返り
   • 時間が経過したら振り返り（2時間など）
   • 大きな学びがあったら即振り返り
   ```

### Reject を選択した場合

1. **却下理由の取得**
   引数から理由を取得（例：`reject "ボタンが小さすぎて押しにくい"`）
   理由が指定されていない場合は「詳細な理由は未記載」とする

2. **フィードバックの記録**
   - `docs/cc-xp/stories/[ID]-feedback.md` に以下の内容で記録：
   ```markdown
   # フィードバック: [ストーリータイトル]
   
   日時: [現在時刻]
   ステータス: Rejected
   修正サイクル: [何回目かを記録]
   
   ## 却下理由
   [却下理由]
   
   ## 必要な修正
   - [ ] [具体的な修正項目1]
   - [ ] [具体的な修正項目2]
   
   ## 次のアクション
   1. このフィードバックを確認
   2. テストを修正/追加
   3. 実装を改善
   4. `/cc-xp:develop` を実行して修正を実装
   ```
   - @docs/cc-xp/backlog.yaml の status を `testing` → `in-progress` に戻す（**重要**: done にはしない）

3. **修正ガイドの表示**
   ```
   📝 次のアクション
   ==================
   1. フィードバックを確認: docs/cc-xp/stories/[ID]-feedback.md
   2. テストを修正/追加
   3. 実装を改善
   
   サーバーは稼働中です: [URL]
   停止する場合: kill $(cat .server.pid)
   ```

4. **次のコマンド案内**（重要：必ず最後に明確に表示）
   ```
   🚀 次のステップ
   ================
   修正を実装する:
   → /cc-xp:develop
   
   このストーリーを諦めて別のストーリーへ:
   → /cc-xp:story [別のID]
   
   💡 修正のヒント
   ---------------
   • フィードバックをよく読んで原因を理解
   • テストから修正を始める（TDD）
   • 小さな変更を積み重ねる
   ```

### Skip を選択した場合

1. **保留メッセージの表示**
   ```
   ℹ️ 判定を保留しました
   
   サーバー稼働中: [URL]
   停止方法: kill $(cat .server.pid)
   ```

2. **次のコマンド案内**（重要：最後に明確に表示）
   ```
   🚀 次のステップ
   ================
   判定を再開:
   → /cc-xp:review accept
   → /cc-xp:review reject "理由"
   
   他の作業へ:
   → /cc-xp:story [別のID]
   → /cc-xp:retro
   ```

## --skip-demo / --skip-e2e オプション時の処理

### --skip-demo オプション

引数に `--skip-demo` がある場合：
1. Phase 1（デモ起動）をスキップ
2. 既存のサーバープロセスを使用
3. Phase 2 から開始

### --skip-e2e オプション

引数に `--skip-e2e` がある場合：
1. Phase 2（E2E 自動テスト）をスキップ
2. Phase 3 の動作確認ガイドから開始
3. 手動確認に特化

## エラーハンドリング

以下の場合は適切なメッセージを表示してください：

### ポート衝突時の対処

ポートが既に使用されている場合の自動対処：

```bash
# ポート使用状況の確認
lsof -i :3000 || netstat -an | grep :3000

# 代替ポートの探索（3001, 3002...）
for port in 3001 3002 3003 8080 8081; do
  if ! lsof -i :$port > /dev/null 2>&1; then
    echo "代替ポート $port を使用します"
    break
  fi
done
```

**エラー時の自動提案**：
```
⚠️ ポート3000が使用中です

以下のオプションがあります：
1. 既存サーバーを使用: /cc-xp:review --skip-demo
2. 代替ポート3001で起動（自動実行中...）
3. 既存プロセスを停止: kill $(lsof -t -i:3000)
```

### E2Eテスト関連エラー

**MCP Playwrightエラー**：
```
❌ MCP Playwrightエラーが発生しました

エラー: [具体的なエラーメッセージ]

対処法：
1. E2Eテストをスキップ: /cc-xp:review --skip-e2e
2. 通常Playwrightに切り替え: npx playwright install
3. 手動テストで確認
```

**通常Playwrightエラー**：
```
❌ Playwrightテストが失敗しました

以下のオプションがあります：
1. テスト修正後に再実行
2. E2Eをスキップ: /cc-xp:review --skip-e2e  
3. 手動確認に切り替え
```

### その他のエラー

- testing ステータスのストーリーがない
- サーバー起動に失敗
- テスト実行に失敗
- Git マージで競合発生

## メトリクスの更新

判定結果に関わらず、以下を@docs/cc-xp/metrics.json に記録：
- レビュー実施時刻
- 判定結果（accept/reject/exit）
- レビュー所要時間（可能なら）

## サマリー表示

処理完了後、結果に応じたサマリーと**次のコマンドを必ず最後に表示**してください。

特に重要：
- 次のコマンドは「🚀 次のステップ」として独立したセクションで表示
- 矢印（→）を使って実行可能なコマンドを明示
- 複数の選択肢がある場合はすべて列挙
