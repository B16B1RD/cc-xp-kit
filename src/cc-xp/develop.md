---
description: XP develop – Kent Beck式Test-Driven Development実践
argument-hint: '[story-id] [--red|--green|--refactor] ※省略時は in-progress ストーリーを使用'
allowed-tools: Bash(git:*), Bash(date), Bash(test), Bash(npm:*), Bash(pnpm:*), Bash(yarn:*), Bash(bun:*), Bash(python:*), Bash(pytest:*), Bash(cargo:*), Bash(go:*), Bash(bundle:*), Bash(dotnet:*), Bash(gradle:*), Bash(npx:*), Bash(ls), WriteFile, ReadFile, mcp__playwright__*
---

# XP Develop - Kent Beck式TDD

## 🎯 ゴール

**Test-Driven Development (Kent Beck)** により、設計品質の高いソフトウェアを実装する。

**TDDの本質**: テストはドキュメントであり、仕様であり、設計手法である。

---

## 🚨 TDD原則 - 絶対厳守

### Kent Beck's Red-Green-Refactor Cycle

```
🔴 Red   → 失敗するテストを書く（設計を明確化）
🟢 Green → テストを通す最小限のコード（機能を実装）
🔵 Refactor → 構造を改善（品質を向上）
```

### 🚫 絶対禁止事項

#### ⛔ CRITICAL: ステータス変更の厳格制限

1. **status を done に変更することは絶対禁止**
   - develop コマンドは testing までしか進めない
   - done への変更は review accept のみが可能
   - 「ストーリー完了」という判断は行わない

2. **backlog.yaml の複数回更新禁止**
   - STEP 0-3 以外での status 変更は絶対禁止
   - 終了時の status 更新は絶対に行わない

#### 🚫 TDD原則の絶対遵守

1. **テストなしの実装** - 実装前に必ずテストを書く
2. **手動テストへの依存** - 自動テストのみが真実
3. **テストを通すためのテスト修正** - テストは仕様、変更不可
4. **複数機能の同時実装** - 一度に1つの振る舞いのみ
5. **Greenを飛ばしてのRefactor** - 必ずGreen状態でリファクタリング

---

## 🛡️ 開始前の確認

### STEP 0-1: Git リポジトリ確認

Gitリポジトリが初期化されているか確認してください。初期化されていない場合は以下を自動実行：

1. `git init` でリポジトリを初期化
2. `git branch -m main` でデフォルトブランチをmainに変更
3. `git add .` で全ファイルをステージング
4. `git commit -m "Initial commit"` で初期コミットを作成

Git設定（user.name, user.email）が未設定の場合も適切に設定してください。

### STEP 0-2: テスト環境確認

プロジェクトにテスト実行環境があることを確認：

```bash
# いずれかのコマンドが実行可能であることを確認
npm test || yarn test || pnpm test || python -m pytest || go test || cargo test
```

**テスト環境がない場合は処理を停止**し、以下を案内：
```
⛔ TDD実行不可: テスト環境が未構築です

以下を先に実行してください：
→ /cc-xp:plan  # プロジェクト設定とテスト環境構築
```

### STEP 0-3: STATUS 原子的更新（唯一の更新箇所）

⚠️ **このコマンドで backlog.yaml を更新するのはここだけです**

backlog.yaml のステータスを更新：
- `in-progress` → `testing` に変更
- updated_at を現在時刻に設定
- **done の場合は処理停止**

⛔ **これ以降、このコマンド内では二度と status を変更しない**
⛔ **done への変更は絶対に行わない（review accept のみ可能）**

---

## 🔴🟢🔵 TDD実行フェーズ

### オプション引数による段階実行

```bash
/cc-xp:develop [story-id] --red     # Redフェーズのみ
/cc-xp:develop [story-id] --green   # Greenフェーズのみ  
/cc-xp:develop [story-id] --refactor # Refactorフェーズのみ
/cc-xp:develop [story-id]           # 全フェーズを順次実行
```

---

## 🔴 Phase 1: Red（失敗するテストを書く）

### 目的

**振る舞いを定義**し、設計を明確化する

### 実行手順

#### 1. テストファイル確認

`docs/cc-xp/tests/[story-id].spec.js` の存在を確認
- 存在しない場合: story未実行のためエラー停止
- 存在する場合: テストファイルを開いて編集

#### 2. 最小の失敗テストを1つ書く

```javascript
// 良いテストの例（振る舞い駆動命名）
describe('TetrisGame', () => {
  it('should_spawn_new_piece_after_line_clear', () => {
    // Arrange - 準備
    const game = new TetrisGame();
    game.fillBottomLine();
    
    // Act - 実行
    game.clearLines();
    
    // Assert - 検証
    expect(game.currentPiece).toBeDefined();
  });
});
```

#### 3. Red状態確認

```bash
npm test
```
- **テストが失敗することを確認**
- 失敗しない場合：テストが不適切（実装が既に存在）

#### 4. Redコミット

```bash
git add docs/cc-xp/tests/
git commit -m "[Red] Add test: should_spawn_new_piece_after_line_clear"
```

---

## 🟢 Phase 2: Green（テストを通す）

### 目的

**テストを通す最小限のコード**を書く

### Kent Beck's 3つの戦略

#### 1. 仮実装（Fake It）- 推奨

```javascript
clearLines() {
  // まずは仮実装でテストを通す
  this.currentPiece = { x: 0, y: 0, shape: [[1]] };
}
```

#### 2. 明白な実装（Obvious Implementation）

```javascript
clearLines() {
  // 実装が明白な場合のみ
  this.detectCompletedLines();
  this.removeLines();
  this.spawnNewPiece();
}
```

