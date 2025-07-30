# プロジェクト構造生成ガイド

## 概要

プロジェクトタイプと技術スタックに基づいて、モダンな開発環境を自動生成するためのガイドです。Claude Codeが参照する設計指針として使用します。

## プロジェクトタイプ別構造

### Web Application 構造

**ディレクトリ構成**:

```text
project/
├── src/
│   ├── components/      # UIコンポーネント
│   ├── services/        # ビジネスロジック
│   ├── utils/           # ユーティリティ関数
│   ├── styles/          # スタイルファイル
│   ├── types/           # TypeScript型定義
│   └── main.js          # エントリーポイント
├── tests/
│   ├── unit/            # 単体テスト
│   ├── integration/     # 統合テスト
│   └── e2e/             # E2Eテスト
├── public/              # 静的ファイル
├── docs/                # プロジェクト文書
├── package.json         # 依存関係管理
├── vite.config.js       # ビルド設定
├── tsconfig.json        # TypeScript設定
├── .eslintrc.js         # リンター設定
└── .prettierrc          # フォーマッター設定
```

**必要な設定ファイル**:

- **package.json**: Vite + Vitest + ESLint + Prettier
- **TypeScript**: 厳格モードで最新機能を活用
- **開発サーバー**: ホットリロード対応
- **テスト環境**: UI テスト + カバレッジ計測
- **Prettier設定**: コード整形ルールを統一
- **エントリーポイント**: メインJavaScriptファイル
- **HTMLテンプレート**: 基本的なHTML5構造
- **基本テスト**: 初期テストケース
- **README**: プロジェクト説明文書

## API Server 構造

**ディレクトリ構成**:

```text
project/
├── src/
│   ├── routes/          # エンドポイント定義
│   ├── controllers/     # リクエスト処理ロジック
│   ├── models/          # データモデル定義
│   ├── middleware/      # 横断的関心事
│   ├── services/        # ビジネスロジック
│   ├── utils/           # ユーティリティ関数
│   ├── types/           # TypeScript型定義
│   ├── config.js        # アプリケーション設定
│   └── server.js        # サーバーエントリーポイント
├── tests/
│   ├── unit/            # 単体テスト
│   └── integration/     # 統合テスト
├── docs/
│   ├── api/             # API文書
│   └── schemas/         # データスキーマ
├── package.json         # 依存関係管理
├── .env.example         # 環境変数テンプレート
└── docker-compose.yml   # ローカル開発環境
```

**必要な設定ファイル**:

- **package.json**: Express + Vitest + セキュリティミドルウェア
- **環境変数**: ポート、データベースURL、JWT秘密鍵
- **ミドルウェア**: Helmet、CORS、圧縮、エラーハンドリング
- **テスト環境**: Supertest + Vitest でAPI統合テスト

**重要な技術要素**:

- **セキュリティ**: Helmet.js、CORS設定、入力検証
- **パフォーマンス**: 圧縮、接続プール、キャッシュ戦略
- **モニタリング**: ヘルスチェックエンドポイント
- **文書化**: OpenAPI/Swagger対応準備

## CLI Tool 構造

**ディレクトリ構成**:

```text
project/
├── src/
│   ├── commands/        # 各CLIコマンド実装
│   ├── utils/           # ユーティリティ関数
│   ├── types/           # TypeScript型定義
│   ├── cli.js           # CLIエントリーポイント
│   ├── version.js       # バージョン管理
│   └── index.js         # プログラムAPI
├── tests/
│   ├── unit/            # 単体テスト
│   └── integration/     # 統合テスト
├── docs/                # プロジェクト文書
├── bin/                 # 実行可能ファイル（ビルド後）
├── package.json         # 依存関係管理
└── README.md            # 使用方法とインストール手順
```

**必要な設定ファイル**:

- **package.json**: Commander.js + Chalk + Inquirer
- **bin設定**: 実行可能ファイルの指定
- **TypeScript**: CLI開発に最適化された設定
- **テスト環境**: CLIコマンドの自動テスト

**重要な技術要素**:

- **コマンドパターン**: 各機能を独立したコマンドに分離
- **引数解析**: Commander.jsによる堅牢な引数処理
- **ユーザー体験**: Chalk（色付き出力）、Ora（スピナー）
- **対話型UI**: Inquirer.jsによる質問形式インターフェース
- **クロスプラットフォーム**: Windows/Mac/Linux対応

## 設定ファイルテンプレート

### package.json パターン

**Web Application用**:

- Scripts: `dev`, `build`, `preview`, `test`, `test:ui`, `test:coverage`, `lint`, `format`, `typecheck`
- 主要依存関係: Vite, Vitest, ESLint, Prettier
- TypeScript使用時: `typescript`, `@types/node`を追加

**API Server用**:

- Scripts: `dev`, `start`, `test`, `test:watch`, `test:coverage`, `lint`, `format`
- 主要依存関係: Express, Helmet, CORS, Compression, Dotenv
- 開発依存関係: Vitest, Supertest, ESLint, Prettier

**CLI Tool用**:

- Scripts: `dev`, `build`, `test`, `test:watch`, `lint`, `format`
- Bin設定: 実行可能ファイルの指定
- 主要依存関係: Commander, Chalk, Ora, Inquirer

### TypeScript設定パターン

**推奨設定**:

- **Target**: ES2022（モダンJS機能を活用）
- **Module**: ESNext（最新モジュールシステム）
- **Strict**: true（厳格な型チェック）
- **Path mapping**: `@/*` → `src/*`（インポートを簡潔に）
- **JSX支援**: React JSX対応

**最適化オプション**:

- `skipLibCheck`: ライブラリ型チェックをスキップ
- `isolatedModules`: ファイル単位でのコンパイル
- `noUnusedLocals/Parameters`: 未使用変数の検出

### Vite設定パターン

**基本設定**:

- **Alias**: `@` → `src/`のパス解決
- **Test**: Vitest統合（globals、jsdom環境）
- **Build**: 最適化とminification

**開発環境**:

- ホットリロード対応
- ソースマップ生成
- プロキシ設定（API開発時）

## プロジェクトタイプ別選択指針

### Web Application

**選択基準**: ブラウザ、UI、ゲーム、インタラクティブアプリ
**特徴**: フロントエンド重視、リアルタイム性、ユーザー体験

### API Server

**選択基準**: サーバー、データベース、認証、バックエンド処理
**特徴**: データ処理、セキュリティ、スケーラビリティ

### CLI Tool

**選択基準**: コマンド、ツール、自動化、スクリプト
**特徴**: コマンドライン操作、バッチ処理、開発効率化

## 実装ガイドライン

### 環境構築の順序

1. **プロジェクトタイプ判定**: 要望内容の分析
2. **ディレクトリ作成**: 標準的な構造の生成
3. **設定ファイル**: package.json, tsconfig.json等の配置
4. **初期ファイル**: エントリーポイントとサンプルコード
5. **テスト環境**: 基本的なテストケースの準備
6. **品質ツール**: Lint、Format設定

### カスタマイズ方針

- **最小構成から開始**: 必要最小限のファイルのみ
- **段階的拡張**: 開発進行に応じて機能追加
- **プロジェクト固有調整**: 要件に合わせた設定変更
