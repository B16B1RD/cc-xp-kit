---
description: 受け入れ基準や設計、必要ならバグ分析YAMLを参照し、TDDで修正や実装を行う。ファイル連携前提でコンテキスト不要。
argument-hint: '<"story 概要" もしくは "bug:<bug-id>">'
allowed-tools: Read(*), Write(*), Edit(*), MultiEdit(*), Test(*), Bash(git:*)

---
# /xp:tdd

## Pre-checks（自然文＋相当コマンド）

- 受け入れ基準が存在するか確認（相当コマンド: `test -f docs/xp/acceptance_criteria.feature`）
- 設計文書が存在するか確認（相当コマンド: `test -f docs/xp/architecture.md`）
- 引数が `bug:<id>` パターンか判定。該当する場合は **`docs/xp/reports/bugs/<id>/analysis.yaml`** を読み込む（相当コマンド: `test -f docs/xp/reports/bugs/<id>/analysis.yaml`）

## Inputs（ファイルからのみ取得）

- `docs/xp/discovery-intent.yaml`（任意、あれば参照）
- `docs/xp/acceptance_criteria.feature`（任意）
- `docs/xp/reports/bugs/<id>/analysis.yaml`（**バグ修正時は必須**）
  - 含まれる情報：再現手順、期待/実際、原因仮説（confidence付）、失敗テスト案、関連ファイル候補

## Task（TDD手順）

Use the tdd-dev subagent. Perform:

1) **目的の特定**
   - 引数が `bug:<id>` の場合：analysis.yaml の「再現手順/期待/実際/原因仮説/失敗テスト案」を要約し、**最小の失敗テスト**を特定
   - 通常のストーリーの場合：受け入れ基準から最小の失敗テストを特定

2) **Red**：失敗するテストを追加
   - ファイル/テスト名/アサーションを明示
   - 既存テストとの重複や衝突があれば調整

3) **Green**：最小実装でテストを通す
   - analysis.yaml の「関連ファイル候補」を優先的に確認
   - 原因仮説（confidence）を参照し、修正箇所の当たりを付ける

4) **Refactor**：緑を保ったまま設計を改善（命名・重複整理・抽象化）

5) **出力**
   - 変更ファイルの一覧と**差分要約（自然文）**
   - 実行テストの結果（要約）
   - 次のテスト候補（例：境界/例外パス）

6) **バージョン管理（自然文＋相当コマンド）**
   - すべての変更をステージに追加する（相当コマンド: `git add -A`）
   - コミットメッセージを付けてコミットする  
     - バグ修正：`fix: <bug-id> - <短い概要> via TDD`（相当コマンド: `git commit -m "fix: <bug-id> - <summary> via TDD"`）  
     - 機能実装：`feat: <story-summary> via TDD`（相当コマンド: `git commit -m "feat: <story> via TDD"`）

## Heuristics（analysis.yaml 連携）

- 原因仮説が複数ある場合、**confidence の高い順**にテスト化 → 実装 → 検証
- 再現が難しい場合：**テストダブル/フェイク時間/固定乱数**などのテクニックで再現性を担保
- Optional 機能（confidence 0.40–0.75）は、**MVPではモック/契約テストに留める**

## Next Steps（条件付き案内）

- 修正後に **`/xp:review "回帰確認: <bug-id>"`** を提案（docs配下への追記のみ。コードは変更しない）
- 未解決の場合：analysis.yaml に**追加観測**（ログ・ガード条件）を追記し、再度 `/xp:tdd "bug:<id>"`

## Notes

- 本コマンドは**コード編集が許可**される（allowed-tools 参照）。一方 `/xp:review` は**コード編集禁止**で分離運用する
- コマンド実行ごとにコンテキストをクリアしても、**ファイルだけで意図・分析・作戦が再構築**できる
