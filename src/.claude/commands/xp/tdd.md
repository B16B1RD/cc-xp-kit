---
description: ストーリーやバグ分析YAMLを参照してTDDを行う。処理は tdd-dev サブエージェントに委譲する。
argument-hint: '<"story 概要" もしくは "bug:<bug-id>">'
allowed-tools: Read(*), Write(*), Edit(*), MultiEdit(*), Test(*), Bash(git:*)
---
# /xp:tdd

## Delegation

- このコマンドの具体的な作業はすべて **tdd-dev サブエージェント**が実施する。
- コマンドは前処理とファイル受け渡しのみを行う。

## Pre-checks（自然文＋相当コマンド）

- 受け入れ基準が存在するか確認（相当: `test -f docs/xp/acceptance_criteria.feature`）
- 設計ドキュメントが存在するか確認（相当: `test -f docs/xp/architecture.md`）
- 引数が `bug:<id>` の場合は `docs/xp/reports/bugs/<id>/analysis.yaml` を読み取る。

## Inputs（ファイル受け渡し）

- docs/xp/discovery-intent.yaml（任意）
- docs/xp/acceptance_criteria.feature（任意）
- docs/xp/reports/bugs/<id>/analysis.yaml（バグ修正時は必須）

## Notes

- TDD の実際の手順や出力は **tdd-dev** に記述済み。ここでは触れない。
