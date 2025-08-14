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

### 🚫 テスト修正の絶対禁止（Kent Beck原則）

**テストは仕様書です。テストを修正することは仕様を歪めることです。**

#### ⛔ 絶対禁止事項

1. **テストを通すためのテスト修正**
   - アサーションの期待値変更
   - テストの削除・コメントアウト
   - テストのスキップ（.skip(), @Ignore等）
   - 期待値の緩和・変更

2. **Greenフェーズでのテスト変更**
   - テストファイルの編集
   - 新規テストの追加
   - テストの構造変更

#### ✅ 正しい対応方法

**テストが失敗した場合**:
1. **実装コードを修正する**（テストは触らない）
2. テストが本当に間違っている場合：
   - 新しい正しいテストを書く
   - 古いテストは残す（削除しない）
   - 両方のテストが通るよう実装を調整

**テスト設計を見直したい場合**:
1. 現在のTDDサイクルを完了させる
2. 新しいRedフェーズで新しいテストを書く
3. 古いテストとの整合性を保つ

#### 📋 テスト不変性の原則

```javascript
// ❌ 禁止：テストを通すためのテスト修正
expect(result).toBe(true);  // 失敗
expect(result).toBe(false); // ← これは仕様を歪める

// ✅ 正しい：実装を修正してテストを通す
expect(result).toBe(true);  // テストは変更しない
// → 実装を修正してtrueを返すようにする
```

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

### STEP 0-3: STATUS 確認（変更なし）

⚠️ **このコマンドではステータス確認のみ行います**

backlog.yaml のステータスを確認：
- `"in-progress"` であることを確認
- **"done" の場合は処理停止**（review完了済み）
- **"testing" の場合は処理停止**（既にdevelop実行済み）

⛔ **TDDサイクル完了まではステータスを変更しない**
⛔ **done への変更は絶対に行わない（review accept のみ可能）**

---

## 🔴🟢🔵 TDD実行フェーズ

### 🔍 実装前チェック: TODOテスト検出

#### STEP 0-4: TODOテスト検出と進捗確認

テストファイル内のTODOテストを検出し、反復的TDDサイクルの準備を行います。

**TODOテストの判定条件**：
```javascript
// パターン1: TODOコメント付きテスト
it('should_move_tetromino_down_when_time_passes', () => {
  // TODO: 落下中のテトロミノをセットアップ
  expect(true).toBe(false); // 🔴 未実装テスト
});

// パターン2: スケルトンテスト
it('should_handle_collision', () => {
  expect(true).toBe(false); // 🔴 仮の失敗テスト
});
```

**検出処理**：
1. テストファイル内の全 `it()` を走査
2. `// TODO:` コメントまたは `expect(true).toBe(false)` を含むテストをTODOと判定
3. TODOテスト数と実装済みテスト数をカウント
4. 進捗状況を表示（例：「テスト進捗: 3/7 実装済み, 4件のTODOテスト検出」）

**TODOテスト検出時の処理**：
- **TODOテストが存在する場合**: 反復的TDDサイクルを開始
- **TODOテストが0件の場合**: 通常のTDD完了条件チェックへ進行

### Kent Beck式「小さなステップ」原則

**"Always write one test at a time, make it run, then improve structure."**

#### 🎯 一度に1つのテストだけ（TODOテスト順次実装）

**厳格なルール**:
1. **1つのテストを書く** → **そのテストを通す** → **構造を改善する**
2. **複数機能の同時実装は禁止**
3. **一度に1つの振る舞いのみ**
4. **最小限の進歩を積み重ねる**

#### 📏 小さなステップの利点

- **設計の明確化**: 1つずつ要求を明確にする
- **リスクの最小化**: 失敗時の影響範囲を限定
- **継続的なフィードバック**: 各ステップで品質確認
- **デバッグの簡素化**: 問題の特定が容易

#### 🚫 「大きなステップ」の禁止

```javascript
// ❌ 禁止：複数テストの同時追加
it('should_spawn_tetromino')
it('should_move_tetromino')  
it('should_rotate_tetromino')

// ✅ 正しい：1つずつ順次追加
it('should_spawn_tetromino')
// ↓ Red→Green→Refactor完了後に次へ
it('should_move_tetromino')
```

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

#### 🔍 2. TODOテスト自動変換（新機能）

**TODOテストが存在する場合の自動処理**：

1. **最初のTODOテストを特定**
2. **TODOを実際の失敗テストに変換**

