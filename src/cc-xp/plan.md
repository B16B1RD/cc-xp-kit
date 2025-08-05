---
description: XP plan – 次のイテレーションを計画する（YAGNI原則：必要なものだけ）
argument-hint: '"ウェブブラウザで遊べるテトリスが欲しい"'
allowed-tools: Bash(date), Bash(echo), Bash(git:*), ReadFile, WriteFile
---

## ゴール

$ARGUMENTS から**最小限の価値あるストーリー**を抽出し、1〜2時間で完了できる小さなイテレーションを計画する。

## XP原則

- **シンプルさ**: 最もシンプルな解決策から始める
- **YAGNI**: 今必要なものだけを計画に入れる
- **小さなリリース**: 動くソフトウェアを素早く届ける
- **継続的インテグレーション**: 頻繁なコミットで進捗を共有

## 手順

1. **Git状態の確認**
   ```bash
   # リポジトリの初期化（必要な場合）
   [ ! -d .git ] && git init
   
   # 現在のブランチと状態を確認
   git status --short
   ```

2. @docs/cc-xp/backlog.yaml があれば既存ストーリーを確認

3. $ARGUMENTS から**ユーザー価値**を見出し、ストーリー候補を生成
   - 「誰が」「何を」「なぜ」を明確にする
   - 技術的タスクではなくユーザー価値で表現
   - 初回の場合は環境構築も最小限のストーリーとして含める

4. 各ストーリーに **Size(1,2,3,5,8)** と **Value(High/Medium/Low)** を割り当て

5. @docs/cc-xp/metrics.json のベロシティを参考に、**最も価値の高い**ストーリーを選定

6. 選定したストーリーの status を `selected` に更新

7. 現在日時を取得してストーリーに記録：
   ```bash
   current_time=$(date +"%Y-%m-%dT%H:%M:%S%:z")
   ```

8. **変更をコミット**：
   ```bash
   git add docs/cc-xp/backlog.yaml
   git commit -m "feat: イテレーション計画 - $(echo "$ARGUMENTS" | head -c 50)..."
   ```

9. シンプルな表で結果を表示

## モダンな開発環境

要求に応じて高速で開発体験の良いツールチェーンを選択：

- **JavaScript/TypeScript**: Bun または pnpm + Vite
- **Python**: uv + Ruff + pytest
- **Rust**: Cargo（標準で既にモダン）
- **Go**: Go modules（標準で既にモダン）
- **Ruby**: mise (旧rtx) + Bundler
- **Java**: SDKMAN + Gradle/Maven
- **C#**: .NET CLI（標準で既にモダン）
- **Elixir**: asdf + Mix
- **その他**: 各言語の最新推奨ツール

## backlog.yaml の構造

```yaml
stories:
  - id: 1722259123
    title: 'ゲーム画面を表示する'
    size: 3
    value: High
    status: selected  # todo | selected | in-progress | done
    created_at: $current_time
    updated_at: $current_time
```

## 次コマンド

```text
最初のストーリーを詳細化：
/cc-xp:story
```
