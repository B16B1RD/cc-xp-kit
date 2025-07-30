---
description: "TDD実行環境。Red→Green→Refactorサイクルを実行し、必須ゲートを通過させながら開発を進めます。"
argument-hint: "実行オプション（--step|--micro|--step X.Y|--resume）"
allowed-tools: ["Bash", "Read", "Write", "TodoWrite"]
---

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
START_CMD=$(extract_commands "$PRACTICE_FILE" "start")
DEV_CMD=$(extract_commands "$PRACTICE_FILE" "dev")

# コマンドが見つからない場合の fallback
[ -z "$TEST_CMD" ] && TEST_CMD="echo 'テストコマンドが設定されていません'"
[ -z "$LINT_CMD" ] && LINT_CMD="echo 'リントコマンドが設定されていません'"

# サーバー起動コマンドの優先度決定
SERVER_CMD=""
if [ -n "$DEV_CMD" ]; then
    SERVER_CMD="$DEV_CMD"
elif [ -n "$START_CMD" ]; then
    SERVER_CMD="$START_CMD"
elif [ -n "$RUN_CMD" ]; then
    SERVER_CMD="$RUN_CMD"
fi

echo "🔧 使用コマンド:"
echo "  - テスト: $TEST_CMD"
echo "  - リント: $LINT_CMD"
[ -n "$BUILD_CMD" ] && echo "  - ビルド: $BUILD_CMD"
[ -n "$SERVER_CMD" ] && echo "  - サーバー: $SERVER_CMD (バックグラウンド実行)"
```

### 4. 実行モードに応じた処理

#### イテレーション全体実行（デフォルト）

```text
🚀 イテレーション N 連続実行を開始します
────────────────────────────────────────
  📋 総ステップ数: X個
  ⏱️ 推定時間: XX分
  🎯 自動実行モード
────────────────────────────────────────

各ステップを自動的に実行していきます...
```

#### 単一ステップ実行（--step）

```text
🔄 単一ステップモードで実行します
次の未完了ステップのみを実行して終了します。
```

### 5. 各ステップの実行

#### 🔴 RED（テスト作成）

Kent Beck 視点で最小限のテストを作成。**REDフェーズ強制化**: テスト失敗確認まで次に進めません。

```bash
# 【REDフェーズ強制化】テスト作成と失敗確認
red_phase_gate() {
    echo "🔴 RED フェーズ: 失敗するテストの作成"
    echo "────────────────────────────────────────"
    
    # コンテキストに応じたディレクトリに移動
    if [ "$CONTEXT_DIR" != "." ]; then
        cd "$CONTEXT_DIR"
    fi

    # テスト作成前の状態確認
    echo "⚠️ 実装前のテスト実行（失敗することを確認）"
    echo "🧪 テスト実行: $TEST_CMD"
    
    # テスト実行結果を詳細に表示
    TEST_OUTPUT=$(eval "$TEST_CMD" 2>&1)
    TEST_EXIT_CODE=$?
    
    # テスト結果の詳細表示
    echo "$TEST_OUTPUT" | head -30
    echo ""
    echo "📊 テスト結果: 終了コード $TEST_EXIT_CODE"
    
    # REDフェーズ必須条件の厳格チェック
    if [ $TEST_EXIT_CODE -eq 0 ]; then
        echo "❌ 致命的エラー: テストが通ってしまいました！"
        echo "🚫 TDD原則違反 - 実装前にテストが成功するのは設計エラーです"
        echo ""
        echo "🔧 対処方法:"
        echo "  1. 実装コードを一時的に削除/コメントアウト"
        echo "  2. テストがエラーになることを確認"
        echo "  3. 再度実行"
        echo ""
        echo "⏹️ RED フェーズ完了まで次のフェーズには進めません"
        exit 1
    else
        echo "✅ REDフェーズ成功: テストが期待通り失敗しました"
        echo "🎯 失敗理由: $(echo "$TEST_OUTPUT" | grep -i "error\|failed\|exception" | head -3)"
        echo "📍 次: 最小限の実装でテストを通します（GREENフェーズ）"
        return 0
    fi
}