```javascript
// 変換前（TODOテスト）
it('should_position_tetromino_at_top_center_when_generated', () => {
  // TODO: テトロミノ生成の準備
  // TODO: テトロミノの初期位置設定
  // TODO: 画面上部中央に配置されることを検証
  expect(true).toBe(false); // 🔴 Red: 最初は失敗するテスト
});

// 変換後（実際の失敗テスト）
it('should_position_tetromino_at_top_center_when_generated', () => {
  // Arrange - 準備
  const TetrisGame = require('../src/tetris-game');
  const game = new TetrisGame();
  
  // Act - 実行
  game.start();
  
  // Assert - 検証
  expect(game.currentPiece.x).toBe(4); // 中央位置 (10/2 - 1)
  expect(game.currentPiece.y).toBe(0); // 上部位置
});
```

**変換ルール**：
- TODOコメントを適切なAAA構造（Arrange-Act-Assert）に展開
- ストーリーの要求に基づいた具体的なテストケースを生成
- `expect(true).toBe(false)` を実際の期待値検証に置換

#### 3. TODOテストがない場合の通常処理

**新規テストを1つ書く**（従来の方法）

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

### Green確認（テスト修正禁止厳守）

```bash
npm test
```

#### 🚫 テスト失敗時の厳格な対応

**テストが失敗した場合**:

⛔ **絶対禁止**:
- テストファイルの編集・修正
- 期待値の変更
- テストのスキップ・削除
- 新規テストの追加

✅ **唯一の正しい対応**:
1. **実装コードのみを修正**
2. `npm test` で再確認
3. 失敗が続く場合は実装を繰り返し修正
4. **全テストがPASSするまで次に進まない**

#### 🔄 強制ループ実装

```
テスト失敗検出
    ↓
実装コードを修正
    ↓
テスト再実行
    ↓
失敗なら繰り返し（テストは触らない）
    ↓
全テストPASS → Greenコミット
```

### Greenコミット（全テストPASS後のみ）

```bash
git add src/    # 実装ファイルのみ
git commit -m "[Green] Implement piece spawning after line clear"
```

⚠️ **テストファイルは絶対にaddしない**（変更していないため）

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

## 🔄 反復的TDDサイクル制御（新実装）

### 🎯 TODOテスト完全解消まで反復実行

**重要な変更**: 単一サイクル実行から反復実行への移行

#### ループ制御フロー

```
1. TODOテスト検出 → あり？
   ↓ YES
2. 最初のTODOテストを選択
   ↓
3. Red-Green-Refactor実行
   ↓
4. 進捗更新（例: "2/7 完了"）
   ↓
5. TODOテスト検出 → あり？
   ↓ YES（戻る） / NO（終了）
6. 全テスト完了確認
```

#### サイクル進行管理

**各サイクル終了時の処理**:
1. **進捗カウント更新**: 完了テスト数 / 総テスト数
2. **TODOテスト再検出**: 残りのTODOテストを確認
3. **継続判定**:
   - TODOテストあり → 次のサイクルへ
   - TODOテストなし → 最終完了チェックへ

#### 中断可能設計

**途中終了オプション**:
```bash
# 1サイクルだけ実行したい場合
/cc-xp:develop --single-cycle

# 特定テスト数まで実行したい場合  
/cc-xp:develop --limit=3
```

---

## 🔄 TDDサイクル最終完了条件（厳格チェック）

### Kent Beck式完了条件（全て必須）

#### 1. TDDコミット履歴の確認

**必須コミット**:
```bash
git log --oneline --grep="\[Red\]" | head -1    # 🔴 Redコミット存在
git log --oneline --grep="\[Green\]" | head -1  # 🟢 Greenコミット存在  
git log --oneline --grep="\[Refactor\]" | head -1  # 🔵 Refactorコミット存在
```

⛔ **いずれかが欠けている場合はTDDサイクル未完了**

#### 2. テスト完全実装確認（新チェック項目）

**🔍 TODOテスト0件チェック**:
```bash
# テストファイル内のTODOテスト検出
grep -n "// TODO:" docs/cc-xp/tests/[story-id].spec.js
grep -n "expect(true).toBe(false)" docs/cc-xp/tests/[story-id].spec.js
```

**完全実装の条件**:
- ✅ TODOコメントが0件
- ✅ `expect(true).toBe(false)` スケルトンテストが0件  
- ✅ 全テストに具体的なAssertionが存在
- ✅ AAA構造（Arrange-Act-Assert）が完備

