---
description: XP review – 動作確認と判定（accept/reject/skipで指定）+ 自動E2E実行
argument-hint: '[accept|reject|skip] [理由（rejectの場合）] [--skip-demo] [--skip-e2e]'
allowed-tools: Bash(git:*), Bash(date), Bash(test), Bash(kill:*), Bash(cat), Bash(bun:*), Bash(npm:*), Bash(pnpm:*), Bash(python:*), Bash(cargo:*), Bash(go:*), Bash(bundle:*), Bash(dotnet:*), Bash(gradle:*), Bash(http-server:*), Bash(lsof:*), Bash(netstat:*), Bash(npx:*), ReadFile, WriteFile, mcp__playwright__*
---

## ゴール

実際に動かしてユーザー視点で確認し、その場で承認/却下を判定する。**1回のコマンドで完結**。

## XP原則

- **動くソフトウェア**: 実際に触れるものが最高のフィードバック
- **オンサイトカスタマー**: ユーザーの立場で即座に判断
- **素早いフィードバック**: 確認から判定まで一気通貫
- **継続的インテグレーション**: 承認後は即マージ

## ステータス遷移ルール

**重要**: ステータスの正しい遷移を厳守してください。

```
selected (plan) → in-progress (story) → testing (develop) → done (review accept のみ)
                                               ↓ (reject)
                                          in-progress
```

- `done` にできるのは **`/cc-xp:review accept` のみ**
- `reject` の場合は `in-progress` に戻す
- すでに `done` のストーリーは変更不可

## 現在の状態確認

### ストーリー情報の取得
@docs/cc-xp/backlog.yaml から `testing` ステータスのストーリーを確認し、以下を取得してください：
- ストーリーID
- タイトル
- 作成日時（created_at）
- 更新日時（updated_at）
- 受け入れ条件（@docs/cc-xp/stories/[ID].md）
- フィードバック履歴（@docs/cc-xp/stories/[ID]-feedback.md）

**重要なバリデーション**：
- `testing` ステータスのストーリーがない場合は、「先に `/cc-xp:develop` を実行してください」と案内
- すでに `done` のストーリーは対象外（再レビュー不可）

**レビューサイクルの確認**：
フィードバックファイルから何回目のレビューかをカウントし、表示に反映。

### 既存プロセスの確認
- サーバー稼働確認: !test -f .server.pid
- 現在のブランチ: !git branch --show-current

## Phase 1: デモ起動（--skip-demoがない場合）

### プロジェクトタイプの判定と起動

プロジェクトの構成ファイルを確認し、適切な方法でアプリケーションを起動してください：

**検出方法：**
- package.json → Node.js/JavaScript
- requirements.txt/pyproject.toml → Python
- Cargo.toml → Rust
- go.mod → Go
- Gemfile → Ruby
- 単独のHTMLファイル → 静的サイト

**起動コマンドの例：**
- Webアプリ: 開発サーバーを起動（npm run dev, python manage.py runserver等）
- CLIツール: ヘルプとデモコマンドを表示
- API: エンドポイント一覧とテスト方法を表示
- 静的HTML: http-serverやPythonのSimpleHTTPServerで起動

起動後は以下を実行してください：
1. プロセスIDを `.server.pid` に保存
2. アクセスURLを表示
3. ログファイルの確認方法を案内

## Phase 2: E2E自動テスト実行（--skip-e2eがない場合）

### E2E戦略の確認

ストーリーファイル（@docs/cc-xp/stories/[ID].md）の`e2e_strategy`を確認：

**e2e-required または e2e-optional の場合のみ実行**

#### MCP Playwright利用時の自動E2E実行

```javascript
// 受け入れ条件を自動的にE2Eテストに変換
const story = readStoryFile(storyId);
for (const scenario of story.acceptanceCriteria) {
  await mcp__playwright__browser_navigate(serverUrl);
  await executeScenario(scenario);
  await mcp__playwright__browser_snapshot();
}
```

実行結果を表示：
```
🌐 E2Eテスト実行結果
==================
✅ シナリオ1: ログインフォーム表示
✅ シナリオ2: 正常ログイン処理  
✅ シナリオ3: エラーハンドリング

スクリーンショット: 3枚保存
実行時間: 12.3秒
```

#### 通常Playwright利用時

```bash
npx playwright test --headed --reporter=html
```

#### E2E非対応環境またはunit-onlyの場合

この段階をスキップし、Phase 3へ進む。

## Phase 3: 動作確認ガイドの表示

ストーリーの受け入れ条件を基に、確認すべきポイントを表示してください：

