---
description: XP research – 実装前の技術調査と仕様確認（価値実現のための正確な知識獲得）
argument-hint: '[id] ※省略時は in-progress ストーリーを使用'
allowed-tools: Bash(date), Bash(echo), Bash(git:*), Bash(test), Bash(mkdir:*), Bash(grep), ReadFile, WriteFile, WebSearch, WebFetch, mcp__context7__*
---

# XP Research - 価値実現のための技術調査

## ゴール

実装前に**公式仕様・ドキュメント・ベストプラクティス**を調査し、価値を正確に実現するための知識基盤を構築する。AIの既存知識に頼らず、最新かつ正確な情報に基づいた実装を可能にする。

## XP原則

- **勇気**: 知らないことを認め、積極的に調査する
- **コミュニケーション**: 調査結果を明確に記録し共有
- **シンプリシティ**: 必要十分な調査に留める
- **フィードバック**: 調査不足は早期に発見し補完

## Git リポジトリ確認（必須）

**🚨 最初に必ず実行してください 🚨**

Gitリポジトリが初期化されているか確認してください。初期化されていない場合は以下を自動実行してください：

1. `git init` でリポジトリを初期化
2. `git branch -m main` でデフォルトブランチをmainに変更
3. `git add .` で全ファイルをステージング
4. `git commit -m "Initial commit"` で初期コミットを作成

Git設定（user.name, user.email）が未設定の場合も適切に設定してください。

## 現在の状態確認

### 対象ストーリーの特定

$ARGUMENTS が指定されている場合はその ID、なければ `in-progress` ステータスのストーリーを使用してください。

@docs/cc-xp/backlog.yaml から該当ストーリーの情報を取得：
- ID、タイトル、ステータス
- core_value（本質価値）
- minimum_experience（最小価値体験）
- hypothesis（検証すべき仮説）

**ステータスバリデーション**：
- 対象ストーリーが `in-progress` であることを確認
- `done` ステータスのストーリーは調査不要
- backlog が存在しない場合は、先に `/cc-xp:plan` と `/cc-xp:story` の実行を案内

### 既存調査結果の確認

`docs/cc-xp/research/[story-id]/` ディレクトリが既に存在するか確認：
- 存在する場合: 追加調査または更新として扱う
- 存在しない場合: 新規調査として開始

## Phase 1: 調査項目の特定

### 1. 実装領域の分析

ストーリーの内容から、調査が必要な技術領域を特定してください：

**技術カテゴリの判定**:
- **ゲーム開発**: ゲームルール、アルゴリズム、物理演算
- **Web開発**: フレームワーク、API、ブラウザ仕様
- **データ処理**: ファイル形式、データ構造、アルゴリズム
- **UI/UX**: デザインシステム、アクセシビリティ、インタラクション
- **インフラ**: デプロイ、CI/CD、クラウドサービス
- **セキュリティ**: 認証、暗号化、脆弱性対策

### 2. 調査項目リストの作成

以下の観点で調査項目を整理してください：

**必須調査項目**:
- 公式仕様・標準規格
- APIリファレンス
- 実装に必要なアルゴリズム
- 必須の依存関係

**推奨調査項目**:
- ベストプラクティス
- よくあるアンチパターン
- パフォーマンス最適化手法
- 参考実装・サンプルコード

**オプション調査項目**:
- 競合製品の分析
- ユーザーコミュニティの知見
- 将来の拡張性考慮事項

## Phase 2: 調査実行

### 1. 公式ドキュメントの検索

**WebSearchツールを活用**して、以下を検索してください：

```
"[技術名] official documentation"
"[技術名] specification"
"[技術名] API reference"
"[技術名] implementation guide"
```

**テトリス例**:
```
"Tetris Guideline official"
"Tetris SRS rotation system"
"Tetris 7-bag randomizer algorithm"
"Tetris scoring system standard"
```

### 2. 仕様の詳細確認

**WebFetchツールを活用**して、見つかった公式ドキュメントから重要な情報を抽出してください：

- 正確な仕様・ルール
- 必須要件と推奨要件
- 制約事項・制限事項
- バージョン情報・互換性

### 3. 実装サンプルの収集

**Context7ツール（利用可能な場合）**を活用して、関連するライブラリやフレームワークのドキュメントを取得してください：

