---
description: XP develop – Kent Beck式Test-Driven Development実践
argument-hint: '[story-id] [--red|--green|--refactor] ※省略時は in-progress ストーリーを使用'
allowed-tools: Bash(git:*), Bash(date), Bash(test), Bash(npm:*), Bash(pnpm:*), Bash(yarn:*), Bash(bun:*), Bash(python:*), Bash(pytest:*), Bash(cargo:*), Bash(go:*), Bash(bundle:*), Bash(dotnet:*), Bash(gradle:*), Bash(npx:*), Bash(ls), WriteFile, ReadFile, mcp__playwright__*
---

# XP Develop - Kent Beck式TDD

## 🎯 ゴール

**Test-Driven Development (Kent Beck)** により、設計品質の高いソフトウェアを実装する。

**TDDの本質**: テストはドキュメントであり、仕様であり、設計手法である。

## TDD原則

@shared/tdd-principles.md

## 🚨 CRITICAL: ステータス変更の厳格制限

1. **status を done に変更することは絶対禁止**
   - develop コマンドは testing までしか進めない
   - done への変更は review accept のみが可能
   - 「ストーリー完了」という判断は行わない

2. **backlog.yaml の複数回更新禁止**
   - STEP 0-3 以外での status 変更は絶対禁止
   - 終了時の status 更新は絶対に行わない

## 開始前の確認

### 共通処理

@shared/git-check.md

### テスト環境確認

@shared/test-env-check.md

**テスト環境がない場合は処理を停止**し、以下を案内：
```
⛔ TDD実行不可: テスト環境が未構築です

以下を先に実行してください：
→ /cc-xp:plan  # プロジェクト設定とテスト環境構築
```

### STATUS 確認

⚠️ **このコマンドではステータス確認のみ行います**

@shared/backlog-reader.md から `in-progress` ステータスのストーリーを確認：
- `"in-progress"` であることを確認
- **"done" の場合は処理停止**（review完了済み）
- **"testing" の場合は処理停止**（既にdevelop実行済み）

⛔ **TDDサイクル完了まではステータスを変更しない**
⛔ **done への変更は絶対に行わない（review accept のみ可能）**

## 🔴🟢🔵 インクリメンタルTDDサイクル

### 🚨 CRITICAL: 1回実行での完全実装必須

**develop コマンドは以下を1回の実行で完了**します：
- **全てのacceptance_criteriaの実装**（Red→Green→Refactorサイクル）
- **全テストがPASS状態**
- **カバレッジ85%以上達成**
- **testingステータスへの更新**

**絶対禁止事項**：
- 部分実装での終了
- 時間制約による早期終了
- 「次回継続」の案内

#### 1. 受け入れ基準の存在確認

backlog.yamlから対象ストーリーの `acceptance_criteria` を確認してください：

```yaml
acceptance_criteria:
  - "ブラウザでページを開くとゲーム画面が表示される"
  - "テトロミノが1秒間隔で自動的に1行下に移動する"
  - "プレースホルダーメッセージが表示されない"
```

**acceptance_criteria がない場合**：
```
⛔ TDD実行不可: 受け入れ基準が未定義です

以下を先に実行してください：
→ /cc-xp:story  # 受け入れ基準の詳細化
```

#### 2. 現在の進捗状態を確認

backlog.yamlから対象ストーリーの開発進捗を確認してください：

```yaml
test_progress:
  - criteria_index: 0
    criteria: "ブラウザでページを開くとゲーム画面が表示される"
    status: green  # green/red/not_started
    test_file: "test/display.spec.js"
  - criteria_index: 1
    criteria: "テトロミノが1秒間隔で自動的に1行下に移動する"
    status: red
    test_file: "test/movement.spec.js"
  - criteria_index: 2
    criteria: "プレースホルダーメッセージが表示されない"
    status: not_started
```

**test_progressが存在しない場合**：
新規にtest_progressセクションをbacklog.yamlに追加し、全てのacceptance_criteriaを`not_started`ステータスで初期化してください。

#### 3. 自動TDDサイクル実行

**シンプルな自動ループ**で全acceptance_criteriaを実装完了まで継続：

