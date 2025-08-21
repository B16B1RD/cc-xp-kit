---
description: プロジェクトを実行/ビルドして動作プレビューを行う。実処理は previewer サブエージェントに委譲する。
argument-hint: '[任意] プレビューの観点や動かしたいシナリオ（例: "スタンドアロンHTMLの起動確認"）'
allowed-tools: Read(*), Bash(npm:*), Bash(pnpm:*), Bash(yarn:*), Bash(deno:*), Bash(go:*), Bash(python:*), Bash(uv:*), Test(*)
---
# /xp:preview

## Delegation

- 実際のプレビュー計画立案・実行・結果記録は **previewer サブエージェント**が担当。
- 本コマンドは前処理（ファイル受け渡し・チェック）と委譲のみを行う。

## Pre-checks（自然文＋相当コマンド）

- プレビューに必要なメタ情報の有無を確認する：
  - `docs/xp/discovery-intent.yaml`（あれば参照）  
  - `docs/xp/architecture.md`（あれば参照）
- 代表的な起動手段の存在を確認する（存在確認のみ。変更は行わない）：
  - Node系: `package.json` の `scripts.start` / `scripts.dev` / `scripts.build`（相当コマンド: `cat package.json`）
  - Python系: `pyproject.toml` / `requirements.txt`（相当コマンド: `test -f pyproject.toml`）
  - Deno/Go: 主要エントリ（相当コマンド: `ls -1`）
  - スタンドアロンHTML: `index.html`（相当コマンド: `test -f index.html || test -f public/index.html`）

## Inputs（ファイル受け渡し）

- docs/xp/discovery-intent.yaml（任意／配布形態に応じたプレビュー方法の選択に使用）
- docs/xp/architecture.md（任意）
- package.json / pyproject.toml / requirements.txt / deno.json など（任意）

## Notes

- **ソースコードの書き換えは行わない。**（プレビューのためのビルド/起動は可）
- エラーや不具合が見つかった場合は **/xp:review** の実行を案内し、バグ分析（analysis.yaml）へ引き継ぐ。
