---
description: "真のアジャイルユーザーストーリー作成 - アジャイル宣言とKent Beck XP原則準拠"
argument-hint: "作りたいものを説明してください（例: テトリスゲーム、計算機アプリ）"
allowed-tools: ["Write", "Read", "LS", "WebSearch", "Bash"]
---

# 真のアジャイルユーザーストーリー作成

要望: $ARGUMENTS

## 🎯 アジャイル宣言の4つの価値

### 1. 個人と対話 > プロセスとツール
**実践**: ユーザーとの直接対話でストーリーを作成

### 2. 動くソフトウェア > 包括的ドキュメント  
**実践**: 動作確認可能な最小機能から開始

### 3. 顧客との協働 > 契約交渉
**実践**: ユーザーフィードバックによる継続的改善

### 4. 変化への対応 > 計画に従うこと
**実践**: 短いサイクルでの適応的計画

## 指示

以下の**真のアジャイル原則**でユーザーストーリーを作成してください：

### 📋 Phase 1: 本物のユーザーストーリー作成

#### アジャイル標準形式の適用

**要望を分析**し、以下の形式でユーザーストーリーを作成してください：

```
As a [ユーザータイプ]
I want [機能・行動]  
So that [価値・理由]
```

**例**:
```
As a player
I want to see a tetris block on the screen
So that I can confirm the game is working

As a student  
I want to calculate simple math problems
So that I can verify my homework answers

As a developer
I want to check API health status
So that I can monitor system availability
```

#### INVEST基準の適用

各ストーリーが以下を満たすことを確認してください：

- **Independent**: 他のストーリーに依存しない
- **Negotiable**: 詳細は実装時に調整可能
- **Valuable**: ユーザーに明確な価値を提供
- **Estimable**: 工数見積もりが可能
- **Small**: 数日以内で完了可能
- **Testable**: 受け入れテストが書ける

### 📋 Phase 2: 受け入れ基準の定義

#### Kent Beck XP方式の受け入れテスト

**各ストーリーに対して受け入れ基準**を定義してください：

```
Given [初期状態]
When [ユーザーアクション]
Then [期待される結果]
```

**例**:
```
Story: テトリスブロック表示

Acceptance Criteria:
Given the game is loaded
When I open the game page
Then I should see a colorful block on the screen

Given the block is displayed  
When I refresh the page
Then the block should still be visible
```

### 📋 Phase 3: 価値駆動優先度付け

#### 顧客価値による優先順位決定

**ビジネス価値順で優先度を設定**してください：

1. **Must Have**: 最小viable product に必須
2. **Should Have**: 重要だが必須ではない  
3. **Could Have**: あると良い機能
4. **Won't Have**: 今回は含めない

**優先度決定基準**:
- ユーザーの痛みを解決するか？
- ビジネス目標に直結するか？
- 技術的リスクは低いか？
- 他の機能への依存度は？

### 📋 Phase 4: 継続的フィードバック計画

#### アジャイル原則「顧客との協働」の実践

**フィードバックループの設計**：

```
1. Story実装 → 2. Demo → 3. Feedback → 4. 適応 → 1に戻る
```

**具体的なフィードバック方法**:
- 各ストーリー完了後のデモセッション
- ユーザビリティテストの実施
- A/Bテストによる仮説検証
- メトリクス測定（使用率、満足度等）

### 📋 Phase 5: ストーリーファイル作成

#### 真のアジャイル管理構造

`.claude/agile-artifacts/stories/user-stories.md` に以下の形式で作成：

```markdown
# Project: [プロジェクト名]

## 🎯 Product Vision
[製品のビジョン - なぜこの製品を作るのか]

## 👥 User Personas
### Primary User: [メインユーザー]
- 背景: [ユーザーの背景]
- 目標: [達成したいこと]  
- 課題: [現在の痛み]

## 📋 User Stories (Priority Order)

### Epic 1: [主要機能群名]

#### Story 1.1 [Must Have]
**Story**: As a [user] I want [action] So that [value]

**Acceptance Criteria**:
- Given [condition] When [action] Then [result]
- Given [condition] When [action] Then [result]

**Definition of Done**:
- [ ] Unit tests written and passing
- [ ] Integration tests passing  
- [ ] User acceptance test passing
- [ ] Code reviewed
- [ ] Performance acceptable
- [ ] Documentation updated

**Story Points**: [1-8 points]
**Dependencies**: [None/Story X.X]

#### Story 1.2 [Should Have]
[同様の形式]

### Epic 2: [次の機能群]
[続く...]

## 🔄 Continuous Feedback Plan

### Feedback Cycles
- **After each story**: 15分デモ + フィードバック
- **End of epic**: ユーザビリティテスト
- **Weekly**: メトリクス レビュー

### Success Metrics
- User satisfaction score
- Feature usage rate  
- Task completion time
- Bug report frequency

## 🎯 Release Planning

### Release 1 (MVP)
- Must Have stories only
- Target: [Date]
- Success criteria: [Metrics]

### Release 2  
- Should Have stories
- Target: [Date]  
- Success criteria: [Metrics]
```

### 📋 Phase 6: アジャイル品質確認

#### 真のアジャイル原則チェック

作成したストーリーが以下を満たしているか確認：

**✅ アジャイル宣言準拠**:
- [ ] ユーザーとの対話を重視
- [ ] 動作確認可能な機能記述
- [ ] 顧客協働の仕組み設計
- [ ] 適応的な計画立案

**✅ Kent Beck XP原則準拠**:
- [ ] ユーザーストーリー標準形式
- [ ] 受け入れテスト定義済み
- [ ] 継続的フィードバック計画
- [ ] シンプルな設計原則

**✅ INVEST基準準拠**:
- [ ] 独立性・交渉可能性確保
- [ ] 価値・見積もり可能性確認
- [ ] 小さな単位・テスト可能性保証

## 🎉 真のアジャイルストーリー完成

```text
✅ 真のアジャイルユーザーストーリー作成完了！

🎯 アジャイル原則適用:
- 📋 標準形式: As a... I want... So that...
- 🎯 価値駆動: ユーザー価値による優先順位
- 🔄 継続的フィードバック: 短いサイクルでの検証

📁 作成ファイル:
- ユーザーストーリー: .claude/agile-artifacts/stories/user-stories.md
- フィードバック計画: 継続的改善の仕組み

🚀 次のステップ: TDD実装開始

最初のストーリーをTDDで実装:
/tdd:run [Story 1.1の機能名]

これにより真のKent Beck TDD原則で開発開始：
- テストファースト厳守
- Red-Green-Refactorサイクル  
- Fake It/Triangulation戦略適用
```

## ⚠️ 偽アジャイルからの脱却

### 削除された偽概念
- ❌ 「Kent Beck + Eric Ries統合哲学」（存在しない）
- ❌ 「5分・15分・30分価値」（時間ベースは非アジャイル）
- ❌ 機械的段階分け（柔軟性を阻害）

### 採用された真の原則  
- ✅ アジャイル宣言4つの価値
- ✅ Kent Beck XP12プラクティス
- ✅ 価値駆動開発
- ✅ 継続的フィードバック

**真のアジャイル開発**で、ユーザー中心の価値創造を実現してください。