---
description: XP story – ユーザーストーリーを詳細化（対話重視）
argument-hint: '[id] ※省略時は最初の selected を使用'
allowed-tools: Bash(date), Bash(echo), Bash(git:*), Bash(test), Bash(grep), ReadFile, WriteFile
---

# XP Story - ユーザーストーリー詳細化

## ゴール

ストーリーを**ユーザーとの対話**として詳細化し、明確な受け入れ条件を定義する。

## XP原則

- **コミュニケーション**: ストーリーはユーザーとの約束
- **フィードバック**: 受け入れ条件で期待を明確化
- **勇気**: 不明点があれば仮定を置いて進む
- **継続的インテグレーション**: 各ステップをコミット

## 現在の状態確認

### Git リポジトリ確認（必須）

**🚨 最初に必ず実行してください 🚨**

Gitリポジトリが初期化されているか確認してください。初期化されていない場合は以下を自動実行してください：

1. `git init` でリポジトリを初期化
2. `git branch -m main` でデフォルトブランチをmainに変更
3. `git add .` で全ファイルをステージング
4. `git commit -m "Initial commit"` で初期コミットを作成

### 環境チェック

- backlog 存在確認: !test -f docs/cc-xp/backlog.yaml
- Git 状態: !git status --short
- 現在のブランチ: !git branch --show-current
- 現在時刻: !date +"%Y-%m-%dT%H:%M:%S%:z"

### 対象ストーリーの特定

$ARGUMENTS が指定されている場合はその ID、なければ最初の `selected` ステータスのストーリーを使用してください。

@docs/cc-xp/backlog.yaml から該当ストーリーの**全情報**を取得：

#### 基本情報

- ID, タイトル, サイズ, 価値, 現在のステータス

#### 戦略的情報（plan.mdで生成）

- **business_value**: 事業価値スコア（1-10）
- **user_value**: ユーザー価値スコア（1-10）
- **implementation_cost**: 実装コスト（1-10）
- **risk_level**: リスクレベル（1-10）
- **priority_score**: 優先順位スコア（計算値）

#### 仮説駆動項目（必須）

- **hypothesis**: 検証すべき仮説
- **kpi_target**: 具体的成功指標
- **success_metrics**: 測定方法

#### 戦略コンテキスト

- **user_persona**: 対象ユーザー
- **business_context**: 事業上の位置づけ
- **competition_analysis**: 競合との差別化要因

**ステータスバリデーション**：
- 対象ストーリーが `selected` であることを確認
- すでに `in-progress` 以降のステータスの場合は、そのまま継続するか確認
- `done` ステータスのストーリーは詳細化不可

**重要**: 上記の戦略的情報が存在しない場合は、旧形式の backlog.yaml として扱い、基本機能のみで進行してください。

backlog が存在しない場合は、先に `/cc-xp:plan` の実行を案内してください。

### AI分析レポートの参照

**重要**: ストーリー詳細化前に、plan.md で生成された AI 分析結果を必ず参照してください。

@docs/cc-xp/analysis_summary.md が存在する場合：
- 市場・競合分析結果を確認
- ペルソナ定義を参照  
- 収益化戦略を把握
- 差別化要因を理解

存在しない場合は、限定的なストーリー詳細化のみ実行してください。

**活用方法**:
AI分析レポート（docs/cc-xp/analysis_summary.md）が存在するか確認してください。存在する場合はビジネス戦略を考慮したストーリー詳細化を、存在しない場合は基本的なストーリー詳細化のみを実行してください。

## フィーチャーブランチの作成

### ブランチの確認

- 既存ブランチ一覧: !git branch -a

**ブランチ作成手順**：

1. `story-[ID]`形式のブランチが既に存在するか確認してください
2. **既存の場合**: ユーザーにチェックアウトするか確認してください
3. **新規作成の場合**: `story-[ID]`ブランチを作成し、チェックアウトしてください

ブランチ作成に失敗した場合は、同名ブランチの存在や未コミット変更の有無を確認してください。

## テストファースト準備（TDD）

### テストファイル自動生成

ストーリー詳細化と同時に、TDD実践のためのテストファイルを自動生成します。

#### 生成されるテストファイル構造