⛔ **TODOテストが検出された場合は即座に停止**
```
❌ TDDサイクル未完了: TODOテストが残存
====================================
検出箇所:
- should_move_tetromino_down_when_time_passes: Line 78
- should_stop_tetromino_when_reaches_bottom: Line 91

→ 反復的TDDサイクルを継続してください
→ /cc-xp:develop (自動で残りのTODOテストを実装)
```

#### 3. テスト品質確認

```bash
npm test  # 全テストPASS必須（TODOテスト0件確認後）
```

#### 3. テスト修正禁止確認

**Git履歴チェック**:
- Redフェーズ後にテストファイルが修正されていないこと
- Greenフェーズでテストファイルの変更がないこと
- テストを通すためのテスト修正がないこと

#### 4. 価値体験実現確認（CRITICAL）

**🎯 技術的成功と価値実現の両立確認**

テストがPASSしても、ユーザーが実際に価値体験できない場合は未完了とします。

**プロジェクトタイプ別の価値体験チェック**:

##### Web アプリケーション・ゲームの場合

```bash
# 必須ファイルの存在確認
test -f index.html || echo "❌ index.html が存在しません"
test -f src/[main-file].js || echo "❌ メインJSファイルが存在しません"

# HTMLの基本構造確認
grep -q "<html" index.html && echo "✅ HTML構造確認"
grep -q "<script" index.html && echo "✅ JavaScript読み込み確認"
```

**価値体験確認項目**:
- ✅ **ブラウザで開ける**: index.html が存在し、基本的なHTML構造を持つ
- ✅ **視覚的に認識できる**: ゲーム画面・アプリ画面が表示される
- ✅ **基本機能が動作**: コアバリューに対応する操作ができる
- ✅ **エラーなく動作**: JavaScript エラーが発生しない

##### CLI ツール・ライブラリの場合

```bash
# 実行可能な形式確認
test -f package.json && grep -q "bin" package.json && echo "✅ CLI実行設定確認"
node [main-file].js --help 2>/dev/null && echo "✅ CLI動作確認"
```

**⛔ 価値体験未達成の場合は即座に停止**:
```
❌ 価値体験実現未完了
========================
検出された問題:
- [ ] ブラウザで開けない（index.html なし）
- [ ] メイン機能が動作しない
- [ ] ユーザーが体験できない状態

🔄 必要な修正:
1. 価値体験に必要なファイルを作成
2. 基本的なUI/UXを実装
3. ストーリーの core_value が体験可能な状態にする

技術的にテストがPASSしても、価値体験できない場合は未完了です。
→ 実装を継続してください
```

##### その他のプロジェクト

- **API サーバー**: エンドポイントへのアクセステストが成功する
- **データ処理**: 実際のデータで期待する結果が出力される

#### 5. アンチパターン検出

**以下が検出された場合は即座に停止**:
- テストファイルの後付け修正
- テストのスキップ・削除
- 複数テストの同時追加
- 期待値の変更履歴

### TDDサイクル完了後の処理

**全条件を満たした場合のみ実行**:

```bash
# 1. 最終進捗確認表示
echo "🎯 TDD完了確認"
echo "実装済みテスト: [N]/[N] (100%)"
echo "TODOテスト: 0件"
echo "全テスト: PASS"

# 2. ステータス更新
# backlog.yamlの status: "in-progress" → "testing" に変更
# updated_at を現在時刻に設定

# 3. 最終コミット（改善版）
git add .
git commit -m "[TDD] Complete iterative Red-Green-Refactor cycles: [story-title]

🔄 反復TDDサイクル完了:
- TODOテスト検出・変換: [N]件
- Red-Green-Refactorサイクル: [N]回実行
- 全テスト実装完了: [N]/[N] (100%)

✅ TDD完了条件:
- TODOテスト0件確認
- 全テストPASS ([N]件)
- Red→Green→Refactorコミット確認
- テスト修正なし
- アンチパターン0件
- 価値体験実現確認済み（ユーザーが体験可能な状態）

🎯 価値実現準備完了
status: "testing" (review待ち)

🎮 価値体験確認済み:
- ユーザーが実際に体験可能な状態
- テストの成功 + 価値の実現を両立
- 技術的完成度と価値提供の統合完了

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>"
```

### 条件未達成時の処理

