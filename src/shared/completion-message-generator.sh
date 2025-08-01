#!/bin/bash

# 完了メッセージ生成スクリプト
# 使用法: bash completion-message-generator.sh [project-directory]

PROJECT_DIR=${1:-.}
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES_DIR="$SCRIPT_DIR/completion-templates"
STORIES_FILE="$PROJECT_DIR/docs/agile-artifacts/stories/user-stories-v1.0.md"

# プロジェクト情報を抽出
extract_project_info() {
    local stories_file="$1"
    local project_type="$2"
    
    # デフォルト値
    PROJECT_NAME="プロジェクト"
    OUTPUT_FILE="作成されたファイル"
    PROGRAM_TYPE="ブラウザ"
    START_COMMAND="npm run dev"  
    TEST_URL="http://localhost:3000"
    HELP_COMMAND="node src/main.js --help"
    USAGE_EXAMPLES="node src/main.js [引数]"
    API_TEST_COMMANDS="curl http://localhost:3000/api/health"
    TEST_URLS="http://localhost:3000/api/docs"
    PORT="3000"
    EXPECTED_BEHAVIORS="- 基本機能が正常に動作する"
    
    # 進捗情報のデフォルト値
    STORIES_FILE_PATH="プロジェクト計画ファイルが見つかりません" 
    STORY_PROGRESS_SUMMARY="進捗情報を取得できませんでした"
    COMPLETED_STORIES="なし"
    NEXT_STORY="未定"
    
    if [ -f "$stories_file" ]; then
        # プロジェクト名を抽出
        local project_line=$(grep "^\*\*プロジェクト\*\*:" "$stories_file" | head -1)
        if [ -n "$project_line" ]; then
            PROJECT_NAME=$(echo "$project_line" | sed 's/.*: *//' | sed 's/^ *//' | sed 's/ *$//')
        fi
        
        # 技術スタックに基づいて詳細情報を設定
        local tech_stack=$(grep "技術スタック" "$stories_file" | head -1)
        
        # 受け入れ基準から期待される動作を抽出
        local acceptance_criteria=$(sed -n '/受け入れ基準/,/^\*\*\|^##/p' "$stories_file" | grep -E '^\s*-\s*\[.\]\s*' | head -3)
        if [ -n "$acceptance_criteria" ]; then
            EXPECTED_BEHAVIORS=$(echo "$acceptance_criteria" | sed 's/^\s*-\s*\[.\]\s*/- /' | paste -sd '\n' -)
        fi
        
        # ストーリーファイルパスを設定
        STORIES_FILE_PATH="$stories_file"
        
        # 進捗情報を取得
        source "$SCRIPT_DIR/story-progress-analyzer.sh"
        analyze_stories "$stories_file" 2>/dev/null
        
        if [ $? -eq 0 ] && [ -n "$TOTAL_STORIES" ]; then
            # 進捗サマリーを生成
            STORY_PROGRESS_SUMMARY=$(generate_progress_summary "visual")
            COMPLETED_STORIES="$COMPLETED_STORIES_LIST"
            if [ -z "$COMPLETED_STORIES" ]; then
                COMPLETED_STORIES="なし"
            fi
            if [ -z "$NEXT_STORY" ]; then
                NEXT_STORY="未定"
            fi
        fi
    fi
    
    # プロジェクトタイプ固有の設定
    case "$project_type" in
        "experience-focused")
            # dist/ディレクトリから出力ファイルを検出
            if [ -d "$PROJECT_DIR/dist" ]; then
                OUTPUT_FILE=$(find "$PROJECT_DIR/dist" -name "*.html" -o -name "*.exe" | head -1 | sed "s|^$PROJECT_DIR/||")
            fi
            PROGRAM_TYPE="ブラウザ"
            ;;
        "development-focused")
            START_COMMAND="nohup npm run dev > /dev/null 2>&1 & echo \$! > .server.pid"
            STOP_COMMAND="kill \$(cat .server.pid 2>/dev/null) && rm -f .server.pid || echo 'サーバーは既に停止しています'"
            TEST_URL="http://localhost:3000"
            ;;
        "cli-focused") 
            # メインファイルを検出
            if [ -f "$PROJECT_DIR/src/main.js" ]; then
                HELP_COMMAND="node src/main.js --help"
                USAGE_EXAMPLES="node src/main.js [引数]"
            elif [ -f "$PROJECT_DIR/src/cli.js" ]; then
                HELP_COMMAND="node src/cli.js --help"  
                USAGE_EXAMPLES="node src/cli.js [引数]"
            fi
            ;;
        "api-focused")
            START_COMMAND="nohup npm start > /dev/null 2>&1 & echo \$! > .server.pid"
            STOP_COMMAND="kill \$(cat .server.pid 2>/dev/null) && rm -f .server.pid || echo 'サーバーは既に停止しています'"
            API_TEST_COMMANDS="curl http://localhost:3000/api/health"
            TEST_URLS="http://localhost:3000/api/docs"
            PORT="3000"
            ;;
    esac
}

