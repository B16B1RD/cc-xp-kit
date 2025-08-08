---
description: XP develop – TDD+E2Eサイクル（Red→Green→Refactor→E2E）を完走
argument-hint: '[id] ※省略時は in-progress ストーリーを使用'
allowed-tools: Bash(git:*), Bash(date), Bash(test), Bash(bun:*), Bash(npm:*), Bash(pnpm:*), Bash(uv:*), Bash(python:*), Bash(pytest:*), Bash(cargo:*), Bash(go:*), Bash(bundle:*), Bash(dotnet:*), Bash(gradle:*), Bash(npx:*), Bash(ls), WriteFile, ReadFile, mcp__playwright__*
---

## ゴール

**テストファースト**でストーリーを実装し、動作するコードを素早く作る。Webアプリケーションの場合はE2Eテストまで含めた完全な品質保証を実現する。各フェーズをGitで記録。

## XP/TDD+E2E原則

- **Red**: まず失敗するテストを書く
- **Green**: テストを通す最小限のコード
- **Refactor**: 動作を保ちながら改善
- **E2E**: ユーザー視点での統合テスト（Webアプリの場合）
- **小さなステップ**: 一度に一つのことだけ
- **継続的インテグレーション**: 各フェーズをコミット

## 現在の状態確認

### 仮説駆動ストーリー情報の取得

**重要**: 開発開始前に、ストーリーの仮説・KPI・戦略情報を必ず確認してください。

#### 基本情報の取得
- in-progressストーリー: @docs/cc-xp/backlog.yaml から確認
- 詳細ストーリー: @docs/cc-xp/stories/[ID].md
- フィードバック（もしあれば）: @docs/cc-xp/stories/[ID]-feedback.md
- 現在のブランチ: !git branch --show-current
- Git状態: !git status --short
- 現在時刻: !date +"%Y-%m-%dT%H:%M:%S%:z"

$ARGUMENTS が指定されている場合はそのID、なければ `in-progress` ステータスのストーリーを使用してください。

#### 仮説駆動開発情報の確認

**backlog.yaml から取得すべき戦略情報**:
- **hypothesis**: 検証すべき核心仮説
- **kpi_target**: 具体的成功指標
- **success_metrics**: KPI測定方法
- **business_value**, **user_value**: 価値スコア
- **user_persona**: 対象ユーザー
- **competition_analysis**: 競合差別化要因

**ストーリーファイル(@docs/cc-xp/stories/[ID].md)から取得**:
- 仮説検証重視の受け入れ条件
- KPI測定可能なテスト要件
- ビジネス価値実現のヒント

**ステータスバリデーション**：
- 対象ストーリーが `in-progress` であることを確認
- `done` ステータスのストーリーは開発対象外

**修正サイクル vs 初回開発**：
- フィードバックファイル存在 → 修正サイクル（前回問題の解決重視）
- フィードバックファイルなし → 初回開発（仮説検証重視）

**重要**: 上記戦略情報が存在しない場合は旧形式として扱い、基本TDDのみ実行してください。

## 開発環境の検出

プロジェクトの構成ファイルから適切なテストツールを判定してください：

### 検出対象ファイル
- JavaScript/TypeScript: 
  - package.json確認: !test -f package.json
  - Bun確認: !test -f bun.lockb
  - pnpm確認: !test -f pnpm-lock.yaml
- Python: 
  - pyproject.toml確認: !test -f pyproject.toml
  - requirements.txt確認: !test -f requirements.txt
- Rust: !test -f Cargo.toml
- Go: !test -f go.mod
- Ruby: !test -f Gemfile
- Java: !test -f build.gradle
- C#: !ls *.csproj

### 推奨テストコマンド
検出された言語に応じて以下を使用：
- JavaScript/TypeScript: `bun test` または `npm test`
- Python: `uv run pytest` または `python -m pytest`
- Rust: `cargo test`
- Go: `go test ./...`
- Ruby: `bundle exec rspec`
- Java: `./gradlew test`
- C#: `dotnet test`

### E2Eテスト環境の判定

**Webアプリケーションの検出**：
以下の条件でWebアプリと判定し、E2Eテストフェーズを追加：
- package.jsonに`"dev"`スクリプトがある
- index.html、app.js、main.tsなどのWebファイルが存在
- フレームワーク（React、Vue、Angular、Svelte等）の設定ファイル

**E2Eテスト戦略の選択**：
1. **MCP Playwright優先**: 利用可能な場合は自動実行
2. **通常Playwright**: playwright.config.*が存在する場合
3. **手動E2Eテスト**: Playwright未対応環境では手動確認を推奨

