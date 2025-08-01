---
description: "Kent Beck純正TDD - 自動判定・数値指定・粒度選択対応"
argument-hint: "[空白=自動|数値=順位|x.y=Story|文字列=機能名] [--micro|--feature|--epic]"
allowed-tools: ["Bash", "Read", "Write", "TodoWrite"]
---

# Kent Beck純正TDD実行

## 🎛️ 粒度選択機能（v0.2.1新機能）

**選択されたタスク**: !bash ~/.claude/commands/shared/task-selector.sh "$ARGUMENTS"

**自動粒度判定**:

- **引数に`--micro`が含まれる場合**: 従来の細かい粒度（単一関数レベル・10-30分）で実行
- **引数に`--epic`が含まれる場合**: プロダクト全体レベル（8-16時間）で実行  
- **デフォルト**: フィーチャー単位（2-4時間）で実行

**粒度別の実装アプローチ**:

### 🔬 Microレベル (--micro)

- **対象**: 単一関数・メソッド
- **時間**: 10-30分
- **TDDサイクル**: 標準的なRed-Green-Refactor
- **適用場面**: 上級者、複雑なアルゴリズム、学習目的

### 🎯 Featureレベル (デフォルト)  

- **対象**: 統合機能群（認証システム、データ管理など）
- **時間**: 2-4時間
- **TDDサイクル**: Phase単位のRed-Green-Refactor
- **適用場面**: 一般的な開発、実用的な価値提供

### 🏛️ Epicレベル (--epic)

- **対象**: プロダクト全体・主要フィーチャー群
- **時間**: 8-16時間（1-2日）
- **TDDサイクル**: Feature群の統合・アーキテクチャレベル
- **適用場面**: MVP開発、大規模リファクタリング

この出力から機能名部分（カッコ内の説明を除いた部分）を抽出し、以下のすべての処理で使用してください。

**粒度判定結果**:

!bash -c '
if echo "$ARGUMENTS" | grep -q "\-\-micro"; then
  echo "🔬 Microレベル実行"
elif echo "$ARGUMENTS" | grep -q "\-\-epic"; then
  echo "🏛️ Epicレベル実行"
else
  echo "🎯 Featureレベル実行"
fi'

## 🎯 真のKent Beck TDD原則

### テストファースト厳守

- **必ずテストから始める** - コードなしでのテスト作成不可能は禁止
- **一度に1つのテスト** - 複数テスト同時作成禁止
- **各変更後に全テスト実行** - 品質退行の即座発見

### Kent Beck世界観

**「TDDは設計手法である」** - Kent Beck, "Test-Driven Development by Example"
- テストコードがコードの設計を導く
- 実装前にAPIを考える
- シンプルな設計の自然な出現

## 🚀 Kent Beck改善機能統合

### ワークフロー開始時の推奨アクション

**進捗ダッシュボード確認**:
```bash
# 現在のプロジェクト状況を確認
bash ~/.claude/commands/shared/progress-dashboard.sh compact
```

**高不安度項目の確認**:
```bash
# 最も不安な項目から着手（Kent Beck原則）
bash ~/.claude/commands/shared/todo-manager.sh anxiety
```

## 重要な指示原則

### 確認事項の具体化（CRITICAL）

ユーザーに確認や操作を求める際は、**必ず具体的な手順**を提示してください：

❌ **曖昧な指示の例**:
- "HTMLファイルをダブルクリック"
- "コマンドを実行"  
- "エンドポイントを確認"
- "結果を確認"
- "データベースを確認"
- "ログを見る"

✅ **具体的な指示の例**:
- "src/index.html をダブルクリック"
- "`npm run dev` を実行"
- "<http://localhost:3000/api/users> にGETリクエスト"
- "logs/output.txt ファイルの内容を確認"
- "PostgreSQL で `SELECT * FROM users;` を実行"
- "browser console で `TypeError: Cannot read property` を確認"

### 確認手順の必須要素

すべての確認指示には以下を含めてください：

1. **何を確認するか** - 確認対象の明確な特定
2. **どこで確認するか** - 具体的な場所・ファイル・URL
3. **どのように確認するか** - 詳細な操作手順
4. **何が期待されるか** - 成功時の具体的な結果
5. **確認できない場合** - 代替確認方法・対処法

