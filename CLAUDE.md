# CLAUDE.md

Claude Code (claude.ai/code) でこのリポジトリのコード作業をする際のガイダンスファイル。

## プロジェクト概要

cc-xp-kit（旧 cc-tdd-kit）は、Kent Beck の XP 原則と Value-Driven TDD サイクルを統合した価値中心の開発支援ツールキットです。このプロジェクトでは、cc-xp-kit 自体を開発します。

### 開発目標

- 6 つのスラッシュコマンド（plan/story/research/develop/review/retro）の実装
- 価値駆動開発ワークフローの自動化
- Claude Code スラッシュコマンドシステムの活用
- TDD 原則に基づく高品質な開発支援ツールの提供

## 重要な言語設定

**すべての出力は日本語で行ってください。** ただし以下を除く。
- YAML のキー名（id, title, status 等）
- 英語が標準のテクニカルターム（TDD, XP, hypothesis 等）

## アーキテクチャ

### ディレクトリ構造

```
/src/cc-xp/        # コマンド定義（.mdファイル）
  plan.md          # 要求分析・ストーリー抽出
  story.md         # ストーリー詳細化
  research.md      # 技術調査・仕様確認
  develop.md       # TDD開発サイクル
  review.md        # レビュー・検証
  retro.md         # 振り返り・分析
  shared/          # 共通コンポーネント（@参照用）
    git-check.md       # Git初期化確認処理
    backlog-reader.md  # backlog.yaml読み込み処理
    tdd-principles.md  # TDD原則説明
    test-env-check.md  # テスト環境確認処理
    next-steps.md      # 次のステップ案内ロジック
    xp-principles.md   # XP原則説明
  templates/       # 調査記録テンプレート
    research-specifications.md
    research-implementation.md
    research-references.md
    research-decisions.md

```

### plan.mdのシンプル化について

**改善内容（v0.2.2）**:
- 全体で 54% のコード削減（3,500 行 → 1,611 行）
- @参照による共通処理のモジュール化
- plan.md: 778 行 → 229 行（70% 削減）
- develop.md: 800 行 → 195 行（76% 削減）
- Claude Code 仕様準拠の自然言語指示

**維持された機能**:
- 真の目的分析、ペルソナ特定、ストーリー生成の核心プロセス
- backlog.yaml の構造（他コマンドとの互換性）
- 仮説駆動開発の要素（hypothesis, kpi_target）

## 🔴🟢🔵 Kent Beck式TDD厳格遵守

### cc-xp-kitの開発で絶対厳守すべきTDD原則

このプロジェクト自体の開発において、Kent Beck の TDD 原則を厳格に遵守してください。

#### 1. Red-Green-Refactor Cycle の厳守

```
🔴 Red   → 失敗するテストを1つだけ書く
🟢 Green → テストを通す最小限のコード
🔵 Refactor → 全テストが通る状態で構造を改善
```

**絶対禁止**:
- テストなしでの実装（アンチパターン）
- 複数機能の同時実装
- Green を飛ばしての Refactor
- テストを通すためのテスト修正

#### 2. テストファーストの絶対厳守

```bash
# cc-xp-kitの全機能について
# 1. 必ずテストを先に書く
# 2. そのテストが失敗することを確認する
# 3. 最小限の実装でテストを通す
# 4. 構造を改善する
```

#### 3. コミット規律の厳守

**すべてのコミットは以下の形式を使用**:
```bash
[Red] テスト: should_extract_value_from_requirements
[Green] 実装: plan.mdで価値抽出機能を実装  
[Refactor] 改善: 価値抽出処理の可読性向上
[Structure] 構造: ファイル構造の整理（振る舞い不変）
```

#### 4. cc-xp-kitのテスト戦略

**テストファイル構造**:
```
test/unit/                    # ユニットテスト
  plan.spec.js               # plan.md機能テスト
  story.spec.js              # story.md機能テスト
  research.spec.js           # research.md機能テスト
  develop.spec.js            # develop.md機能テスト
  review.spec.js             # review.md機能テスト
  retro.spec.js              # retro.md機能テスト

test/integration/             # 統合テスト
  workflow.e2e.js            # 全ワークフロー統合テスト
  backlog.generation.spec.js # backlog.yaml生成テスト

test/regression/              # 回帰テスト
  value-extraction.regression.js  # 価値抽出回帰テスト
  tdd-enforcement.regression.js   # TDD強制回帰テスト
```

#### 5. 品質ゲートの厳守

**cc-xp-kitの品質基準**:
- **テストカバレッジ**: 85%以上必須
- **TDDサイクル完全性**: Red→Green→Refactor の完全実施
- **アンチパターン**: 0 件必須
- **回帰テスト**: 全バグに対して自動生成

#### 6. TDD実装例（cc-xp-kit）

**価値抽出機能のTDD例**:
```javascript
// test/unit/plan.spec.js
describe('ValueExtractor', () => {
  it('should_extract_core_value_from_user_requirements', () => {
    // Arrange
    const requirements = "ウェブブラウザで遊べるテトリスが欲しい";
    const extractor = new ValueExtractor();
    
    // Act  
    const result = extractor.extractCoreValue(requirements);
    
    // Assert
    expect(result).toContain("ゲーム体験");
    expect(result).toContain("達成感");
    expect(result).not.toContain("技術実装"); // 技術中心でない
  });
});
```