# REDフェーズゲート実行
red_phase_gate
```

#### 🟢 GREEN（最小実装）

**Fake It戦略必須**: 最初はハードコーディング。**GREENフェーズ強制化**: テスト成功確認後のみ次へ進行。

```bash
# 【GREENフェーズ強制化】最小実装とテスト成功確認
green_phase_gate() {
    echo "🟢 GREEN フェーズ: 最小実装でテストを通す"
    echo "────────────────────────────────────────"
    echo "💡 Fake It戦略: まずはハードコーディングで実装"
    echo ""
    
    # 実装後のテスト実行
    echo "🧪 実装後テスト実行: $TEST_CMD"
    TEST_OUTPUT=$(eval "$TEST_CMD" 2>&1)
    TEST_EXIT_CODE=$?
    
    # テスト結果の詳細表示
    echo "$TEST_OUTPUT" | head -30
    echo ""
    echo "📊 テスト結果: 終了コード $TEST_EXIT_CODE"
    
    # GREENフェーズ必須条件の厳格チェック
    if [ $TEST_EXIT_CODE -eq 0 ]; then
        echo "✅ GREENフェーズ成功: テストが通りました"
        
        # 必須ゲート: コード品質チェック
        echo ""
        echo "🔍 必須ゲート: コード品質チェック"
        echo "🧹 リント実行: $LINT_CMD"
        
        LINT_OUTPUT=$(eval "$LINT_CMD" 2>&1)
        LINT_EXIT_CODE=$?
        
        if [ $LINT_EXIT_CODE -ne 0 ]; then
            echo "❌ リントエラーが検出されました"
            echo "$LINT_OUTPUT" | head -15
            echo ""
            echo "🚫 品質ゲート不通過 - リントエラーを修正してください"
            exit 1
        fi
        
        echo "✅ リント通過: コード品質OK"
        echo "📍 次: 必要に応じてリファクタリング（REFACTORフェーズ）"
        return 0
    else
        echo "❌ GREENフェーズ失敗: テストがまだ失敗しています"
        echo "🔧 失敗理由: $(echo "$TEST_OUTPUT" | grep -i "error\|failed\|exception" | head -3)"
        echo ""
        echo "🚫 実装を確認・修正してから再実行してください"
        exit 1
    fi
}

