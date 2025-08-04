---
description: XP story – ユーザーストーリーを詳細化（対話重視）
argument-hint: '[id] ※省略時は最初の selected を使用'
allowed-tools: Bash(date), Bash(git:*), ReadFile, WriteFile
---

## ゴール

ストーリーを**ユーザーとの対話**として詳細化し、明確な受け入れ条件を定義する。

## XP原則

- **コミュニケーション**: ストーリーはユーザーとの約束
- **フィードバック**: 受け入れ条件で期待を明確化
- **勇気**: 不明点があれば仮定を置いて進む
- **継続的インテグレーション**: 各ステップをコミット

## 手順

1. 対象ストーリーを特定（$ARGUMENTS または最初の selected）

2. **フィーチャーブランチの作成**：
   ```bash
   # ストーリー用のブランチを作成
   git checkout -b story-${id}
   ```

3. ユーザー視点でストーリーを記述：
   ```
   As a [ユーザー]
   I want [機能]
   So that [価値]
   ```

4. **具体的な**受け入れ条件を 3つ以内で定義（Given-When-Then形式）

5. 現在日時を取得：
   ```bash
   current_time=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
   ```

6. @docs/cc-xp/stories/<id>.md に保存（作成日時付き）

7. backlog.yaml の status を `in-progress` に更新、`updated_at` を更新

8. **変更をコミット**：
   ```bash
   git add docs/cc-xp/stories/${id}.md docs/cc-xp/backlog.yaml
   git commit -m "docs: ストーリー詳細化 - ${title}"
   ```

## ストーリーファイルの構造

```markdown
---
created_at: $current_time
---

# Story: ゲーム画面を表示する

## ユーザーストーリー
As a プレイヤー
I want ブラウザでテトリスを開く
So that すぐに遊び始められる

## 受け入れ条件

### シナリオ1: 初回アクセス
Given ブラウザでURLを開いたとき
When ページが読み込まれたら
Then 10×20のゲーム盤面が表示される

### シナリオ2: ゲーム開始
Given ゲーム画面が表示されているとき
When スペースキーを押したら
Then ブロックが落下し始める
```

## 次コマンド

```text
TDDサイクルを開始：
/cc-xp:develop
```
