---
description: XP plan – ユーザー要求から価値あるストーリーを抽出
argument-hint: '"ウェブブラウザで遊べるテトリスが欲しい"'
allowed-tools: Bash(date), Bash(echo), Bash(git:*), Bash(test), Bash(mkdir:*), Bash(cat), ReadFile, WriteFile
---

## ゴール

ユーザー要求「$ARGUMENTS」の**真の目的**を理解し、価値あるストーリーセットを生成する。

## 3段階要求分析プロセス

### Stage 1: 真の目的分析

表面的な要求の背後にある本当のニーズを探る：
- **現状の不満**: なぜこの要求が生まれたか
- **真の達成目標**: 本当に解決したい問題は何か
- **成功のイメージ**: 実現時にユーザーが感じる価値

### Stage 2: ペルソナ特定

要求に関わる主要な関係者を特定：

- **エンドユーザー**: 直接システムを使用する人
- **開発者**: 実装・保守を担当する人
- **利害関係者**: ビジネス価値に関心を持つ人

### Stage 3: ストーリー生成と優先度設定

各ペルソナのニーズを構造化して優先度を設定：

#### 要件カテゴリ

**機能要件**:
- コア機能（システムの核心価値）
- データ管理（CRUD操作）
- ユーザー管理（認証・権限）
- 外部連携（API・統合）

**非機能要件**:
- UI/UX（使いやすさ、レスポンシブ）
- パフォーマンス（速度、効率）
- セキュリティ（データ保護）
- 可用性（安定稼働）
- スケーラビリティ（成長対応）

**開発者要件**:
- テスト（ユニット、統合、E2E）
- 保守性（コード品質、ドキュメント）
- 拡張性（モジュール設計）
- 監視・デプロイ

## User Storyフォーマット

```
As a [役割]
I want [機能]
So that [価値]

Acceptance Criteria:
- [具体的な受け入れ条件]
```

**優先度判定基準**:
- **Must Have**: システムの核心価値
- **Should Have**: 品質・体験向上
- **Could Have**: あると便利な機能

## 実行プロセス

### 環境確認
```bash
# プロジェクト構造作成
test -d docs/cc-xp || mkdir -p docs/cc-xp
```

### 分析実行

ユーザー要求「$ARGUMENTS」について、3段階分析を実行：

1. **真の目的分析**: 背景の不満、根本問題、成功時の価値
2. **ペルソナ特定**: エンドユーザー、開発者、利害関係者
3. **ストーリー生成**: 要件をUser Story形式で整理

### backlog.yaml生成

分析結果を基にストーリーセットを生成し、backlog.yamlに記録します。

**必要なメタデータ**:
```yaml
iteration:
  id: [timestamp]
  business_goal: "簡潔なビジネス目標"
  success_criteria: "成功基準"
  target_users: "対象ユーザー"

stories:
  - id: [story-id]
    title: "ストーリータイトル"
    description: "詳細説明"
    business_value: 1-10
    user_value: 1-10
    hypothesis: "検証すべき仮説"
    kpi_target: "具体的成功指標"
    status: "selected"
    priority: "Must Have|Should Have|Could Have"
```

### 完了確認

分析完了後、生成されたストーリーの概要と次ステップを表示。

**次のコマンド**: `/cc-xp:story` でストーリー詳細化を開始