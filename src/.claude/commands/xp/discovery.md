---
description: ユーザー要求を分析し、分類と要件定義の素案を生成する
argument-hint: '"<曖昧な要件>"'
allowed-tools: Bash(mkdir:*), Bash(echo:*), Write(*), Read(*)
---
# /xp:discovery

## Goal

- ユーザーが自然文で書いた要求を整理・分類する
- 主要なペルソナ、背景目的、capabilities を抽出する
- YAML に落とし込み、後続の design コマンドに渡せる形にする

## Steps

1. intake-classifier サブエージェントを呼び出し、与えられた要求を以下に分類する:
   - intent.delivery_model（standalone, client-server, SaaS など）
   - capabilities（機能一覧）
   - 非機能要求の示唆（性能、可用性、可観測性など）

2. requirements-engineer サブエージェントを呼び出し、上記の分類結果をもとに以下を生成する:
   - `docs/xp/discovery.yaml`
     - intent:
         delivery_model: …
     - capabilities: […]
     - personas: […]
     - background: …
   - `docs/xp/acceptance_criteria.feature` （存在しない場合のみ作成）

3. 出力確認:
   - 生成された `docs/xp/discovery.yaml` を一覧表示
   - 次の推奨コマンド `/xp:design` を案内
