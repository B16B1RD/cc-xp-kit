# Kent Beck式エラー対応

## 🛑 エラー時の3つの質問
1. **最もシンプルな解決方法は？**
2. **Fake Itで一旦解決できないか？**
3. **問題を小さく分割できないか？**

## 対応手順

### 1. テストで再現
```javascript
test("エラーを再現する最小テスト", () => {
  // エラーが起きる条件を最小限で記述
  expect(() => problematicFunction()).toThrow();
});
```

### 2. Fake Itで解決
```javascript
function problematicFunction() {
  // まず動くようにする
  return "fixed"; // 後で改善
}
```

### 3. コミットして記録
```bash
git commit -m "[BEHAVIOR] Fix error with Fake It approach"
```

### 4. 次のサイクルで改善
- 三角測量で一般化
- 段階的にリファクタリング

## ⚠️ 避けるべきこと
- 複雑なライブラリの追加
- 大規模な設計変更
- 複数問題の同時解決
- Stack Overflowのコピペ
