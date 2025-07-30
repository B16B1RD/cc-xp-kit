# Claude Code スラッシュコマンド ベストプラクティス集

## 基本原則

### 1. シンプルさを保つ

**良い例:**

```markdown
---
allowed-tools: Bash(npm test)
description: テストを実行
---

# テスト実行
!`npm test`
```text

**避けるべき例:**

```markdown
---
allowed-tools: Bash(*)
description: 何でもできる万能コマンド
---

複雑すぎる処理...
```text

### 2. 単一責任の原則

各コマンドは1つの明確な目的を持つべきです。

```text
/test          # テストの実行のみ
/test:coverage # カバレッジレポートのみ
/test:watch    # ウォッチモードのみ
```text

### 3. 予測可能な命名

- 動詞で始める: `/create-component`, `/run-tests`
- 一貫性を保つ: `/db:migrate`, `/db:seed`, `/db:reset`
- 略語を避ける: `/deploy` > `/dpl`

## セキュリティのベストプラクティス

### 最小権限の付与

```yaml
# ❌ 悪い例 - 過度に広い権限
allowed-tools: 
  - Bash(*)
  - Edit

# ✅ 良い例 - 必要最小限
allowed-tools:
  - Bash(npm test)
  - Bash(npm run lint)
  - Read(src/*)
```text

### 危険なコマンドの制限

```yaml
# ❌ 絶対に避ける
allowed-tools:
  - Bash(rm -rf *)
  - Bash(sudo *)
  
# ✅ 安全な代替
allowed-tools:
  - Bash(rm dist/*)
  - Bash(npm run clean)
```text

### パスの制限

```yaml
# src/ディレクトリのみ編集可能
allowed-tools:
  - Edit(src/*)
  - Write(src/*)
  - Read(*)  # 読み取りは全体を許可
```text

## 動的コンテンツの効果的な使用

### コンテキスト収集パターン

```yaml
---
allowed-tools:
  - Bash(git status --short)
  - Bash(git diff --stat)
  - Bash(git log -1 --oneline)
description: 現在の作業状況を把握
---

# 作業コンテキスト

## 変更ファイル
!`git status --short`

## 変更統計
!`git diff --stat`

## 最新コミット
!`git log -1 --oneline`

これらの情報を基に次の作業を決定してください。
```text

### 条件付き処理パターン

```yaml
---
allowed-tools:
  - Bash
  - Read(*)
description: プロジェクトタイプを判定
---

# プロジェクトタイプ判定

Bashツールで以下を実行してプロジェクトタイプを判定：
```
test -f package.json && echo "Node.js" || echo "Other"
```

@package.json
```text

### プログレッシブ情報開示

```markdown
---
allowed-tools: Bash(npm test), Read(coverage/*)
argument-hint: "[simple|detailed]"
---

# テスト結果

!`npm test`

$ARGUMENTS

詳細レポートが必要な場合は `/test-report detailed` を実行してください。
```text

## 組織化のパターン

### ネームスペースによる構造化

```text
.claude/commands/
├── db/
│   ├── migrate.md    # /db:migrate
│   ├── seed.md       # /db:seed
│   └── reset.md      # /db:reset
├── test/
│   ├── unit.md       # /test:unit
│   ├── e2e.md        # /test:e2e
│   └── all.md        # /test:all
└── deploy/
    ├── staging.md    # /deploy:staging
    └── production.md # /deploy:production
```text

### 共通設定の活用

`shared/common-tools.yaml`:

```yaml
git-tools: &git-tools
  - Bash(git status:*)
  - Bash(git add:*)
  - Bash(git commit:*)

file-tools: &file-tools
  - Read(*)
  - Edit
  - Write(src/*)
```text

コマンドでの使用:

```yaml
---
allowed-tools:
  - *git-tools
  - *file-tools
---
```text

## パフォーマンスの最適化

### 1. 不要なツール呼び出しを避ける

```yaml
# ❌ 悪い例 - 複数回の呼び出し
!`git status`
!`git status --short`

# ✅ 良い例 - 一度の呼び出し
!`git status --short`
```text

### 2. キャッシュ可能な情報の分離

```markdown
## 静的情報
@.eslintrc.json
@package.json

## 動的情報
!`git status --short`
```text

### 3. 条件付き実行

```yaml
allowed-tools: Bash(test -f tsconfig.json && npm run typecheck)
---

# TypeScriptプロジェクトの場合のみ型チェック
!`test -f tsconfig.json && npm run typecheck || echo "Not a TypeScript project"`
```text

## エラーハンドリング

### 明確なエラーメッセージ

```yaml
---
allowed-tools: ["Bash"]
---

# 環境チェック

Bashツールで以下を実行してNode.js環境確認：
```
which node || echo "ERROR: Node.js is not installed"
```
```text

### フォールバック戦略

```yaml
---
allowed-tools: 
  - Bash
  - Read(test-logs/*)
---

# テスト実行

Bashツールで以下を実行：
```
npm test || echo "Tests failed, checking logs..."
```

失敗時のログ:
@test-logs/latest.log
```text

## ドキュメンテーション

### コマンド内ヘルプ

```markdown
---
description: コンポーネントを生成
argument-hint: "component-name [options]"
---

# コンポーネント生成

使用方法:
- `/create-component Button` - 基本的なコンポーネント
- `/create-component Button --with-test` - テスト付き
- `/create-component Button --with-story` - Storybook付き

引数: $ARGUMENTS
```text

### 使用例の提供

```markdown
## 例

1. 基本的な使用:
   ```bash
   /deploy staging
   ```

1. 環境変数付き:

   ```bash
   /deploy staging --env=preview
   ```

## テストとデバッグ

### コマンドのテスト方法

1. **Dry-run モード**

```yaml
---
allowed-tools: ["Bash"]
argument-hint: "[--dry-run]"
---

$ARGUMENTS

実際のデプロイ: `npm deploy`
Dry-run: Bashツールで実行 `echo "Would run: npm deploy"`
```text

2. **デバッグ情報の出力**

```yaml
---
allowed-tools: Bash(env | grep NODE), Bash(pwd)
---

## デバッグ情報
- 作業ディレクトリ: !`pwd`
- Node環境: !`env | grep NODE`
```text

## アンチパターン

### 1. 過度に複雑なワンライナー

❌ 避ける:

```yaml
allowed-tools:
  - Bash(find . -name "*.js" -exec grep -l "TODO" {} \;)
  - Bash
```text

✅ 代わりに:

```yaml
allowed-tools: Grep
description: TODOコメントを検索
```text

### 2. ハードコードされた環境依存

❌ 避ける:

```yaml
allowed-tools: Bash(cd /Users/john/projects && npm test)
```text

✅ 代わりに:

```yaml
allowed-tools: Bash(npm test)
```text

### 3. 状態を持つコマンド

❌ 避ける:

```markdown
前回の実行結果を記憶して...
```text

✅ 代わりに:

```markdown
現在の状態: !`cat .last-run.json`
```text

## まとめ

1. **シンプルに保つ** - 複雑さは敵
2. **セキュアに設計** - 最小権限の原則
3. **予測可能に** - 驚きの最小化
4. **文書化する** - 使い方を明確に
5. **テスト可能に** - 検証方法を提供

これらのベストプラクティスに従うことで、安全で保守性が高く、チームで共有しやすいスラッシュコマンドを作成できます。
