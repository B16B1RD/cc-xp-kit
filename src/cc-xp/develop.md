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

### STEP 0: STATUS 更新処理（最優先）

**🚨 この処理を最初に必ず実行 🚨**

```bash
# backlog.yaml の status を確認
echo "=== 現在のステータス確認 ==="
grep -A 5 -B 5 "status:" docs/cc-xp/backlog.yaml | head -20

# done になっていたら CRITICAL ERROR
if grep -q "status: done" docs/cc-xp/backlog.yaml; then
    echo "🚨 CRITICAL ERROR: status が done になっています！"
    echo "❌ develop では done への変更は絶対禁止"
    echo "❌ 即座に停止します"
    exit 1
fi

# in-progress から testing に更新
sed -i 's/status: in-progress/status: testing/' docs/cc-xp/backlog.yaml

echo "=== 更新後のステータス確認 ==="
grep -A 5 -B 5 "status:" docs/cc-xp/backlog.yaml | head -20
```

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
```bash
echo "=== Green Phase 開始前 status 確認 ==="
if grep -q "status: done" docs/cc-xp/backlog.yaml; then
    echo "🚨 ERROR: status が done に変更されています！"
    echo "❌ Green Phase を停止します"
    exit 1
fi
```

#### 1. 本質価値実装

- `core_value`を実現する実装
- ユーザーが実際に価値を体験できる実装
- 「楽しい」「便利」と感じられる実装

#### 2. 価値体験確認（プロジェクトタイプ別）

**Webアプリケーションの場合**:
```bash
# 開発サーバーをバックグラウンドで起動
if [ -f package.json ] && grep -q '"dev"' package.json; then
    echo "🚀 開発サーバー起動中..."
    pkill -f "npm.*dev" 2>/dev/null || true
    nohup npm run dev > dev.log 2>&1 & echo $! > .dev-server.pid
    sleep 3
    
    if curl -s http://localhost:5173 >/dev/null 2>&1; then
        echo "✅ アクセス可能: http://localhost:5173"
    else
        echo "❌ サーバー起動失敗"
    fi
fi
```

### Phase 3: Value-Maximizing Refactor（価値最大化の最適化）

**🚨 フェーズ開始前の status 確認 🚨**
```bash
echo "=== Refactor Phase 開始前 status 確認 ==="
if grep -q "status: done" docs/cc-xp/backlog.yaml; then
    echo "🚨 ERROR: status が done に変更されています！"
    echo "❌ Refactor Phase を停止します"
    exit 1
fi
```

#### 1. 品質最適化

- コードの可読性・保守性向上
- パフォーマンス最適化
- エラーハンドリング強化

## 🛡️ 防御層3: 完了前の最終確認

### STEP FINAL: 絶対確認処理

**🚨 この処理を完了前に必ず実行 🚨**

```bash
echo "=== 最終 STATUS 確認（CRITICAL） ==="

# done になっていたら緊急停止
if grep -q "status: done" docs/cc-xp/backlog.yaml; then
    echo "🚨🚨🚨 CRITICAL ERROR 🚨🚨🚨"
    echo "❌ status が done に変更されています！"
    echo "❌ これは重大な違反です"
    echo "❌ 即座に修正します"
    
    # 強制修正
    sed -i 's/status: done/status: testing/' docs/cc-xp/backlog.yaml
    echo "✅ status を testing に強制修正しました"
fi

# 最終確認
echo "=== 最終確認結果 ==="
grep -A 3 -B 3 "status:" docs/cc-xp/backlog.yaml

# testing であることを確認
if grep -q "status: testing" docs/cc-xp/backlog.yaml; then
    echo "✅ status: testing - 正常"
else
    echo "❌ status が testing ではありません - 修正が必要"
    exit 1
fi
```

### コミット処理

```bash
# backlog.yaml をコミット
git add docs/cc-xp/backlog.yaml
git commit -m "develop: ストーリーを testing に更新 - done 禁止厳守"

# 実装ファイルをコミット  
git add .
git commit -m "feat: 価値駆動TDD実装完了 - testing段階"
```

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

```bash
# 1. 即座に検出・修正
grep -q "status: done" docs/cc-xp/backlog.yaml && {
    echo "🚨 EMERGENCY: status=done を検出"
    sed -i 's/status: done/status: testing/' docs/cc-xp/backlog.yaml
    echo "✅ testing に緊急修正完了"
}

# 2. 修正をコミット
git add docs/cc-xp/backlog.yaml
git commit -m "EMERGENCY: status を done から testing に緊急修正"

# 3. 確認
grep "status:" docs/cc-xp/backlog.yaml
```

## 重要な注意事項

- **🚨 絶対禁止**: develop で status を done にすることは絶対禁止
- **✅ 必須**: 各フェーズで status 確認する
- **🔒 防御**: 三層防御システムで完全ガード
- **⚡ 緊急**: done 検出時は即座に停止・修正

この防御システムにより、status=done 問題を完全に解決します。