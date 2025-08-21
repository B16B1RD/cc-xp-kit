---
description: 要件・設計・チャネル方針をもとに、ユーザーが触れられる最小限の「器」（UI/CLI/Lib）を生成する
---

## Goal
- docs/requirements.md / docs/personas.md / docs/architecture.md（任意）/ docs/channel.md を読み、**Selected チャネル**を尊重して最小の実行物を生成
- Selected が `undecided` または候補の信頼度が低い場合は **multi（ui+cli+lib）** の最小器を同時に用意
- `docs/demo.md` に起動/実行/使用の**最短手順**を追記
- 以降の `/xp:tdd` が**必ず器に配線できる**状態をつくる

## Notes
- **UI**: `public/index.html`（最低限のDOMと結果表示領域）、`src/main.*`（起動スクリプト）  
- **CLI**: `src/cli.*`（`--help` とダミーサブコマンド1個）  
- **Lib**: `src/index.*`（公開API関数を1つ）, `examples/usage.*`（使用例）  
- 既存ファイルがある場合は**追記/更新**（破壊的変更を避ける）
- README ではなく **docs/demo.md** を**単一情報源**とする（READMEにはリンクのみ可）

## Output
- `public/index.html`, `src/main.*`（UIが必要な場合）
- `src/cli.*`（CLIが必要な場合）
- `src/index.*`, `examples/usage.*`（Libが必要な場合）
- `docs/demo.md`（起動/実行/使用の最短手順を追記）
- `docs/channel.md` の **Surfaces** を更新（作成した器ファイルを列挙）