#### 3. 三角測量（Triangulation）

```javascript
// 2つ以上のテストケースから一般化
it('should_spawn_I_piece_after_single_line_clear')
it('should_spawn_O_piece_after_double_line_clear')
// → 一般的なspawnPiece()実装を導き出す
```

### Green確認

```bash
npm test
```
- **全テストがPASS**することを確認
- 1つでも失敗する場合は修正を続行

### Greenコミット

```bash
git add src/
git commit -m "[Green] Implement piece spawning after line clear"
```

---

## 🔵 Phase 3: Refactor（構造を改善）

### 目的

**コードの品質を向上**させる（振る舞いは不変）

### Tidy First原則

**構造的変更**のみ実施（振る舞いは変更しない）

### リファクタリング手順

#### 1. 事前テスト

```bash
npm test  # 必ずGreen状態であることを確認
```

#### 2. リファクタリング実施

- **重複の除去** - DRY原則
- **意図の明確化** - 命名改善
- **メソッド抽出** - 単一責任原則
- **条件記述の分解** - 複雑度削減

```javascript
// Before
clearLines() {
  let count = 0;
  for (let y = 19; y >= 0; y--) {
    let complete = true;
    for (let x = 0; x < 10; x++) {
      if (!this.field[y][x]) complete = false;
    }
    if (complete) {
      this.field.splice(y, 1);
      this.field.unshift(Array(10).fill(0));
      count++;
    }
  }
  if (count > 0) this.spawnPiece();
}

// After（メソッド抽出）
clearLines() {
  const completedLines = this.findCompletedLines();
  this.removeLines(completedLines);
  if (completedLines.length > 0) {
    this.spawnPiece();
  }
}
```

#### 3. 事後テスト

```bash
npm test  # リファクタリング後も全テストPASS
```

#### 4. Refactorコミット

```bash
git add src/
git commit -m "[Refactor] Extract line detection methods"
```

---

## 📊 テスト品質確認

### t-wada's FIRST原則

- **F**ast - 高速実行
- **I**ndependent - テスト間の独立性  
- **R**epeatable - 再現可能性
- **S**elf-Validating - 自己検証
- **T**imely - 適時作成（実装前）

### AAA構造チェック

```javascript
it('should_[expected_behavior]_when_[condition]', () => {
  // Arrange（準備） - テストデータと条件設定
  const game = new TetrisGame();
  game.setupInitialState();
  
  // Act（実行） - テスト対象の実行
  const result = game.performAction();
  
  // Assert（検証） - 期待結果の確認
  expect(result).toEqual(expectedValue);
});
```

---

## 🔄 サイクル終了確認

### 最終チェック

1. **全テストがPASS** - `npm test`
2. **カバレッジ確認** - 重要な経路がテスト済み
3. **リンター確認** - コード品質基準達成
4. **ステータス確認** - `status: testing` 維持

### 最終コミット

```bash
git add .
git commit -m "[TDD] Red-Green-Refactor サイクル終了: [feature]

- Red: Add failing test for [behavior]
- Green: Implement minimal solution
- Refactor: Improve code structure

注意: ストーリーは未完了（status: testing）
承認は /cc-xp:review で実施

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>"
```

---

## ⚠️ 終了前の最終 STATUS 確認

**必須チェック**: backlog.yaml の status が正しい状態であることを確認してください：

- **testing の場合**: ✅ 正常（そのまま終了）
- **done の場合**: ❌ **CRITICAL ERROR** - 不正な状態変更が検出されました
- **その他の場合**: ❌ エラー処理

⚠️ **done が検出された場合は、このコマンドの実装に重大なバグがあります**

---

## 🎯 TDDサイクル終了サマリー

TDDサイクル終了後、以下を表示：

```
🔴🟢🔵 Kent Beck式TDDサイクル終了
===========================
ストーリー: [ストーリータイトル]
ブランチ: story-[ID]
ステータス: testing ✅

実施サイクル:
🔴 Red: 失敗テスト作成 → コミット
🟢 Green: 最小実装 → コミット  
🔵 Refactor: 構造改善 → コミット

品質確認:
✅ 全テスト PASS
✅ FIRST原則遵守
✅ AAA構造
✅ テストファースト実践

🚨 CRITICAL 確認事項
⛔ status = testing （done は絶対に NG）
⛔ ストーリーは未完了（review でのみ完了）
✅ テストが仕様書として機能
✅ 自動テストのみで品質保証
✅ デグレードなし（回帰テスト）
```

## 次のステップ

```
🚀 次のステップ
================
自動テスト実行とコードレビュー:
→ /cc-xp:review

💡 TDD原則
- テストは仕様書
- テストは設計手法  
- 実装よりテストが先
- Greenになったらリファクタリング
```

---

## 🚫 アンチパターン自動検出

以下が検出された場合、**処理を自動停止**：

1. **テストファイルが存在しない**
2. **テスト実行環境がない**
3. **テストなしで実装を開始**
4. **Redを飛ばしてGreenから開始**
5. **Green状態でないままRefactor実行**
6. **テストを通すためにテストを修正**

---

## エラーハンドリング

### テスト失敗時

```
⚠️ テスト失敗が検出されました

Red フェーズ: 期待通り（継続）
Green フェーズ: 実装を修正してください
Refactor フェーズ: リファクタリングを取り消してください
```

### テスト環境エラー

```
⛔ テスト実行エラー

1. テストランナーの設定を確認
2. 依存関係のインストール状況を確認  
3. /cc-xp:plan でのセットアップ実行を推奨
```

**この厳格なTDDプロセスにより、高品質で保守しやすいコードを確実に生成します。**