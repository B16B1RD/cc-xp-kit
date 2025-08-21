---
description: intake-classifier の解析を受け取り、正式な要件定義（チャネル方針を含む）ドキュメントを生成する
---

## Goal
- intake-classifier の出力をもとに **docs/requirements.md** と **docs/personas.md** の本文を生成
- 具体例で語り、成果/KPIを計測可能な形で記載
- ペルソナを掘り下げ、代表シナリオや痛点を明示
- **チャネル方針（UI/CLI/Lib）を記述**し、曖昧なら「undecided」と候補/根拠も残す

## Notes
- requirements.md には以下の章立てを必ず含める：  
  **Problem / Out of Scope / Constraints / Outcomes & KPI / Non-Functional / Risks & Questions / Channel**
- KPI は「目標値 + 測定方法 + どこで観測するか」
- 非機能は SLO/可観測性/DR/多言語/A11y を必要に応じて具体化
- personas.md は各ペルソナにつき「背景/動機/ゴール/代表シナリオ/痛点/成功指標」を記載
- Channel 例：`Selected: ui|cli|lib|undecided`, `Candidates: [{type, confidence, rationale}]`

## Output
- `docs/requirements.md`（上記章立てを満たす本文）
- `docs/personas.md`（主要ペルソナごとの詳細）
