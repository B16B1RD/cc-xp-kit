# デフォルトプラクティス（言語非依存）

## プロジェクト構造
```
project/
├── src/                 # ソースコード
├── tests/               # テストコード
├── docs/                # ドキュメント
├── scripts/             # ユーティリティスクリプト
├── config/              # 設定ファイル
└── README.md           # プロジェクト説明
```

## バージョン管理
```yaml
vcs: git
branch_strategy: feature-branch
commit_style: conventional
```

## テスト戦略
```yaml
approach: TDD (Test-Driven Development)
cycle: "Red → Green → Refactor"
coverage_target: 80%
```

## 実行コマンド
```bash
# 基本的なコマンド構造
test: "実行可能なテストコマンドを検索"
build: "ビルドコマンドを検索"
run: "実行コマンドを検索"
lint: "リントツールを検索"
```

## Git 無視パターン
```gitignore
# OS generated files
.DS_Store
Thumbs.db
*.swp
*~

# IDE
.idea/
.vscode/
*.sublime-*

# Build outputs
build/
dist/
out/
target/

# Logs
*.log
logs/

# Environment
.env
.env.local
```

## ベストプラクティス
- **小さく始める**: 最小限の動作するコードから開始
- **頻繁にコミット**: 小さな変更を頻繁にコミット
- **明確な命名**: 変数、関数、ファイル名は意図を明確に
- **DRY原則**: Don't Repeat Yourself
- **KISS原則**: Keep It Simple, Stupid
- **早期リターン**: ネストを減らして可読性向上

## ディレクトリ規約
- `src/` または `lib/`: メインのソースコード
- `tests/` または `test/`: テストコード
- `docs/` または `documentation/`: ドキュメント
- `examples/` または `samples/`: 使用例
- `scripts/` または `tools/`: ビルド・デプロイスクリプト

## コミットメッセージ
```
type(scope): subject

body

footer
```

Types:
- feat: 新機能
- fix: バグ修正
- docs: ドキュメント
- style: フォーマット
- refactor: リファクタリング
- test: テスト追加・修正
- chore: ビルド・補助ツール

## 一般的な開発フロー
1. 要件を理解する
2. テストを書く（RED）
3. テストを通すコードを書く（GREEN）
4. コードを改善する（REFACTOR）
5. コミットする
6. 繰り返す