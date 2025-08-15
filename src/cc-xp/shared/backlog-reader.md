# Backlog 読み込みと状態確認

## Backlog 状態確認

- backlog 存在確認: !test -f docs/cc-xp/backlog.yaml
- Git 状態: !git status --short
- 現在のブランチ: !git branch --show-current
- 現在時刻: !date +"%Y-%m-%dT%H:%M:%S%:z"

@docs/cc-xp/backlog.yaml から該当ストーリーの**全情報**を取得してください：

### 基本情報

- ID、タイトル、サイズ、価値、現在のステータス

### 価値実現項目（評価の核心）

- **core_value**: 実現すべき本質価値
- **minimum_experience**: 最小価値体験
- **value_story**: 価値体験を中心としたストーリー
- **hypothesis**: 価値体験を中心とした検証可能な仮説
- **kpi_target**: 価値体験の測定方法
- **success_metrics**: 価値が体験できることの確認項目

### 戦略的情報（存在する場合）

- **business_value**: 事業価値スコア（1-10）
- **user_value**: ユーザー価値スコア（1-10）
- **implementation_cost**: 実装コスト（1-10）
- **risk_level**: リスクレベル（1-10）
- **priority_score**: 優先順位スコア（計算値）

### 仮説駆動項目

- **user_persona**: 対象ユーザー
- **business_context**: 事業上の位置づけ
- **competition_analysis**: 競合との差別化要因

**重要**: backlog が存在しない場合は、先に `/cc-xp:plan` の実行を案内してください。
**注意**: 戦略的情報が存在しない場合は、旧形式の backlog.yaml として扱い、基本機能のみで進行してください。