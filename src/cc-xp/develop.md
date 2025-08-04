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

## 手順

### 0. 開発環境の検出とセットアップ
プロジェクトの言語を検出し、モダンなツールチェーンを使用：

- **JavaScript/TypeScript**: 
  - Bun: `bun test` / `bun run test`
  - pnpm + Vitest: `pnpm test`
- **Python**: 
  - uv + pytest: `uv run pytest`
- **Rust**: 
  - cargo: `cargo test`
- **Go**: 
  - go test: `go test ./...`
- **Ruby**: 
  - RSpec: `bundle exec rspec`
- **Java**: 
  - Gradle: `./gradlew test`
  - Maven: `./mvnw test`
- **C#**: 
  - .NET: `dotnet test`

### 1. Red Phase（テスト作成）
- @docs/cc-xp/stories/<id>.md の受け入れ条件をテストに変換
- 言語に適したテストファイルを作成
- テスト実行して**失敗を確認**（これが重要！）
- **Redコミット**：
  ```bash
  git add tests/
  git commit -m "test: 🔴 ${story_title}のテストを追加"
  ```

### 2. Green Phase（最小実装）
- テストを通すための**最もシンプルな**実装
- ハードコーディングでもOK（後で改善）
- テストが通ったことを確認
- **Greenコミット**：
  ```bash
  git add src/ lib/ # 実装ファイル
  git commit -m "feat: ✅ ${story_title}の最小実装"
  ```

### 3. Refactor Phase（改善）
- 重複を除去
- 名前を改善
- でも**やりすぎない**（YAGNI）
- テストが通り続けることを確認
- **Refactorコミット**：
  ```bash
  git add -u
  git commit -m "refactor: ♻️ ${story_title}のコード改善"
  ```

### 4. 進捗更新
- 現在日時を取得：
  ```bash
  current_time=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  ```
- backlog.yaml の status を `testing` に更新、`updated_at` を $current_time に設定
- 変更をコミット：
  ```bash
  git add docs/cc-xp/backlog.yaml
  git commit -m "chore: ストーリー ${id} を testing に更新"
  ```
- 簡潔な実装サマリーを表示

## テストの例（モダンな書き方）

### TypeScript + Bun/Vitest
```typescript
import { expect, test, describe } from "bun:test"; // or "vitest"

describe("ゲーム盤面", () => {
  test("10×20のサイズである", () => {
    const board = createBoard();
    expect(board.width).toBe(10);
    expect(board.height).toBe(20);
  });
});
```

### Python + pytest
```python
def test_game_board_size():
    board = create_board()
    assert board.width == 10
    assert board.height == 20
```

### Rust
```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_game_board_size() {
        let board = create_board();
        assert_eq!(board.width, 10);
        assert_eq!(board.height, 20);
    }
}
```

## 次コマンド

```text
動作確認とレビュー：
/cc-xp:review
```
