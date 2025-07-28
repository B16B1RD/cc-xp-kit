# TDD実行

オプション: $ARGUMENTS（--step, --micro, --step X.Y, --resume）

## 実行モード

### デフォルト: イテレーション全体の連続実行 🎯
オプションなしの場合、現在のイテレーションの全ステップを自動実行。

### オプション
- `--step`: 単一ステップのみ実行して終了
- `--micro`: ステップごとに確認しながら実行
- `--step X.Y`: 特定ステップから開始
- `--resume`: 中断箇所から再開

## 実行フロー

### 1. プロジェクトコンテキストの検出
```bash
# 言語検出ロジックを読み込み
source ~/.claude/commands/shared/language-detector.md

# 現在のコンテキストを検出
CURRENT_CONTEXT=$(get_current_context)
CONTEXT_DIR=$(echo "$CURRENT_CONTEXT" | cut -d: -f1)
CONTEXT_LANG=$(echo "$CURRENT_CONTEXT" | cut -d: -f2)

echo "🔍 実行コンテキスト: $CONTEXT_DIR ($CONTEXT_LANG)"

# 適用するプラクティスファイルを決定
if [ "$CONTEXT_LANG" = "mixed" ]; then
    # 混合プロジェクトの場合、プライマリ言語を使用
    MIXED_LANGUAGES=($(get_mixed_languages))
    PRIMARY_LANG=$(get_primary_language "${MIXED_LANGUAGES[@]}")
    PRACTICE_FILE=$(resolve_practice_file "$PRIMARY_LANG" "user")
    echo "📖 混合プロジェクト - プライマリ言語: $PRIMARY_LANG"
    echo "📖 適用プラクティス: $PRACTICE_FILE"
else
    PRACTICE_FILE=$(resolve_practice_file "$CONTEXT_LANG" "user")
    echo "📖 適用プラクティス: $PRACTICE_FILE"
fi
```

### 2. 準備
- 最新のイテレーションファイルを読み込み
- 前回フィードバックの確認（未収集なら警告）
- 言語別コマンドの準備

### 3. 言語別コマンドの準備
```bash
# プラクティスファイルから言語別コマンドを抽出
extract_commands() {
    local practice_file="$1"
    local command_type="$2"  # test, lint, build, run など
    
    # プラクティスファイルから該当コマンドを抽出
    grep "^$command_type:" "$practice_file" | cut -d'"' -f2 2>/dev/null || echo ""
}

# 各種コマンドを設定
TEST_CMD=$(extract_commands "$PRACTICE_FILE" "test")
LINT_CMD=$(extract_commands "$PRACTICE_FILE" "lint")
BUILD_CMD=$(extract_commands "$PRACTICE_FILE" "build")
RUN_CMD=$(extract_commands "$PRACTICE_FILE" "run")

# コマンドが見つからない場合の fallback
[ -z "$TEST_CMD" ] && TEST_CMD="echo 'テストコマンドが設定されていません'"
[ -z "$LINT_CMD" ] && LINT_CMD="echo 'リントコマンドが設定されていません'"

echo "🔧 使用コマンド:"
echo "  - テスト: $TEST_CMD"
echo "  - リント: $LINT_CMD"
[ -n "$BUILD_CMD" ] && echo "  - ビルド: $BUILD_CMD"
[ -n "$RUN_CMD" ] && echo "  - 実行: $RUN_CMD"
```

### 4. 実行モードに応じた処理

#### イテレーション全体実行（デフォルト）
```
🚀 イテレーション N 連続実行を開始します
────────────────────────────────────────
  📋 総ステップ数: X個
  ⏱️ 推定時間: XX分
  🎯 自動実行モード
────────────────────────────────────────

各ステップを自動的に実行していきます...
```

#### 単一ステップ実行（--step）
```
🔄 単一ステップモードで実行します
次の未完了ステップのみを実行して終了します。
```

### 5. 各ステップの実行

#### 🔴 RED（テスト作成）
Kent Beck 視点で最小限のテストを作成。

言語別テスト実行:
```bash
# コンテキストに応じたディレクトリに移動
if [ "$CONTEXT_DIR" != "." ]; then
    cd "$CONTEXT_DIR"
fi

# 言語別テストコマンドを実行
echo "🧪 テスト実行: $TEST_CMD"
eval "$TEST_CMD" 2>&1 | head -20

# テスト結果の確認
TEST_EXIT_CODE=${PIPESTATUS[0]}
if [ $TEST_EXIT_CODE -eq 0 ]; then
    echo "❌ テストが通ってしまいました！まずは失敗するテストを書いてください。"
    exit 1
else
    echo "✅ テストが失敗しました。RED フェーズ完了。"
fi
```

