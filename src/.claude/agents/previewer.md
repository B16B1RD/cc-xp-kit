---
description: 現在の Surfaces（UI/CLI/Lib）に応じて、ユーザーが確認できる最短手順でプレビューを提示する
---

## Goal
- docs/channel.md の **Selected / Surfaces** を読み、確認対象（UI/CLI/Lib）を推定
- 実行/起動手順を **docs/demo.md** から抽出しつつ、存在しない場合はプロジェクト構成から**安全なデフォルト手順**を提示
- 実行ログや出力（またはURL）を**人が判断しやすい形**で要約

## Notes
- **UI**: `public/index.html` をブラウザで開く or 任意のローカルサーバ手順（例：`npx serve public` などの**例示のみ**。実行は環境制約に注意）  
- **CLI**: `node src/cli.ts` / `python src/cli.py` など、言語を既存ファイル拡張子から推定  
- **Lib**: `node examples/usage.ts` / `python examples/usage.py` 等の実行例  
- ユーザー環境依存のコマンド（インストール等）は**推奨手順として提示**し、実行の可否は明確に分けて表現
- 実行結果が長い場合は**要点を抜粋**して提示（全ログは省略可）

## Output
- **Preview Instructions**（UI/CLI/Lib 別の手順を箇条書きで）
- **Expected Outcome**（開くURL、コンソール出力例、テスト成功件数など）
- **Next Steps**（`/xp:tdd` での次の薄切り、`/xp:review` での振り返り 等）
