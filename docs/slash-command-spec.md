# Claude Code スラッシュコマンド完全仕様書

## 概要

Claude Code のスラッシュコマンドは、頻繁に使用するプロンプトをMarkdownファイルとして定義し、`/`コマンドで簡単に実行できる機能です。

## ファイル構造と配置

### 配置場所

1. **プロジェクト用コマンド**
   - パス: `.claude/commands/`
   - 特徴: プロジェクト固有、チームで共有可能
   - 優先度: ユーザー用より高い

2. **ユーザー用コマンド**
   - パス: `~/.claude/commands/`
   - 特徴: すべてのプロジェクトで利用可能
   - 優先度: プロジェクト用より低い

### ファイル形式

- **拡張子**: `.md` (Markdown)
- **エンコーディング**: UTF-8
- **改行コード**: LF推奨

### 命名規則

- **基本コマンド**: `command-name.md` → `/command-name`
- **ネームスペース**: `namespace/command.md` → `/namespace:command`
- **正規化**: 小文字、ハイフンをアンダースコアに変換

例:
```
.claude/commands/
├── tdd.md                  # /tdd
├── tdd-quick.md           # /tdd-quick
└── tdd/
    ├── init.md            # /tdd:init
    ├── story.md           # /tdd:story
    └── plan.md            # /tdd:plan
```

## YAML Frontmatter

### 基本構造

```yaml
---
allowed-tools: [ツールリスト]
description: コマンドの簡潔な説明
argument-hint: 期待される引数の形式
---
```

### allowed-tools フィールド

#### 基本構文

- `ToolName` - すべてのアクションを許可
- `ToolName(*)` - 任意の引数を許可
- `ToolName(filter)` - 特定のパターンのみ許可

#### ツール別の例

**ファイル操作:**
```yaml
allowed-tools: 
  - Edit                    # すべての編集を許可
  - Read(*)                 # すべてのファイル読み取りを許可
  - Write(src/*)            # src/内への書き込みのみ
  - MultiEdit               # 複数ファイルの一括編集
```

**Bashコマンド:**
```yaml
allowed-tools:
  - Bash(*)                 # すべてのコマンド（リスキー）
  - Bash(ls *)              # lsコマンドのみ
  - Bash(git add:*)         # git addの任意の引数
  - Bash(npm install)       # npm installのみ（引数なし）
```

**検索ツール:**
```yaml
allowed-tools:
  - Grep                    # すべてのGrep操作
  - Glob(*.js)              # JavaScriptファイルのみ
  - LS                      # ディレクトリリスト
```

**その他のツール:**
```yaml
allowed-tools:
  - WebSearch               # Web検索
  - WebFetch                # URL取得
  - Task                    # エージェントタスク
  - TodoWrite               # TODOリスト管理
```

### 複合的な許可設定

```yaml
---
allowed-tools:
  # Git操作関連
  - Bash(git status:*)
  - Bash(git add:*)
  - Bash(git commit:*)
  - Bash(git log *)
  # ファイル操作
  - Read(*)
  - Edit
  # 検索
  - Grep
description: Git操作と開発支援の統合コマンド
argument-hint: "[commit message]"
---
```

## 動的コンテンツ

### $ARGUMENTS プレースホルダー

ユーザーからの入力を受け取る:

```markdown
---
description: イシューを修正
argument-hint: "issue-number"
---

# Issue #$ARGUMENTS の修正

要求されたイシュー番号: $ARGUMENTS
```

使用例: `/fix-issue 123` → `$ARGUMENTS` が `123` に置換

### ! 記法 (Bashコマンド実行)

コマンドの実行結果を埋め込む:

```markdown
---
allowed-tools: Bash(git status), Bash(git diff HEAD)
---

## 現在の状態

### Git Status:
!`git status --short`

### 変更内容:
!`git diff HEAD`
```

**重要**: `allowed-tools` での許可が必須

### @ 記法 (ファイル参照)

ファイルやディレクトリを参照:

```markdown
## プロジェクト構造

@src/

## 設定ファイル:
@package.json

## 複数ファイル参照:
@src/index.js @src/utils.js
```

- ファイル: 内容を表示
- ディレクトリ: ファイルリストを表示
- 相対パス・絶対パス両対応

## 高度な使用例

### 1. 動的Git コミットコマンド

```yaml
---
allowed-tools: 
  - Bash(git add:*)
  - Bash(git status:*)
  - Bash(git commit:*)
  - Bash(git diff HEAD)
  - Bash(git log *)
description: インテリジェントなGitコミット作成
---

## コンテキスト

- 現在のステータス: !`git status --short`
- 変更内容: !`git diff HEAD`
- 最近のコミット: !`git log --oneline -5`

## タスク

上記の変更に基づいて、適切なコミットメッセージを作成してコミットしてください。
```

### 2. プロジェクト分析コマンド

```yaml
---
allowed-tools:
  - Bash(find . -name "*.js" | wc -l)
  - Bash(npm list --depth=0)
  - Grep
  - Read(*)
description: プロジェクトの健康診断
argument-hint: "[detailed|summary]"
---

# プロジェクト分析 ($ARGUMENTS モード)

## ファイル統計
- JavaScriptファイル数: !`find . -name "*.js" | wc -l`
- TypeScriptファイル数: !`find . -name "*.ts" | wc -l`

## 依存関係
!`npm list --depth=0`

## package.json
@package.json
```

### 3. テスト実行とレポート

```yaml
---
allowed-tools:
  - Bash(npm test)
  - Bash(npm run coverage)
  - Read(coverage/*)
description: テスト実行と結果分析
---

# テスト実行

## テスト結果
!`npm test`

## カバレッジ
!`npm run coverage`

## レポート詳細
@coverage/lcov-report/index.html
```

## セキュリティベストプラクティス

### 1. 最小権限の原則

```yaml
# 悪い例 - 過度に広い権限
allowed-tools: Bash(*)

# 良い例 - 必要最小限
allowed-tools: 
  - Bash(npm test)
  - Bash(npm run build)
```

### 2. パス制限

```yaml
# 特定ディレクトリのみ編集可能
allowed-tools:
  - Edit(src/*)
  - Read(*)
  - Write(dist/*)
```

### 3. 危険なコマンドの回避

```yaml
# 避けるべき
allowed-tools: Bash(rm -rf *)

# 安全な代替
allowed-tools: Bash(rm dist/bundle.js)
```

## トラブルシューティング

### コマンドが認識されない

1. ファイル拡張子が `.md` か確認
2. 配置場所が正しいか確認
3. ファイル名の特殊文字を確認

### 動的コンテンツが動作しない

1. `allowed-tools` で許可されているか確認
2. Bashコマンドの構文エラーを確認
3. ファイルパスが正しいか確認

### Frontmatterが読み込まれない

1. YAML構文が正しいか確認
2. インデントが正しいか確認
3. 特殊文字のエスケープを確認

## 互換性とバージョン

- Claude Code 最新版で完全サポート
- 動的コンテンツは v1.0.0 以降
- Frontmatterは v0.9.0 以降

## 関連ドキュメント

- [Claude Code公式ドキュメント](https://docs.anthropic.com/en/docs/claude-code/slash-commands)
- [ベストプラクティス集](./best-practices.md)
- [高度な使用例](../examples/advanced-commands/)