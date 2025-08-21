---
description: Discovery の Intent Model / YAML を読み取り、確度に応じて 単一案 / 分岐案 / MVP+拡張 で設計を生成する。
---
# /xp:design

## Inputs

- docs/xp/requirements.md（存在すれば）
- 直近の /xp:discovery の **Machine-readable YAML**（docs/xp/discovery-intent.yaml）

## Task

Use the architect subagent to:

1) Intent Model / capabilities の **confidence しきい値**に従い、設計出力方針を選ぶ。
   - 単一案 / 分岐案 / **MVP + Optional Add-ons**
2) 生成:
   - docs/xp/architecture.md（C4：MVP=実線、Optional=点線。非機能/可観測性/セキュリティを反映）
   - docs/xp/adr/0001-runtime-model.md（MVPの実行形態）
   - docs/xp/adr/0002-data-persistence.md（保存/同期の方針）
   - 必要時のみ api/*.stub.yaml（冒頭に「未採用（採用条件：…）」を明記）
3) 「最初に実装すべき TDD ストーリー」候補を3件以内で提示（MVP達成に直結するもの）。

## Next Steps（条件付き案内）

- `api/*.stub.yaml` を生成した場合：
  - 「いまは未採用。採用条件」を **docs/adr にも記録**し、必要なら **/xp:review** で意思決定を共有。
- 認証や外部依存が **未採用** の場合：
  - **/xp:tdd "<MVPの最初のストーリー>"** を案内（例：ローカル高スコア保存/読み出し）。
- 認証や外部依存が **採用候補（信頼度中）** の場合：
  - **/xp:discovery** で該当する Open Questions を再確認し、閾値を上げてから採否判断。