```
test/
├── [story-id].spec.js        # ユニットテスト（振る舞い検証）
├── [story-id].e2e.js         # E2Eテスト（価値体験検証）  
└── [story-id].regression.js  # 回帰テスト（review reject時に追加）
```

#### ユニットテストテンプレート生成

**test/[story-id].spec.js**:
```javascript
/**
 * [Story Title] - Unit Tests
 * TDD: Red → Green → Refactor
 * 
 * Story: [story-id]
 * Core Value: [core_value]
 * Minimum Experience: [minimum_experience]
 */

describe('[ComponentName]', () => {
  describe('[MethodName]', () => {
    it('should_[expected_behavior]_when_[condition]', () => {
      // Arrange - 準備
      // TODO: テスト対象のセットアップ
      
      // Act - 実行
      // TODO: テスト対象メソッドの実行
      
      // Assert - 検証
      // TODO: 期待する結果の検証
      expect(true).toBe(false); // 🔴 Red: 最初は失敗するテスト
    });
  });

  // TODO: 追加のテストケース
  // it('should_handle_edge_case_when_invalid_input', () => { ... });
  // it('should_maintain_state_when_multiple_operations', () => { ... });
});
```

#### E2Eテストテンプレート生成

**test/[story-id].e2e.js**:
```javascript
/**
 * [Story Title] - End-to-End Tests
 * 価値体験の実際の検証
 * 
 * Story: [story-id]  
 * Value Story: [value_story]
 */

describe('[Story Title] - E2E', () => {
  it('should_provide_core_value_experience', async () => {
    // Given - 価値体験が可能な状態
    // TODO: アプリケーション起動・初期状態設定
    
    // When - ユーザーが実際に行う価値体験操作
    // TODO: 実際のユーザー操作をシミュレート
    
    // Then - 価値が実現されていることの確認
    // TODO: core_value が体験できることを確認
    // TODO: minimum_experience が実現されることを確認
    
    expect(true).toBe(false); // 🔴 Red: 最初は失敗するテスト
  });

  it('should_meet_acceptance_criteria', async () => {
    // TODO: 受け入れ条件の自動検証
    // シナリオ1: [acceptance_criteria_1]
    // シナリオ2: [acceptance_criteria_2]  
    // シナリオ3: [acceptance_criteria_3]
    
    expect(true).toBe(false); // 🔴 Red: 最初は失敗するテスト
  });
});
```

#### 回帰テストテンプレート生成

**test/[story-id].regression.js** (初期は空、reject時に自動追加):
```javascript
/**
 * [Story Title] - Regression Tests
 * review reject時に自動追加される回帰テスト
 * 
 * Story: [story-id]
 */

describe('[Story Title] - Regression', () => {
  // review reject時に自動的にテストケースが追加されます
  // reject理由に基づいた具体的な回帰テストが生成されます
});
```

#### テストファイル生成の実行

以下の手順でテストファイルを生成：

1. **テストディレクトリの確認・作成**
2. **ストーリー情報の取得**（backlog.yamlから）
3. **テンプレートへの情報挿入**
4. **ファイル生成・保存**
5. **初回テスト実行**（全て失敗することを確認）

#### Red状態の確認

生成後、即座にテスト実行して Red 状態を確認：
```bash
npm test test/[story-id]*.js
```

**期待する結果**: 全テストが失敗（🔴 Red状態）
- 失敗しない場合：既に実装が存在する可能性
- テスト実行エラー：環境設定の問題

---

## 戦略的ストーリー詳細化

### 1. 価値実現ストーリーの作成

選択されたストーリー「[タイトル]」を**価値体験を中心**に詳細化してください：

#### 🎯 本質価値の確認と詳細化

**最重要**: backlog.yaml の項目が価値実現レベルに達していない場合、以下に従って**価値中心に詳細化**してください：

##### core_value の明確化

このストーリーが実現すべき本質価値を明確に：
```
「[ユーザー]が[具体的な体験]を通じて[本質的な価値]を得る」
```

**価値明確化例**:
- 技術的 ❌: "テトロミノを正確に生成する"
- 価値中心 ✅: "プレイヤーが落下ブロックを操作してライン消去の達成感を味わう"

##### minimum_experience の定義