## 仮説駆動TDDサイクルの実施

### 開発アプローチの選択

**初回開発（フィードバックファイルなし）**:
1. **仮説検証テストから開始** - KPI測定可能なテスト作成
2. 核心価値を最短で検証する実装
3. ユーザー体験と競合優位性を確保

**修正サイクル（フィードバックファイル存在）**:
1. **前回の問題を再現するテストから開始**
2. 既存の仮説検証テストが壊れていないことを確認
3. 修正は最小限に留める（他の部分を壊さない）

### Phase 1: Red（仮説検証テスト作成）

#### 🎯 仮説検証ファーストアプローチ

**最優先**: ストーリーの`hypothesis`を検証するテストを作成

#### タスク手順
1. **核心仮説検証テスト**: backlog.yamlの`hypothesis`を検証するテストを最初に作成
2. **KPI測定テスト**: `kpi_target`に対応する測定テストを組み込み
3. **受け入れ条件テスト**: @docs/cc-xp/stories/[ID].md の仮説検証重視受け入れ条件をテスト化
4. 適切なテストファイルを作成（tests/, test/, spec/, __tests__/）
5. **必ず失敗することを確認**

#### 仮説検証テストコード例

**従来のテスト**（機能中心）:
```typescript
describe("ゲーム盤面", () => {
  test("10×20のサイズである", () => {
    const board = createBoard(); // 技術的な機能テスト
    expect(board.width).toBe(10);
    expect(board.height).toBe(20);
  });
});
```

**仮説駆動テスト**（ビジネス価値中心）:
```typescript
import { expect, test, describe } from "bun:test";
import { startTimer, measureKPI } from "./kpi-tracker"; // KPI測定ライブラリ

describe("核心仮説: 3秒以内でゲーム開始できる", () => {
  test("忙しいビジネスパーソンが即座にテトリスを開始", async () => {
    // 仮説検証: 初回起動から3秒以内でゲーム開始
    const startTime = startTimer();
    const game = await createQuickStartTetris(); // まだ存在しない
    const loadTime = startTime.elapsed();
    
    // KPI検証: 3秒以内の起動
    expect(loadTime).toBeLessThan(3000);
    
    // ビジネス価値検証: ゲームがすぐにプレイ可能
    expect(game.isPlayable()).toBe(true);
    expect(game.canDropPiece()).toBe(true);
    
    // KPI測定データの記録
    measureKPI('game_startup_time', loadTime);
    measureKPI('user_persona', 'busy_businessperson');
  });
  
  test("セッション時間が5-10分の範囲に収まる設計", () => {
    const game = createQuickStartTetris(); // まだ存在しない
    
    // 仮説検証: 短時間で没入できる体験設計
    expect(game.hasFastPacedGamplay()).toBe(true);
    expect(game.hasNaturalEndpoints()).toBe(true); // 自然な終了ポイント
    
    // 競合差別化: 他のテトリスより手軽
    expect(game.hasOneClickStart()).toBe(true);
  });
});
```

**Python (pytest) - 仮説駆動版**
```python
import time
import pytest
from kpi_tracker import measure_kpi, start_timer

class TestCoreHypothesis:
    """核心仮説: 3秒以内でゲーム開始できる"""
    
    def test_quick_start_for_busy_businessperson(self):
        """忙しいビジネスパーソンが即座にテトリスを開始"""
        # 仮説検証: 初回起動から3秒以内
        start_time = start_timer()
        game = create_quick_start_tetris()  # まだ存在しない
        load_time = start_time.elapsed()
        
        # KPI検証
        assert load_time < 3000  # 3秒以内
        assert game.is_playable()
        
        # KPI測定データ記録
        measure_kpi('game_startup_time', load_time)
        measure_kpi('user_persona', 'busy_businessperson')
```

#### 確認とコミット
テストを実行し、**失敗を確認**してから：
```bash
git add [テストファイル]
git commit -m "test: 🔴 [ストーリータイトル]のテストを追加"
```

### Phase 2: Green（仮説検証実装）

#### 🎯 ビジネス価値重視の最小実装

**タスク**
1. **仮説検証テストを通す実装**を最優先で作成
2. **KPI測定機能**を組み込む（ハードコーディングでもOK）
3. ユーザー体験と競合優位性を確保する実装
4. テストが**成功することを確認**

#### 実装例の比較

**従来の実装**（機能中心）:
```javascript
function createBoard() {
  return { width: 10, height: 20 }; // 技術要件だけ満たす
}
```

