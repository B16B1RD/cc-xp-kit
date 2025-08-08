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

### ストーリー情報
- in-progressストーリー: @docs/cc-xp/backlog.yaml から確認
- 受け入れ条件: @docs/cc-xp/stories/[ID].md
- フィードバック（もしあれば）: @docs/cc-xp/stories/[ID]-feedback.md
- 現在のブランチ: !git branch --show-current
- Git状態: !git status --short
- 現在時刻: !date +"%Y-%m-%dT%H:%M:%S%:z"

$ARGUMENTS が指定されている場合はそのID、なければ `in-progress` ステータスのストーリーを使用してください。

**ステータスバリデーション**：
- 対象ストーリーが `in-progress` であることを確認
- `done` ステータスのストーリーは開発対象外

**修正サイクルの確認**：
フィードバックファイルが存在する場合、これは修正サイクルであることを認識し、前回の問題点を意識して開発を進めてください。

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

## TDDサイクルの実施

### 修正サイクルの場合の注意
フィードバックファイルが存在する場合：
1. **前回の問題を再現するテストから始める**
2. 既存のテストも確認し、壊れていないことを確認
3. 修正は最小限に留める（他の部分を壊さない）

### Phase 1: Red（テスト作成）

#### タスク
1. @docs/cc-xp/stories/[ID].md の最初の受け入れ条件をテストコードに変換
2. 適切なテストファイルを作成（tests/, test/, spec/, __tests__/）
3. **必ず失敗することを確認**

#### テストコード例

**JavaScript/TypeScript (Bun/Vitest)**
```typescript
import { expect, test, describe } from "bun:test";

describe("ゲーム盤面", () => {
  test("10×20のサイズである", () => {
    const board = createBoard(); // まだ存在しない
    expect(board.width).toBe(10);
    expect(board.height).toBe(20);
  });
});
```

**Python (pytest)**
```python
def test_game_board_size():
    board = create_board()  # まだ存在しない
    assert board.width == 10
    assert board.height == 20
```

#### 確認とコミット
テストを実行し、**失敗を確認**してから：
```bash
git add [テストファイル]
git commit -m "test: 🔴 [ストーリータイトル]のテストを追加"
```

### Phase 2: Green（最小実装）

#### タスク
1. テストを通すための**最もシンプルな実装**を作成
2. ハードコーディングでもOK（後で改善）
3. テストが**成功することを確認**

#### 実装例
```javascript
// 最小限の実装（ハードコーディングOK）
function createBoard() {
  return { width: 10, height: 20 };
}
```

#### 確認とコミット
テストを実行し、**成功を確認**してから：
```bash
git add [実装ファイル]
git commit -m "feat: ✅ [ストーリータイトル]の最小実装"
```

### Phase 3: Refactor（改善）

#### タスク
1. 重複を除去
2. 名前を改善
3. でも**やりすぎない**（YAGNI）
4. テストが**通り続けることを確認**

#### リファクタリング例
- マジックナンバーを定数化
- 関数を適切な場所に移動
- 変数名を明確に

#### 確認とコミット
テストを実行し、**成功を維持**してから：
```bash
git add -u
git commit -m "refactor: ♻️ [ストーリータイトル]のコード改善"
```

## メトリクスとステータスの更新

### メトリクス更新
@docs/cc-xp/metrics.json を更新：
- tddCycles.red += 1
- tddCycles.green += 1  
- tddCycles.refactor += 1
- lastUpdated: 現在時刻

### ストーリーステータス更新
@docs/cc-xp/backlog.yaml の該当ストーリー：
- status: `in-progress` → `testing` （**重要**: doneにはしない）
- updated_at: 現在時刻

注意：ステータスを `done` にするのは `/cc-xp:review accept` のみです。

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