最低限必要な価値体験を明確に：
```
「[ユーザー]が最低限[この体験]ができれば[本質価値]が実現される」
```

**最小体験例**:
- 技術的 ❌: "7 種類のテトロミノが正確に生成される"
- 価値中心 ✅: "ブロックが落下し、キーで移動・回転でき、ラインが消える"

##### 価値測定方法の明確化

価値が実際に体験できることの確認項目：
```
「1.[価値体験確認]、2.[操作可能性確認]、3.[視覚的確認]、4.[満足度確認]」
```

**価値測定例**:
- 技術的 ❌: "データ構造検証、アルゴリズムテスト、パフォーマンス測定"
- 価値中心 ✅: "1.実際にゲームをプレイできる、2.キー入力で操作できる、3.ライン消去が見える、4.楽しいと感じる"

#### 👤 戦略的ペルソナの活用

以下を統合してペルソナを定義：
- backlog.yaml の`user_persona`
- analysis_summary.md のペルソナ分析
- 競合分析結果(`competition_analysis`)

#### 📝 Value Story形式

```
As a [価値体験者]
I want [価値体験]
So that [本質価値の実現]
And I expect [体験できること・感じること]
```

**技術中心例**（避けるべき）：
- As a **プレイヤー**
- I want **テトロミノが正確に生成される**
- So that **データ構造が正しい**

**価値中心例**（推奨）：
- As a **ゲームプレイヤー**
- I want **落下ブロックを操作してライン消去を楽しむ体験**
- So that **巧妙な配置による達成感と継続的なフロー体験を得られる**
- And I expect **実際にプレイして楽しいと感じ、もう一度やりたくなる**

### 2. 価値実現の受け入れ条件定義

**価値が実際に体験できる**条件を**3つ以内**で作成してください。各条件は必ず価値体験を確認可能な形式にします：

#### 🎯 価値体験可能な受け入れ条件の必須要件

**全受け入れ条件は価値体験を確認できる必要があります**：
1. **Given条件**: 価値体験が可能な状態の設定
   - **技術的前提**: 必要なファイル・環境が存在する具体的な条件
   - **状態設定**: ユーザーが価値体験を開始できる準備状態
2. **When操作**: ユーザーが実際に行う価値体験操作
3. **Then期待結果**: 価値が実現されていることの確認
4. **And追加条件**: 体験満足度・継続意欲の確認

**⛔ Given条件での技術的前提の必須明示**：
- **Web アプリ**: 「index.html が存在し、ブラウザで開ける状態で」
- **ゲーム**: 「ゲーム画面が表示され、操作可能な状態で」  
- **CLI**: 「コマンドが実行可能な状態で」
- **API**: 「サーバーが起動し、エンドポイントにアクセス可能な状態で」

#### 価値実現受け入れ条件フォーマット

**必須フォーマット**：
```gherkin
シナリオ[N]: [価値体験内容]（[価値層]）
Given [価値体験が可能な状態]
When [ユーザーが実際に行う価値体験操作]
Then [価値が体験できる] AND [本質価値が実現される]
And [満足度が確認される] AND [継続意欲が生まれる]
```

#### 🎯 価値実現の3層構造

**第1層：Core Value（本質価値）検証**（最優先 ★★★）
- `core_value`が実現されていることの確認
- `minimum_experience`が実際に体験可能であることの確認
- ユーザーが本質価値を実感できることの検証

**第2層：Experience Enhancement（体験向上）検証**（重要 ★★）  
- 価値体験がより豊かになる要素の確認
- ユーザビリティ・操作性の向上確認
- 継続利用したくなる要素の検証

**第3層：Context Optimization（文脈最適化）検証**（補助 ★）
- 利用環境・状況への適応確認
- 異なるユーザー層への対応確認
- 技術的安定性・パフォーマンスの検証

#### 💡 技術中心から価値中心への改善例

**技術中心の受け入れ条件**（価値が実現されない）：
```gherkin
シナリオ1: テトロミノ生成処理
Given 7種類のテトロミノデータが定義される
When 生成処理が実行される
Then 4x4マトリクス形状が正確に生成される
```