**仮説駆動実装**（ビジネス価値中心）:
```javascript
// 仮説検証: 3秒以内でゲーム開始可能な実装
async function createQuickStartTetris() {
  const startTime = performance.now();
  
  // 最小限だが、ビジネス価値を実現する実装
  const game = {
    // 即座にプレイ可能（競合優位性）
    isPlayable: () => true,
    canDropPiece: () => true,
    hasOneClickStart: () => true,
    
    // 短時間没入体験設計
    hasFastPacedGamplay: () => true,
    hasNaturalEndpoints: () => true,
    
    // KPI測定機能（ハードコーディング）
    measureStartupTime: () => performance.now() - startTime
  };
  
  // KPI測定データを記録
  const loadTime = performance.now() - startTime;
  console.log(`Startup time: ${loadTime}ms`); // 後でKPIシステムに送信
  
  return game;
}
```

#### 確認とコミット
テストを実行し、**仮説検証テスト成功を確認**してから：
```bash
git add [実装ファイル]
git commit -m "feat: ✅ [ストーリータイトル]の仮説検証実装 - [hypothesis要約]"
```

### Phase 3: Refactor（価値最適化）

#### 🚀 ユーザー価値とビジネス価値の最適化

**タスク**
1. **KPI測定精度を向上**
2. **ユーザー体験を改善**（user_personaに基づく）
3. **競合差別化要因を強化**（competition_analysisに基づく）
4. 重複除去・名前改善（但しYAGNI遵守）
5. **仮説検証テストが通り続けることを確認**

#### リファクタリング例
```javascript
// KPI測定の改善
const KPI_TRACKER = {
  gameStartupTime: [],
  userPersona: new Set(),
  
  record(metric, value) {
    this[metric].push({ value, timestamp: Date.now() });
    // 後でbacklog.yamlのsuccess_metricsに基づいて分析
  }
};

// ユーザー体験の最適化（user_personaに基づく）
function optimizeForBusyBusinessperson(game) {
  // 25-35歳ビジネスパーソン向けの体験改善
  return {
    ...game,
    hasQuickTutorial: () => true, // 忙しい人向け
    supportsOneHandedPlay: () => true, // 通勤中対応
    hasProgressSaving: () => true // 中断・再開対応
  };
}
```

#### 確認とコミット
テストを実行し、**仮説検証精度向上を確認**してから：
```bash
git add -u
git commit -m "refactor: ♻️ [ストーリータイトル]の価値最適化 - KPI測定精度向上"
```

## 仮説検証メトリクスとステータス更新

### 拡張メトリクス更新

@docs/cc-xp/metrics.json を**仮説検証結果を含めて**更新：

#### 基本TDDサイクル記録
- tddCycles.red += 1
- tddCycles.green += 1  
- tddCycles.refactor += 1
- lastUpdated: 現在時刻

#### 仮説駆動開発メトリクス（新規追加）
```json
{
  "hypothesisDriven": {
    "hypothesesTested": 1,
    "kpiMeasurements": {
      "game_startup_time": [2850, 2920, 2780], // 実測値
      "user_engagement": "pending", // 後でreviewフェーズで測定
      "competitive_advantage": "implemented"
    },
    "businessValueRealized": {
      "user_value_score": 8, // backlog.yamlから
      "business_value_score": 7,
      "priority_score": 2.67
    },
    "personas": ["busy_businessperson"],
    "lastHypothesisTest": "現在時刻"
  }
}
```

### 戦略的ストーリーステータス更新

@docs/cc-xp/backlog.yaml の該当ストーリー：
- status: `in-progress` → `testing` （**重要**: doneにはしない）
- updated_at: 現在時刻

#### 仮説検証進捗の記録（新規追加）
```yaml
  # 既存フィールドに追加
  hypothesis_status: "implemented" # implemented/pending/failed
  kpi_measurements:
    - metric: "game_startup_time"
      target: "< 3000ms"
      actual: [2850, 2920, 2780]
      status: "passing"
  development_notes: |
    仮説「3秒以内でゲーム開始可能」の実装完了。
    KPI測定により平均2.85秒を実現。
    競合優位性（ワンクリック開始）も実装済み。
```

**注意**: ステータスを `done` にするのは `/cc-xp:review accept` のみです。

## Phase 4: E2E（統合テスト）※Webアプリの場合のみ

### E2Eテストの実施

**Webアプリケーション検出時のみ実行**。ストーリーの受け入れ条件をブラウザ操作に変換します。

#### MCP Playwright利用時

受け入れ条件を基に自動的にE2Eテストを実行：

