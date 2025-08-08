---
description: XP plan – 次のイテレーションを計画する（YAGNI原則：必要なものだけ）
argument-hint: '"ウェブブラウザで遊べるテトリスが欲しい"'
allowed-tools: Bash(date), Bash(echo), Bash(git:*), Bash(test), Bash(mkdir:*), Bash(cat), ReadFile, WriteFile
---

## ゴール

「$ARGUMENTS」から**最小限の価値あるストーリー**を抽出し、1〜2時間で完了できる小さなイテレーションを計画する。

## XP原則

- **シンプルさ**: 最もシンプルな解決策から始める
- **YAGNI**: 今必要なものだけを計画に入れる
- **小さなリリース**: 動くソフトウェアを素早く届ける
- **継続的インテグレーション**: 頻繁なコミットで進捗を共有

## 現在の状態確認

### Git環境
- リポジトリ状態確認: !test -d .git
- 現在のブランチ: !git branch --show-current
- 未コミット変更: !git status --short

### 未コミット変更の警告

未コミット変更がある場合（`git status --porcelain` の出力が空でない場合）、以下の警告を表示してください：

```
⚠️ 未コミットの変更が検出されました
=====================================

以下のファイルに変更があります：
[git status --short の出力をここに表示]

【推奨アクション】
1. 現在の変更をコミット:
   git add .
   git commit -m "現在の作業を保存"

2. 変更を一時的に退避:
   git stash push -m "計画前の作業"

3. 変更を破棄（注意！）:
   git checkout -- .

新しいイテレーション計画を開始する前に、
現在の作業を適切に処理することを推奨します。
```

### プロジェクト構造
- ディレクトリ確認: !test -d docs/cc-xp/stories
- backlog確認: !test -f docs/cc-xp/backlog.yaml
- metrics確認: !test -f docs/cc-xp/metrics.json

### E2Eテスト環境の確認

**MCP Playwright環境の検出**：
Claude Code環境でMCP Playwrightが利用可能かどうかを確認してください。利用可能な場合は以下を表示：

```
✅ MCP Playwright が利用可能です
==================================
以下の機能が使用できます：
• 自動ブラウザ操作
• スクリーンショット取得
• 要素の自動検出とクリック
• フォーム入力の自動化

WebアプリケーションのE2Eテストが自動実行されます。
```

**通常Playwright環境の検出**：
- Playwright設定確認: !test -f playwright.config.ts || test -f playwright.config.js
- package.json内Playwright確認: !grep -q "playwright" package.json 2>/dev/null || echo "not found"

利用可能な場合：
```
⚠️ 通常のPlaywrightが検出されました
=================================
MCP Playwrightは利用不可ですが、
通常のPlaywrightでE2Eテストを実行できます。

npx playwright test
```

**E2Eテスト非対応環境**：
両方とも利用不可の場合：
```
ℹ️ E2Eテスト環境が見つかりません
==============================
Webアプリケーションの場合は手動テストを推奨します。

次のツールの導入を検討してください：
• MCP Playwright（Claude Code環境）
• Playwright（npm install playwright）
```

### タイムスタンプ
- 現在時刻: !date +"%Y-%m-%dT%H:%M:%S%:z"
- イテレーションID: !date +%s

## タスク

### 1. 環境の準備

必要に応じて以下を実行してください：

**Gitの初期化**（.gitディレクトリがない場合）
```bash
git init
```

**ディレクトリ構造の作成**（docs/cc-xp/storiesがない場合）
```bash
mkdir -p docs/cc-xp/stories
```

**metrics.jsonの初期化**（存在しない場合）
`docs/cc-xp/metrics.json` を以下の内容で作成：
```json
{
  "velocity": 0,
  "cycleTime": 0,
  "testCoverage": 0,
  "toolchain": "未設定",
  "completedStories": 0,
  "tddCycles": {
    "red": 0,
    "green": 0,
    "refactor": 0
  },
  "commitCount": 0,
  "lastUpdated": "[現在時刻]",
  "iterations": []
}
```

### 2. ユーザー要望の分析

「$ARGUMENTS」を分析し、以下の観点でユーザーストーリーを抽出してください：

- **誰が使うのか**（ユーザーペルソナ）
- **何をしたいのか**（機能）
- **なぜ必要なのか**（価値）

### 3. ストーリー候補の生成

最も価値の高いものから順に3〜5個のストーリーを生成し、それぞれに割り当ててください：

- **Size**: 1, 2, 3, 5, 8（フィボナッチ数列）
- **Value**: High, Medium, Low
- **初回の場合**: 環境構築も最小限のストーリーとして含める

既存のメトリクスがある場合は参考にしてください：
- @docs/cc-xp/metrics.json のvelocityフィールド
- 推奨合計ポイント: velocity ± 20%

### 4. 開発環境の推定

プロジェクトの性質から適切なツールチェーンを選択してください：

- **Webフロントエンド**: Bun + Vite または pnpm + Vite
- **Node.jsバックエンド**: Bun または pnpm
- **Python**: uv + pytest
- **その他**: 各言語の最新推奨ツール

「HTMLファイルダブルクリックだけで手軽に遊べる」という要件の場合は、外部依存のない純粋なHTML/CSS/JavaScriptを選択。

### 5. backlog.yamlの作成/更新

選定したストーリーを `docs/cc-xp/backlog.yaml` に記録：

```yaml
stories:
  - id: [イテレーションID]
    title: '[ストーリータイトル]'
    size: [ポイント]
    value: [High/Medium/Low]
    status: selected  # 重要: 新規ストーリーは必ず selected から開始
    created_at: [現在時刻]
    updated_at: [現在時刻]
    iteration_id: [イテレーションID]
```

**ステータスの流れ**：
- `selected` (plan) → `in-progress` (story) → `testing` (develop) → `done` (review accept のみ)

### 6. 変更のコミット

以下のコマンドで変更をコミットしてください：

```bash
git add docs/cc-xp/backlog.yaml docs/cc-xp/metrics.json
git commit -m "feat: イテレーション計画 - [要望の最初の50文字]..."
```

### 7. 結果の表示

選定したストーリーを表形式で表示し、次のステップを案内してください：

```
📋 選定されたストーリー
========================
ID     | タイトル              | サイズ | 価値
------ | -------------------- | ------ | ----
[ID]   | [タイトル]            | [S]    | [V]

合計ポイント: [合計]
推定時間: [1-2時間]
開発方針: [選択したツールチェーン]
```

### 重要：次のコマンドを必ず明確に表示

```
🚀 次のステップ
================
最初のストーリーを詳細化:
→ /cc-xp:story

このコマンドで:
• ユーザーストーリーを作成
• 受け入れ条件を定義
• テスト戦略を決定

💡 開発の流れ
------------
1. story: ストーリー詳細化
2. develop: TDDサイクル（Red→Green→Refactor）
3. review: 動作確認と判定
4. retro: 振り返り（適宜）

すべてのコマンド:
• /cc-xp:story - ストーリー詳細化
• /cc-xp:develop - TDD開発
• /cc-xp:review - レビューと判定
• /cc-xp:retro - 振り返り
```

## 注意事項

- 未コミットの変更がある場合は警告を表示
- 初回実行時は環境構築ストーリーを必ず含める
- YAGNIを守り、必要最小限のストーリーに絞る
