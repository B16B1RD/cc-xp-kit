#!/bin/bash
set -e

# MD040エラー修正スクリプト：コードブロックに言語指定を追加

echo "🔧 MD040エラー修正中: コードブロックに言語指定を追加"

# 出力用コードブロック（主にTDDツールの実行結果）
find . -name "*.md" -not -path "./node_modules/*" -not -path "./.git/*" -print0 | xargs -0 sed -i.bak 's/^```$/```text/g'

# シェルスクリプト用コードブロック
find . -name "*.md" -not -path "./node_modules/*" -not -path "./.git/*" -print0 | while IFS= read -r -d '' file; do
    if grep -l "git\|bash\|npm\|echo\|cd\|mkdir" "$file" > /dev/null 2>&1; then
        sed -i.bak2 '/```text/,/```/{
            /git \|bash \|npm \|echo \|cd \|mkdir \|chmod \|curl /I{
                s/^```text$/```bash/
            }
        }' "$file"
    fi
done

# JSON用コードブロック
find . -name "*.md" -not -path "./node_modules/*" -not -path "./.git/*" -print0 | while IFS= read -r -d '' file; do
    if grep -l "{.*}" "$file" > /dev/null 2>&1; then
        sed -i.bak3 '/```text/,/```/{
            /{.*}/{
                s/^```text$/```json/
            }
        }' "$file"
    fi
done

# YAML用コードブロック
find . -name "*.md" -not -path "./node_modules/*" -not -path "./.git/*" -print0 | while IFS= read -r -d '' file; do
    if grep -l "allowed-tools:\|description:" "$file" > /dev/null 2>&1; then
        sed -i.bak4 '/```text/,/```/{
            /allowed-tools:\|description:/{
                s/^```text$/```yaml/
            }
        }' "$file"
    fi
done

# バックアップファイルを削除
find . -name "*.bak*" -not -path "./node_modules/*" -not -path "./.git/*" -exec rm {} +

echo "✅ MD040エラー修正完了"
echo "💡 手動で確認が必要な箇所があるかもしれません"