# Gitコミット規則

## タグの使用（必須）

### [BEHAVIOR] - 振る舞いの変更
```bash
git commit -m "[BEHAVIOR] Add tetrimino rotation"
git commit -m "[BEHAVIOR] Fix boundary check"
git commit -m "[BEHAVIOR] Implement score calculation"
```

### [STRUCTURE] - 構造的変更
```bash
git commit -m "[STRUCTURE] Extract collision detection"
git commit -m "[STRUCTURE] Rename variables for clarity"
git commit -m "[STRUCTURE] Move game logic to separate file"
```

### [INIT] - 初期化・設定
```bash
git commit -m "[INIT] TDD environment setup"
git commit -m "[INIT] Add test framework"
```

## ルール
- 1コミット = 1つの論理的変更
- テスト実行（タイムアウト対策）:
  ```bash
  npm test -- --watchAll=false --forceExit 2>&1
  ```
- すべてのテストが通ってからコミット
- コンパイラ警告ゼロ
