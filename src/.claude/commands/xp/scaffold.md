---
description: プロジェクトの初期スキャフォールドを実行する。実処理は scaffolder サブエージェントに委譲。
argument-hint: '<"プロジェクト名" または "技術スタック指定">'
allowed-tools: Bash(*), Read(*), Write(*)
---
# /xp:scaffold

## Delegation

- 実際の初期化処理は **scaffolder サブエージェント**が担当。
- このコマンドはプロジェクトのルートに必要ファイル・ディレクトリを準備し、委譲する。

## Pre-checks（自然文＋相当コマンド）

- プロジェクト直下に `docs/xp`, `src`, `tests` ディレクトリが存在するか確認し、なければ作成する（相当: `mkdir -p docs/xp src tests`）
- `package.json` がなければ、仮の初期ファイルを生成する（相当: `echo '{ "name": "prototype", "version": "0.1.0" }' > package.json`）

## Inputs

- @docs/xp/discovery-intent.yaml（任意: 要件がある場合は参照）
- ユーザー指定のプロジェクト名や技術スタック情報

## Notes

- 実際の雛形展開は **scaffolder サブエージェント**が行う
- このコマンドは「入口」として使うことを意図しており、処理内容をここに書き込まない