```
mcp__context7__resolve-library-id で関連ライブラリを検索
mcp__context7__get-library-docs で詳細ドキュメントを取得
```

### 4. ベストプラクティスの調査

以下の情報を収集してください：

- 推奨される実装パターン
- 避けるべきアンチパターン
- パフォーマンス考慮事項
- セキュリティ考慮事項

## Phase 3: 調査結果の記録

### 調査ディレクトリの作成

`docs/cc-xp/research/[story-id]/` ディレクトリを作成してください。

### 1. specifications.md の作成

公式仕様と必須要件を記録：

```markdown
# 仕様書 - [ストーリータイトル]

## 公式仕様

### 基本仕様
- [仕様項目1]
- [仕様項目2]

### 必須要件
- [要件1]
- [要件2]

### 参照URL
- [公式ドキュメントURL]
- [仕様書URL]

## 重要な制約事項
- [制約1]
- [制約2]

## バージョン情報
- 仕様バージョン: [version]
- 最終確認日: [date]
```

### 2. implementation.md の作成

実装ガイドラインとベストプラクティスを記録：

```markdown
# 実装ガイド - [ストーリータイトル]

## 推奨実装アプローチ

### アーキテクチャ
[推奨される設計パターン]

### 主要アルゴリズム
```[language]
[サンプルコード]
```

### データ構造

```[language]
[データ構造定義]
```

## ベストプラクティス

- [プラクティス1]
- [プラクティス2]

## アンチパターン（避けるべき実装）

- ❌ [アンチパターン1]
- ❌ [アンチパターン2]

## パフォーマンス最適化

- [最適化手法1]
- [最適化手法2]
```

### 3. references.md の作成

参考リンクと追加リソースを記録：

```markdown
# 参考資料 - [ストーリータイトル]

## 公式リソース
- [公式サイト](URL)
- [APIドキュメント](URL)
- [チュートリアル](URL)

## コミュニティリソース
- [実装例1](URL)
- [実装例2](URL)
- [ブログ記事](URL)

## 関連ライブラリ
- [ライブラリ1]: [説明]
- [ライブラリ2]: [説明]

## 競合製品分析
- [製品1]: [特徴]
- [製品2]: [特徴]
```

### 4. decisions.md の作成

技術的決定事項と根拠を記録：

```markdown
# 技術的決定事項 - [ストーリータイトル]

## 決定事項

### 1. [決定項目1]
**決定**: [選択した方法]
**根拠**: [なぜこの方法を選んだか]
**代替案**: [検討した他の選択肢]

### 2. [決定項目2]
**決定**: [選択した方法]
**根拠**: [なぜこの方法を選んだか]
**代替案**: [検討した他の選択肢]

## リスクと対策
- **リスク1**: [内容]
  - **対策**: [対応方法]
- **リスク2**: [内容]
  - **対策**: [対応方法]

## 今後の検討事項
- [将来考慮すべき事項1]
- [将来考慮すべき事項2]
```

## Phase 4: backlog.yaml の更新

@docs/cc-xp/backlog.yaml の該当ストーリーに調査情報を追加：

```yaml
research_status: "completed"
research_completed_at: [現在時刻]
research_notes: |
  主要な調査結果の要約
  - [重要な発見1]
  - [重要な発見2]
specifications_url: [主要な公式ドキュメントURL]
```

## Phase 5: 調査品質の確認

### チェックリスト

調査完了前に以下を確認してください：

- [ ] 公式仕様を確認したか
- [ ] 実装に必要なアルゴリズムを理解したか
- [ ] ベストプラクティスを把握したか
- [ ] アンチパターンを認識したか
- [ ] 技術的決定事項を記録したか
- [ ] 参考実装を収集したか

### 調査の充実度評価

**高品質な調査** (★★★):
- 公式仕様を完全に把握
- 複数の実装例を参照
- ベストプラクティスを網羅
- 将来の拡張性も考慮

**標準的な調査** (★★):
- 必要最小限の仕様を把握
- 基本的な実装方法を理解
- 主要なアンチパターンを認識

**最小限の調査** (★):
- 基本仕様のみ確認
- 最低限の実装知識を獲得

## Phase 4: 🔵 リファクタリングカタログ作成

### TDD Refactorフェーズ支援のためのリファクタリング指針

`/cc-xp:develop` のRefactorフェーズで使用するため、**段階的なリファクタリング計画**を作成します。

