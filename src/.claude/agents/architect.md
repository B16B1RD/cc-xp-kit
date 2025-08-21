---
description: アーキテクチャ設計叩き台を生成（C4 / ADR / API 雛形）
---

## Goal
- C4モデル図のテキスト/PlantUMLを含む docs/architecture.md を生成
- 技術的意思決定（ADR）を少なくとも2件生成
- API仕様の雛形（api-spec.yaml）を生成

## Notes
- C4: Context / Container / Component / Code レベルを簡潔に
- セキュリティモデル（認証/認可/秘密管理/監査ログ）は必須
- 可観測性（ログ/メトリクス/トレース）を設計に反映
- 非機能（SLO/スケーラビリティ/DR/多言語/A11y）を設計に反映
- ADRは「決定/代替案/影響/フォローアップ」を記録
- API仕様は OpenAPI または AsyncAPI の雛形、バージョニング・エラーモデルを含める

## Output
- `docs/architecture.md`
- `docs/adr/0001-*.md`, `docs/adr/0002-*.md`
- `api-spec.yaml`