# テンプレートの変数を置換
replace_template_variables() {
    local template_content="$1"
    
    # 改行を含む変数を一時ファイルで安全に処理
    local temp_file=$(mktemp)
    echo "$template_content" > "$temp_file"
    
    # 単純な変数を置換
    sed -i "s|#{PROJECT_NAME}|$PROJECT_NAME|g" "$temp_file"
    sed -i "s|#{OUTPUT_FILE}|$OUTPUT_FILE|g" "$temp_file"
    sed -i "s|#{PROGRAM_TYPE}|$PROGRAM_TYPE|g" "$temp_file"
    sed -i "s|#{TEST_URL}|$TEST_URL|g" "$temp_file"
    sed -i "s|#{HELP_COMMAND}|$HELP_COMMAND|g" "$temp_file"
    sed -i "s|#{USAGE_EXAMPLES}|$USAGE_EXAMPLES|g" "$temp_file"
    sed -i "s|#{API_TEST_COMMANDS}|$API_TEST_COMMANDS|g" "$temp_file"
    sed -i "s|#{TEST_URLS}|$TEST_URLS|g" "$temp_file"
    sed -i "s|#{PORT}|$PORT|g" "$temp_file"
    sed -i "s|#{STORIES_FILE_PATH}|$STORIES_FILE_PATH|g" "$temp_file"
    sed -i "s|#{COMPLETED_STORIES}|$COMPLETED_STORIES|g" "$temp_file"
    sed -i "s|#{NEXT_STORY}|$NEXT_STORY|g" "$temp_file"
    
    # 複雑な変数（改行を含む・特殊文字を含む）をPython で置換
    local temp_file2=$(mktemp)
    
    # 環境変数として設定
    export EXPECTED_BEHAVIORS_VAR="$EXPECTED_BEHAVIORS"
    export STORY_PROGRESS_VAR="$STORY_PROGRESS_SUMMARY"
    export START_COMMAND_VAR="$START_COMMAND"
    export STOP_COMMAND_VAR="$STOP_COMMAND"
    
    # Pythonを使った安全な置換
    python3 -c "
import sys
import os

content = open('$temp_file', 'r', encoding='utf-8').read()

# 環境変数から値を取得
expected_behaviors = os.environ.get('EXPECTED_BEHAVIORS_VAR', '')
story_progress = os.environ.get('STORY_PROGRESS_VAR', '')
start_command = os.environ.get('START_COMMAND_VAR', '')
stop_command = os.environ.get('STOP_COMMAND_VAR', '')

# 文字列置換
content = content.replace('#{EXPECTED_BEHAVIORS}', expected_behaviors)
content = content.replace('#{STORY_PROGRESS_SUMMARY}', story_progress)
content = content.replace('#{START_COMMAND}', start_command)
content = content.replace('#{STOP_COMMAND}', stop_command)

print(content, end='')
" > "$temp_file2"
    
    # 結果を出力
    cat "$temp_file2"
    
    rm -f "$temp_file" "$temp_file2"
}

# メイン実行
main() {
    # プロジェクトタイプを判定
    PROJECT_TYPE=$(bash "$SCRIPT_DIR/project-type-detector.sh" "$PROJECT_DIR")
    
    # プロジェクト情報を抽出（PROJECT_TYPEを明示的に渡す）
    extract_project_info "$STORIES_FILE" "$PROJECT_TYPE"
    
    # 対応するテンプレートファイルを選択
    TEMPLATE_FILE="$TEMPLATES_DIR/${PROJECT_TYPE}.md"
    
    if [ ! -f "$TEMPLATE_FILE" ]; then
        echo "エラー: テンプレートファイルが見つかりません: $TEMPLATE_FILE" >&2
        exit 1
    fi
    
    # テンプレートを読み込んで変数を置換
    TEMPLATE_CONTENT=$(cat "$TEMPLATE_FILE")
    replace_template_variables "$TEMPLATE_CONTENT"
}

# スクリプト実行
main "$@"