### 視覚的要素の確認指示

視覚的な確認が必要な場合の必須事項：

1. **確認場所**: ブラウザのどのタブ、開発者ツールのどのパネル
2. **確認方法**: F12 → Console、F12 → Elements等の具体的操作
3. **期待内容**: 表示されるべき具体的な文字列、図形、色、数値
4. **確認不能時**: ログ出力、エラーメッセージでの代替確認方法

## 作業開始前の必須確認

TDD作業開始前に**必ず以下を実行**してください：

### 1. ユーザーストーリーの確認
`.claude/agile-artifacts/stories/user-stories-v1.0.md` を読み込み、以下を確認：
- 現在の作業がどのストーリーに該当するか
- 該当ストーリーの受け入れ基準
- 優先度と工数見積もり

### 2. イテレーション計画の確認  
`.claude/agile-artifacts/iterations/iteration-plan-v1.0.md` を読み込み、以下を確認：
- 現在のPhaseと次のタスク
- 完了すべきチェック項目
- 予定時間と進捗状況

### 3. チェック項目の段階的制御
- **前のチェック項目が☐（未完了）の場合は作業を停止**
- 現在のタスクのチェック項目を確認
- 作業完了後は該当チェック項目を☑️に更新
- **ファイルを必ず保存して進捗を記録**

### 4. 作業対象の明確化
上記確認により、実装する具体的な機能・タスクを明確にしてから開始

## 指示

以下の**厳格なTDDサイクル**を実行してください：

### 🔴 RED フェーズ: テスト作成

#### 1. 最小の失敗テスト作成

**Kent Beck原則**: 「最小の失敗するテストを書く」

**手順**:
1. **機能の最小単位を特定**してください：
   ```
   例：
   - login → "正しい認証情報で認証成功"
   - calculate → "2 + 3 = 5"
   - move-block → "ブロックがX座標で移動"
   ```

2. **1つのテストのみ作成**してください：
   ```javascript
   // 例: 計算機能
   test('should add two numbers', () => {
     expect(add(2, 3)).toBe(5);
   });
   ```

3. **テストが存在しない実装を呼び出す**ことを確認：
   - 関数が存在しない
   - クラスが存在しない
   - メソッドが存在しない

#### 2. テスト実行で失敗確認

**必須**: テストが赤（失敗）であることを確認してください：

```bash
# プロジェクトタイプに応じて実行
npm test -- --watchAll=false --forceExit 2>&1
# または
python -m pytest -v 2>&1
# または
go test ./... 2>&1
```

**確認項目**:
- ✅ テストが実行される
- ✅ テストが失敗する
- ✅ 失敗理由が期待通り（関数未定義等）

**失敗しない場合**: テストの書き方を修正してください

#### 🔍 REDフェーズ完了確認

**チェック項目の更新（必須）**:
1. `.claude/agile-artifacts/iterations/iteration-plan-v1.0.md` を読み込み
2. 現在のタスクのREDフェーズ項目を☐から☑️に更新
3. ファイルを保存して進捗を記録
4. **次のGREENフェーズに進む前に更新完了を確認**

**受け入れ条件チェック**:
```bash
bash ~/.claude/commands/shared/acceptance-criteria.sh check red "[抽出した機能名]" "テスト作成完了"
```

**30秒フィードバック**:
```bash
bash ~/.claude/commands/shared/micro-feedback.sh step "1.1" "[抽出した機能名]"
```

### 🟢 GREEN フェーズ: 最小実装

#### Kent Beck三大戦略の自動判定適用

**戦略自動選択システム**:

まず**現在の状況を確認**してください：

1. **テストファイルを確認**してください：
   ```bash
   # テストファイル内のテスト数を確認
   grep -c "test\|it\|describe" src/**/*.test.* 2>/dev/null || echo "0"
   ```

2. **実装ファイルの存在確認**してください：
   ```bash
   # 対象の関数やクラスが既に存在するか確認
   grep -n "function [抽出した機能名]\|class [抽出した機能名]\|const [抽出した機能名]" src/**/*.* 2>/dev/null || echo "未実装"
   ```

**自動戦略判定**:

### 📊 状況1: 初回テスト作成（最も一般的）

