#!/bin/bash

# プロジェクトタイプ判定スクリプト
# 使用法: bash project-type-detector.sh [project-directory]

PROJECT_DIR=${1:-.}
STORIES_FILE="$PROJECT_DIR/docs/agile-artifacts/stories/user-stories-v1.0.md"

# プロジェクトタイプを判定
detect_project_type() {
    local project_dir="$1"
    
    # user-storiesファイルから技術スタック情報を抽出
    if [ -f "$STORIES_FILE" ]; then
        local tech_stack=$(grep "技術スタック" "$STORIES_FILE" | head -1)
        
        # 体験重視型の判定
        if echo "$tech_stack" | grep -q "単一.*ファイル\|単体.*ファイル\|HTML.*ファイル"; then
            echo "experience-focused"
            return 0
        fi
        
        # CLI型の判定
        if echo "$tech_stack" | grep -q -i "cli\|command.*line\|コマンド"; then
            echo "cli-focused"
            return 0
        fi
        
        # API型の判定
        if echo "$tech_stack" | grep -q -i "api\|server\|express\|fastapi\|rest"; then
            echo "api-focused"
            return 0
        fi
    fi
    
    # ファイル構造から判定（優先度順）
    
    # 1. 体験重視型の判定（最優先）
    if [ -d "$project_dir/dist" ] && find "$project_dir/dist" -name "*.html" -o -name "*.exe" 2>/dev/null | grep -q .; then
        echo "experience-focused"
        return 0
    fi
    
    # 2. CLI型の判定
    if [ -f "$project_dir/src/main.js" ] || [ -f "$project_dir/src/cli.js" ] || find "$project_dir/bin" -type f 2>/dev/null | grep -q .; then
        echo "cli-focused"
        return 0
    fi
    
    # 3. package.jsonベースの判定
    if [ -f "$project_dir/package.json" ]; then
        # API型の判定
        if grep -q -i "express\|fastify\|koa\|server" "$project_dir/package.json"; then
            echo "api-focused"
            return 0
        fi
        
        # 開発効率型の判定
        if grep -q "\"dev\":\|\"start\":" "$project_dir/package.json"; then
            echo "development-focused"
            return 0
        fi
    fi
    
    # 4. TDDキット自体の判定（特殊ケース）
    if [ -d "$project_dir/src/commands" ] && [ -d "$project_dir/src/subcommands" ]; then
        echo "cli-focused"
        return 0
    fi
    
    # デフォルトは開発効率型
    echo "development-focused"
}

# メイン実行
PROJECT_TYPE=$(detect_project_type "$PROJECT_DIR")
echo "$PROJECT_TYPE"