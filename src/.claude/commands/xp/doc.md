---
description: ドキュメント雛形の生成（docs/templates から必要なテンプレを展開）
allowed-tools: Bash(mkdir:*), Bash(test:*), Read(*), Edit(*), MultiEdit(*)
argument-hint: "<requirements|acceptance|architecture|adr|test-strategy|runbook|quality-gates|release-strategy>"
---
# /xp:doc

## Goal

- 指定された種類のドキュメント雛形を docs/xp に展開する
- 存在しなければ新規作成、存在する場合は全置換で更新する
- 各テンプレに「埋め方ガイド」を追記する

## Pre-steps (Bash)

以下のディレクトリーがなければ作成する
- docs/xp/templates

## Task

- "$ARGUMENTS" に対応するテンプレートを docs/xp/ に作成
- 併せて「各セクションの埋め方ガイド」をファイル末尾に追加

Notes:

- adr の場合は `docs/xp/adr/000x-template.md` として次の番号で作成
- 既存ファイルがあれば全置換

## Write

- requirements → docs/xp/requirements.md
- acceptance → docs/xp/acceptance_criteria.feature
- architecture → docs/xp/architecture.md
- adr → docs/xp/adr/000x-template.md
- test-strategy → docs/xp/test_strategy.md
- runbook → docs/xp/runbook.md
- quality-gates → docs/xp/quality-gates.md
- release-strategy → docs/xp/release-strategy.md

## Summary

- 作成/更新したファイル一覧
- 次の推奨コマンド：`/xp:discovery` または `/xp:design`
