---
description: XP develop – Value-Driven TDD（価値駆動）による本質価値実現
argument-hint: '[id] ※省略時は in-progress ストーリーを使用'
allowed-tools: Bash(git:*), Bash(date), Bash(test), Bash(bun:*), Bash(npm:*), Bash(pnpm:*), Bash(uv:*), Bash(python:*), Bash(pytest:*), Bash(cargo:*), Bash(go:*), Bash(bundle:*), Bash(dotnet:*), Bash(gradle:*), Bash(npx:*), Bash(ls), WriteFile, ReadFile, mcp__playwright__*
---

# 🚨 絶対禁止事項 - 必読 🚨

## ⛔ STATUS = DONE への変更は絶対禁止 ⛔

```
🚨 CRITICAL WARNING 🚨
❌ develop では status: done への変更は絶対に禁止
❌ done に設定すると重大なワークフロー破壊が発生
❌ 一度でも done にすると後続処理に深刻な影響

✅ develop では必ず status: testing で停止
✅ done への変更は /cc-xp:review accept でのみ許可
✅ この禁止事項を違反した場合は即座にエラー停止
```

**🔒 三層防御システム 🔒**
- **防御層1**: 開始時の強制確認
- **防御層2**: 各フェーズでの status 確認  
- **防御層3**: 完了前の最終確認

---

# XP Develop - 価値駆動 TDD

## ゴール

**Value-Driven TDD** により、ユーザーが実際に価値を体験できるソフトウェアを実装する。

## 🛡️ 防御層1: 開始時の強制確認

### STEP 0-1: Git リポジトリ確認（最優先）

**🚨 最初に必ず実行してください 🚨**

Gitリポジトリが初期化されているか確認してください。初期化されていない場合は以下を自動実行してください：

1. `git init` でリポジトリを初期化
2. `git branch -m main` でデフォルトブランチをmainに変更
3. `git add .` で全ファイルをステージング
4. `git commit -m "Initial commit"` で初期コミットを作成

Git設定（user.name, user.email）が未設定の場合も適切に設定してください。設定が必要な場合はグローバル設定として自動設定してください。

### STEP 0-2: STATUS 更新処理

**🚨 この処理を次に必ず実行 🚨**

backlog.yamlのステータスを確認し、以下の処理を実行してください：

1. 現在のステータスを確認
2. `status: done`になっている場合は**CRITICAL ERROR**として処理を停止
3. `status: in-progress`を`status: testing`に更新
4. 更新後のステータスを確認

**✅ 確認必須項目**:
- [ ] status が testing に正しく更新された
- [ ] done になっていない  
- [ ] updated_at が現在時刻

### STEP 1: 価値理解確認

backlog.yaml から確認。
- `core_value`（本質価値）が明確。
- `minimum_experience`（最小価値体験）が具体的。
- `value_story`が価値体験中心。

## 🛡️ 防御層2: Red-Green-Refactor フェーズ

### Phase 1: Value-First Red（価値優先失敗テスト）

**🚨 フェーズ開始前の status 確認 🚨**
```bash
echo "=== Red Phase 開始前 status 確認 ==="
if grep -q "status: done" docs/cc-xp/backlog.yaml; then
    echo "🚨 ERROR: status が done に変更されています！"
    echo "❌ Red Phase を停止します"
    exit 1
fi
```

#### 1. 本質価値テスト作成

- `core_value`を検証するテスト
- ユーザーが実際に体験できることをテスト
- 技術的詳細ではなく、価値体験をテスト

#### 2. Red状態確認

- すべてのテストが失敗（Red 状態）
- 失敗理由が「価値がまだ実現されていない」

### Phase 2: Value-Driven Green（価値実現実装）

**🚨 フェーズ開始前の status 確認 🚨**

backlog.yamlのステータスを確認してください。`status: done`になっている場合は処理を停止してください。

#### 1. 本質価値実装

- `core_value`を実現する実装
- ユーザーが実際に価値を体験できる実装
- 「楽しい」「便利」と感じられる実装

#### 2. 価値体験確認（プロジェクトタイプ別）

**Webアプリケーションの場合**:
開発サーバーをバックグラウンドで起動してください。package.jsonに"dev"スクリプトがある場合は、既存の同名プロセスを停止してからnpm run devを実行してください。

起動後は適切なポート（5173など）でアクセス可能か確認してください。

### Phase 3: Value-Maximizing Refactor（価値最大化の最適化）

**🚨 フェーズ開始前の status 確認 🚨**

backlog.yamlのステータスを確認してください。`status: done`になっている場合はRefactor Phaseを停止してください。

#### 1. 品質最適化

- コードの可読性・保守性向上
- パフォーマンス最適化
- エラーハンドリング強化

## 🛡️ 防御層3: 完了前の最終確認

### STEP FINAL: 絶対確認処理

**🚨 この処理を完了前に必ず実行 🚨**

最終STATUS確認を実行してください：

1. backlog.yamlのステータスを確認
2. `status: done`になっている場合は**CRITICAL ERROR**として強制的に`status: testing`に修正
3. 最終的に`status: testing`であることを確認
4. testing以外の場合は処理を停止

### コミット処理

以下の手順でコミットを実行してください：

1. **backlog.yamlのコミット**:
   - ファイル: `docs/cc-xp/backlog.yaml`
   - メッセージ: "develop: ストーリーを testing に更新 - done 禁止厳守"

2. **実装ファイルのコミット**:
   - ファイル: 全ての変更ファイル（`.`）
   - メッセージ: "feat: 価値駆動TDD実装完了 - testing段階"

各コミット前に、ステージング、変更確認、コミット実行の手順を実行してください。

## 完了サマリー

開発完了後、以下を表示。

```
🎯 Value-Driven TDD 完了
=========================
ストーリー: [ストーリータイトル]
ブランチ: story-[ID]
ステータス: testing ✅

実施フェーズ:
✅ Value-First Red - 価値テスト作成
✅ Value-Driven Green - 価値実現実装  
✅ Value-Maximizing Refactor - 価値最大化。

🚨 重要確認事項 🚨
✅ status = testing (done ではない)
✅ 価値体験が実装済み
✅ すべてのテストが成功
```

## 次のステップ

```
🚀 次のステップ
================
価値検証とレビューを実施:
→ /cc-xp:review

レビューオプション:
• accept - すべて満足時のみ
• reject "理由" - 修正要求
• skip - 判定保留

💡 重要
- status は testing のまま
- done への変更は review accept でのみ
```

## エラーハンドリング

### status が done になった場合の緊急対応

backlog.yamlで`status: done`を検出した場合は、即座に`status: testing`に修正してください。

修正後は以下を実行してください：
1. 修正ファイルをコミット（メッセージ: "EMERGENCY: status を done から testing に緊急修正"）
2. ステータスが正しく修正されたかを確認

## 重要な注意事項

- **🚨 絶対禁止**: develop で status を done にすることは絶対禁止
- **✅ 必須**: 各フェーズで status 確認する
- **🔒 防御**: 三層防御システムで完全ガード
- **⚡ 緊急**: done 検出時は即座に停止・修正

この防御システムにより、status=done 問題を完全に解決します。