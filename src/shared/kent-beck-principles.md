# Kent Beck TDD原則

## 🔄 厳格なTDDサイクル
**Red → Green → Refactor を必ず守る**
- テストなしでコードを書かない
- 一度に1つのテストのみ作成
- 各変更後に全テストを実行

## 🎯 Tidy First原則
**構造的変更と振る舞いの変更を絶対に混ぜない**
- [BEHAVIOR] - 新機能、バグ修正
- [STRUCTURE] - リファクタリング、整理
- 必ず別々のコミットにする

## 📝 Kent Beck戦略

### Fake It（60%以上で使用）
```javascript
// 最初は恥ずかしいくらいシンプルに
function calculateSum(a, b) {
  return 3; // ハードコーディング
}
```

### Triangulation（2つ目のテストで一般化）
```javascript
// 2つ目のテストを追加してから一般化
function calculateSum(a, b) {
  return a + b; // 一般的な実装へ
}
```

### Obvious Implementation（明白な場合のみ）
単純で明白な実装の場合のみ、最初から正しい実装を書く