#### リファクタリングディレクトリの作成

`docs/cc-xp/research/[story-id]/refactoring/` ディレクトリを作成してください。

### 1. refactoring-catalog.md の作成

**Kent Beck's Tidy First** アプローチに基づく段階的リファクタリング計画：

```markdown
# Refactoring Catalog - [ストーリータイトル]

## 🔵 Refactoring Strategy

### Phase 1: 構造的変更（振る舞い不変）

#### 1.1 Dead Code Elimination
- **対象**: [未使用の変数・関数]
- **手順**: 
  1. 静的解析で未使用要素を特定
  2. テスト実行で破損確認
  3. 安全に削除
- **検証**: 全テストがPASS状態維持

#### 1.2 Normalize Symmetries
- **対象**: [非対称な構造]
- **手順**:
  1. 類似パターンの統一
  2. 命名規則の一貫性
  3. パラメータ順序の統一
- **検証**: 動作が完全に同一

#### 1.3 New Interface, Old Implementation  
- **対象**: [改善すべきインターフェース]
- **手順**:
  1. 新しいインターフェースを設計
  2. 既存実装をそのまま使用
  3. 段階的に移行
- **検証**: 新旧インターフェース両方が動作

### Phase 2: 読みやすさ改善

#### 2.1 Explaining Variables
- **対象**: [複雑な式・条件]
- **手順**:
  1. 意味のある変数名で抽出
  2. コメントの代わりに変数で説明
  3. ネストした条件の分割
- **検証**: ロジックが同一

#### 2.2 Explaining Constants  
- **対象**: [マジックナンバー・ハードコーディング]
- **手順**:
  1. 意味を表す定数名を定義
  2. 値の由来を記録
  3. 関連する定数をグループ化
- **検証**: 値と動作が完全に同一

#### 2.3 Explicit Parameters
- **対象**: [暗黙的な依存関係]
- **手順**:
  1. グローバル変数を明示的パラメータに
  2. 隠れた前提条件を表面化
  3. 依存関係の注入
- **検証**: 外部依存が明確化されても動作同一

### Phase 3: 責任の分離

#### 3.1 Extract Method
- **対象**: [長い関数・複雑な処理]
- **手順**:
  1. 単一責任の処理単位で分割
  2. 意味のある関数名を付与
  3. 引数・戻り値を最小化
- **検証**: 分割前後で完全に同じ結果

#### 3.2 Extract Variable
- **対象**: [複雑な計算・繰り返し処理]
- **手順**:
  1. 計算結果を変数に保存
  2. 処理の意図を変数名で表現
  3. パフォーマンス向上効果を測定
- **検証**: 最終結果が同一

#### 3.3 Change Function Declaration  
- **対象**: [不適切な関数シグネチャ]
- **手順**:
  1. パラメータの追加・削除・並び替え
  2. 関数名の改善
  3. 戻り値の型・構造の改善
- **検証**: 呼び出し元が正しく更新

### Phase 4: データ構造の改善

#### 4.1 Encapsulate Variable
- **対象**: [公開されている変数]
- **手順**:
  1. getter/setterメソッドを作成
  2. 直接アクセスを削除
  3. 必要に応じてvalidationを追加
- **検証**: データアクセスパターンが保持

#### 4.2 Combine Functions into Class
- **対象**: [関連する関数群]
- **手順**:
  1. 共通データを持つ関数をクラス化
  2. データを private フィールドに
  3. 関数をメソッドに変換
- **検証**: 機能が完全に保持

#### 4.3 Split Phase
- **対象**: [複数の責任を持つ処理]
- **手順**:
  1. 処理の段階を明確に分離
  2. 段階間のデータ構造を定義
  3. 各段階の独立性を確保
- **検証**: 全体の処理結果が同一

### Phase 5: 条件ロジックの改善

#### 5.1 Replace Nested Conditional with Guard Clauses
- **対象**: [深いネストの条件文]
- **手順**:
  1. 異常系を早期returnで処理
  2. 正常系のネストを削減
  3. 可読性の向上を確認
- **検証**: 全条件パターンで同じ結果

#### 5.2 Replace Conditional with Polymorphism
- **対象**: [型による条件分岐]
- **手順**:
  1. 型ごとにクラスを作成
  2. 共通インターフェースを定義
  3. 条件分岐をメソッド呼び出しに
- **検証**: 動的分岐が正しく動作

### リファクタリング実行の注意事項

#### TDD統合の原則
1. **必ずGreen状態でRefactor開始**
2. **1つのリファクタリング = 1つのコミット**  
3. **各ステップでテスト実行を確認**
4. **Red状態になったら即座に復元**
5. **リファクタリング中は機能追加禁止**

#### Martin Fowler's Refactoring Checklist
- [ ] **Small steps**: 小さなステップで実行
- [ ] **Test frequently**: 各ステップでテスト実行
- [ ] **Revert on red**: 失敗したら即座に復元
- [ ] **Commit on green**: 成功したらコミット
- [ ] **Improve design**: 設計品質の向上を確認

#### リファクタリング順序の最適化
```
1. 最も安全で効果の高いもの（Dead Code等）
2. 読みやすさの改善（命名・構造）
3. 責任分離（メソッド抽出等）
4. データ構造の改善
5. 条件ロジックの改善（最もリスクが高い）
```
```

