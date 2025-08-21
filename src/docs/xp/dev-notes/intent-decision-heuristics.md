# Intent-Driven Decision Heuristics

本プロジェクトでは、`docs/xp/discovery-intent.yaml` を単一の情報源として設計/実装判断を行う。

## Confidence しきい値

- 0.75–1.00 : MVPで採用
- 0.40–0.74 : Optional（将来拡張）。今は実装しない or 契約/モックに留める
- 0.00–0.39 : 見送り（ADRに記述し条件が整えば再検討）

## 分岐の考え方

1. **体験（Outcome）**に直結するか？
2. **運用/配布（Delivery/Operational）**の制約を満たすか？
3. **データ範囲（Data Scope）/協調（Collaboration）**が本当に必要か？
4. 将来の Roadmap が **Optional Add-on** で差し込み可能か？

## よくある例

- `standalone-html` + `frontend-only(≥0.7)` → **完全ローカルMVP**。API/認証は Optional。
- `optional-cloud-leaderboard(0.5–0.7)` → `api/leaderboard.stub.yaml` を作成し、採用条件を ADR へ。
- `required-auth(≥0.75)` → 認証ガードの ATDD を先に作る（未ログイン時の期待挙動）。