**価値中心の受け入れ条件**（価値が実現される）：
```gherkin  
シナリオ1: ゲームとしてのテトリス体験（Core Value検証）
Given index.html が存在し、ブラウザでテトリスゲームが表示される状態で
When プレイヤーがゲームを開始する時
Then ブロックが上から落下してくる AND キー操作で移動・回転できる
And ラインが完成すると消える AND スコアが加算される
And プレイして「楽しい」と感じる

シナリオ2: スムーズな操作体験（Experience Enhancement検証）
Given ゲームが正常に起動し、プレイ可能な状態で
When プレイヤーがキーを押す時  
Then 即座にブロックが反応する AND 視覚的フィードバックが明確
And 操作がスムーズでストレスを感じない AND もっとプレイしたくなる

シナリオ3: 様々な環境での安定動作（Context Optimization検証）
Given 異なるブラウザやデバイスで
When ゲームを開いた時
Then どの環境でも同じようにプレイできる AND パフォーマンスが安定する  
And ユーザー体験が一貫している AND 技術的問題が発生しない
```

#### 📊 KPI測定可能性チェック

各受け入れ条件について、以下を確認してください：
- [ ] 定量的な測定が可能
- [ ] backlog.yaml の`kpi_target`に対応
- [ ] `success_metrics`で測定手法が明確
- [ ] 仮説検証に直結している

### 3. テスト戦略の判定

各受け入れ条件について、以下を判断してください：

#### 基本テスト戦略

- **automated**: プログラムで検証可能（ユニットテストのみ）
- **manual**: 人の目で確認が必要
- **hybrid**: 両方必要

#### E2Eテスト戦略（Webアプリケーション限定）

- **e2e-required**: E2E テスト必須（UI 操作の核心機能）
- **e2e-optional**: E2E テスト推奨（品質向上のため）
- **unit-only**: ユニットテストのみで十分（ロジック中心）

#### 判定基準

**E2Eテストが必須（e2e-required）**：
- ユーザーの主要なワークフロー（ログイン、購入、投稿など）
- フォーム送信とバリデーション
- ナビゲーションとページ遷移
- 外部 API との統合部分

**E2Eテストが推奨（e2e-optional）**：
- 補助的な UI 機能
- アニメーションや視覚効果
- レスポンシブデザインの確認

**ユニットテストのみ（unit-only）**：
- 純粋な計算ロジック
- データ変換処理
- バリデーション関数

### 4. 実装ヒントの追加

技術的な観点から実装のヒントを簡潔に追加：
- 推奨ライブラリ/フレームワーク
- 注意すべきポイント
- 参考リンク（あれば）

## 拡張ストーリーファイルの作成

`docs/cc-xp/stories/[ID].md` を**戦略的情報を統合**した以下の内容で作成してください：

### Evidence-Driven品質チェック（生成後必須実行）

**ストーリーファイル作成後、以下を必ず確認**：
1. ✅ hypothesis に具体的数値・測定条件が含まれている
2. ✅ kpi_target に複数の数値基準が設定されている
3. ✅ success_metrics に 4 つ以上の具体的測定項目がリストされている
4. ✅ 各受け入れ条件が実装・測定可能で具体的である

**品質チェック失敗時は、該当項目を上記詳細化指示に従って修正**

```markdown
---
# 基本情報
created_at: [現在時刻]
estimated_time: [推定分数]
test_strategy: [automated/manual/hybrid]
e2e_strategy: [e2e-required/e2e-optional/unit-only] # Webアプリの場合のみ
difficulty: [easy/medium/hard]

# 仮説駆動項目（詳細化済み）
hypothesis: "上記詳細化指示で具体化された検証可能な仮説"
kpi_target: "複数数値基準を含む測定可能な目標"
success_metrics: "自動テスト可能な具体的測定項目リスト"
business_value: [1-10]
user_value: [1-10]
priority_score: [計算値]

# 戦略コンテキスト
user_persona: "[対象ユーザー]"
business_context: "[事業上の位置づけ]"
competition_analysis: "[競合差別化要因]"
---

# Story: [タイトル]

## 核心仮説
**仮説**: [hypothesis]
**成功指標**: [kpi_target]  
**測定方法**: [success_metrics]

## 戦略的ユーザーストーリー
As a [戦略的ペルソナ]
I want [機能・要望]
So that [得られる価値]
And I expect [具体的KPI/成功指標]

## 仮説検証重視の受け入れ条件

### シナリオ1: [核心仮説検証]
Given [戦略的前提条件]
When [アクション]
Then [KPI測定可能な結果]

### シナリオ2: [ユーザー体験検証]
Given [ユーザーコンテキスト]  
When [ユーザー操作]
Then [競合優位性を示す結果]

## テスト戦略（仮説検証重視）
- **仮説検証テスト**: [KPI測定を含むテスト]
- **自動テスト**: [機能検証]
- **手動確認**: [ユーザー体験検証]
- **E2E戦略**: [e2e-required/e2e-optional/unit-only]

## ビジネス価値実現のヒント
- **競合差別化**: [competition_analysisに基づく実装方針]
- **ユーザー価値最大化**: [user_personaに基づく配慮点]
- **KPI測定**: [success_metricsの実装方法]

## 前提条件
- [環境要件]
- [依存関係]  
- **KPI測定環境**: [測定ツール・システム要件]
```

