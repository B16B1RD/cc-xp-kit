---
description: プロジェクトの最小実行可能な足場を生成する（scaffolder サブエージェント利用）
argument-hint: "[任意] プロジェクト名や簡単な説明（空でも可）"
allowed-tools: Read(*), Edit(*), MultiEdit(*)
---
# /xp:scaffold

## Goal

- discovery / design の成果物（requirements / acceptance / architecture）を可能な限り活用して、
  動作可能な最小アプリ足場を生成する。
- 形態（GUI / CLI / API / ライブラリ等）は Intent Model を参考に推定する。
- 「ユーザーが動かせる最小の何か」を必ず含める（単なる Hello ではなく、薄いユースケースの実行可能形）。
- ドキュメント、依存ファイル、起動スクリプトを含める。

## Pre-checks（自然文）

- `docs/xp/`, `src/`, `tests/` が存在するか確認し、なければ作成する。
- プロジェクトの依存定義ファイルが存在しない場合は、対象スタックに応じた最小内容で初期化する
  （例：Nodeなら `package.json`、Pythonなら `pyproject.toml` 等）。

## Inputs to scaffolder

- requirements: `docs/xp/requirements.md`（なければ README の最小情報を利用）
- personas: `docs/xp/personas.md`（任意）
- acceptance: `docs/xp/acceptance_criteria.feature`（任意）
- architecture: `docs/xp/architecture.md`（任意／存在すれば最優先）
- argument: "$ARGUMENTS"（任意）

## Task

1) **プロジェクト構造**（src/, tests/, docs/xp/）の作成/補完
2) **実行可能コード**の配置（MVPの最小ユースケースを実行可能に）
3) **依存定義**の最小更新（例：package.json / requirements.txt など）
4) **README.md** に起動・テスト実行方法を追記
5) **tests/** に最小のスモークテストを追加（起動確認/エントリポイント確認）

## Post-checks（自然文） & Next Steps

- 設計ドキュメント（`docs/xp/architecture.md`）の有無を確認する。
  - **存在する場合**：TDD に進める前提が揃っていることを案内する。
  - **存在しない場合**：まず **/xp:design** の実行を案内する。
- 受け入れ基準（`docs/xp/acceptance_criteria.feature`）の有無を確認する。
  - **存在する場合**：その内容に沿って **/xp:tdd "<最初のストーリー名>"** を案内する。
  - **存在しない場合**：**/xp:doc acceptance** もしくは **/xp:discovery** で補完するよう案内する。
