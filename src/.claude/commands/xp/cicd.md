---
description: プロジェクトの CI/CD・品質ゲート・リリース戦略を整備する。実処理は devops サブエージェントに委譲する。
argument-hint: '[任意] 追加要望（例: "Node18で動かしたい", "CodeQLも有効化"）'
allowed-tools: Read(*), Write(*), Edit(*)
---
# /xp:cicd

## Delegation

- 実際の CI/CD 設定生成・品質ゲート定義・リリース戦略作成は **devops サブエージェント**が担当。
- 本コマンドは前処理（ファイル受け渡し・存在確認）と委譲のみを行う。

## Pre-checks（自然文＋相当コマンド）

- GitHub Actions 用のディレクトリが存在するか確認し、なければ作成する  
  （相当コマンド: `mkdir -p .github/workflows`）
- テンプレがある場合は参照できることを確認する  
  （相当コマンド: `test -f docs/xp/templates/quality-gates.md` / `test -f docs/xp/templates/release-strategy.md`）
- スタック推定に必要なメタファイルの存在を確認する  
  - Node 系: `package.json`（相当: `test -f package.json`）  
  - Python 系: `pyproject.toml` または `requirements.txt`（相当: `test -f pyproject.toml || test -f requirements.txt`）  
  - Go: `go.mod`（相当: `test -f go.mod`）  
  - それ以外は devops に自動判定させる

## Inputs（ファイル受け渡し）

- docs/xp/discovery-intent.yaml（任意：非機能や配布モデルを反映）
- docs/xp/architecture.md（任意：コンテナ/サービス単位のテスト戦略反映）
- docs/xp/templates/quality-gates.md（任意：なければ devops が初期版を生成）
- docs/xp/templates/release-strategy.md（任意：なければ devops が初期版を生成）

## Notes

- 生成・更新対象の例：  
  - `.github/workflows/ci.yml`（lint / test / coverage / security）  
  - `docs/xp/quality-gates.md`（品質基準と失敗時ポリシー）  
  - `docs/xp/release-strategy.md`（段階配布/ロールバック/監査）  
- 秘密情報（トークン/キー）は**直接書き込まない**。必要なら **リポジトリの Secrets** を参照する記述に留める。