```
📋 確認ポイント
===============
ストーリー: [タイトル]

受け入れ条件：
□ [シナリオ1の要約]
□ [シナリオ2の要約]
□ [シナリオ3の要約]（あれば）

確認手順：
1. [具体的な操作]
2. [期待される結果]
```

## Phase 4: 動作確認と判定

### 引数なしの場合（デフォルト）
ストーリーの受け入れ条件と確認手順を表示し、以下のガイダンスを提供：

```
📋 確認ポイント
===============
ストーリー: [タイトル]
ブランチ: story-[ID]
ステータス: testing
レビュー回数: [X]回目

全体進捗:
- 完了ストーリー: [X]/[総数]
- 現在のイテレーション時間: [経過時間]

受け入れ条件：
□ [シナリオ1の要約]
□ [シナリオ2の要約]
□ [シナリオ3の要約]（あれば）

確認手順：
1. [具体的な操作]
2. [期待される結果]

デモURL: [起動したURL]

E2Eテスト結果:
[実行された場合のみ表示]
🌐 E2Eテスト: [✅成功/❌失敗/➖スキップ]
```

フィードバックファイルが存在する場合は追加表示：
```
⚠️ 前回のフィードバック（[何回目]）
====================================
[前回の却下理由の要約]
詳細: docs/cc-xp/stories/[ID]-feedback.md

修正確認ポイント:
• [前回の問題が解決されているか]
• [新たな問題が発生していないか]
```

動作確認後、最後に必ず以下を表示：

```
🤔 動作確認後の判定方法
====================
すべての条件を満たしている場合:
→ /cc-xp:review accept

修正が必要な場合:
→ /cc-xp:review reject "理由"

判定を保留する場合:
→ /cc-xp:review skip

💡 判定のポイント
---------------
• 受け入れ条件をすべて確認
• ユーザー視点で使いやすさを評価
• 前回の問題が解決されているか確認
• 新たな問題が発生していないか確認
```

### 引数で判定が指定された場合
$ARGUMENTS の最初の単語を確認：
- `accept`: Phase 4のAccept処理を実行
- `reject`: Phase 4のReject処理を実行（理由は引数の残り部分）
- `skip`: Phase 4のSkip処理を実行

## Phase 5: 判定に基づく処理

判定に応じて以下の処理を実行し、**必ず最後に次のコマンドを明確に表示**してください。

### Accept を選択した場合

**重要**: この処理でのみステータスを `done` に変更します。

1. **ストーリーの完了処理**
   - @docs/cc-xp/backlog.yaml のstatusを `testing` → `done` に更新（**Acceptの場合のみ**）
   - completed_atに現在時刻を記録: !date -u +"%Y-%m-%dT%H:%M:%SZ"
   - @docs/cc-xp/metrics.json の完了ストーリー数を増加

2. **Gitマージ処理**
   ```bash
   # テスト実行（プロジェクトに応じたコマンド）
   # mainブランチへマージ
   git checkout main
   git merge --no-ff story-[ID] -m "merge: ストーリー [ID] - [タイトル]"
   # タグ付け
   git tag -a "story-[ID]-done" -m "完了: [タイトル]"
   ```

3. **サーバー停止**（.server.pidがある場合）
   ```bash
   kill $(cat .server.pid)
   rm .server.pid
   ```

4. **完了メッセージ**
   ```
   ✨ ストーリー完了！
   ==================
   
   マージ済み: story-[ID] → main
   タグ: story-[ID]-done
   ```

5. **次のコマンド案内**（重要：必ず最後に明確に表示）
   ```
   🚀 次のステップ
   ================
   
   【選択肢1】振り返りを実施:
   → /cc-xp:retro
   （完了ストーリーが複数ある場合は特に推奨）
   
   【選択肢2】次のストーリーを開始:
   → /cc-xp:story
   （まだ selected ストーリーがある場合）
   
   【選択肢3】新しいイテレーション計画:
   → /cc-xp:plan "新しい要望"
   （すべてのストーリーが完了した場合）
   
   💡 推奨
   -------
   • 2-3個のストーリー完了ごとに振り返り
   • 時間が経過したら振り返り（2時間など）
   • 大きな学びがあったら即振り返り
   ```

### Reject を選択した場合

1. **却下理由の取得**
   引数から理由を取得（例：`reject "ボタンが小さすぎて押しにくい"`）
   理由が指定されていない場合は「詳細な理由は未記載」とする