**判定条件**: テスト数が0-1個 AND 関数が未実装
**→ 🎯 Fake It戦略を強制適用**

**理由**: Kent Beck統計「60%以上でFake It使用」
**行動**: 必ずハードコーディングから開始

### 📊 状況2: 2つ目のテスト追加

**判定条件**: 同じ関数に対するテストが既に1個存在
**→ 🎯 Triangulation戦略を自動推奨**

**自動検出方法**:
```bash
# 同じ関数名のテスト数を確認
grep -c "[抽出した機能名]" src/**/*.test.* 2>/dev/null
```

**行動**: ハードコーディングを破る一般化実装

### 📊 状況3: 明白な実装（稀）

**判定条件**: 実装が数学的に自明（square, abs等）
**→ 🎯 Obvious Implementation戦略を許可**

**注意**: Kent Beck「確信がない場合はFake Itを使え」

#### 戦略1: Fake It（最も重要）

**Kent Beck**: 「恥ずかしがらずにハードコーディングから始める」

**🚨 Fake It強制チェック**:
1. **テストの期待値を確認**してください：
   ```bash
   # テストファイルから期待値を抽出
   grep -A2 -B2 "expect.*toBe\|assert" src/**/*.test.* | head -5
   ```

2. **期待値をそのままハードコーディング**してください：
   ```javascript
   // ❌ 間違い: 最初から一般化
   function add(a, b) {
     return a + b; // これはFake Itではない！
   }
   
   // ✅ 正解: 完全なハードコーディング
   function add(a, b) {
     return 5; // テストが expect(add(2,3)).toBe(5) なら5を返す
   }
   ```

3. **Fake It適用確認**:
   ```bash
   # 実装ファイルにハードコード値があることを確認
   grep -n "return [0-9]\|return '[^']*'\|return \"[^\"]*\"" src/**/*.* 2>/dev/null
   ```

**Fake It成功基準**:
- ✅ テストの期待値と完全に一致する固定値を返す
- ✅ 引数を一切使用しない
- ✅ 条件分岐やループを含まない
- ✅ 「これで本当にいいの？」という恥ずかしさを感じる

**なぜFake Itか**:
- 設計の複雑さを避ける
- 最小の変更でテスト通過
- 次のテストで一般化を促進
- **Kent Beck統計**: 経験豊富な開発者ほどFake Itを多用

#### 戦略2: Triangulation（2つ目のテスト時）

**🔍 Triangulation自動検出システム**:

1. **同じ関数の既存テスト確認**:
   ```bash
   # 現在のテスト数を確認
   EXISTING_TESTS=$(grep -c "$ARGUMENTS" src/**/*.test.* 2>/dev/null || echo "0")
   echo "既存テスト数: $EXISTING_TESTS"
   ```

2. **ハードコーディング検出**:
   ```bash
   # 現在の実装がハードコードかチェック
   grep -n "return [0-9]\|return '[^']*'" src/**/*.* | grep "$ARGUMENTS"
   ```

**🎯 Triangulation適用条件**:
- ✅ 既存テストが1個以上存在
- ✅ 現在の実装がハードコーディング
- ✅ 新しいテストが既存テストと異なる入力値

**Triangulation実行手順**:

1. **2つ目のテストを追加**してください：
   ```javascript
   // 既存テスト: expect(add(2, 3)).toBe(5)
   // 新しいテスト: 異なる入力値で同じ関数をテスト
   test('should add different numbers', () => {
     expect(add(1, 4)).toBe(5); // 意図的に同じ期待値にしてハードコードを破る
   });
   ```

2. **テスト実行でハードコードの破綻確認**:
   ```bash
   npm test -- --watchAll=false --forceExit 2>&1
   ```

3. **一般化実装への強制変更**:
   ```javascript
   // ハードコードが破綻するため、一般化が必要
   function add(a, b) {
     return a + b; // ようやく正しい実装
   }
   ```

**Triangulation成功確認**:
- ✅ 2つ以上のテストが全て通過
- ✅ ハードコーディングが除去されている  
- ✅ 実装が一般化されている
- ✅ 引数を実際に使用している

#### 戦略3: Obvious Implementation（明白な場合のみ）

**⚠️ 危険: 慎重な適用判定が必要**

