---
description: ストーリー単位でTDD開発を実行（ATDD→Unit→実装→Refactor）
---

## Goal
- 指定ストーリーを受け入れテストから実装まで TDD で進める
- Red→Green→Refactor のサイクルを明示する
- 完了後はテスト実行方法を提示する

## Notes
- まず受け入れテスト（.feature）を書く
- 失敗する最小ユニットテストを追加
- 最小実装でGreenに
- 追加テストで一般化（triangulation）
- リファクタで設計を改善（重複排除・責務整理）
- commit メッセージを生成する

## Output
- `tests/acceptance/test_<story>.feature`
- `tests/test_<story>.spec.*`
- `src/<story>.*`
- Git commit message
