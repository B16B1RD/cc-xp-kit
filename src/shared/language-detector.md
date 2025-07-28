# 言語検出ロジック

## 検出フロー

### 1. プロジェクトタイプの判定
```bash
detect_project_type() {
    local project_root=$(pwd)
    local language_markers=()
    local found_languages=()
    
    # 言語マーカーファイルを再帰的に検索（最大2階層まで）
    while IFS= read -r -d '' file; do
        language_markers+=("$file")
    done < <(find . -maxdepth 2 \( \
        -name "package.json" -o \
        -name "pyproject.toml" -o \
        -name "requirements.txt" -o \
        -name "Cargo.toml" -o \
        -name "go.mod" -o \
        -name "pom.xml" -o \
        -name "build.gradle" -o \
        -name "*.csproj" -o \
        -name "Gemfile" -o \
        -name "composer.json" \
        \) -print0)
    
    # 各マーカーから言語を特定
    for marker in "${language_markers[@]}"; do
        case "$(basename "$marker")" in
            package.json)
                found_languages+=("javascript")
                ;;
            pyproject.toml|requirements.txt)
                found_languages+=("python")
                ;;
            Cargo.toml)
                found_languages+=("rust")
                ;;
            go.mod)
                found_languages+=("go")
                ;;
            pom.xml|build.gradle)
                found_languages+=("java")
                ;;
            *.csproj)
                found_languages+=("csharp")
                ;;
            Gemfile)
                found_languages+=("ruby")
                ;;
            composer.json)
                found_languages+=("php")
                ;;
        esac
    done
    
    # 重複を除去
    found_languages=($(printf '%s\n' "${found_languages[@]}" | sort -u))
    
    # プロジェクトタイプを決定
    if [ ${#found_languages[@]} -eq 0 ]; then
        echo "default"
    elif [ ${#found_languages[@]} -eq 1 ]; then
        echo "${found_languages[0]}"
    else
        # 複数言語の場合、サブディレクトリ構造を確認
        local has_subdirectory_structure=false
        
        # ルート直下以外に言語マーカーがあるかチェック
        while IFS= read -r -d '' file; do
            local dir=$(dirname "$file")
            if [ "$dir" != "." ]; then
                has_subdirectory_structure=true
                break
            fi
        done < <(find . -mindepth 2 -maxdepth 2 \( \
            -name "package.json" -o \
            -name "pyproject.toml" -o \
            -name "requirements.txt" -o \
            -name "Cargo.toml" -o \
            -name "go.mod" \
            \) -print0)
        
        if [ "$has_subdirectory_structure" = true ]; then
            echo "monorepo"
        else
            # ルート直下に複数言語 = 混合プロジェクト
            echo "mixed"
        fi
    fi
}
```

### 2. 混合プロジェクトの言語一覧取得
```bash
get_mixed_languages() {
    local languages=()
    
    # ルート直下の言語マーカーファイルを検出
    while IFS= read -r -d '' file; do
        local language=$(detect_language_from_file "$file")
        languages+=("$language")
    done < <(find . -maxdepth 1 \( \
        -name "package.json" -o \
        -name "pyproject.toml" -o \
        -name "requirements.txt" -o \
        -name "Cargo.toml" -o \
        -name "go.mod" \
        \) -print0)
    
    # 重複を除去してソート
    printf '%s\n' "${languages[@]}" | sort -u
}

# プライマリ言語の決定（混合プロジェクト用）
get_primary_language() {
    local languages=("$@")
    
    # 優先順序に基づいてプライマリ言語を決定
    local priority_order=("python" "javascript" "rust" "go")
    
    for priority_lang in "${priority_order[@]}"; do
        for lang in "${languages[@]}"; do
            if [ "$lang" = "$priority_lang" ]; then
                echo "$priority_lang"
                return 0
            fi
        done
    done
    
    # 優先順序にない場合は最初の言語
    echo "${languages[0]}"
}
```

