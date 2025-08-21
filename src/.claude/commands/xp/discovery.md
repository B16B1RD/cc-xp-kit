---
description: 曖昧要件を Intent Model に構造化し、capabilities を信頼度つきで提示。結果を docs/xp/discovery-intent.yaml に永続化する。
argument-hint: "<要件テキスト（数行でOK）>"
allowed-tools: Read(*), Edit(*), MultiEdit(*)
---

## Context
- 参考資料（任意）: README.md, docs/xp/**/*.md
- 既存の意図ファイル（任意）: docs/xp/discovery-intent.yaml
- テンプレ: docs/xp/templates/discovery-intent.yaml（存在しない場合は生成して良い）

## Task
1. intake-classifier サブエージェントを用いて、次の内容を Markdown と YAML の両方で作成する。
   - **Intent Model**（目的/文脈/データ範囲/協調/配布/運用/将来像）
   - **Capability Candidates**（`name` / `confidence` / `rationale`）
   - **Non-Functional (Initial)**
   - **Risks & Assumptions**
   - **Open Questions（優先度順 Top3–5）**
   - **Machine-readable YAML**（上記の凝縮版）

2. Machine-readable YAML は、**ファイルとして必ず保存**すること。
   - 保存先: `docs/xp/discovery-intent.yaml`
   - 既存ファイルがある場合は、今回の解析結果を反映して**上書き**する（互換フィールドは極力保持）。
   - YAML 構造は以下に準拠する（不足フィールドは安全に追加する）:
     ```yaml
     intent:
       outcome: "<string>"
       user_context:
         connectivity: "<online|offline|mixed>"
         devices: ["<desktop>", "<mobile?>"]
         shared_device: <bool>
       delivery_model: "<standalone-html|pwa|desktop|mobile|cli|library>"
       data_scope: "<local|org|public>"
       collaboration: "<none|async|realtime>"
       persistence_need: "<none|short|long|strong-consistency>"
       privacy_security:
         pii: <bool>
         payment: <bool>
         age_restriction: <bool>
       operational_constraints:
         no_server: <bool>
         low_cost: <bool>
         maintenance_team: "<none|small|dedicated>"
       roadmap_hints: ["<...>"]
     capabilities:
       - name: "<capability-name>"
         confidence: 0.0-1.0
         rationale: "<why>"
     non_functional:
       performance:
         frame_target: "<e.g. 60fps>"
         input_latency_ms_p95: <number>
         initial_load_budget_kb: <number>
       distribution: "<string>"
       accessibility: "<string>"
       observability: "<string>"
     risks: ["<...>"]
     assumptions: ["<...>"]
     open_questions:
       - "<...>"
       - "<...>"
     ```

3. Markdown 出力では、以下の順でセクションを提示する（人間レビュー用）。
   1) **Intent Model**  
   2) **Capability Candidates（confidence降順）**  
   3) **Non-Functional (Initial)**  
   4) **Risks & Assumptions**  
   5) **Open Questions（Top3–5）**  
   6) **保存先**: `docs/xp/discovery-intent.yaml` に保存した旨と差分要約（新規/更新フィールド）

4. Open Questions がある場合は、**優先質問**として太字で再掲し、回答が得られたら
   `docs/xp/discovery-intent.yaml` の該当フィールド（intent / capabilities / non_functional など）へ反映して
   再度 `/xp:discovery` を実行してよい旨を案内する。

## Notes
- 「スタンドアロン」等の単語だけで意思決定しない。**Intent Model**（目的/文脈/データ/協調/配布/運用/将来）を総合して capabilities を提案する。
- capabilities は **必ず** `name / confidence / rationale` の3点セットで提示すること（信頼度しきい値は design 側で使用）。
- 互換性: 既存の `docs/xp/discovery-intent.yaml` があれば読み込み、破壊的変更を避けつつ差分を統合する（未知フィールドは温存）。

## Next Steps
- **/xp:design** は `docs/xp/discovery-intent.yaml` を**必須**入力として参照し、confidence に基づき
  単一案 / 分岐案 / MVP+拡張 を選択して設計を生成する。
- 質問が未解決のままなら、回答を追記してから **/xp:discovery** を再実行し、YAML を上書き更新する。