# GREENフェーズゲート実行
green_phase_gate
```

コミット:

```bash
git add .
git commit -m "[BEHAVIOR] Step X.Y: Fake It implementation"
```

#### 🔵 REFACTOR（必要時）

**構造的変更のみ**: 振る舞いは変えない。**REFACTORフェーズ強制化**: リファクタリング実行とテスト確認。

```bash
# 【REFACTORフェーズ強制化】構造改善と動作保証
refactor_phase_gate() {
    echo "🔵 REFACTOR フェーズ: 構造的改善（振る舞いは変更しない）"
    echo "────────────────────────────────────────"
    echo "⚠️ 重要: 機能追加ではなく、コードの構造のみを改善"
    echo ""
    
    # リファクタ前のテスト状態を記録
    echo "📸 リファクタ前のテスト状態を記録"
    PRE_REFACTOR_OUTPUT=$(eval "$TEST_CMD" 2>&1)
    PRE_REFACTOR_EXIT=$?
    
    if [ $PRE_REFACTOR_EXIT -ne 0 ]; then
        echo "❌ リファクタ前にテストが失敗しています"
        echo "🚫 REFACTORフェーズは成功状態からのみ開始可能"
        exit 1
    fi
    
    echo "✅ リファクタ前: テスト成功状態確認済み"
    echo ""
    echo "🔄 リファクタリング実行中..."
    echo "（構造的変更を実施してください）"
    echo ""
    
    # リファクタ後の動作保証確認
    echo "🧪 リファクタ後の動作保証確認: $TEST_CMD"
    POST_REFACTOR_OUTPUT=$(eval "$TEST_CMD" 2>&1)
    POST_REFACTOR_EXIT=$?
    
    # テスト結果の詳細表示
    echo "$POST_REFACTOR_OUTPUT" | head -30
    echo ""
    echo "📊 リファクタ後テスト結果: 終了コード $POST_REFACTOR_EXIT"
    
    # REFACTORフェーズ必須条件の厳格チェック
    if [ $POST_REFACTOR_EXIT -eq 0 ]; then
        echo "✅ REFACTORフェーズ成功: 振る舞いが保持されています"
        
        # 必須ゲート: コード品質向上確認
        echo ""
        echo "🔍 必須ゲート: リファクタ後品質チェック"
        echo "🧹 リント実行: $LINT_CMD"
        
        REFACTOR_LINT_OUTPUT=$(eval "$LINT_CMD" 2>&1)
        REFACTOR_LINT_EXIT=$?
        
        if [ $REFACTOR_LINT_EXIT -ne 0 ]; then
            echo "❌ リファクタ後にリントエラーが発生"
            echo "$REFACTOR_LINT_OUTPUT" | head -15
            echo ""
            echo "🚫 リファクタリングでコード品質が悪化しました"
            exit 1
        fi
        
        echo "✅ リファクタ後品質: 向上またはNa維持"
        echo "🎯 REFACTORフェーズ完了: 構造的改善成功"
        return 0
    else
        echo "❌ 致命的エラー: リファクタで動作が破壊されました"
        echo "🚫 テストが失敗 - 振る舞いの変更は禁止です"
        echo ""
        echo "🔧 対処方法:"
        echo "  1. リファクタリング変更を元に戻す"
        echo "  2. テストが通ることを確認"
        echo "  3. より慎重にリファクタリングを実施"
        echo ""
        exit 1
    fi
}

# REFACTORフェーズゲート実行
refactor_phase_gate

# リファクタ成功時のコミット
git add .
git commit -m "[STRUCTURE] Step X.Y: Refactor for better structure"
```

### 4. 必須チェック（各ステップ後）

参照: `~/.claude/commands/shared/mandatory-gates.md`

- **動作確認**: プロジェクトタイプに応じて実施
  - Web: サーバーバックグラウンド起動 + Playwright MCP でスクリーンショット
  - CLI: コマンド実行結果
  - API: サーバーバックグラウンド起動 + curl でレスポンス確認

```bash
# 【サーバーバックグラウンド実行機能】タイムアウトなしでサーバー起動
start_server_background() {
    local project_type="$1"
    
    if [ "$project_type" = "web" ] || [ "$project_type" = "api" ]; then
        if [ -n "$SERVER_CMD" ]; then
            echo "🚀 サーバーバックグラウンド起動中..."
            echo "📝 コマンド: $SERVER_CMD"
            
            # バックグラウンドでサーバー起動（タイムアウトなし）
            nohup bash -c "$SERVER_CMD" > server.log 2>&1 &
            SERVER_PID=$!
            
            echo "📊 サーバー PID: $SERVER_PID"
            echo "📄 ログファイル: server.log"
            
            # サーバー起動確認（短時間待機）
            echo "⏳ サーバー起動を少し待機..."
            sleep 3
            
            # プロセスが生きているか確認
            if kill -0 "$SERVER_PID" 2>/dev/null; then
                echo "✅ サーバーがバックグラウンドで実行中"
                
                # ポート検出試行（オプション）
                detect_server_port
                
                return 0
            else
                echo "❌ サーバー起動に失敗しました"
                echo "📄 エラーログ:"
                tail -10 server.log 2>/dev/null || echo "ログファイルが見つかりません"
                return 1
            fi
        else
            echo "⚠️ サーバーコマンドが設定されていません"
            return 1
        fi
    else
        echo "📝 $project_type プロジェクトはサーバー不要"
        return 0
    fi
}