### 3. サブプロジェクトの検出（モノレポ用）
```bash
detect_subprojects() {
    local subprojects=()
    
    # 各言語マーカーファイルとその場所を記録
    while IFS= read -r -d '' file; do
        local dir=$(dirname "$file")
        local language=$(detect_language_from_file "$file")
        
        if [ "$dir" != "." ]; then
            subprojects+=("$dir:$language")
        fi
    done < <(find . -mindepth 2 -maxdepth 3 \( \
        -name "package.json" -o \
        -name "pyproject.toml" -o \
        -name "Cargo.toml" -o \
        -name "go.mod" \
        \) -print0)
    
    printf '%s\n' "${subprojects[@]}"
}

detect_language_from_file() {
    local file="$1"
    case "$(basename "$file")" in
        package.json) echo "javascript" ;;
        pyproject.toml) echo "python" ;;
        Cargo.toml) echo "rust" ;;
        go.mod) echo "go" ;;
        *) echo "default" ;;
    esac
}
```

### 3. 現在のコンテキストの検出
```bash
get_current_context() {
    local current_dir=$(pwd)
    local search_dir="$current_dir"
    
    # 現在のディレクトリから上位に向かって言語マーカーを探す
    while [ "$search_dir" != "/" ]; do
        for marker in package.json pyproject.toml Cargo.toml go.mod; do
            if [ -f "$search_dir/$marker" ]; then
                local language=$(detect_language_from_file "$search_dir/$marker")
                echo "$search_dir:$language"
                return 0
            fi
        done
        search_dir=$(dirname "$search_dir")
    done
    
    echo ".:default"
}
```

### 4. プラクティスファイルの解決
```bash
resolve_practice_file() {
    local language="$1"
    local install_type="$2"  # "user" or "project"
    
    local base_path
    if [ "$install_type" = "project" ]; then
        base_path=".claude/commands/shared"
    else
        base_path="$HOME/.claude/commands/shared"
    fi
    
    local practice_file="$base_path/language-practices/$language.md"
    
    if [ -f "$practice_file" ]; then
        echo "$practice_file"
    else
        echo "$base_path/language-practices/default.md"
    fi
}
```

### 5. カスタム設定の読み込み
```bash
load_custom_practice() {
    local project_root="$1"
    local subproject_dir="$2"
    
    # 優先順位順に設定ファイルを読み込み
    local configs=()
    
    # 1. プロジェクトルートのカスタム設定
    if [ -f "$project_root/.claude/language-practice.md" ]; then
        configs+=("$project_root/.claude/language-practice.md")
    fi
    
    # 2. サブプロジェクトのカスタム設定
    if [ -n "$subproject_dir" ] && [ -f "$subproject_dir/.claude/language-practice.md" ]; then
        configs+=("$subproject_dir/.claude/language-practice.md")
    fi
    
    printf '%s\n' "${configs[@]}"
}
```

## 使用例

### 基本的な使用
```bash
PROJECT_TYPE=$(detect_project_type)
echo "検出されたプロジェクトタイプ: $PROJECT_TYPE"

case "$PROJECT_TYPE" in
    monorepo)
        echo "モノレポが検出されました"
        detect_subprojects
        ;;
    *)
        echo "単一言語プロジェクト: $PROJECT_TYPE"
        ;;
esac
```

### コンテキスト認識
```bash
CURRENT_CONTEXT=$(get_current_context)
CONTEXT_DIR=$(echo "$CURRENT_CONTEXT" | cut -d: -f1)
CONTEXT_LANG=$(echo "$CURRENT_CONTEXT" | cut -d: -f2)

echo "現在のコンテキスト: $CONTEXT_DIR ($CONTEXT_LANG)"
```

### プラクティス適用
```bash
PRACTICE_FILE=$(resolve_practice_file "$CONTEXT_LANG" "user")
echo "適用されるプラクティス: $PRACTICE_FILE"

# カスタム設定の読み込み
CUSTOM_CONFIGS=($(load_custom_practice "." "$CONTEXT_DIR"))
for config in "${CUSTOM_CONFIGS[@]}"; do
    echo "カスタム設定: $config"
done
```