**🔍 Obvious Implementation適用判定**:

1. **実装の明白さチェック**:
   ```
   以下のいずれかに該当する場合のみ使用可能：
   
   ✅ 数学的に自明: square(x) = x * x
   ✅ 単純な変換: toString() = String(value)  
   ✅ 1行で完結: isEmpty() = array.length === 0
   ✅ ライブラリ呼び出し: uuid() = crypto.randomUUID()
   ```

2. **Kent Beck警告チェック**:
   ```
   以下の場合は絶対にFake Itを使用：
   
   ❌ ビジネスロジックを含む
   ❌ 条件分岐が必要
   ❌ エラーハンドリングが必要
   ❌ 実装方法に迷いがある
   ❌ 「これで合ってるかな？」と思う
   ```

3. **自信度チェック**（Kent Beck基準）:
   ```bash
   echo "実装に100%の確信がありますか？ (y/n)"
   read -r CONFIDENCE
   if [ "$CONFIDENCE" != "y" ]; then
     echo "🚨 Fake It戦略を使用してください"
   fi
   ```

**Obvious Implementation実装例**:
```javascript
// ✅ 明白な実装例
function square(x) {
  return x * x; // 数学的に自明
}

function isEmpty(array) {
  return array.length === 0; // 1行で完結
}

// ❌ 避けるべき例（Fake Itを使う）
function calculateTax(price, rate) {
  return price * rate; // ビジネスロジック→不明確
}
```

**🚨 戦略適用後の検証システム**

各戦略適用後に以下を確認してください：

1. **適用戦略の記録**:
   ```bash
   echo "[$(date)] $ARGUMENTS: Applied strategy - [Fake It/Triangulation/Obvious]" >> .claude/agile-artifacts/tdd-logs/strategy-log.md
   ```

2. **戦略適用の正当性確認**:
   ```bash
   # Fake It確認: ハードコードが存在するか
   if grep -q "return [0-9]\|return '[^']*'" src/**/*.*; then
     echo "✅ Fake It戦略適用済み"
   fi
   
   # Triangulation確認: 複数テストが存在するか
   if [ $(grep -c "$ARGUMENTS" src/**/*.test.* 2>/dev/null || echo "0") -ge 2 ]; then
     echo "✅ Triangulation戦略適用可能"
   fi
   ```

3. **Kent Beck原則遵守確認**:
   ```bash
   # テストファースト確認
   if [ ! -f src/**/*.test.* ]; then
     echo "🚨 エラー: テストファイルが存在しません"
   fi
   
   # 品質確認
   npm test -- --watchAll=false 2>&1 | grep -q "PASS" && echo "✅ 全テスト通過"
   ```

#### 2. テスト実行で成功確認

```bash
# 同じテストコマンドを再実行
npm test -- --watchAll=false --forceExit 2>&1
```

**確認項目**:
- ✅ テストが緑（成功）になる
- ✅ 既存テストが全て通過
- ✅ コンパイルエラーなし

#### 3. 動作確認（ユーザー体験の検証）

**実装した機能をユーザーの視点で確認**してください：

**体験重視型（摩擦ゼロ重視）**:

作成した単体HTMLファイルの確認を行ってください：

1. **作成されたHTMLファイルの具体的な場所を明示**して案内してください
   - ❌ 曖昧: "HTMLファイルをダブルクリック"
   - ✅ 具体的: "src/index.html をダブルクリック"

2. **OS別の開き方を詳細に説明**してください：
   - Mac: `open ファイルパス`
   - Windows: `start ファイルパス`  
   - Linux: `xdg-open ファイルパス`

3. **期待される動作を具体的に説明**してください：
   - ブラウザで即座に動作開始すること
   - 特定の画面要素が表示されること
   - 特定の機能が利用できること

4. **視覚的要素の確認方法を詳細に指示**してください：
   - 開発者ツール(F12)を開く手順
   - Consoleタブでの確認内容
   - 期待されるログメッセージの具体例
   - 画面上で確認すべき要素の詳細

5. **確認項目をチェックリスト形式で提示**してください：
   - インストール・設定不要で動作するか
   - ファイル一つで完結しているか
   - 実装した機能が期待通り動作するか
   - エラーが発生していないか

