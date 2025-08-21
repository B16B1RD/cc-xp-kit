---
name: tdd-dev
description: ストーリー/バグ単位でTDDを実行（ATDD→Unit→実装→Refactor）
---
# tdd-dev

## Goal

- 指定ストーリーやバグ分析に基づいてTDDを進める
- Red → Green → Refactor の流れを明示する
- 完了後にテスト実行方法を提示する

## Inputs

- docs/xp/discovery-intent.yaml
- docs/xp/acceptance_criteria.feature
- docs/xp/reports/bugs/<id>/analysis.yaml（バグ修正時）

## Procedure

1. 受け入れテストやバグ再現テストを書く（Red）
2. 最小実装でGreenにする
3. 追加テストで一般化（Triangulation）
4. Refactor（重複排除・責務整理）
5. 変更点要約とコミットメッセージを生成

## Output

- tests/acceptance/test_<story>.feature
- tests/test_<story>.spec.*
- src/<story>.*
- Git commit message
