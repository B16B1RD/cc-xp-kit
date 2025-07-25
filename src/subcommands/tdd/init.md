# TDD開発環境の初期化

現在のプロジェクトに TDD 開発環境をセットアップします。

## 実行内容

1. **プロジェクト用ディレクトリの作成**
```bash
mkdir -p .claude/agile-artifacts/{stories,iterations,reviews,tdd-logs}
```

2. **CLAUDE.mdの作成/更新**
- 既存ファイルがあれば、TDD 情報を先頭に追加
- なければ新規作成

内容:
```markdown
# TDD開発環境

Kent BeckのTDD哲学に基づいた開発環境です。

## 開発理念
「シンプルさ」「フィードバック」「勇気」「尊重」「コミュニケーション」

[共通リソースの参照]
- TDD原則: ~/.claude/commands/shared/kent-beck-principles.md
- 必須ゲート: ~/.claude/commands/shared/mandatory-gates.md
- コミット規則: ~/.claude/commands/shared/commit-rules.md

## 利用可能なコマンド
- `/tdd:init` - 環境初期化
- `/tdd:story` - ストーリー作成
- `/tdd:plan` - イテレーション計画
- `/tdd:run` - TDD実行
- `/tdd:status` - 進捗確認
- `/tdd:review` - レビュー
- `/tdd-quick` - クイックスタート

[既存の内容があればここに保持]
```

3. **セッション管理ファイル**
`.claude/agile-artifacts/tdd-logs/session.json`:
```json
{
  "initialized": "[現在日時]",
  "sessions": [],
  "iterations": {},
  "mandatory_checks": {
    "enabled": true
  }
}
```

4. **Git初期化**
```bash
# 未初期化の場合のみ
if [ ! -d .git ]; then
  git init
fi

# .gitignoreの作成（なければ）
if [ ! -f .gitignore ]; then
  echo "node_modules/
dist/
*.log
.DS_Store
.env
coverage/" > .gitignore
fi

# 初期コミット
git add .
git commit -m "[INIT] TDD development environment setup"
```

## 完了メッセージ

```
✅ TDD開発環境を初期化しました！

作成内容:
- プロジェクト用ディレクトリ（.claude/agile-artifacts/）
- CLAUDE.md
- セッション管理
- Git初期化

次のステップ:
/tdd:story "作りたいものの説明"
```
