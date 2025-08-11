# Git Repository Check - 共通関数

## Gitリポジトリ存在確認

cc-xp コマンドを実行する前に、必ずこの確認処理を実行してください。

### 基本確認処理

```bash
# Git Repository Check
echo "=== Git リポジトリ確認 ==="
if [ ! -d ".git" ]; then
    echo "❌ エラー: Gitリポジトリが初期化されていません"
    echo ""
    echo "🔧 解決方法:"
    echo "1. 新規プロジェクトの場合:"
    echo "   git init"
    echo "   git add ."
    echo "   git commit -m \"Initial commit\""
    echo ""
    echo "2. 既存プロジェクトの場合:"
    echo "   適切なGitリポジトリディレクトリに移動してください"
    echo ""
    echo "3. Gitを使用しない場合:"
    echo "   cc-xpツールはGitリポジトリ内での使用を前提としています"
    echo "   ファイル管理とバージョン管理のためGitの使用を強く推奨します"
    echo ""
    echo "🚫 処理を中止します"
    exit 1
fi

# Git設定確認（初回のみ）
if ! git config user.name > /dev/null 2>&1 || ! git config user.email > /dev/null 2>&1; then
    echo "⚠️  警告: Git設定が不完全です"
    echo ""
    echo "🔧 Git設定を行ってください:"
    echo "   git config --global user.name \"Your Name\""
    echo "   git config --global user.email \"your.email@example.com\""
    echo ""
    echo "または、このプロジェクトのみの設定:"
    echo "   git config user.name \"Your Name\""
    echo "   git config user.email \"your.email@example.com\""
    echo ""
    echo "🚫 処理を中止します"
    exit 1
fi

echo "✅ Git リポジトリ確認完了"
echo ""
```

### コミット実行関数

```bash
# Safe Git Commit Function
safe_git_commit() {
    local files="$1"
    local message="$2"
    
    echo "=== Git コミット実行 ==="
    echo "対象ファイル: $files"
    echo "コミットメッセージ: $message"
    echo ""
    
    # ファイル存在確認
    for file in $files; do
        if [ ! -f "$file" ] && [ ! -d "$file" ]; then
            echo "⚠️  警告: ファイル '$file' が見つかりません"
        fi
    done
    
    # git add の実行
    echo "📁 ファイルをステージング..."
    if ! git add $files; then
        echo "❌ エラー: ファイルのステージングに失敗しました"
        echo "確認事項:"
        echo "- ファイルが存在するか"
        echo "- ファイルのパーミッションが正しいか"
        echo "- Gitリポジトリ内にいるか"
        return 1
    fi
    
    # 変更があるか確認
    if git diff --cached --quiet; then
        echo "ℹ️  情報: コミットする変更がありません"
        return 0
    fi
    
    # git commit の実行
    echo "💾 変更をコミット..."
    if ! git commit -m "$message"; then
        echo "❌ エラー: コミットに失敗しました"
        echo "確認事項:"
        echo "- Git設定（user.name, user.email）が正しいか"
        echo "- コミットメッセージが適切か"
        echo "- リポジトリの状態に問題がないか"
        return 1
    fi
    
    echo "✅ コミット完了"
    return 0
}
```

### ブランチ操作関数

```bash
# Safe Git Branch Function
safe_git_branch() {
    local branch_name="$1"
    local operation="$2"  # create, checkout, merge
    
    echo "=== Git ブランチ操作 ==="
    echo "ブランチ: $branch_name"
    echo "操作: $operation"
    echo ""
    
    case "$operation" in
        "create")
            echo "🌱 新しいブランチを作成..."
            if ! git checkout -b "$branch_name"; then
                echo "❌ エラー: ブランチ作成に失敗しました"
                echo "確認事項:"
                echo "- 同名のブランチが既に存在しないか"
                echo "- 現在のディレクトリがGitリポジトリか"
                echo "- 未コミットの変更がないか"
                return 1
            fi
            echo "✅ ブランチ '$branch_name' を作成し、切り替えました"
            ;;
            
        "checkout")
            echo "🔄 ブランチを切り替え..."
            if ! git checkout "$branch_name"; then
                echo "❌ エラー: ブランチ切り替えに失敗しました"
                echo "確認事項:"
                echo "- ブランチ '$branch_name' が存在するか"
                echo "- 未コミットの変更がないか"
                echo "- マージコンフリクトがないか"
                return 1
            fi
            echo "✅ ブランチ '$branch_name' に切り替えました"
            ;;
            
        "merge")
            echo "🔀 ブランチをマージ..."
            current_branch=$(git branch --show-current)
            if ! git merge --no-ff "$branch_name" -m "merge: $branch_name"; then
                echo "❌ エラー: マージに失敗しました"
                echo "確認事項:"
                echo "- マージコンフリクトが発生していないか"
                echo "- ブランチ '$branch_name' が存在するか"
                echo "- 現在のブランチ '$current_branch' が正しいか"
                return 1
            fi
            echo "✅ ブランチ '$branch_name' を '$current_branch' にマージしました"
            ;;
            
        *)
            echo "❌ エラー: 不正な操作 '$operation'"
            return 1
            ;;
    esac
    
    return 0
}
```

### 使用例

```bash
# 1. 最初にGitリポジトリ確認を実行
source src/cc-xp/_git_check.md

# 2. 安全なコミット実行
safe_git_commit "docs/cc-xp/backlog.yaml" "feat: ストーリー作成"

# 3. 安全なブランチ操作
safe_git_branch "story-123" "create"
```

## 統合方針

1. **各コマンドファイルの冒頭**で Git リポジトリ確認する
2. **gitコマンド実行箇所**を安全関数に置き換え
3. **エラー時の適切なガイダンス**を表示
4. **Git未初期化時の明確な解決方法**を提示