**開発効率型（フルスタック）**:
```bash
# 開発サーバー起動
npm run dev
echo "ブラウザで確認: http://localhost:3000"
echo "確認事項:"
echo "- 機能が期待通り動作するか？"
echo "- パフォーマンスは十分か？"
echo "- 拡張しやすい構造か？"
```

**学習型（理解重視）**:
```bash
# 段階的動作確認
echo "Step 1: 基本機能の確認"
echo "Step 2: 拡張機能の確認"
echo "Step 3: 高度な機能の確認"
echo "確認事項:"  
echo "- 各段階が理解できるか？"
echo "- 学習目標が達成できるか？"
echo "- 次のステップが明確か？"
```

**CLI系**:
```bash
# 直接実行テスト
node src/main.js test-input
echo "確認事項:"
echo "- 期待した結果が得られるか？"
echo "- エラーメッセージは分かりやすいか？"
echo "- 使いやすいインターフェースか？"
```

**体験品質チェック**:
```bash
echo "=== ユーザー体験評価 ==="
echo "1. 摩擦度: 使い始めるまでの手順数は？"
echo "2. 理解度: 使い方がすぐに分かるか？"
echo "3. 満足度: 期待した価値が得られるか？"
echo "4. 継続性: また使いたくなるか？"
```

#### 4. 品質チェック

```bash
# リンター実行
npm run lint 2>&1

# タイプチェック（TypeScriptの場合）
npm run typecheck 2>&1

# 全テスト再実行
npm test 2>&1
```

#### 🔍 GREENフェーズ完了確認

**チェック項目の更新（必須）**:
1. `.claude/agile-artifacts/iterations/iteration-plan-v1.0.md` を読み込み
2. 現在のタスクのGREENフェーズ項目を☐から☑️に更新
3. ファイルを保存して進捗を記録
4. **次のREFACTORフェーズに進む前に更新完了を確認**

**受け入れ条件チェック**:
```bash
bash ~/.claude/commands/shared/acceptance-criteria.sh check green "[抽出した機能名]" "最小実装完了"
```

**30秒フィードバック**:
```bash
bash ~/.claude/commands/shared/micro-feedback.sh step "1.2" "[抽出した機能名]"
```

#### 5. BEHAVIORコミット

**Tidy First原則**: 振る舞いの変更をコミット

```bash
git add .
git commit -m "[BEHAVIOR] Add [機能名]: [抽出した機能名] with Fake It implementation"
```

### 🔵 REFACTOR フェーズ: 構造改善

**Kent Beck**: 「動作するコードがあってから構造を改善する」

#### 1. 構造改善の実施

**振る舞いを変えずに構造のみ改善**:

- 変数名の改善
- 関数の分割
- 重複コードの除去
- 可読性の向上

**例**:
```javascript
// Before
function calc(x, y) {
  return x + y;
}

// After (構造改善)
function addTwoNumbers(firstNumber, secondNumber) {
  return firstNumber + secondNumber;
}
```

#### 2. テストで振る舞い保護確認

**必須**: リファクタリング後にテスト実行

```bash
npm test -- --watchAll=false --forceExit 2>&1
```

**確認項目**:
- ✅ 全テストが緑のまま
- ✅ 振る舞いが変化していない
- ✅ 新しいバグが発生していない

#### 🔍 REFACTORフェーズ完了確認

**チェック項目の更新（必須）**:
1. `.claude/agile-artifacts/iterations/iteration-plan-v1.0.md` を読み込み
2. 現在のタスクのREFACTORフェーズ項目を☐から☑️に更新
3. ファイルを保存して進捗を記録
4. **TDDサイクル完了として記録**

**受け入れ条件チェック**:
```bash
bash ~/.claude/commands/shared/acceptance-criteria.sh check refactor "$(echo "$ARGUMENTS")" "構造改善完了"
```

**30秒フィードバック**:
```bash
bash ~/.claude/commands/shared/micro-feedback.sh step "1.3" "$(echo "$ARGUMENTS")"
```

#### 3. STRUCTUREコミット

**Tidy First原則**: 構造改善をコミット

```bash
git add .
git commit -m "[STRUCTURE] $(echo "$ARGUMENTS"): Improve code structure and readability"
```

## 🔄 TDDサイクル継続

### 次のテスト追加