#### 🟢 GREEN（最小実装）
必ず Fake It から始める。実装後のテスト実行:

```bash
# 実装後のテスト実行
echo "🧪 実装後テスト実行: $TEST_CMD"
eval "$TEST_CMD" 2>&1 | head -20

TEST_EXIT_CODE=${PIPESTATUS[0]}
if [ $TEST_EXIT_CODE -eq 0 ]; then
    echo "✅ テストが通りました。GREEN フェーズ完了。"
    
    # 必須ゲート: リント実行
    echo "🔍 リント実行: $LINT_CMD"
    eval "$LINT_CMD" 2>&1 | head -10
    
    LINT_EXIT_CODE=${PIPESTATUS[0]}
    if [ $LINT_EXIT_CODE -ne 0 ]; then
        echo "⚠️ リントエラーがあります。修正してください。"
        exit 1
    fi
    
    echo "✅ リントも通りました。"
else
    echo "❌ テストがまだ失敗しています。実装を確認してください。"
    exit 1
fi
```

コミット:
```bash
git add .
git commit -m "[BEHAVIOR] Step X.Y: Fake It implementation"
```

#### 🔵 REFACTOR（必要時）
構造的変更のみ（振る舞いは変えない）。リファクタ後の確認:

```bash
# リファクタ後のテスト実行（振る舞いが変わってないことを確認）
echo "🧪 リファクタ後テスト実行: $TEST_CMD"
eval "$TEST_CMD" 2>&1 | head -20

TEST_EXIT_CODE=${PIPESTATUS[0]}
if [ $TEST_EXIT_CODE -eq 0 ]; then
    echo "✅ リファクタ後もテストが通っています。"
    
    # 必須ゲート: リント実行
    echo "🔍 リント実行: $LINT_CMD"
    eval "$LINT_CMD" 2>&1 | head -10
    
    LINT_EXIT_CODE=${PIPESTATUS[0]}
    if [ $LINT_EXIT_CODE -ne 0 ]; then
        echo "⚠️ リントエラーがあります。修正してください。"
        exit 1
    fi
    
    echo "✅ REFACTOR フェーズ完了。"
else
    echo "❌ リファクタでテストが壊れました！変更を確認してください。"
    exit 1
fi

git add .
git commit -m "[STRUCTURE] Step X.Y: Extract method"
```

### 4. 必須チェック（各ステップ後）
参照: `~/.claude/commands/shared/mandatory-gates.md`

- **動作確認**: プロジェクトタイプに応じて実施
  - Web: Playwright MCP でスクリーンショット
  - CLI: コマンド実行結果
  - API: curl でレスポンス確認

- **受け入れ基準**: ストーリーファイルを更新
```bash
sed -i 's/\[ \]/\[x\]/' project-stories.md
```

- **進捗更新**: イテレーションファイルの保存

### 5. モードに応じた完了処理

#### イテレーション完了時（デフォルト）
すべてのステップ完了後、フィードバック収集を実行。

#### 単一ステップ完了時（--step）
```
✅ Step X.Y 完了
次のステップを実行するには: /tdd:run --step
```

### 6. フィードバック収集（イテレーション完了時のみ）

#### 簡素版（1分で完了）
```
💭 3つの質問：

1. 期待通りでしたか？ [5段階 + コメント]
2. 次に欲しい機能は？ [一言で]
3. 改善点は？ [あれば]
```

すべて回答されるまで完了としない。

### 7. フィードバック保存
`.claude/agile-artifacts/reviews/iteration-N-feedback.md`:
```bash
git commit -m "[BEHAVIOR] Save iteration N feedback"
```

## エラー対応
参照: `~/.claude/commands/shared/error-handling.md`

エラー時は 3 つの質問に答えてから対応。

## プロジェクトタイプ別確認
参照: `~/.claude/commands/shared/project-verification.md`

## 完了メッセージ

### イテレーション完了時
```
🎉 イテレーション N 完了！
技術実装: 100%
フィードバック: 収集済み

次: /tdd:review N
```

### 単一ステップ完了時
```
✅ Step X.Y 完了！
進捗: X/Y ステップ完了

続行: /tdd:run （イテレーション全体）
     /tdd:run --step （次のステップのみ）
```