### 2. refactoring-checklist.md の作成

実際のリファクタリング作業で使用するチェックリスト：

```markdown  
# Refactoring Execution Checklist - [ストーリータイトル]

## 🔵 Refactor実行前チェック
- [ ] 全テストがGreen状態
- [ ] 現在のコードをcommit済み  
- [ ] リファクタリング対象を1つに絞る
- [ ] 期待する改善効果を明確化

## Phase 1: 構造的変更
- [ ] Dead Code Elimination実行
- [ ] テスト実行 → Green確認 → Commit
- [ ] Normalize Symmetries実行  
- [ ] テスト実行 → Green確認 → Commit
- [ ] New Interface作成
- [ ] テスト実行 → Green確認 → Commit

## Phase 2: 読みやすさ改善
- [ ] Explaining Variables適用
- [ ] テスト実行 → Green確認 → Commit
- [ ] Explaining Constants適用
- [ ] テスト実行 → Green確認 → Commit
- [ ] Explicit Parameters適用
- [ ] テスト実行 → Green確認 → Commit

## Phase 3: 責任分離
- [ ] Extract Method実行
- [ ] テスト実行 → Green確認 → Commit
- [ ] Extract Variable実行
- [ ] テスト実行 → Green確認 → Commit
- [ ] Function Declaration改善
- [ ] テスト実行 → Green確認 → Commit

## Phase 4: データ構造改善
- [ ] Encapsulate Variable適用
- [ ] テスト実行 → Green確認 → Commit
- [ ] Combine Functions into Class
- [ ] テスト実行 → Green確認 → Commit
- [ ] Split Phase適用
- [ ] テスト実行 → Green確認 → Commit

## Phase 5: 条件ロジック改善
- [ ] Guard Clauses適用
- [ ] テスト実行 → Green確認 → Commit
- [ ] Polymorphism導入
- [ ] テスト実行 → Green確認 → Commit

## 🔵 Refactor完了後確認
- [ ] 全テストPASS
- [ ] コード品質改善を確認
- [ ] パフォーマンス改善/劣化なしを確認
- [ ] すべての変更がCommit済み
- [ ] 最終コミットメッセージ: "[Refactor] 改善内容の要約"

## Red状態になった場合
- [ ] 即座に `git restore .` で復元
- [ ] より小さなステップに分割
- [ ] リファクタリング戦略を見直し
- [ ] 必要に応じてrefactoring-catalog.mdを更新
```

### 3. code-smells.md の作成

Martin Fowlerのコード臭い検出と対処法：