2. **フィードバックの記録**
   - `docs/cc-xp/stories/[ID]-feedback.md` に以下の内容で記録：
   ```markdown
   # フィードバック: [ストーリータイトル]
   
   日時: [現在時刻]
   ステータス: Rejected
   修正サイクル: [何回目かを記録]
   
   ## 却下理由
   [却下理由]
   
   ## 必要な修正
   - [ ] [具体的な修正項目1]
   - [ ] [具体的な修正項目2]
   
   ## 次のアクション
   1. このフィードバックを確認
   2. テストを修正/追加
   3. 実装を改善
   4. `/cc-xp:develop` を実行して修正を実装
   ```
   - @docs/cc-xp/backlog.yaml のstatusを `testing` → `in-progress` に戻す（**重要**: doneにはしない）

3. **修正ガイドの表示**
   ```
   📝 次のアクション
   ==================
   1. フィードバックを確認: docs/cc-xp/stories/[ID]-feedback.md
   2. テストを修正/追加
   3. 実装を改善
   
   サーバーは稼働中です: [URL]
   停止する場合: kill $(cat .server.pid)
   ```

4. **次のコマンド案内**（重要：必ず最後に明確に表示）
   ```
   🚀 次のステップ
   ================
   修正を実装する:
   → /cc-xp:develop
   
   このストーリーを諦めて別のストーリーへ:
   → /cc-xp:story [別のID]
   
   💡 修正のヒント
   ---------------
   • フィードバックをよく読んで原因を理解
   • テストから修正を始める（TDD）
   • 小さな変更を積み重ねる
   ```

### Skip を選択した場合

1. **保留メッセージの表示**
   ```
   ℹ️ 判定を保留しました
   
   サーバー稼働中: [URL]
   停止方法: kill $(cat .server.pid)
   ```

2. **次のコマンド案内**（重要：最後に明確に表示）
   ```
   🚀 次のステップ
   ================
   判定を再開:
   → /cc-xp:review accept
   → /cc-xp:review reject "理由"
   
   他の作業へ:
   → /cc-xp:story [別のID]
   → /cc-xp:retro
   ```

## --skip-demo / --skip-e2e オプション時の処理

### --skip-demo オプション
引数に `--skip-demo` がある場合：
1. Phase 1（デモ起動）をスキップ
2. 既存のサーバープロセスを使用
3. Phase 2から開始

### --skip-e2e オプション
引数に `--skip-e2e` がある場合：
1. Phase 2（E2E自動テスト）をスキップ
2. Phase 3の動作確認ガイドから開始
3. 手動確認に特化

## エラーハンドリング

以下の場合は適切なメッセージを表示してください：

### ポート衝突時の対処

ポートが既に使用されている場合の自動対処：

```bash
# ポート使用状況の確認
lsof -i :3000 || netstat -an | grep :3000

# 代替ポートの探索（3001, 3002...）
for port in 3001 3002 3003 8080 8081; do
  if ! lsof -i :$port > /dev/null 2>&1; then
    echo "代替ポート $port を使用します"
    break
  fi
done
```

**エラー時の自動提案**：
```
⚠️ ポート3000が使用中です

以下のオプションがあります：
1. 既存サーバーを使用: /cc-xp:review --skip-demo
2. 代替ポート3001で起動（自動実行中...）
3. 既存プロセスを停止: kill $(lsof -t -i:3000)
```

### E2Eテスト関連エラー

**MCP Playwrightエラー**：
```
❌ MCP Playwrightエラーが発生しました

エラー: [具体的なエラーメッセージ]

対処法：
1. E2Eテストをスキップ: /cc-xp:review --skip-e2e
2. 通常Playwrightに切り替え: npx playwright install
3. 手動テストで確認
```

**通常Playwrightエラー**：
```
❌ Playwrightテストが失敗しました

以下のオプションがあります：
1. テスト修正後に再実行
2. E2Eをスキップ: /cc-xp:review --skip-e2e  
3. 手動確認に切り替え
```

### その他のエラー
- testingステータスのストーリーがない
- サーバー起動に失敗
- テスト実行に失敗
- Gitマージで競合発生

## メトリクスの更新

判定結果に関わらず、以下を@docs/cc-xp/metrics.json に記録：
- レビュー実施時刻
- 判定結果（accept/reject/exit）
- レビュー所要時間（可能なら）

## サマリー表示

処理完了後、結果に応じたサマリーと**次のコマンドを必ず最後に表示**してください。

特に重要：
- 次のコマンドは「🚀 次のステップ」として独立したセクションで表示
- 矢印（→）を使って実行可能なコマンドを明示
- 複数の選択肢がある場合はすべて列挙