```typescript
// 例：ログインフォーム テスト
await mcp__playwright__browser_navigate("http://localhost:3000")
await mcp__playwright__browser_snapshot() // 初期状態の記録
await mcp__playwright__browser_type("Email input field", "ref123", "test@example.com")
await mcp__playwright__browser_type("Password input field", "ref456", "password123")
await mcp__playwright__browser_click("Login button", "ref789")
await mcp__playwright__browser_wait_for("text", "Welcome")
await mcp__playwright__browser_snapshot() // ログイン後状態の記録
```

#### 通常Playwright利用時

```bash
# E2Eテストファイルの生成（tests/e2e/ または e2e/）
npx playwright test --headed
```

#### E2E非対応環境

手動テスト手順を生成し、コメントとして記録：

```javascript
/*
E2E手動テスト手順:
1. http://localhost:3000 にアクセス
2. ログインフォームにtest@example.com, password123を入力
3. ログインボタンをクリック
4. "Welcome"メッセージが表示されることを確認
*/
```

#### 確認とコミット

E2Eテストが成功したら：

```bash
git add [E2Eテストファイル]
git commit -m "test: 🌐 [ストーリータイトル]のE2Eテストを追加"
```

### 最終コミット
```bash
git add docs/cc-xp/backlog.yaml docs/cc-xp/metrics.json
git commit -m "chore: ストーリー [ID] を testing に更新"
```

## 完了サマリー

TDDサイクル完了後、**必ず以下を表示**してください：

```
📊 TDD+E2Eサイクル完了
====================
ストーリー: [タイトル]
ブランチ: story-[ID]
ステータス: testing ✅

全体進捗:
- 完了ストーリー: [X]/[総数]
- 現在のイテレーション時間: [経過時間]
- 修正サイクル: [X]回目（該当する場合）

実施フェーズ:
✅ Red   - テスト作成（失敗確認）
✅ Green - 最小実装（テスト成功）
✅ Refactor - コード改善（テスト維持）
[Webアプリの場合のみ表示]
✅ E2E   - 統合テスト（ユーザー視点）

使用ツール: 
- ユニット: [検出されたテストツール]
- E2E: [MCP Playwright / Playwright / 手動テスト]
```

### 重要：次のコマンドを必ず表示

修正サイクルの回数に関わらず、以下を**常に最後に表示**：

```
🚀 次のステップ
================
動作確認とレビューを実施:
→ /cc-xp:review

レビューで以下を選択できます:
• accept - 受け入れ条件を満たしている
• reject "理由" - 修正が必要
• skip - 判定を保留
```

特に複数回の修正サイクル時は以下も追加：

```
📊 開発状況
-----------
ストーリー開始から: [経過時間]
修正サイクル: [X]回目
前回の問題: [フィードバックから要約]

💡 ヒント
---------
• 前回のフィードバック: docs/cc-xp/stories/[ID]-feedback.md
• 修正内容をしっかり確認してからレビューへ
• 詰まったら別のストーリーに切り替えも検討
```

## トラブルシューティング

以下の場合の対処を案内してください：

**テストツールが見つからない場合**
- インストール方法を提示
- 代替ツールを提案

**テストが最初から成功する場合**
- Redフェーズのやり直しを指示
- より厳密なテストの作成を提案

**リファクタリング後にテストが失敗**
- 変更を確認
- git diffで差分を表示
- 前のコミットに戻る方法を案内

## テスト高速化のコツ

開発効率を向上させるため、以下の高速化手法を活用してください：

### 推奨オプション

**JavaScript/TypeScript**
- `bun test --watch` - ファイル変更時に自動再実行
- `npm test -- --watch` - watchモードで継続的テスト
- `vitest --run --reporter=verbose` - 詳細出力で問題を素早く特定

**Python**
- `pytest --maxfail=1` - 最初の失敗で停止
- `pytest -k test_name` - 特定テストのみ実行
- `pytest --tb=short` - 簡潔なトレースバック
- `pytest-watch` - ファイル監視モード（要インストール）

**Rust**
- `cargo watch -x test` - ファイル変更時に自動テスト
- `cargo test --nocapture` - 出力を即座に表示

**Go**
- `go test -failfast` - 最初の失敗で停止
- `gow test ./...` - ファイル監視ツール（要インストール）

### 高速化の原則
- **部分実行**: 関連テストのみを実行して時間短縮
- **早期失敗**: 最初のエラーで停止して修正サイクルを高速化
- **自動再実行**: ファイル保存時に自動でテスト実行
- **並列実行**: 可能な限り並列でテスト実行

## 注意事項

- 各フェーズは明確に分離（混ぜない）
- コミットメッセージの絵文字を統一（🔴✅♻️）
- テストの失敗・成功を必ず確認してからコミット