# ポート検出機能
detect_server_port() {
    echo "🔍 サーバーポート検出中..."
    
    # 一般的なポートをチェック
    for port in 3000 8000 8080 5000 4000 9000; do
        if netstat -tuln 2>/dev/null | grep -q ":$port "; then
            echo "🌐 サーバーポート発見: $port"
            echo "📋 アクセスURL: http://localhost:$port"
            export DETECTED_SERVER_PORT="$port"
            return 0
        fi
    done
    
    echo "📄 ログからポート情報を検索..."
    local port_from_log=$(grep -i "port\|listen" server.log 2>/dev/null | grep -o "[0-9]\{4,5\}" | head -1)
    
    if [ -n "$port_from_log" ]; then
        echo "🌐 ログからポート発見: $port_from_log"
        echo "📋 アクセスURL: http://localhost:$port_from_log"
        export DETECTED_SERVER_PORT="$port_from_log"
    else
        echo "⚠️ ポートが自動検出できませんでした"
    fi
}

# サーバー停止機能
stop_server_background() {
    if [ -n "$SERVER_PID" ] && kill -0 "$SERVER_PID" 2>/dev/null; then
        echo "🛑 サーバー停止中 (PID: $SERVER_PID)"
        kill "$SERVER_PID" 2>/dev/null
        sleep 2
        
        # 強制終了が必要な場合
        if kill -0 "$SERVER_PID" 2>/dev/null; then
            echo "🔄 強制停止実行"
            kill -9 "$SERVER_PID" 2>/dev/null
        fi
        
        echo "✅ サーバー停止完了"
    fi
}
```

- **受け入れ基準**: ストーリーファイルを更新

```bash
# 【改善】完全同期機能: ストーリーとイテレーションの状態を完全に同期
sync_progress_files() {
    local current_step="$1"
    local criteria_completed="$2"
    local phase="$3"  # RED, GREEN, REFACTOR
    
    echo "🔄 ファイル同期開始: Step $current_step ($phase フェーズ)"
    
    # Step情報を解析（例: "1.2" -> Story="1.2", Iteration="1"）
    local story_id=$(echo "$current_step" | sed 's/\([0-9]\+\)\..*/\1/')
    local iteration_num="$story_id"
    
    # 1. ストーリーファイルの更新
    update_story_criteria() {
        local story="$1"
        local criteria="$2"
        local story_file=".claude/agile-artifacts/stories/project-stories.md"
        
        if [ -f "$story_file" ]; then
            # 該当ストーリーの受け入れ基準を更新
            sed -i "/\*\*Story.*$story/,/^\*\*Story\|^$/s/- \[ \] .*${criteria}/- \[x\] ${criteria}/" "$story_file"
            echo "  ✅ ストーリー更新: Story $story - $criteria"
        else
            echo "  ⚠️ ストーリーファイルが見つかりません: $story_file"
        fi
    }
    
    # 2. イテレーションファイルの更新
    update_iteration_step() {
        local iteration="$1"
        local step="$2"
        local iteration_file=".claude/agile-artifacts/iterations/iteration-${iteration}.md"
        
        if [ -f "$iteration_file" ]; then
            # 該当ステップの進捗マークを更新
            sed -i "/Step.*$step/,/^###\|^$/s/- \[ \]/- \[x\]/g" "$iteration_file"
            echo "  ✅ イテレーション更新: Iteration $iteration - Step $step"
        else
            echo "  ⚠️ イテレーションファイルが見つかりません: $iteration_file"
        fi
    }
    
    # 3. 必須ゲートの更新
    update_mandatory_gates() {
        local iteration="$1"
        local gate_type="$2"  # "動作確認", "受け入れ基準", "Gitコミット"
        local iteration_file=".claude/agile-artifacts/iterations/iteration-${iteration}.md"
        
        if [ -f "$iteration_file" ]; then
            # 特定の必須ゲートを更新
            sed -i "/## 必須ゲート/,/^##\|^$/s/- \[ \] \*\*${gate_type}\*/- \[x\] **${gate_type}**/" "$iteration_file"
            echo "  ✅ 必須ゲート更新: $gate_type"
        fi
    }
    
    # 実際の更新実行
    case "$phase" in
        "RED")
            update_story_criteria "$story_id" "テスト失敗確認"
            update_iteration_step "$iteration_num" "$current_step"
            update_mandatory_gates "$iteration_num" "動作確認"
            ;;
        "GREEN")
            update_story_criteria "$story_id" "実装完了"
            update_story_criteria "$story_id" "テスト成功"
            update_mandatory_gates "$iteration_num" "受け入れ基準"
            ;;
        "REFACTOR")
            update_story_criteria "$story_id" "リファクタリング完了"
            update_mandatory_gates "$iteration_num" "Gitコミット"
            ;;
    esac
    
    echo "💾 ファイル同期完了: $current_step ($phase)"
}

