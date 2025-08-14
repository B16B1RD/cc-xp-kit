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

### Kent Beck式「小さなステップ」原則

**"Always write one test at a time, make it run, then improve structure."**

#### 🎯 一度に1つのテストだけ

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

## 🔄 TDDサイクル完了条件（厳格チェック）

### Kent Beck式完了条件（全て必須）

#### 1. TDDコミット履歴の確認

**必須コミット**:
```bash
git log --oneline --grep="\[Red\]" | head -1    # 🔴 Redコミット存在
git log --oneline --grep="\[Green\]" | head -1  # 🟢 Greenコミット存在  
git log --oneline --grep="\[Refactor\]" | head -1  # 🔵 Refactorコミット存在
```

⛔ **いずれかが欠けている場合はTDDサイクル未完了**

#### 2. テスト品質確認

```bash
npm test  # 全テストPASS必須
```

#### 3. テスト修正禁止確認

**Git履歴チェック**:
- Redフェーズ後にテストファイルが修正されていないこと
- Greenフェーズでテストファイルの変更がないこと
- テストを通すためのテスト修正がないこと

#### 4. アンチパターン検出

**以下が検出された場合は即座に停止**:
- テストファイルの後付け修正
- テストのスキップ・削除
- 複数テストの同時追加
- 期待値の変更履歴

### TDDサイクル完了後の処理

**全条件を満たした場合のみ実行**:

```bash
# 1. ステータス更新
# backlog.yamlの status: "in-progress" → "testing" に変更
# updated_at を現在時刻に設定

# 2. 最終コミット
git add .
git commit -m "[TDD] Red-Green-Refactor サイクル完了: [feature]

🔴 Red: Add failing test for [behavior]  
🟢 Green: Implement minimal solution
🔵 Refactor: Improve code structure

✅ TDD完了条件:
- 全テストPASS
- Red→Green→Refactorコミット確認
- テスト修正なし
- アンチパターン0件

status: "testing" (review待ち)

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>"
```

### 条件未達成時の処理

**TDDサイクルが不完全な場合**:
```
⚠️ TDDサイクル未完了
==================
未達成条件: [具体的な未達成項目]
現在ステータス: "in-progress" (変更なし)

完了に向けて:
→ /cc-xp:develop --[red|green|refactor]

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
🔴🟢🔵 Kent Beck式TDDサイクル終了
===========================
ストーリー: [ストーリータイトル]
ブランチ: story-[ID]
ステータス: "testing" ✅

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
⛔ status = "testing" （"done" は絶対に NG）
⛔ ストーリーは未完了（review でのみ完了）
✅ テストが仕様書として機能
✅ 自動テストのみで品質保証
✅ デグレードなし（回帰テスト）
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