**現在の機能が完了した場合**:

1. **同じ機能の追加テストケース**:
   ```javascript
   // エッジケース
   test('should handle zero', () => {
     expect(add(0, 5)).toBe(5);
   });
   ```

2. **関連機能の追加**:
   ```javascript
   // 減算機能
   test('should subtract two numbers', () => {
     expect(subtract(5, 3)).toBe(2);
   });
   ```

### 🎉 TDDサイクル完了

**プロジェクト管理ファイルの最終更新（必須）**:
1. `.claude/agile-artifacts/stories/user-stories-v1.0.md` で該当ストーリーの進捗を更新
2. `.claude/agile-artifacts/iterations/iteration-plan-v1.0.md` でタスク完了をマーク
3. 両ファイルを保存して確実に記録

```text
✅ Kent Beck TDDサイクル完了！

🔴 RED: テスト作成 → 失敗確認完了
🟢 GREEN: 最小実装 → 成功確認完了  
🔵 REFACTOR: 構造改善 → 品質保持完了

🎯 実装機能: [機能名]
🧪 適用戦略: [Fake It/Triangulation/Obvious Implementation]
📝 コミット: BEHAVIORコミット + STRUCTUREコミット
📊 プロジェクト進捗: ストーリー・イテレーション計画更新完了
```

**機能完了時の具体的なテスト案内**:

以下を実行して、プロジェクトタイプに応じた**具体的なテスト手順**を確認してください：

```bash
bash ~/.claude/commands/shared/completion-message-generator.sh
```

**このコマンドにより**：
- ✅ 実装した機能の**具体的なテスト方法**が表示される
- ✅ プロジェクトタイプに応じた**期待される動作**を確認できる  
- ✅ **簡単なフィードバック**で機能の品質を評価できる

```text
🔄 次のTDDサイクル:
/tdd:run  # 自動判定で次の機能を開始
```

#### 🔄 2分イテレーションフィードバック

**Kent Beck XP価値評価**:
```bash
bash ~/.claude/commands/shared/micro-feedback.sh iteration "1"
```

#### 📊 進捗状況更新

**ストーリー進捗チェック**:
```bash
bash ~/.claude/commands/shared/story-tracker.sh check "$(echo "$ARGUMENTS")" "TDDサイクル完了"
```

**イテレーション追跡更新**:
```bash
bash ~/.claude/commands/shared/iteration-tracker.sh complete-task "1" "1.1"
```

#### 🧠 Kent Beck流次アクション分析

**科学的な次アクション決定**:
```bash
bash ~/.claude/commands/shared/analyze-next-action.sh "1.1" "fake_it" 1 30
```

**高不安度項目チェック**:
```bash
bash ~/.claude/commands/shared/todo-manager.sh list high
```

#### 📈 全体状況ダッシュボード

**詳細進捗確認**:
```bash
bash ~/.claude/commands/shared/progress-dashboard.sh detailed
```

#### 🎯 Kent Beck原則に基づく次アクション選択

**システム推奨アクション**（analyze-next-action.shの結果に基づく）:

1. **同じ機能のTriangulation** - 2つ目のテストで一般化
2. **高不安度項目への着手** - "Most Anxious Thing First"原則
3. **関連機能のTDD** - 次の機能をTDDで追加
4. **ユーザーフィードバック** - 実装した機能の使用感確認
5. **品質向上** - より高度なリファクタリング実施
6. **機能完了** - 現在の機能で満足

**重要**: 高不安度項目（5/7以上）がある場合は、Kent Beck原則により必ずそれから着手してください。

**次のTDDサイクル開始**:
```
/tdd:run  # 自動判定で最適な次の機能を開始
```

## 🚨 TDD原則厳守チェック

各段階で以下を確認してください：

### ✅ RED段階チェック

- [ ] テストが実際に失敗する
- [ ] 失敗理由が期待通り
- [ ] 1つのテストのみ作成

### ✅ GREEN段階チェック  

- [ ] 最小の変更でテストが通る
- [ ] Kent Beck戦略を適用
- [ ] 全テストが通過

### ✅ REFACTOR段階チェック

- [ ] 振る舞いが変化していない
- [ ] テストが全て緑のまま
- [ ] 構造のみ改善

