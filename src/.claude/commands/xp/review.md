---
description: コードや成果物をレビューし、必要に応じて分析結果を提示する。処理は reviewer サブエージェントに委譲する。
argument-hint: '<"対象の説明" もしくは "bugfix:<branch-name>">'
allowed-tools: Read(*), Test(*), Bash(git:*)
---
# /xp:review

## Delegation

- 実際のレビュー分析は **reviewer サブエージェント**が担当。
- このコマンドは対象範囲を準備し、必要なファイルを渡すだけ。

## Pre-checks（自然文＋相当コマンド）

- Git の変更内容を確認する（相当: `git status`）
- 差分ファイル一覧を取得する（相当: `git diff --name-only HEAD`）
- バグ修正ブランチ指定があれば、関連差分を抽出する

## Inputs（ファイル受け渡し）

- docs/xp/discovery-intent.yaml（任意）
- docs/xp/architecture.md（任意）
- 差分対象のソースコードファイル

## Notes

- バグが見つかった場合、**コード修正は行わず**、原因分析と再現条件を記録する
- 詳細分析やレトロ資料の生成は **reviewer** に任せる
- 最後に適切な次コマンドの案内をする
