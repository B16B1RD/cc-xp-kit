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

### 進捗確認と次ステップの決定

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

#### 3. 次のアクションを決定

進捗状態に基づいて、次に実行すべきアクションを1つだけ決定：

**Case A: 全て not_started の場合**
→ 最初のacceptance_criteriaのテストを1つ作成

**Case B: 現在 red ステータスがある場合**
→ そのテストを通す最小限の実装を生成

**Case C: 現在 green で、次が not_started の場合**
→ 次のacceptance_criteriaのテストを1つ作成

**Case D: 全て green の場合**
→ リファクタリングまたはreviewコマンドへの案内

**重要**: 一度に複数のテストを作成したり、複数の実装を行うことは禁止です。

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

全てのacceptance_criteriaがgreenになった場合のみ：

```yaml
stories:
  - id: story-id
    status: testing  # in-progress から testing に更新
    updated_at: "2025-08-16T17:30:00+09:00"
    development_notes: |
      インクリメンタルTDD完了:
      - 実装基準数: 3/3件
      - 最小限実装 → 段階的改善サイクル: 3回完了
      - 真のTDDサイクルで価値体験を段階的に実現
```

#### 重要な原則

1. **1つずつの進捗**: 必ず1つのacceptance_criteriaに集中
2. **最小限から開始**: 完璧を目指さず、動作することを優先
3. **段階的な価値実現**: 各criteria完了時にユーザーが体験可能
4. **TODOテスト禁止**: expect(true).toBe(false)を含むテストは作成しない

### 次回実行時の動作

developコマンドの次回実行時は、test_progressを確認して自動的に次のアクションを決定：

- **redステータスがある**: そのテストを通す最小限実装を提案
- **次のnot_startedがある**: 次のacceptance_criteriaのテスト作成
- **全てgreen**: reviewコマンドへの案内

これにより、真のTDDの小さなサイクルを繰り返し、段階的に価値を積み重ねることができます。

## 次のステップ

@shared/next-steps.md

### develop 完了時の重要な案内

TDDサイクル完了後、**必ず以下の形式で次のステップを案内してください**：

```
🚀 次のステップ
================
develop完了：ストーリーのレビューと価値検証を実施してください:
→ /cc-xp:review

価値体験確認とコード品質評価を実行し、accept/rejectを判定します。
```

**重要**:
- ステータスが "testing" に更新された場合、次は review コマンドです
- 決して "accept" を直接指示しないでください
- review コマンドでの評価後に accept/reject が判定されます