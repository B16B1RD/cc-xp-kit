# 📘 XP Kit (xp: Prefix)

## 使い方

1. **プロジェクト配置**

   * このフォルダ構成のままプロジェクトに設置してください。

2. **スラッシュコマンド**

   * `/xp:discovery "<曖昧要件>"`
     → 要件の背景・ペルソナ・ユースケースを分析し、`docs/xp/discovery.yaml` を生成
   * `/xp:design`
     → `discovery.yaml` を参照し、C4設計・ADR・必要に応じて API 仕様を生成
   * `/xp:scaffold`
     → 設計をもとに最小限の足場を生成（src/, tests/, docs/xp/ 等）
   * `/xp:tdd "<story>"`
     → 受け入れ基準と設計に基づき TDD 実装（Red→Green→Refactor→Commit）
   * `/xp:cicd`
     → CI/CD パイプライン、品質ゲート設定を生成
   * `/xp:review`
     → レビュー用資料やレトロスペクティブ出力
   * `/xp:doc <テンプレ名>`
     → 雛形展開（設計/要件/ADR/レビュー用など）

3. **サブエージェント**

   * `.claude/agents/` に役割別のサブエージェントを配置し、文脈を独立管理します。
   * 例: scaffolder, tester, reviewer

---

## 標準ルール

* すべてのコマンド定義は **自然文＋（相当コマンド）** 形式で記述されています。
  例:

  * 「設計ドキュメントが存在するか確認する（相当コマンド: `test -f docs/xp/architecture.md`）」
  * 「すべての変更をステージに追加する（相当コマンド: `git add -A`）」

* コマンド間の連携は **YAML ファイル**で担保します。

  * discovery の結果 → `docs/xp/discovery.yaml`
  * design / tdd などがこの YAML を参照して分岐処理を行います。

---

## 方針

* **役割＝サブエージェント**
* **手順＝スラッシュコマンド**
* Gherkin 形式で仕様を語り、TDD で実装（Red → Green → Refactor）
* 非機能要件・可観測性・リリース戦略を初期から考慮する
* 「曖昧な要件 → 本質を抽出 → 設計・実装へ連携」の流れを自動化する