```markdown
# Code Smells Detection - [ストーリータイトル]

## 検出されたCode Smells

### 🏭 Bloaters（巨大化）
- [ ] **Large Class**: [クラス名] - 責任が多すぎる
  - 対処: Extract Class, Extract Subclass
- [ ] **Long Method**: [メソッド名] - 処理が長すぎる  
  - 対処: Extract Method, Decompose Conditional
- [ ] **Long Parameter List**: [メソッド名] - パラメータが多すぎる
  - 対処: Parameter Object, Preserve Whole Object

### 🗃️ Object-Orientation Abusers（オブジェクト指向の悪用）
- [ ] **Switch Statements**: [場所] - 型による条件分岐
  - 対処: Replace Conditional with Polymorphism
- [ ] **Temporary Field**: [フィールド名] - 一時的にしか使わないフィールド
  - 対処: Extract Class, Replace Method with Method Object
- [ ] **Refused Bequest**: [クラス名] - 親クラスの機能を使わない
  - 対処: Replace Inheritance with Delegation

### 🔗 Change Preventers（変更の妨げ）
- [ ] **Divergent Change**: [クラス名] - 1つのクラスが複数の理由で変更
  - 対処: Extract Class
- [ ] **Shotgun Surgery**: [機能] - 1つの変更で複数箇所を修正
  - 対処: Move Method, Move Field, Inline Class

### 🎈 Dispensables（無駄）
- [ ] **Comments**: [場所] - 不要なコメント
  - 対処: Extract Variable, Extract Method, Rename Method
- [ ] **Duplicate Code**: [場所1, 場所2] - 重複コード  
  - 対処: Extract Method, Pull Up Method
- [ ] **Dead Code**: [場所] - 使われないコード
  - 対処: 削除
- [ ] **Speculative Generality**: [場所] - 不要な汎用化
  - 対処: Inline Class, Remove Parameter

### 🔌 Couplers（密結合）
- [ ] **Feature Envy**: [メソッド] - 他クラスのデータを頻繁に使用
  - 対処: Move Method, Extract Method
- [ ] **Inappropriate Intimacy**: [クラス1, クラス2] - 過度な相互依存
  - 対処: Move Method, Extract Class, Change Bidirectional Association to Unidirectional
- [ ] **Message Chains**: [チェーン] - 長いメソッドチェーン
  - 対処: Hide Delegate, Extract Method
```

## 変更のコミット

以下の手順でコミットしてください：

1. **対象ファイル**:
   - `docs/cc-xp/research/[story-id]/*.md`
   - `docs/cc-xp/backlog.yaml`
2. **コミットメッセージ**: "docs: 技術調査完了 - [ストーリータイトル]"

## 完了サマリーの表示

```
📚 技術調査完了
================
ストーリー: [タイトル]
調査時間: [所要時間]
調査品質: [★★★/★★/★]

📋 調査結果:
- 公式仕様: ✅ 確認済み
- 実装ガイド: ✅ 作成済み
- 参考資料: [X]件収集
- 技術決定: [Y]件記録

🔵 リファクタリング準備:
- リファクタリングカタログ: ✅ 作成済み
- 実行チェックリスト: ✅ 準備完了
- Code Smells検出: [Z]件特定
- TDD統合戦略: ✅ 策定済み

🔍 重要な発見:
• [発見1]
• [発見2]
• [発見3]

📁 調査結果の保存先:
docs/cc-xp/research/[story-id]/

⚠️ 注意事項:
• [特に注意すべき点1]
• [特に注意すべき点2]
```

## 次のステップ

```
🚀 次のステップ
================
調査結果に基づいてTDD開発を開始:
→ /cc-xp:develop

このコマンドで:
• 調査結果を参照しながら開発
• 正確な仕様に基づいた実装
• ベストプラクティスの適用

💡 開発のポイント
---------------
• specifications.md の仕様を厳守
• implementation.md のガイドに従う
• decisions.md の決定事項を反映

🔵 リファクタリングのポイント
---------------------------
• refactoring-catalog.md の段階的計画に従う
• 必ずGreen状態でRefactor開始
• 1つのリファクタリング = 1つのコミット
• refactoring-checklist.md でステップ確認
• Code Smells検出結果を参考に改善
```

## エラーハンドリング

### 調査ツールが利用できない場合

WebSearch、WebFetch、Context7 が利用できない場合：
```
⚠️ 調査ツールが利用できません

代替手段:
1. ユーザーに直接URLを提供してもらう
2. ローカルのドキュメントを参照
3. 既存のコード例から学習
```

### 公式ドキュメントが見つからない場合

```
⚠️ 公式ドキュメントが見つかりません

対応方法:
1. コミュニティリソースを活用
2. デファクトスタンダードを調査
3. 類似技術から推測
4. ユーザーに確認を求める
```

## 重要な注意事項

- **過信の防止**: AIの既存知識だけに頼らず、必ず外部ソースを確認
- **最新性の確保**: 古い情報に注意し、最新の仕様を優先
- **実装可能性**: 理想的な仕様と実装可能な範囲のバランスを考慮
- **価値中心**: 技術的完璧さより、ユーザー価値の実現を優先