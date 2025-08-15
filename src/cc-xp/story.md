---
description: XP story – ユーザーストーリーを詳細化（対話重視）
argument-hint: '[id] ※省略時は最初の selected を使用'
allowed-tools: Bash(date), Bash(echo), Bash(git:*), Bash(test), Bash(grep), ReadFile, WriteFile
---

# XP Story - ユーザーストーリー詳細化

## ゴール

ストーリーを**ユーザーとの対話**として詳細化し、明確な受け入れ条件を定義する。

## XP原則

@src/cc-xp/shared/xp-principles.md

## 共通処理

@src/cc-xp/shared/git-check.md

### 現在の状態確認

@src/cc-xp/shared/backlog-reader.md

### 対象ストーリーの特定

$ARGUMENTS が指定されている場合はその ID、なければ最初の `selected` ステータスのストーリーを使用してください。

**ステータスバリデーション**：
- 対象ストーリーが `selected` であることを確認
- すでに `in-progress` 以降のステータスの場合は、そのまま継続するか確認
- `done` ステータスのストーリーは詳細化不可

### AI分析レポートの参照

**重要**: ストーリー詳細化前に、plan.md で生成された AI 分析結果を必ず参照してください。

@docs/cc-xp/analysis_summary.md が存在する場合：
- 市場・競合分析結果を確認
- ペルソナ定義を参照  
- 収益化戦略を把握
- 差別化要因を理解

存在しない場合は、限定的なストーリー詳細化のみ実行してください。

## フィーチャーブランチの作成

### ブランチの確認

- 既存ブランチ一覧: !git branch -a

**ブランチ作成手順**：

1. `story-[ID]`形式のブランチが既に存在するか確認してください
2. **既存の場合**: ユーザーにチェックアウトするか確認してください
3. **新規作成の場合**: `story-[ID]`ブランチを作成し、チェックアウトしてください

ブランチ作成に失敗した場合は、同名ブランチの存在や未コミット変更の有無を確認してください。

## テストファースト準備（TDD）

### テストファイル自動生成

ストーリー詳細化と同時に、TDD実践のためのテストファイルを自動生成します。

#### 生成されるテストファイル構造

```
test/
├── [story-id].spec.js        # ユニットテスト（振る舞い検証）
├── [story-id].e2e.js         # E2Eテスト（価値体験検証）  
└── [story-id].regression.js  # 回帰テスト（review reject時に追加）
```

#### ユニットテストテンプレート生成（価値体験検証強化）

**test/[story-id].spec.js**:
```javascript
/**
 * [Story Title] - Unit Tests
 * TDD: Red → Green → Refactor
 * 
 * Story: [story-id]
 * Core Value: [core_value]
 * Minimum Experience: [minimum_experience]
 */

describe('[ComponentName]', () => {
  describe('[MethodName]', () => {
    it('should_[expected_behavior]_when_[condition]', () => {
      // Arrange - 準備
      // TODO: テスト対象のセットアップ
      
      // Act - 実行
      // TODO: テスト対象メソッドの実行
      
      // Assert - 検証
      // TODO: 期待する結果の検証
      expect(true).toBe(false); // 🔴 Red: 最初は失敗するテスト
    });
  });

  // 🎯 価値体験検証テストの必須生成
  describe('価値体験実現確認', () => {
    it('should_provide_minimum_experience_to_user', () => {
      // Arrange - 価値体験が可能な状態のセットアップ
      const [ComponentName] = require('../src/[component-name]');
      const component = new [ComponentName]();
      
      // Act - 価値体験の実行：minimum_experience の検証
      // backlog.yamlから: "[minimum_experience内容を具体的に記載]"
      component.start(); // ゲーム開始・アプリ起動
      
      // minimum_experienceに基づく具体的な検証
      const experience = [];
      for (let i = 0; i < 10; i++) { // 複数フレーム実行
        const state = component.getCurrentState();
        experience.push(state);
        component.update(); // 状態更新
      }
      
      // Assert - 価値体験の確認
      // 1. minimum_experienceが実際に動作する
      expect(component).toBeDefined();
      expect(typeof component.start).toBe('function');
      expect(typeof component.update).toBe('function');
      
      // 2. 価値の本質が体験できる（dynamic behavior）
      const hasValueExperience = experience.some((state, index) => {
        // 時間経過による価値のある変化を検証
        return index > 0 && state !== experience[index - 1];
      });
      expect(hasValueExperience).toBe(true); // 🔴 Red: 最初は失敗するテスト
    });
  });
});
```

#### E2Eテストテンプレート生成

**test/[story-id].e2e.js**:
```javascript
/**
 * [Story Title] - E2E Tests
 * 価値体験の完全なエンドツーエンド検証
 */

describe('[Story Title] - E2E価値体験検証', () => {
  it('should_provide_complete_value_experience', () => {
    // E2E環境セットアップ
    // 実際のユーザー環境に近い状態での価値体験検証
    
    // 価値体験の完全なフロー実行
    // minimum_experience から target_experience まで
    
    expect(true).toBe(false); // 🔴 Red: 最初は失敗するテスト
  });
});
```

## ストーリー詳細化プロセス

### 1. 受け入れ条件の明確化

選択されたストーリーについて、以下を明確にしてください：

1. **価値体験の具体化**
   - minimum_experience を実際に体験可能な形に詳細化
   - ユーザーが「これが欲しかった」と感じる瞬間の特定

2. **技術仕様の定義**
   - 価値実現に必要な技術要素の特定
   - 実装アプローチの検討

3. **検証方法の設計**
   - 価値体験が実現されたことをどう確認するか
   - 自動テストでの検証項目

### 2. ストーリー詳細ファイルの生成

`docs/cc-xp/stories/[story-id].md` を生成してください：

```markdown
# [Story Title]

## 価値体験の詳細化

### minimum_experience の具体化
- [具体的な価値体験の説明]

### target_experience の詳細
- [目標とする価値体験の説明]

## 受け入れ条件

### 価値実現条件
1. [価値体験が確認できる条件]
2. [ユーザーが満足を感じる条件]

### 技術実現条件
1. [技術的に満たすべき条件]
2. [品質基準]

## 実装アプローチ

### 技術的な実装方針
- [実装の方向性]

### 価値実現の検証方法
- [価値が実現されたことの確認方法]
```

### 3. ステータス更新

ストーリー詳細化完了後、以下を実行してください：

1. backlog.yamlのストーリーステータスを `selected` から `in-progress` に更新
2. `updated_at` を現在時刻で更新
3. 必要に応じて `development_notes` を追加

## 次のステップ

@src/cc-xp/shared/next-steps.md