# JavaScript/TypeScript モダンプラクティス

## パッケージ管理
```yaml
primary: pnpm         # 高速でディスク効率的
alternatives:
  - bun              # 超高速な新世代ランタイム
  - npm              # 標準パッケージマネージャー
  - yarn             # 高速な代替パッケージマネージャー
lockfile: pnpm-lock.yaml
```

## プロジェクト構造
```
project/
├── src/
│   ├── components/      # UIコンポーネント（Reactなど）
│   ├── services/        # ビジネスロジック
│   ├── utils/           # ユーティリティ関数
│   ├── types/           # TypeScript 型定義
│   └── index.ts         # エントリーポイント
├── tests/               # テストファイル
│   ├── unit/
│   └── integration/
├── public/              # 静的ファイル
├── dist/                # ビルド出力
├── package.json
├── tsconfig.json        # TypeScript設定
├── vite.config.ts       # Viteビルド設定（または webpack）
└── .nvmrc              # Node.js バージョン指定
```

## テストフレームワーク
```yaml
primary: vitest       # Vite ベースの高速テストランナー
alternatives:
  - jest             # 定番のテストフレームワーク
  - mocha + chai     # 柔軟なテスト環境
e2e: playwright       # E2Eテスト
```

## 開発ツール
```yaml
bundler: vite         # 高速な開発サーバーとビルドツール
linter: eslint        # JavaScript/TypeScript リンター
formatter: prettier   # コードフォーマッター
type_checker: tsc     # TypeScript コンパイラ
```

## 実行コマンド
```bash
# 環境セットアップ
init: "pnpm install"

# 開発サーバー
dev: "pnpm dev"
dev_host: "pnpm dev --host"  # ネットワーク経由でアクセス可能

# テスト実行
test: "pnpm test"
test_watch: "pnpm test:watch"
test_coverage: "pnpm test:coverage"
e2e: "pnpm test:e2e"

# コード品質
lint: "pnpm lint"
format: "pnpm format"
typecheck: "pnpm typecheck"

# ビルド
build: "pnpm build"
preview: "pnpm preview"  # ビルド結果のプレビュー

# 依存関係管理
add_dep: "pnpm add"
add_dev_dep: "pnpm add -D"
update_deps: "pnpm update"
```

## Git 無視パターン
```gitignore
# 依存関係
node_modules/
.pnpm-store/

# ビルド出力
dist/
build/
.next/
out/

# キャッシュ
.cache/
.parcel-cache/
.turbo/

# テスト
coverage/
.nyc_output/

# 環境変数
.env
.env.local
.env.*.local

# エディタ
.vscode/
.idea/

# OS
.DS_Store
Thumbs.db

# ログ
*.log
npm-debug.log*
pnpm-debug.log*
yarn-debug.log*
```

## ベストプラクティス
- **ESモジュール**: `"type": "module"` を package.json に設定
- **TypeScript**: 厳格モード（strict: true）を有効化
- **パスエイリアス**: `@/` で src ディレクトリを参照
- **環境変数**: dotenv ではなく Vite の import.meta.env を使用
- **コード分割**: 動的インポートで遅延読み込み
- **Tree Shaking**: ES モジュールで不要なコードを除去