```
🔄 自動実装ループ（全criteria greenまで継続）
=================================================
while (未完了のacceptance_criteriaが存在) {
  
  // Step 1: 次のnot_startedまたはredのcriteriaを特定
  nextCriteria = 最初のnot_startedまたはredステータスのcriteria
  
  // Step 2: TDDサイクル実行
  if (nextCriteria.status == "not_started") {
    → Red: そのcriteriaのテストを作成
    → 必ずテストが失敗することを確認
    → criteriaのstatusを"red"に更新
  }
  
  if (nextCriteria.status == "red") {
    → Green: テストを通す最小限の実装
    → テストがPASSすることを確認
    → criteriaのstatusを"green"に更新
  }
  
  // Step 3: 進捗確認と継続判定
  remainingCount = not_startedまたはredのcriteria数
  if (remainingCount > 0) {
    → 🔄 自動継続（次のサイクルを即座に実行）
  } else {
    → ✅ 全criteria実装完了（testingステータス更新）
  }
}
```

**重要原則**：
- 1つのcriteriaずつ確実に実装
- Red→Green→次のcriteriaの自動サイクル
- 中断・早期終了は一切認めない

### TDDサイクル実行

### 現在の状態に基づいたアクション実行

進捗状態に基づいて、以下のいずれか1つを実行してください：

#### Case A: 最初のテスト作成 (not_started → red)

最初のacceptance_criteriaのみにフォーカスした実動作テストを作成：

```javascript
// 例: "ブラウザでページを開くとゲーム画面が表示される"
describe('Game Display', () => {
  it('should_display_canvas_element', () => {
    // DOM環境のセットアップ
    document.body.innerHTML = '<div id="app"></div>';
    
    // ゲーム初期化
    const game = new TetrisGame();
    
    // canvas要素の存在確認
    const canvas = document.getElementById('gameCanvas');
    expect(canvas).toBeTruthy();
    expect(canvas.tagName).toBe('CANVAS');
  });
});
```

**重要**: expect(true).toBe(false) のTODOテストは作成禁止。必ず実動作するテストを作成。

#### Case B: 最小限実装 (red → green)

現在失敗しているテストを通す最小限の実装：

```javascript
// 最小限実装例
class TetrisGame {
  constructor() {
    // canvas要素を作成してDOMに追加
    const canvas = document.createElement('canvas');
    canvas.id = 'gameCanvas';
    canvas.width = 300;
    canvas.height = 600;
    document.getElementById('app').appendChild(canvas);
  }
}
```

**重要**: 「最小限」とは、テストを通すための必要最小限のコード。完璧でなくても良い。

#### Case C: 次のテスト作成 (green → red)

次のacceptance_criteriaのテストを1つ作成：

```javascript
// 例: "テトロミノが画面上部に出現する"
it('should_display_tetromino_at_top', () => {
  const game = new TetrisGame();
  
  // テトロミノの初期位置確認
  expect(game.currentPiece).toBeDefined();
  expect(game.currentPiece.y).toBe(0);
  
  // canvasに描画されているか確認
  const canvas = document.getElementById('gameCanvas');
  const ctx = canvas.getContext('2d');
  const imageData = ctx.getImageData(0, 0, 90, 90); // 上部領域
  const hasDrawing = Array.from(imageData.data).some(pixel => pixel !== 0);
  expect(hasDrawing).toBe(true);
});
```

#### Case D: リファクタリングまたは完了

全てのacceptance_criteriaがgreenの場合：
- コードの重複除去
- 設計の改善
- または review コマンドへの案内

### サイクル完了後の状態更新

1つのacceptance_criteriaのTDDサイクルが完了したら、進捗を記録：

#### Red → Green 完了時の更新

```yaml
# backlog.yamlの更新
test_progress:
  - criteria_index: 0
    criteria: "ブラウザでページを開くとゲーム画面が表示される"
    status: green  # red から green に更新
    test_file: "test/display.spec.js"
    implementation_notes: "最小限実装: canvas要素のDOM追加"
    completed_at: "2025-08-16T17:30:00+09:00"
```