### ✅ 品質保証

- [ ] コンパイルエラーなし
- [ ] リンターエラーなし
- [ ] 実際の動作確認完了

## 💡 Kent Beck智慧の実践

### TDDマントラ

「**Red, Green, Refactor. Red, Green, Refactor.**」

### 設計哲学

「**テストがコードの設計を駆動する**」
- テストが先にAPIを定義
- 使いやすいAPIが自然に出現
- 複雑性の早期発見

### 品質哲学

「**動かしてから直す**」
- Make it work（動作させる）
- Make it right（正しくする）
- Make it fast（速くする）

## 🛠️ 統合Kent Beck改善ツール

### 7つの智慧ツール

#### 1. 🧠 次アクション分析システム

```bash
bash ~/.claude/commands/shared/analyze-next-action.sh <step_id> <strategy> <anxiety> <elapsed_time>
```
- Kent Beck戦略自動判定
- 実装ステージ分析
- 科学的次アクション推奨

#### 2. 📝 不安優先ToDo管理

```bash
bash ~/.claude/commands/shared/todo-manager.sh add "エラーハンドリング"
bash ~/.claude/commands/shared/todo-manager.sh anxiety
```
- "Most Anxious Thing First"原則実装
- 自動優先度判定
- 1-7不安度スコア

#### 3. 📖 ストーリー進捗追跡

```bash
bash ~/.claude/commands/shared/story-tracker.sh check "機能名" "結果"
bash ~/.claude/commands/shared/story-tracker.sh progress
```
- 受け入れ基準自動検出
- インタラクティブ進捗更新
- 開発フェーズ判定

#### 4. 📊 リアルタイム進捗ダッシュボード

```bash
bash ~/.claude/commands/shared/progress-dashboard.sh compact
bash ~/.claude/commands/shared/progress-dashboard.sh detailed
```
- プロジェクト全体状況
- 品質指標算出
- 推奨アクション生成

#### 5. ⚡ マイクロフィードバックループ

```bash
bash ~/.claude/commands/shared/micro-feedback.sh step "1.1" "機能名"
bash ~/.claude/commands/shared/micro-feedback.sh iteration "1"
```
- 30秒ステップフィードバック
- 2分イテレーションフィードバック
- XP価値評価（Communication, Simplicity, Feedback, Courage）

#### 6. ✅ 受け入れ条件明示システム

```bash
bash ~/.claude/commands/shared/acceptance-criteria.sh check red "1.1" "機能名"
bash ~/.claude/commands/shared/acceptance-criteria.sh list
```
- RED/GREEN/REFACTORフェーズ別基準
- インタラクティブチェック
- Kent Beck戦略詳細説明

#### 7. 📋 YAML形式イテレーション追跡

```bash
bash ~/.claude/commands/shared/iteration-tracker.sh start "1"
bash ~/.claude/commands/shared/iteration-tracker.sh add-task "1" "機能名"
bash ~/.claude/commands/shared/iteration-tracker.sh status "1"
```
- 90分イテレーション管理
- TDDサイクル統合
- メトリクス自動計算

### 統合ワークフロー

**1. セッション開始**:
```bash
bash ~/.claude/commands/shared/progress-dashboard.sh compact
bash ~/.claude/commands/shared/todo-manager.sh anxiety
```

**2. 各TDDフェーズ完了後**:
```bash
bash ~/.claude/commands/shared/acceptance-criteria.sh check [red|green|refactor] "機能名" "結果"
bash ~/.claude/commands/shared/micro-feedback.sh step "ステップID" "機能名"
```

**3. TDDサイクル完了後**:
```bash
bash ~/.claude/commands/shared/micro-feedback.sh iteration "イテレーションID"
bash ~/.claude/commands/shared/story-tracker.sh check "機能名" "結果"
bash ~/.claude/commands/shared/analyze-next-action.sh "ステップID" "戦略" "不安度" "時間"
bash ~/.claude/commands/shared/progress-dashboard.sh detailed
```

**4. セッション終了時**:
```bash
bash ~/.claude/commands/shared/iteration-tracker.sh status "イテレーションID"
bash ~/.claude/commands/shared/story-tracker.sh progress
```

この統合システムにより、Kent Beck純正TDDの真の力を最大限活用できます。