#### 7. アンチパターン自動検出

**cc-xp-kitの開発で以下を検出した場合は即座に修正**:
- テストファイルが存在しない機能実装
- 実装先行コミット（Red なしの実装）  
- テスト修正コミット（テストを通すためのテスト変更）
- 価値実現なき技術実装

### cc-xp-kit開発の哲学

**技術よりも価値実現を重視**:
- cc-xp-kit 自体も「ユーザー（開発者）の価値体験」を最優先
- 技術的完全性よりも、実際に開発者が価値を感じる体験
- TDD による設計品質向上と価値実現の両立

### Git操作の権限

.claude/settings.local.json で設定済み。
- コミット、ブランチ操作は許可
- **SKIP_HOOKS=1 の使用は禁止** - プロジェクトのフック設定を必ず実行
- フックエラーが発生した場合は適切に対応してコミット実行

### 価値中心哲学への転換 (v0.2.2)

**重大な哲学的変更**:「Technical Excellence」から「User Value Excellence」への転換。
- **従来**: 技術的に完璧だが価値がない実装を許容
- **新規**: ユーザーが実際に価値を体験できる実装を必須化

## カスタムスラッシュコマンドの作成指針

### 基本原則

カスタムスラッシュコマンド（src/cc-xp/*.md）には、**自然文による指示**のみを記載してください。

**✅ 正しい書き方**：
```
Gitリポジトリが初期化されているか確認してください。
初期化されていない場合は、適切な解決方法を案内してください。
```

**❌ 間違った書き方**：
```bash
if [ ! -d ".git" ]; then
    echo "❌ エラー: Gitリポジトリが初期化されていません"
    exit 1
fi
```

### 重要な理由

- **並列実行問題の回避**: 複数の```bash ブロックがあると、Claude Code が並列実行し、同じ処理が重複する
- **保守性**: 自然文なら、Claude Code が適切に解釈して実行する
- **柔軟性**: 環境や状況に応じて適切な手法を選択できる

### 推奨パターン

1. **状況確認**:「〜を確認してください」
2. **条件分岐**:「〜の場合は〜してください」
3. **実行指示**:「〜してください」
4. **エラー対応**:「失敗した場合は〜を案内してください」

## リファクタリングの成果（v0.2.3）

### アーキテクチャの改善

cc-xp-kit は @参照によるモジュール化リファクタリングで大幅改善を実現。

**🎯 主要成果**:
- **54% のコード削減**: 3,500 行 → 1,611 行
- **共通コンポーネント化**: 6 つの共通処理を shared/ ディレクトリに抽出
- **保守性向上**: 重複コードの排除により変更影響範囲を最小化

**📦 shared/コンポーネント**:
```
shared/git-check.md       # Git初期化確認（全コマンド共通）
shared/backlog-reader.md  # backlog.yaml読み込み処理
shared/tdd-principles.md  # TDD原則説明  
shared/test-env-check.md  # テスト環境検出・設定
shared/next-steps.md      # ワークフロー進行ロジック
shared/xp-principles.md   # XP原則と価値駆動哲学
```

**📊 各コマンドの削減実績**:
- plan.md: 778 行 → 229 行（70% 削減）
- story.md: 550 行 → 222 行（60% 削減）  
- develop.md: 800 行 → 195 行（76% 削減）
- review.md: 650 行 → 257 行（60% 削減）
- retro.md: 450 行 → 226 行（50% 削減）
- research.md: 300 行 → 187 行（38% 削減）

### 技術的改善点

1. **Claude Code 仕様準拠**: @参照による標準的なファイル包含パターン
2. **自然言語指示**: bash スクリプトではなく自然文での処理指示
3. **並列実行対応**: 重複処理の排除により実行効率向上
4. **モジュール設計**: 各共通処理の単一責任原則を遵守

## cc-xp-kit 開発における動作テスト制限

### ⚠️ 重要: スラッシュコマンドのテスト実行について

**cc-xp-kit の開発・修正時の制限事項**:

- **/cc-xp:* コマンドは Claude Code のスラッシュコマンドシステムでのみ動作**
- **Bash や他のシェルでは実行不可能**
- **プランモードでは実際のコマンド実行は不可能**

### 動作確認の代替手段

cc-xp-kit のコマンド修正後は、以下の方法で検証してください。

1. **コードレビューによる静的検証**
   - 引数解析ロジックの確認
   - フロー制御の正確性確認
   - 出力メッセージの適切性確認

2. **実装パターンの確認**
   - 自然言語指示の明確性
   - 条件分岐の完全性
   - エラーハンドリングの適切性

3. **ユーザー報告に基づく修正**
   - 実際の使用環境での問題報告
   - 具体的な動作不良の症状分析
   - 期待動作との差分確認

### テスト不可能な理由

```bash
# ❌ これは動作しません
/cc-xp:review  # Bashでは認識されない

# ❌ 代替手段も制限があります  
cd tmp/example && /cc-xp:review  # 同様に動作しない
```

**結論**: cc-xp-kit の開発では、実動作テストではなく設計レビューと論理的検証を重視してください。
