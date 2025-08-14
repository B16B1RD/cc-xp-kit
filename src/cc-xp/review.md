---
description: XP review – 価値×技術の二軸評価と判定（accept/reject/skipで指定）+ 価値体験確認
argument-hint: '[accept|reject|skip] [理由（rejectの場合）] [--skip-demo] [--skip-e2e]'
allowed-tools: Bash(git:*), Bash(date), Bash(test), Bash(kill:*), Bash(cat), Bash(http-server:*), Bash(lsof:*), Bash(netstat:*), ReadFile, WriteFile(docs/cc-xp/stories/*-feedback.md), WriteFile(docs/cc-xp/backlog.yaml), mcp__playwright__browser_navigate, mcp__playwright__browser_snapshot, mcp__playwright__browser_take_screenshot
---

# XP Review - 価値×技術 二軸評価

## ゴール

実際に価値を体験してユーザー視点で評価し、価値実現度と技術品質の二軸で承認/却下を判定する。**1回のコマンドで完結**。

## ⛔ 絶対的禁止事項 - CRITICAL

### review コマンドの責務境界

**review コマンドは評価・判定のみを行います。修正作業は一切行いません。**

#### 🚫 実装修正の絶対禁止

1. **ソースコードの修正・作成の絶対禁止**
   - src/*.js, src/*.ts, src/*.py 等への一切の変更禁止
   - HTMLファイルの修正・新規作成禁止（index.html, test-*.html等）
   - 実装ファイルへの編集・作成は絶対禁止
   - **⛔ CRITICAL**: 不完全な実装を補うためのファイル作成は絶対禁止

2. **開発作業の完全禁止**
   - Red→Green→Refactor サイクル実行禁止
   - 問題解決の実装禁止
   - バグ修正作業禁止
   - コード改善作業禁止

#### 🚫 テスト実行の制限

1. **修正を伴うテスト作業禁止**
   - npm test での修正確認禁止
   - テストが失敗しても修正作業はしない

2. **ブラウザ操作の制限**
   - 確認・評価目的のみ許可
   - 実装修正は絶対禁止

#### 🚫 ステータス変更の厳格化

1. **不適切なステータス遷移禁止**
   - reject: testing → in-progress のみ許可
   - accept: testing → done のみ許可
   - **testing への再変更は絶対禁止**

### ⚠️ 責務の明確な境界

```
✅ review の責務:
- 評価・判定
- フィードバック記録
- status 変更

❌ develop の責務（review では禁止）:
- 実装修正
- テスト修正
- コード改善
- 問題解決
```

---

## XP原則

- **価値あるソフトウェア**: 実際に価値を体験できるものが最高のフィードバック
- **オンサイトカスタマー**: ユーザーの価値体験視点で即座に判断
- **素早いフィードバック**: 価値確認から判定まで一気通貫
- **継続的な価値提供**: 承認後は即座にユーザーの価値提供

## Git リポジトリ確認（必須）

**🚨 最初に必ず実行してください 🚨**

Gitリポジトリが初期化されているか確認してください。初期化されていない場合は以下を自動実行してください：

1. `git init` でリポジトリを初期化
2. `git branch -m main` でデフォルトブランチをmainに変更
3. `git add .` で全ファイルをステージング
4. `git commit -m "Initial commit"` で初期コミットを作成

Git設定（user.name, user.email）が未設定の場合も適切に設定してください。設定が必要な場合はグローバル設定として自動設定してください。

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

@docs/cc-xp/backlog.yaml から `"testing"` ステータスのストーリーを確認し、**価値実現に必要な全情報**を取得してください。

#### 基本情報

- ストーリーID, タイトル, created_at, updated_at

#### 価値実現項目（評価の核心）

- **core_value**: 実現すべき本質価値
- **minimum_experience**: 最小価値体験
- **value_story**: 価値体験を中心としたストーリー
- **success_metrics**: 価値体験の可能性測定方法
- **value_realization_status**: 価値実現状況（realized/partial/failed）

#### 戦略的な評価情報  

- **business_value**, **user_value**: 価値スコア
- **user_persona**: 対象ユーザー
- **competition_analysis**: 競合との差別化要因
- **development_notes**: 開発時の仮説検証メモ

#### 従来情報

- 受け入れ条件（@docs/cc-xp/stories/[ID].md）
- フィードバック履歴（@docs/cc-xp/stories/[ID]-feedback.md）

**重要なバリデーション**：
- `"testing"` ステータスのストーリーがない場合は、「先に `/cc-xp:develop` を実行してください」と案内
- すでに `"done"` のストーリーは対象外（再レビュー不可）

**仮説検証レビューサイクルの確認**：
- フィードバックファイルから何回目のレビューかをカウント
- 前回の KPI 測定結果と改善状況を確認
- 仮説検証の進捗状況を評価

**重要**: 戦略的情報が存在しない場合は旧形式として扱い、基本レビューのみ実行してください。

### 既存プロセスの確認

- サーバー稼働確認: !test -f .server.pid
- 現在のブランチ: !git branch --show-current

## Phase 0: 自動品質ゲート（読み取り専用）

### テスト結果の確認と評価

**⚠️ 重要: review コマンドはテスト結果の確認のみ実行**
- テストの実行と結果確認は可能
- テストやコードの修正は絶対禁止
- 問題があれば reject して develop コマンドへ案内

#### 0.1 全テスト実行

プロジェクトのテストスイートを実行して品質を確認：

```bash
# プロジェクトタイプに応じたテスト実行
npm test || yarn test || pnpm test ||
python -m pytest || python -m unittest ||
go test ./... ||
cargo test ||
bundle exec rspec
```

**テスト結果の判定**:
- **全テストPASS**: レビュー継続
- **1つでも失敗**: 自動的に reject、develop コマンドでの修正を案内
  （review コマンドでは修正作業は行わない）

#### 0.2 テストカバレッジ確認

```bash
# カバレッジ付きテスト実行
npm test -- --coverage ||
pytest --cov ||
go test -cover ./...
```

**カバレッジ基準**:
- **85%以上**: ✅ 合格
- **85%未満**: ⚠️ 警告（rejectするかユーザー判断）
- **測定不可**: ℹ️ 情報表示のみ

#### 0.3 Linter/Formatter確認

```bash
# コード品質チェック
npm run lint ||
flake8 . ||
golangci-lint run ||
cargo clippy
```

**品質基準**:
- **警告なし**: ✅ 合格
- **警告あり**: ⚠️ 修正推奨
- **エラーあり**: ❌ reject推奨

#### 0.4 TDD完全性チェック

**TDDサイクルの確認**:
1. **テストファイル存在確認**
   - `docs/cc-xp/tests/[story-id].spec.js` 存在
   - `docs/cc-xp/tests/[story-id].e2e.js` 存在

2. **コミット履歴のTDD確認**
   ```bash
   git log --oneline --grep="\[Red\]"
   git log --oneline --grep="\[Green\]" 
   git log --oneline --grep="\[Refactor\]"
   ```

3. **TDDサイクル完全性判定**
   - **Red→Green→Refactor完了**: ✅ 真のTDD実践
   - **不完全なサイクル**: ⚠️ TDD原則違反の可能性
   - **テストファイルなし**: ❌ TDD未実践（即座にreject）

#### 品質ゲート判定

```
🔍 自動品質ゲート結果
=====================
テスト実行: ✅ 全てPASS (XX/XX)
カバレッジ: ✅ 87% (基準85%以上)
コード品質: ✅ 警告なし
TDD完全性: ✅ Red→Green→Refactor確認

総合判定: ✅ PASS - レビュー継続
```

**自動reject条件**:
- テスト失敗が1つでもある
- TDDテストファイルが存在しない  
- Red→Green→Refactorサイクルが不完全
- **🚨 開発メッセージ検出**: 即座に強制Reject
  - Web アプリ: 「開発中」「実装中」「準備完了」等のメッセージ表示
  - ゲーム: 「TDDで開発中」「Coming Soon」等のスタブメッセージ
  - Canvas/DOM: 実際のコンテンツではなく開発状況メッセージ
- **価値体験不可能**: ユーザーが実際に価値体験できない状態
  - Web アプリ: index.html が存在しない、ブラウザで開けない
  - ゲーム: プレイできる状態になっていない
  - CLI: 実行可能な形になっていない
- **実装-体験分離**: バックエンド完成でもフロントエンド未統合

**自動reject時の処理**:
1. ステータスを `testing → in-progress` に戻す
2. フィードバックファイルに問題を記録
3. reject 理由を明確に表示
4. `/cc-xp:develop` での修正実行を案内
5. **重要**: review コマンドでは修正作業を行わない

---

## Phase 1: デモ起動（--skip-demoがない場合）

### プロジェクトタイプの判定と起動

プロジェクトの構成ファイルを確認し、適切な方法でアプリケーションを起動してください。

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

起動後は以下を実行してください。
1. プロセス ID を `.server.pid` に保存
2. アクセス URL を表示
3. ログファイルの確認方法を案内

## Phase 2: E2E自動テスト実行（--skip-e2eがない場合）

### E2E戦略の確認

ストーリーファイル（@docs/cc-xp/stories/[ID].md）の`e2e_strategy`を確認する。

**e2e-required または e2e-optional の場合のみ実行**

#### 🚨 CRITICAL: 価値体験の詳細検証（必須実行）

**Step 1: 基本アクセス確認**
```javascript
await mcp__playwright__browser_navigate(serverUrl);
await mcp__playwright__browser_snapshot();
```

**Step 2: 開発メッセージの検出（強制Reject条件）**
```javascript
// DOM内の開発メッセージ検出
const developmentMessages = await page.evaluate(() => {
  const bodyText = document.body.innerText.toLowerCase();
  const patterns = [
    'tddで開発中', '開発中', '実装中', '準備中', '準備完了',
    'coming soon', 'under development', 'work in progress',
    'todo', 'not implemented', '未実装'
  ];
  
  return patterns.filter(pattern => bodyText.includes(pattern));
});

// Canvas内のテキストメッセージ検出
const canvasMessages = await page.evaluate(() => {
  const canvas = document.querySelector('canvas');
  if (!canvas) return [];
  
  const ctx = canvas.getContext('2d');
  const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
  
  // テキスト描画パターンの検出（開発メッセージの特徴）
  const textRegions = [];
  // 単色のテキスト領域を検出
  // 「開発中」等のメッセージは通常、単色でCanvas中央に配置される
  
  return textRegions;
});
```

**Step 3: minimum_experience実現度の詳細確認**
```javascript
// backlog.yamlのminimum_experienceを確認
const minimumExperience = getMinimumExperience(storyId);

// プロジェクトタイプ別の価値体験検証
if (minimumExperience.includes('テトロミノ') && minimumExperience.includes('落下')) {
  // テトリスゲームの価値体験検証
  await verifyTetrisGameExperience();
} else if (minimumExperience.includes('表示') && minimumExperience.includes('操作')) {
  // 一般的なWebアプリの価値体験検証
  await verifyWebAppExperience();
}
```

**Step 4: 実際のゲーム要素検証（テトリス例）**
```javascript
const verifyTetrisGameExperience = async () => {
  // Canvas内の実際のゲーム要素確認
  const gameElements = await page.evaluate(() => {
    const canvas = document.getElementById('tetris-canvas');
    const ctx = canvas.getContext('2d');
    const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
    
    // 色分析で実際のゲーム要素を検出
    const pixelAnalysis = analyzePixelPatterns(imageData);
    
    return {
      hasGameField: detectGameField(pixelAnalysis),       // ゲームフィールド検出
      hasTetromino: detectTetromino(pixelAnalysis),      // テトロミノ検出
      hasAnimation: detectMovement(pixelAnalysis),       // 動きの検出
      developmentText: detectDevelopmentText(pixelAnalysis) // 開発メッセージ検出
    };
  });
  
  // 時間差での動作確認（落下動作の検証）
  await page.waitForTimeout(3000);
  const gameMovement = await page.evaluate(() => {
    // 3秒後の状態と比較して動的要素を確認
  });
  
  return {
    gameElements,
    hasMovement: gameMovement.detected,
    experienceLevel: calculateExperienceLevel(gameElements, gameMovement)
  };
};
```

#### MCP Playwright利用時の価値体験検証実行

```javascript
// 価値体験中心の検証シナリオ実行
const valueExperienceResults = [];

// シナリオ1: 基本的な価値体験アクセス
await mcp__playwright__browser_navigate(serverUrl);
const basicAccess = await verifyBasicAccess();
valueExperienceResults.push({
  scenario: '基本アクセス',
  result: basicAccess.accessible ? 'PASS' : 'FAIL',
  details: basicAccess
});

// シナリオ2: 開発メッセージの不存在確認（Critical）
const developmentCheck = await checkDevelopmentMessages();
if (developmentCheck.found) {
  // 開発メッセージが検出された場合は即座に強制Reject
  return {
    criticalFailure: true,
    reason: '開発メッセージが検出されました',
    messages: developmentCheck.messages,
    autoReject: true
  };
}

// シナリオ3: minimum_experience実現確認
const experienceVerification = await verifyMinimumExperience();
valueExperienceResults.push({
  scenario: 'minimum_experience実現',
  result: experienceVerification.realized ? 'PASS' : 'FAIL',
  realizationLevel: experienceVerification.level,
  details: experienceVerification.details
});

return valueExperienceResults;
```

実行結果を表示する：
```
🌐 E2Eテスト実行結果（価値体験検証）
================================
✅ シナリオ1: 基本アクセス - アプリケーション正常表示
❌ シナリオ2: 開発メッセージ検出 - 「TDDで開発中」メッセージを検出
⚠️ シナリオ3: minimum_experience - 部分的実現（テトロミノ未検出）

🚨 CRITICAL FAILURE: 開発メッセージが検出されました
検出メッセージ: ["TDDで開発中"]
自動判定: 強制Reject

スクリーンショット: 3枚保存
実行時間: 15.2秒
```

#### E2E非対応環境またはunit-onlyの場合

この段階をスキップし、Phase 3 へ進む。

**⚠️ 重要**: E2E テストで「開発メッセージ検出」や「minimum_experience未実現」が確認された場合、Phase 3 の価値実現度評価で自動的に低スコア（1-2点）となり、強制Reject となります。

## Phase 3: 価値×技術の二軸評価

**価値実現度**と**技術品質**の二軸で総合的に評価してください：

### 🎯 第1軸：価値実現度評価 (70%重み)

**Core Value実現確認**:
- 本質価値が実際に体験できるか？
- 最小価値体験が提供されているか？
- ユーザーが「楽しい」「便利」と感じるか？

**価値実現度スコア** (1-10) - 厳格判定:
- 9-10: ★★★ 期待を超える価値体験 (minimum_experience + 追加価値)
- 7-8: ★★ 期待通りの価値体験 (minimum_experienceを完全実現)
- 5-6: ★ 最小限の価値体験 (minimum_experienceをほぼ実現)
- 3-4: ⚠️ 価値体験不十分 (minimum_experienceの一部のみ実現)
- 1-2: ❌ 価値体験不可能 (開発メッセージやエラー表示のみ)

**⚠️ 重要な評価観点（必ず確認）**:
- **実際の体験可能性**: ユーザーが今すぐその価値を体験できるか
- **minimum_experience実現度**: backlog.yamlで約束した体験が実際に提供されているか
- **実装 vs 体験のギャップ**: 技術的には動作するが体験できない状態でないか
- **開発メッセージの排除**: 「準備完了」「実装中」等のメッセージが表示されていないか

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

**判定ルール（厳格化）**:
- **⛔ 開発メッセージ検出**: **問答無用で強制Reject**
  - 検出パターン: 「TDD開発中」「実装中」「準備完了」「Coming Soon」等
  - Canvas内テキスト、DOM内テキスト問わず即座にReject
  - 技術的実装の完成度に関係なく価値未提供として却下
- **⛔ minimum_experience未実現**: **強制Reject**
  - backlog.yamlで約束した最小価値体験が実際に提供されていない
  - 例：「テトロミノ落下」約束 → スタティックな画面のみ表示
- **⛔ 価値実現度 < 3**: **強制Reject**
  - 価値が全く体験できない状態（エラー・開発メッセージ・機能なし）
- **⛔ 実装-体験分離**: **強制Reject**
  - バックエンド実装は完成しているがフロントエンド未統合
  - テストPASSだが実際のユーザー体験不可能
- **技術品質 < 5**: 自動 Reject (動作しない)
- **価値実現度 ≥ 7**: 優先 Accept (ユーザーに価値提供)
- **総合スコア ≥ 6.0**: Accept

**🚨 CRITICAL: 価値体験の必須確認項目**
以下の条件をすべて満たさない場合は**問答無用で強制Reject**:
1. **ユーザーがbacklog.yamlのminimum_experienceを実際に体験できる**
2. **開発メッセージではなく実際のコンテンツが表示される**  
3. **技術的なテスト成功ではなく、実際の価値提供が確認できる**

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

**重要**: この処理でのみステータスを `"done"` に変更し、**仮説検証結果を永続記録**します。

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

   以下の手順でGitマージを実行してください：

   - mainブランチに切り替え
   - story-[ID]ブランチをno-fastforwardでマージ
   - [ID]-doneタグを作成

   各ステップでエラーが発生した場合は、適切なエラーハンドリングを実行してください。

4. **サーバー停止**（.server.pidファイルがある場合）

   開発サーバーが起動している場合は、pidファイルを使用してプロセスを停止し、pidファイルを削除してください。

5. **完了メッセージ**
   ```
   ✨ ストーリー完了！
   ==================
   
   マージ済み: story-[ID] → main
   タグ: story-[ID]-done
   ```

6. **次のコマンド案内**
   コマンド終了時の次のステップ案内はCLAUDE.mdの定義に従って自動表示されます。

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
   2. `/cc-xp:develop` を実行して修正を実装
   ```
   - @docs/cc-xp/backlog.yaml の status を `"testing"` → `"in-progress"` に戻す（**重要**: "done" にはしない）

3. **修正ガイドの表示**
   ```
   📝 次のアクション
   ==================
   1. フィードバックを確認: docs/cc-xp/stories/[ID]-feedback.md
   2. `/cc-xp:develop` を実行して修正作業開始
   
   🚨 重要: review コマンドでは修正作業を行いません
   修正は必ず develop コマンドで実施してください
   
   サーバーは稼働中です: [URL]
   停止する場合: kill $(cat .server.pid)
   ```

4. **次のコマンド案内**
   コマンド終了時の次のステップ案内はCLAUDE.mdの定義に従って自動表示されます。

### Skip を選択した場合

1. **保留メッセージの表示**
   ```
   ℹ️ 判定を保留しました
   
   サーバー稼働中: [URL]
   停止方法: kill $(cat .server.pid)
   ```

2. **次のコマンド案内**
   コマンド終了時の次のステップ案内はCLAUDE.mdの定義に従って自動表示されます。

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

ポート使用状況を確認し、代替ポート（3001, 3002, 3003, 8080, 8081）を探索して利用可能なポートを使用してください。

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

**reject時の追加記録**：
- 却下理由の分類（UI/性能/セキュリティ/等）
- 前回reject以降の経過日数
- 累積reject回数（品質改善分析用）

```json
{
  "rejectAnalysis": {
    "avgCyclesPerStory": 2.1,
    "topRejectReasons": ["UI usability", "Error handling", "Performance"]
  }
}
```

## サマリー表示

処理完了後、結果に応じたサマリーと**次のコマンドを必ず最後に表示**してください。

特に重要：
- 次のコマンドは「🚀 次のステップ」として独立したセクションで表示
- 矢印（→）を使って実行可能なコマンドを明示
- 複数の選択肢がある場合はすべて列挙