# ステップ完了時の同期実行（例）
# sync_progress_files "1.2" "実装完了" "GREEN"
```

- **進捗更新**: イテレーションファイルの必須ゲート更新

```bash
# 【改善終了】新しい完全同期機能を使用
# 例: sync_progress_files "1.2" "実装完了" "GREEN"
# 実際の使用時は、各フェーズで適切なパラメータで呼び出す
```

### 5. 完了確認と継続判定

各ステップ完了後、完全な確認と同期を実行：

```bash
# 【完全確認機能強化】ストーリーとイテレーションの完全確認
strict_completion_check() {
    local current_step="$1"
    local phase="$2"
    
    echo "🔍 完了確認開始: Step $current_step ($phase フェーズ)"
    echo "────────────────────────────────────────"
    
    local story_id=$(echo "$current_step" | sed 's/\([0-9]\+\)\..*/\1/')
    local iteration_num="$story_id"
    local story_file=".claude/agile-artifacts/stories/project-stories.md"
    local iteration_file=".claude/agile-artifacts/iterations/iteration-${iteration_num}.md"
    
    # 1. ストーリー完了確認（強化版）
    check_story_strict() {
        if [ ! -f "$story_file" ]; then
            echo "❌ 致命的エラー: ストーリーファイルが存在しません: $story_file"
            exit 1
        fi
        
        # 該当ストーリーの未完了数をカウント
        local unchecked=$(grep -A 15 "\*\*Story.*$story_id" "$story_file" | grep -c "- \[ \]" || echo "0")
        
        if [ "$unchecked" -gt 0 ]; then
            echo "❌ Story $story_id: 未完了の受け入れ基準 $unchecked 個"
            
            # 未完了項目を表示
            echo "📋 未完了項目:"
            grep -A 15 "\*\*Story.*$story_id" "$story_file" | grep "- \[ \]" | head -5
            echo ""
            echo "🚫 次のステップに進むには、全ての受け入れ基準を完了してください"
            return 1
        else
            echo "✅ Story $story_id: 全ての受け入れ基準が完了"
            return 0
        fi
    }
    
    # 2. イテレーション完了確認（強化版）
    check_iteration_strict() {
        if [ ! -f "$iteration_file" ]; then
            echo "❌ 致命的エラー: イテレーションファイルが存在しません: $iteration_file"
            exit 1
        fi
        
        # ステップ完了確認
        local unchecked_steps=$(grep -A 5 "Step.*$current_step" "$iteration_file" | grep -c "- \[ \]" || echo "0")
        
        if [ "$unchecked_steps" -gt 0 ]; then
            echo "❌ Iteration $iteration_num Step $current_step: 未完了タスク $unchecked_steps 個"
            return 1
        fi
        
        # 必須ゲート確認
        local unchecked_gates=$(grep -A 20 "## 必須ゲート" "$iteration_file" | grep -c "- \[ \]" || echo "0")
        
        if [ "$unchecked_gates" -gt 0 ]; then
            echo "❌ Iteration $iteration_num: 未完了の必須ゲート $unchecked_gates 個"
            
            # 未完了ゲートを表示
            echo "📋 未完了ゲート:"
            grep -A 20 "## 必須ゲート" "$iteration_file" | grep "- \[ \]" | head -3
            echo ""
            echo "🚫 レビューに進むには、全ての必須ゲートを通過してください"
            return 1
        else
            echo "✅ Iteration $iteration_num: 全ての必須ゲートが完了"
            return 0
        fi
    }
    
    # 3. 総合確認実行
    local story_ok=false
    local iteration_ok=false
    
    if check_story_strict; then
        story_ok=true
    fi
    
    if check_iteration_strict; then
        iteration_ok=true
    fi
    
    # 結果判定
    if [ "$story_ok" = true ] && [ "$iteration_ok" = true ]; then
        echo ""
        echo "✅ 完了確認成功: Step $current_step ($phase フェーズ) の全ての条件が満たされています"
        echo "📍 次のフェーズに進むことができます"
        return 0
    else
        echo ""
        echo "❌ 完了確認失敗: 未完了のタスクがあります"
        echo "🚫 TDDプロセスでは、各フェーズの完全完了が必須です"
        exit 1
    fi
}

