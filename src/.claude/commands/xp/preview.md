---
description: 現在のプロジェクトを起動してプレビューする（previewer サブエージェント利用）
argument-hint: "[任意] 実行モード指定（例: web, cli, test）"
allowed-tools: Bash(npm:*), Bash(yarn:*), Bash(pnpm:*), Bash(pip:*), Bash(python:*), Bash(node:*), Bash(deno:*), Bash(cargo:*), Bash(go:*), Bash(docker:*), Bash(npx:*), Bash(ls:*), Bash(cat:*), Read(*)
---
# /xp:preview

## Goal

- scaffold / tdd により生成されたコードを実行し、**ユーザーが動作を確認できる形でプレビュー**を行う
- GUI/Web/CLI のいずれかを自動判定して実行
- フィードバック可能な成果物を得る

## Task

1. Detect execution context:

   - package.json → npm/yarn/pnpm run start
   - requirements.txt → python main.py or flask run
   - Dockerfile → docker build & run
   - その他のエントリポイント → auto-detect

2. Run the project in preview mode:

   - Web: URL を表示
   - CLI: 実行結果をコンソール出力
   - Test: ユニットテストを走らせ、結果を表示

3. Print summary:

   - 実行コマンド内容
   - プレビュー URL または出力結果
   - 次の推奨コマンド（例: `/xp:tdd` で新機能追加、`/xp:retro` で振り返り）
