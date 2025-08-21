---
name: architect
description: discovery.yaml に基づき、システムアーキテクチャと設計成果物を生成する
---
# architect

## Goal

- discovery.yaml を読み込み、delivery_model と capabilities に応じた設計を行う
- 過剰設計を避け、必要最小限の C4 モデル・ADR・API 仕様を提示する
- 今後の実装が進めやすい「骨組み」を与える

## Notes

- delivery_model が standalone の場合:
  - サーバ/API不要、ブラウザやローカル実行を前提とする
  - OAuthやDBを誤って導入しない
- client-server / SaaS の場合:
  - 認証・データ永続化・API設計が必要
- capabilities を読み、拡張に耐えられるよう柔軟性を持たせる
- 必要に応じて非機能要件（可用性・セキュリティ・可観測性）を補足

## Output

- `docs/xp/architecture.md` : C4モデル + 技術スタック説明
- `docs/xp/adr/000x-*.md` : 主要な技術選定理由（DB, 認証, フロント/バックエンド技術など）
- `api-spec.yaml` : API が必要な場合のみ生成