# 各フェーズ後の必須確認実行（例）
# strict_completion_check "1.2" "GREEN"
```

### 6. モードに応じた完了処理

#### イテレーション完了時（デフォルト）

全ステップ・全必須ゲート完了後、フィードバック収集を実行。

#### 単一ステップ完了時（--step）

```text
✅ Step X.Y 完了
次のステップを実行するには: /tdd:run --step
```

### 6. フィードバック収集（イテレーション完了時のみ）

#### 段階的フィードバック収集（1問ずつ）

**Step 1: 満足度確認**

```text
💭 イテレーション完了フィードバック

まず最初にお聞きします：

**今回のイテレーションは期待通りでしたか？**

1⭐ 全く期待外れ
2⭐ やや期待外れ  
3⭐ 普通
4⭐ やや期待以上
5⭐ 大変満足

数字でお答えください: [1-5]
```

**回答受信後、詳細コメントを収集**

```text
ありがとうございます。

**その理由を一言で教えてください：**
（良かった点・不満な点など）
```

**Step 2: 次の要望確認**

```text
次にお聞きします：

**次に欲しい機能や改善は何ですか？**

一番優先したいもの1つを教えてください。
```

**Step 3: プロセス改善確認**

```text
最後にお聞きします：

**開発プロセスで改善したい点はありますか？**

なければ「なし」とお答えください。
```

**全回答完了まで次に進めない制御**

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

### サーバーバックグラウンド実行の使用例

```bash
# Webプロジェクトの動作確認
if [ "$PROJECT_TYPE" = "web" ]; then
    # サーバーバックグラウンド起動
    start_server_background "web"
    
    # 動作確認実行
    if [ -n "$DETECTED_SERVER_PORT" ]; then
        echo "🖼️ Playwrightでスクリーンショット取得"
        # Playwright MCP でスクリーンショット取得処理
    fi
    
    # 確認後にサーバー停止
    stop_server_background
fi

# APIプロジェクトの動作確認
if [ "$PROJECT_TYPE" = "api" ]; then
    start_server_background "api"
    
    if [ -n "$DETECTED_SERVER_PORT" ]; then
        echo "🔍 APIレスポンス確認"
        curl -s "http://localhost:$DETECTED_SERVER_PORT/health" || echo "🩸 Healthチェック失敗"
        curl -s "http://localhost:$DETECTED_SERVER_PORT/api" || echo "🩸 APIチェック失敗"
    fi
    
    stop_server_background
fi
```

## 完了メッセージ

### イテレーション完了時

```text
🎉 イテレーション N 完了！
技術実装: 100%
フィードバック: 収集済み

次: /tdd:review N
```

### 単一ステップ完了時

```text
✅ Step X.Y 完了！
進捗: X/Y ステップ完了

続行: /tdd:run （イテレーション全体）
     /tdd:run --step （次のステップのみ）
```
