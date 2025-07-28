---
allowed-tools:
  - Bash(test -f package.json && echo "true" || echo "false")
  - Bash(test -f tsconfig.json && echo "TypeScript" || echo "JavaScript")
  - Bash(npm test 2>&1 | tail -20)
  - Bash(npm run lint 2>&1 | tail -10)
  - Bash(git status --short)
  - Bash(find . -name "*.test.*" -o -name "*.spec.*" | wc -l)
  - Read(package.json)
  - Grep
description: プロジェクトの健康状態を総合的に診断
argument-hint: "[quick|full]"
---

# 🏥 プロジェクト健康診断レポート

診断モード: **$ARGUMENTS**

## 📊 プロジェクト基本情報

### プロジェクトタイプ

- Node.js プロジェクト: !`test -f package.json && echo "✅ Yes" || echo "❌ No"`
- 言語: !`test -f tsconfig.json && echo "TypeScript" || echo "JavaScript"`

### プロジェクト設定

@package.json

## 🧪 テスト状況

### テストファイル数

!`find . -name "*.test.*" -o -name "*.spec.*" | wc -l` 個のテストファイル

### テスト実行結果

!`npm test 2>&1 | tail -20`

## 🔍 コード品質

### Lintチェック

!`npm run lint 2>&1 | tail -10`

### TODOコメント

Grep を使用して TODO コメントを検索:

- `// TODO`
- `# TODO`
- `/* TODO`

## 📝 Git状態

### 変更ファイル

!`git status --short`

## 🎯 推奨アクション

以下の点を確認してください:

1. **テストカバレッジ**: テストが不足している場合は追加を検討
2. **Lint エラー**: 修正が必要なコード品質の問題
3. **未コミットの変更**: 重要な変更は適切にコミット
4. **TODOコメント**: 未実装の機能や改善点の確認

---

💡 **ヒント**: より詳細な診断が必要な場合は `/health-check full` を実行してください。