## backlog.yamlの更新

@docs/cc-xp/backlog.yaml の該当ストーリーを更新：
- status: `"selected"` → `"in-progress"`（**重要**: "done" にはしない）
- updated_at: 現在時刻

**ステータスの流れ**：
- `selected` (plan) → `in-progress` (story) → `testing` (develop) → `done` (review accept のみ)

## 変更のコミット

以下の手順でコミットしてください：

1. **対象ファイル**:
   - `docs/cc-xp/stories/[ID].md`（ストーリー詳細）
   - `docs/cc-xp/backlog.yaml`（ステータス更新）
   - `test/[ID].spec.js`（ユニットテスト）
   - `test/[ID].e2e.js`（E2Eテスト）
   - `test/[ID].regression.js`（回帰テスト）

2. **コミットメッセージ**:
   ```
   [Story] [ID]: 詳細化完了 + TDDテスト準備
   
   - ストーリー詳細化完了
   - 受け入れ条件定義
   - TDDテストファイル生成（Red状態）
   
   次のステップ: /cc-xp:develop で Red→Green→Refactor
   ```

3. **実行手順**:
   - 生成されたファイルの存在を確認
   - git addでステージング
   - 変更があることを確認
   - 適切なコミットメッセージでコミット実行

コミットに失敗した場合は、ファイルの存在、パーミッション、Git設定を確認してください。

## 戦略的完了サマリーの表示

**必ず以下の拡張サマリーを表示してください**：

```
🎯 戦略的ストーリー詳細化完了（TDD準備済み）
===============================================

ストーリー: [タイトル]
ブランチ: story-[ID]
ステータス: in-progress ✅

📊 ビジネス指標:
- 事業価値: [business_value]/10
- ユーザー価値: [user_value]/10
- 優先度スコア: [priority_score]
- サイズ: [ポイント]
- 総合価値: [High/Medium/Low]

🎲 核心仮説:
仮説: "[hypothesis]"
成功指標: "[kpi_target]"
測定方法: "[success_metrics]"

👤 対象ユーザー:
ペルソナ: "[user_persona]"

🎯 仮説検証重視の受け入れ条件:
✓ [シナリオ1: 核心仮説検証要約]
✓ [シナリオ2: ユーザー体験検証要約]  
✓ [シナリオ3: 技術品質検証要約]（あれば）

🔴🟢🔵 TDDテスト準備完了:
✅ ユニットテスト: test/[ID].spec.js
✅ E2Eテスト: test/[ID].e2e.js
✅ 回帰テスト: test/[ID].regression.js
✅ Red状態確認済み（全テスト失敗）

🔬 テスト戦略:
- TDDサイクル: Red → Green → Refactor
- テストファースト: 実装前にテスト作成済み
- 仮説検証: KPI測定を含む自動テスト
- 回帰防止: reject時に自動追加

⏱️ 推定: [X]分
🚀 期待効果: [ビジネス成果予測]
```

### 次のステップ案内

```
🚀 次のステップ

技術調査を実施してください:
→ /cc-xp:research

調査完了後、TDD開発を開始:
→ /cc-xp:develop
```

## 注意事項

- 受け入れ条件は具体的で測定可能に
- YAGNI を意識し、過度な詳細化を避ける
- ユーザー価値を中心に考える
