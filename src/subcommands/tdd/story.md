---
description: "要望からユーザーストーリーを作成し、受け入れ基準を設定。プロダクトオーナーの視点で価値を定義します。"
argument-hint: "作成したいストーリーの説明（例: ログイン機能）"
allowed-tools: ["Write", "Read", "LS", "WebSearch", "Bash"]
---

# ユーザーストーリーの作成

要望: $ARGUMENTS

## 指示

以下を実行してください：

1. **要望を分析**してプロジェクトタイプを判定してください（web-app/api-server/cli-tool）。

2. **技術スタックを選択**してください。重要な制約：
   - **JavaScriptプロジェクト**: bunまたはpnpmを使用してください。**npmは避けてください**。
   - **Pythonプロジェクト**: uvまたはpoetryを使用してください。**pipは避けてください**。
   - **その他の言語**: 最新のモダンなツールを優先してください。

3. **`.claude/agile-artifacts/project-config.json`** を作成して選択した技術スタックを記録してください。

4. **ユーザーストーリー**を3つのリリースに分けて作成してください：
   - Release 0: 最初の30分で見えるもの（2-3ストーリー）
   - Release 1: 基本的な価値（3-4ストーリー）
   - Release 2: 継続的な価値（3-4ストーリー）

5. **`.claude/agile-artifacts/stories/project-stories.md`** にストーリーを保存してください。

6. **Gitコミット**を実行してストーリーファイルをコミットしてください（コミット規則は @~/.claude/commands/shared/commit-rules.md を参照）：
   ```bash
   git add .claude/agile-artifacts/
   git commit -m "[BEHAVIOR] Create user stories with modern tech stack"
   ```

## 原則

- **YAGNI**: 今必要ない機能は含めない
- **検証可能**: 曖昧な基準を避ける（受け入れ基準は @~/.claude/commands/shared/mandatory-gates.md を参照）
- **段階的**: 小さく始めて大きく育てる
- **モダンツール優先**: npm/pipは避け、高速なツールを使用

## 完了後

```text
📝 ストーリーとプロジェクト設定を作成しました！

🎯 プロジェクト判定: [Web App/API/CLI]
🛠️ 技術スタック: [選択された技術群]
📊 ストーリー総数: X個

次: /tdd:init (モダン環境構築)
```