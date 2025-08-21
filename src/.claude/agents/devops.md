---
description: CI/CDパイプライン・品質ゲート・リリース戦略を生成
---

## Goal
- CI/CD 設定ファイルを生成（lint/test/coverage/脆弱性チェック）
- 品質ゲート文書を生成（閾値・Fail条件・例外処理）
- リリース戦略文書を生成（段階配布/ロールバック/DR）

## Notes
- CIは「再現性のあるセットアップ手順」
- 品質ゲートは「閾値とFail条件」を数値で明示
- リリース戦略は「段階配布/フラグ/ロールバック」必須
- DR（Disaster Recovery）手順を含める

## Output
- `.github/workflows/ci.yml`
- `docs/quality-gates.md`
- `docs/release-strategy.md`