#### 全criteria完了時のステータス更新

**🚨 CRITICAL: testingステータス更新の厳格な条件**

以下の条件を**すべて満たした場合のみ**testingステータスに更新：

1. **全acceptance_criteriaがgreen**: 1つでもnot_startedまたはredがある場合は更新禁止
2. **全テストが完全に実装**: TODOテストや仮実装は禁止
3. **価値体験が完全実現**: minimum_experienceが完全に体験可能

**部分実装での更新は絶対禁止**：

```yaml
# ❌ 禁止例（2/10件実装）
# status: testing  # 絶対に更新しない

# ✅ 正しい例（全件実装完了時のみ）
stories:
  - id: story-id
    status: testing  # in-progress から testing に更新
    updated_at: "2025-08-16T17:30:00+09:00"
    development_notes: |
      インクリメンタルTDD完了（全基準実装）:
      - 実装基準数: 10/10件（100%完了）
      - 最小限実装 → 段階的改善サイクル: 10回完了
      - 全acceptance_criteriaがgreen確認済み
      - 価値体験完全実現確認済み
```

**部分実装の場合の対応**：

```yaml
# 部分実装の場合（例: 2/10件）
development_notes: |
  インクリメンタルTDD継続中:
  - 実装済み基準数: 2/10件（20%完了）
  - 残り8件の受け入れ基準を継続実装中
  - 次回developコマンドで継続実装予定
# status: in-progress のまま維持（testing更新禁止）
```

#### 重要な原則

1. **1つずつの進捗**: 必ず1つのacceptance_criteriaに集中
2. **最小限から開始**: 完璧を目指さず、動作することを優先
3. **段階的な価値実現**: 各criteria完了時にユーザーが体験可能
4. **TODOテスト禁止**: expect(true).toBe(false)を含むテストは作成しない
5. **🚨 継続実装の必須原則**: 全criteria greenまで自動継続、早期終了禁止

### 🔄 実装進捗の自動管理

**各TDDサイクル完了後の自動処理**：

#### 1. 進捗状況の確認と表示

```
📊 実装進捗確認
================
- 完了済み: [Green件数]件 / [Total]件  
- 残り作業: [Not_started + Red件数]件
- 進捗率: [Green/Total * 100]%

🔄 次のアクション: [次のcriteria名]の[Red/Green]フェーズを実行
```

#### 2. 自動継続の実行

```
🚨 CRITICAL: 自動継続実行
==========================
while (not_started または red のcriteriaが存在) {
  nextAction = 次のnot_startedまたはredのcriteria
  
  if (nextAction found) {
    → 即座に次のTDDサイクルを実行
    → 進捗更新後、再度このループを継続
  }
}

if (全criteriaがgreen) {
  → testingステータス更新
  → reviewコマンド案内
  → develop完了宣言
}
```

#### 3. 継続実装の保証

**絶対に実行される処理**：
- 各criteria完了後の自動進捗チェック
- 残り作業がある場合の強制継続
- 全criteria完了まで停止しない自動ループ

**絶対に実行されない処理**：
- 部分実装での終了メッセージ
- 「次回継続」の案内
- 時間制約による早期終了

## 次のステップ

@shared/next-steps.md

### develop 完了時の案内

#### ✅ 完全実装完了の確認

develop実行により、以下が**確実に達成**されています：

```
✅ 完了条件確認済み
=====================
✅ 全acceptance_criteriaがgreen状態
✅ test_progressに not_started/red が0件
✅ 全テストがPASS状態  
✅ カバレッジ85%以上達成
✅ 価値体験が完全実現済み
✅ testingステータス更新完了
```

#### 🚀 次のステップ案内

**develop完了により自動的に案内**：

```
🎉 develop完了: 全acceptance_criteria実装完了
============================================
ストーリーのレビューと価値検証を実施してください:

→ /cc-xp:review

価値体験確認とコード品質評価を実行し、accept/rejectを判定します。
全ての実装が完了しているため、reviewで承認される可能性が高いです。
```

**🎯 成果確認**：
- 1回のdevelop実行で全実装完了
- 部分実装状態での終了なし
- 継続実行の必要なし