**TDDサイクルが不完全な場合**:
```
⚠️ TDDサイクル未完了
==================
進捗状況: [実装済み数]/[総数] ([%]%)
TODOテスト: [N]件残存
全テストPASS: [YES/NO]

未達成条件: 
- [ ] TODOテスト完全解消
- [ ] 全テストPASS
- [ ] 価値体験実現（ユーザーが体験可能な状態）
- [ ] [その他の具体的な未達成項目]

現在ステータス: "in-progress" (変更なし)

完了に向けて:
→ /cc-xp:develop (残りのTODOテストを自動実装)
または
→ /cc-xp:develop --[red|green|refactor] (個別フェーズ実行)

全条件を満たすまでdevelopコマンドは完了しません。
```

---

## ⚠️ 終了前の最終 STATUS 確認

**必須チェック**: backlog.yaml の status が正しい状態であることを確認してください：

- **"testing" の場合**: ✅ 正常（そのまま終了）
- **"done" の場合**: ❌ **CRITICAL ERROR** - 不正な状態変更が検出されました
- **その他の場合**: ❌ エラー処理

⚠️ **done が検出された場合は、このコマンドの実装に重大なバグがあります**

---

## 🎯 TDDサイクル終了サマリーと次のステップ

**重要**: 以下の2つのセクションを必ず順番に表示:
1. TDDサイクル終了サマリー
2. 次のステップ案内（/cc-xp:review への誘導）

**必ず以下を表示してください**：

```
🔄 反復的TDD完全実装終了
=========================
ストーリー: [ストーリータイトル]
ブランチ: story-[ID]
ステータス: "testing" ✅

反復TDDサイクル実行結果:
📊 テスト実装進捗: [N]/[N] (100% 完了)
🔄 実行サイクル数: [N]回
🔴 Red: TODOテスト変換・新規テスト作成
🟢 Green: 最小実装でテスト通過
🔵 Refactor: 構造改善・品質向上

完全実装確認:
✅ TODOテスト 0件 (完全解消)
✅ 全テスト PASS ([N]件すべて)
✅ FIRST原則遵守
✅ AAA構造完備
✅ テストファースト実践

🚨 CRITICAL 確認事項
⛔ status = "testing" （"done" は絶対に NG）
⛔ ストーリーは未完了（review でのみ完了）
✅ テストが完全な仕様書として機能
✅ 自動テストのみで品質保証
✅ デグレードなし（回帰テスト）
✅ 価値実現準備完了
```

### 次のステップ案内

**TDDサイクル完了後、必ず以下を表示してください**：

```
🎯 次のステップ

価値実現の確認とレビュー実行:
→ /cc-xp:review

実装したストーリーの価値体験検証と品質評価を行ってください。
review完了後にのみストーリーが "done" に変更されます。
```

---

## 🚫 Kent Beck式アンチパターン自動検出

以下が検出された場合、**処理を自動停止し、修正方法を案内**：

### 🔴 Redフェーズのアンチパターン

1. **テストファイルが存在しない**
   → `docs/cc-xp/tests/[story-id].spec.js` が未作成

2. **複数テストの同時追加**
   → 1つのコミットで複数の `it()` を追加

3. **実装先行**
   → テストより先に実装ファイルを作成・変更

### 🟢 Greenフェーズのアンチパターン

1. **テストを通すためのテスト修正**
   → テストファイルの変更（期待値変更、削除等）

2. **テストスキップ**
   → `.skip()`, `@Ignore`, `xit()` の使用

3. **新規テストの追加**
   → Greenフェーズでの `it()` 追加

4. **テスト実装の混在**
   → 1コミットでテストと実装を同時変更

### 🔵 Refactorフェーズのアンチパターン

1. **振る舞い変更の混在**
   → リファクタリングと機能追加の同時実行

2. **テスト破綻の放置**
   → リファクタリング後のテスト失敗を放置

### 🔄 TDDサイクル全般のアンチパターン

1. **フェーズ飛ばし**
   → Red→Refactor、Green→Red等の順序違反

2. **TDDサイクル未完了でのステータス変更**
   → Red-Green-Refactorコミットが揃う前の完了

3. **手動テストへの依存**
   → 自動テスト以外での動作確認に依存

### 検出時の自動対応

**アンチパターン検出時**:
```
🚨 TDDアンチパターン検出
======================
検出項目: [具体的なアンチパターン]
対象ファイル: [問題のあるファイル]

🔧 修正方法:
[具体的な修正手順]

⛔ コマンドを停止します
ステータス: "in-progress" (変更なし)

正しいTDDサイクルで再実行してください:
→ /cc-xp:develop --red
```

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

---

**この厳格なTDDプロセスにより、高品質で保守しやすいコードを確実に生成します。**