# 高度なスラッシュコマンド例

このディレクトリには、Claude Code のスラッシュコマンドの高度な使用例が含まれています。これらの例は、動的コンテンツ、YAML frontmatter、および Claude Code の機能を最大限に活用する方法を示しています。

## 含まれるコマンド

### 1. health-check.md - プロジェクト健康診断
プロジェクトの全体的な健康状態を診断する包括的なコマンドです。

**特徴:**
- 動的なプロジェクトタイプ検出
- テストとLintの実行結果表示
- Git状態の確認
- 推奨アクションの提案

**使用例:**
```bash
/health-check        # クイック診断
/health-check full   # 詳細診断
```

### 2. smart-commit.md - インテリジェントGitコミット
コンテキストを理解して適切なコミットメッセージを生成します。

**特徴:**
- 変更内容の自動分析
- プロジェクトのコミット規約に準拠
- コミットタイプの自動判定
- 詳細な変更内容の表示

**使用例:**
```bash
/smart-commit                    # 全ての変更をコミット
/smart-commit src/*.js          # 特定ファイルのみ
/smart-commit --amend           # 最新コミットを修正
```

### 3. context-gather.md - プロジェクトコンテキスト収集
新しいプロジェクトや機能開発を始める際に、プロジェクトの全体像を把握します。

**特徴:**
- プロジェクト構造の可視化
- 主要ファイルの自動検出
- コード統計の表示
- Git情報の収集

**使用例:**
```bash
/context-gather              # 全体的なコンテキスト
/context-gather frontend     # フロントエンドに焦点
/context-gather testing      # テスト環境に焦点
```

## 動的コンテンツの活用

これらのコマンドは以下の動的機能を使用しています:

### ! 記法 (Bashコマンド実行)
```markdown
!`git status --short`
!`npm test 2>&1 | tail -20`
!`find . -name "*.test.*" | wc -l`
```

### @ 記法 (ファイル参照)
```markdown
@package.json
@README.md
@CLAUDE.md
```

### $ARGUMENTS (ユーザー入力)
```markdown
診断モード: $ARGUMENTS
フォーカスエリア: $ARGUMENTS
```

## セキュリティ考慮事項

各コマンドは `allowed-tools` で必要最小限の権限のみを要求:

```yaml
allowed-tools:
  - Bash(git status:*)      # Git状態確認のみ
  - Bash(npm test)          # テスト実行のみ
  - Read(*.json)            # JSONファイル読み取り
  - Grep                    # 検索機能
```

## カスタマイズ方法

これらのコマンドは、あなたのプロジェクトに合わせてカスタマイズできます:

1. **プロジェクト固有の設定を追加**
   ```yaml
   allowed-tools:
     - Bash(yarn test)  # npm の代わりに yarn
   ```

2. **独自のチェック項目を追加**
   ```markdown
   ### カスタムチェック
   !`./scripts/custom-check.sh`
   ```

3. **出力フォーマットを調整**
   ```markdown
   ## 📊 レポート（$ARGUMENTS フォーマット）
   ```

## インストール方法

これらのコマンドを使用するには:

1. ファイルを適切な場所にコピー:
   ```bash
   # ユーザー用
   cp health-check.md ~/.claude/commands/
   
   # プロジェクト用
   cp health-check.md .claude/commands/
   ```

2. Claude Code で使用:
   ```bash
   /health-check
   /smart-commit
   /context-gather
   ```

## 学習リソース

- [スラッシュコマンド仕様書](../../docs/slash-command-spec.md)
- [ベストプラクティス集](../../docs/best-practices.md)
- [Claude Code 公式ドキュメント](https://docs.anthropic.com/en/docs/claude-code/slash-commands)

これらの例を参考に、あなた独自の高度なスラッシュコマンドを作成してください！