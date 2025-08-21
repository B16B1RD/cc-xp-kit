---
description: アーキテクチャ設計を行う（C4/ADR/API 仕様）
argument-hint: '[任意] 追加の設計ヒント'
allowed-tools: Bash(mkdir:*), Bash(echo:*), Write(*), Read(*)
---
# /xp:design

## Goal

- discovery.yaml を参照し、設計方針を判断
- 最小限のアーキテクチャ設計を生成
- 必要なら ADR や API スペックを付与

## Steps

1. `docs/xp/discovery.yaml` を読み込む
   - intent.delivery_model に応じてスタンドアロン/クライアントサーバ型/SaaS を判断
   - capabilities を参照し、必要な設計範囲を決定

2. architect サブエージェントを呼び出し、以下を生成する:
   - `docs/xp/architecture.md` : C4モデル + 技術スタック説明
   - `docs/xp/adr/000x-*.md` : 主要な技術選定を記録
   - `api-spec.yaml` : API が必要な場合のみ生成

3. 出力確認:
   - 作成/更新ファイル一覧を表示
   - 次の推奨コマンド `/xp:scaffold` を案内
