---
description: CI/CD と品質ゲート、リリース戦略を生成/更新（devops サブエージェントを利用）
allowed-tools: Bash(mkdir:*), Read(*), Edit(*), MultiEdit(*)
---
# /xp:cicd

## Goal

- devops サブエージェントでCI/CD設定と品質ゲート/リリース戦略を生成
- .github/workflows/ci.yml / docs/quality-gates.md / docs/release-strategy.md に保存する

## Pre-steps (Bash)

以下のディレクトリをなければ作成する
- .github/workflows
- docs/xp/

## Task

Produce FULL file bodies for:

- .github/workflows/ci.yml（lint/test/coverage/依存脆弱性）
- docs/xp/quality-gates.md（閾値・Fail条件・例外扱いの手順）
- docs/xp/release-strategy.md（フラグ/段階配布/ロールバック/DR/監査）

Notes:

- CIは再現性のあるセットアップ（依存インストール、テスト、Lint、Coverage）
- 品質ゲートは「Fail条件を数値で明示」
- リリース戦略は「段階配布/フラグ/ロールバック」必須

## Write

- Replace entire content of `.github/workflows/ci.yml`
- Replace entire content of `docs/xp/quality-gates.md`
- Replace entire content of `docs/xp/release-strategy.md`

## Summary

- 作成/更新したファイル一覧
- 次の推奨コマンド：`/xp:review`
