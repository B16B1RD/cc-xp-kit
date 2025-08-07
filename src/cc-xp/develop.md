---
description: XP develop – TDDサイクル（Red→Green→Refactor）を完走
argument-hint: '[id] ※省略時は in-progress ストーリーを使用'
allowed-tools: Bash(*), WriteFile, ReadFile
---

## ゴール

**テストファースト**でストーリーを実装し、動作するコードを素早く作る。各フェーズをGitで記録。

## XP/TDD原則

- **Red**: まず失敗するテストを書く
- **Green**: テストを通す最小限のコード
- **Refactor**: 動作を保ちながら改善
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

### 最終コミット
```bash
git add docs/cc-xp/backlog.yaml docs/cc-xp/metrics.json
git commit -m "chore: ストーリー [ID] を testing に更新"
```

## 完了サマリー

TDDサイクル完了後、**必ず以下を表示**してください：

```
📊 TDDサイクル完了
==================
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

使用ツール: [検出されたテストツール]
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

## 注意事項

- 各フェーズは明確に分離（混ぜない）
- コミットメッセージの絵文字を統一（🔴✅♻️）
- テストの失敗・成功を必ず確認してからコミット
