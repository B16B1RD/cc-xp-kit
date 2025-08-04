---
description: XP retro – 振り返りと継続的改善
allowed-tools: Bash(date), Bash(git:*), ReadFile, WriteFile
---

## ゴール

短いサイクルを振り返り、**次をもっと良く**するための学びを得る。

## XP原則

- **振り返り**: 定期的に立ち止まって改善
- **勇気**: 問題を直視し、変化を受け入れる
- **継続的改善**: 小さな改善を積み重ねる
- **透明性**: Gitログから客観的データを収集

## 手順

1. **Gitログから実績データを収集**
   ```bash
   # 今回のイテレーションのコミット数
   commit_count=$(git log --oneline --since="2 hours ago" | wc -l)
   
   # TDDサイクルの実施確認（Red/Green/Refactorコミット）
   red_commits=$(git log --oneline --since="2 hours ago" | grep -c "🔴")
   green_commits=$(git log --oneline --since="2 hours ago" | grep -c "✅")
   refactor_commits=$(git log --oneline --since="2 hours ago" | grep -c "♻️")
   
   # 完了したストーリー
   completed_stories=$(git log --oneline --since="2 hours ago" | grep -c "✨")
   ```

2. **メトリクスファイルから追加データ収集**
   - 完了ストーリー数とポイント
   - サイクルタイム
   - テストカバレッジ（可能なら）
   - 使用ツールの効果

3. **シンプルな振り返り**（多くても3つずつ）
   - **Good**: うまくいったこと
   - **Bad**: 改善が必要なこと
   - **Try**: 次に試すこと

4. **メトリクス更新**
   現在日時を取得してメトリクスを更新：
   ```bash
   current_time=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
   ```
   
   metrics.json の内容：
   ```json
   {
     "velocity": 8,
     "cycleTime": 45,
     "testCoverage": 85,
     "toolchain": "bun + vitest",
     "completedStories": $completed_stories,
     "tddCycles": {
       "red": $red_commits,
       "green": $green_commits,
       "refactor": $refactor_commits
     },
     "commitCount": $commit_count,
     "lastUpdated": "$current_time"
   }
   ```

5. **振り返り結果をコミット**
   ```bash
   git add docs/cc-xp/metrics.json
   git commit -m "docs: 📊 イテレーション振り返り - $(date +%Y-%m-%d)"
   ```

6. **次のアクション提示**
   - 未完了ストーリーがある → 継続
   - すべて完了 → 新しい計画
   - ツールチェーンの最適化提案

## 出力例

```markdown
## イテレーション振り返り

### 📊 実績（Gitログより）
- コミット数: 12
- TDDサイクル: Red(3) → Green(3) → Refactor(3)
- 完了ストーリー: 2（8ポイント）
- サイクルタイム: 45分
- 使用ツール: Bun + Vitest（起動が高速！）

### 💡 学び
**Good**: 
- TDDサイクルを厳密に守れた（Red/Green/Refactor各3回）
- Bunのテスト実行が爆速
- フィーチャーブランチで安心して実験できた

**Bad**: 
- 最初のテストが大きすぎた
- コミットメッセージが曖昧なものがあった

**Try**: 
- より小さなテストから始める
- Conventional Commitsを徹底する
- Vitestのwatch機能を活用する

### 🚀 次のステップ
残りストーリーを継続：
/cc-xp:story
```

## Git統計の活用

振り返りで以下のGitコマンドも活用可能：

```bash
# 変更行数の統計
git diff --stat main..HEAD

# 誰がどれだけ貢献したか（ペアプロの場合）
git shortlog -sn --since="2 hours ago"

# ファイル変更頻度（リファクタリング対象の発見）
git log --name-only --since="2 hours ago" | grep -v "^$" | sort | uniq -c | sort -nr
```

## 次コマンド

```text
新しいイテレーション：
/cc-xp:plan "次の機能要望"

継続：
/cc-xp:story
```
