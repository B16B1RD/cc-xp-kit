# CLAUDE.md 自動生成機能

## 概要

プロジェクトタイプと技術スタックに基づいて、プロジェクト固有のCLAUDE.mdを自動生成します。

## 基本生成機能

### CLAUDE.md生成テンプレート

**基本構造**:
```
# CLAUDE.md

## プロジェクト概要
- プロジェクト名（現在のディレクトリ名から自動取得）
- プロジェクトタイプ（引数から取得）
- 技術スタック（引数から取得）
- 開発方法論: Test-Driven Development (TDD)
- アーキテクチャ（プロジェクトタイプ別説明）

## 基本コマンド
（プロジェクトタイプと技術スタック別に生成）

## TDD開発原則
### Kent Beck の TDD サイクル
1. Red: 失敗するテストを書く
2. Green: テストを通す最小限のコードを書く
3. Refactor: コードを改善する（テストは通ったまま）

### 実装戦略
- Fake It (60%以上で使用): 最初はハードコーディングで実装
- Triangulation: 2つ目のテストで一般化を促す
- Obvious Implementation: 実装が明白な場合のみ最初から正しく実装

### 必須ゲート
各開発ステップで以下を確認：
- ✅ すべてのテストが通る
- ✅ コード品質チェックが通る
- ✅ 受け入れ基準を満たしている
- ✅ Git コミットでマイルストーンを記録

## アーキテクチャ
（プロジェクトタイプ別に生成）

## 品質基準
（プロジェクトタイプと技術スタック別に生成）

## 開発ワークフロー
### TDD イテレーション
1. /tdd:story - ユーザーストーリー作成
2. /tdd:plan - 90分イテレーション計画
3. /tdd:run - TDD実行（Red→Green→Refactor）
4. /tdd:review - コード品質とパフォーマンス確認
5. /tdd:status - 進捗確認

### ブランチ戦略
- main: 本番リリース可能な状態
- develop: 開発中の機能統合
- feature/*: 機能開発ブランチ

### コミット規則
- [BEHAVIOR]: 新機能・振る舞い変更
- [STRUCTURE]: リファクタリング・構造変更
- [FIX]: バグ修正
- [TEST]: テストのみの変更
- [DOCS]: ドキュメント更新

## 重要な指示
### ファイル作成の原則
- 必要最小限: 必要な場合のみファイルを作成
- 既存ファイル優先: 新規作成より既存ファイル編集を優先
- 段階的実装: 小さく始めて段階的に拡張

### コード品質
- 重複を徹底的に排除
- 意図を明確に表現する命名
- 単一責任の原則を守る
- 依存関係を明示的にする

## プロジェクト固有のガイドライン
（プロジェクトタイプと技術スタック別に生成）

## デバッグとトラブルシューティング
（プロジェクトタイプと技術スタック別に生成）
```

### プロジェクトタイプ別コマンドセクション

**Web Application**:
```bash
# 開発サーバー起動
npm run dev          # 開発サーバー
npm run build        # 本番ビルド
npm run preview      # ビルド結果プレビュー

# テスト実行
npm test             # 全テスト実行
npm run test:watch   # テスト監視モード
npm run test:ui      # テストUI表示

# コード品質
npm run lint         # ESLint実行
npm run format       # Prettier実行
npm run typecheck    # TypeScript型チェック
```

**API Server**:
```bash
# サーバー起動
npm run dev          # 開発サーバー（ホットリロード）
npm start            # 本番サーバー

# テスト実行
npm test             # 全テスト実行
npm run test:watch   # テスト監視モード
npm run test:coverage # カバレッジ計測

# ヘルスチェック
curl http://localhost:3000/health
```

**CLI Tool**:
```bash
# CLI実行
node src/cli.js help         # ヘルプ表示
node src/cli.js --version    # バージョン確認

# テスト実行
npm test                     # 全テスト実行
npm run test:watch           # テスト監視モード
```

generate_architecture_section() {
    local project_type="$1"
    
    case "$project_type" in
        web-app)
            cat << 'EOF'
### ディレクトリ構造
```
src/
├── components/          # UIコンポーネント
├── services/           # ビジネスロジック
├── utils/              # ユーティリティ関数
├── styles/             # スタイルファイル
├── types/              # TypeScript型定義
└── main.js             # エントリーポイント

tests/
├── unit/               # 単体テスト
├── integration/        # 統合テスト
└── e2e/                # E2Eテスト

public/                 # 静的ファイル
dist/                   # ビルド出力
```

### 設計原則
- **コンポーネント分離**: UIとロジックの分離
- **状態管理**: 最小限のグローバル状態
- **モジュール化**: 機能単位でのファイル分割
```

**API Server**:
```
### ディレクトリ構造
src/
├── routes/             # ルーティング定義
├── controllers/        # リクエスト処理
├── models/             # データモデル
├── middleware/         # ミドルウェア
├── services/           # ビジネスロジック
├── utils/              # ユーティリティ
└── server.js           # サーバーエントリーポイント

tests/
├── unit/               # 単体テスト
└── integration/        # 統合テスト

### 設計原則
- レイヤー分離: ルーティング・コントローラー・サービス・モデル
- ミドルウェア: 横断的関心事の分離
- エラーハンドリング: 統一されたエラー処理
```

**CLI Tool**:
```
### ディレクトリ構造
src/
├── commands/           # CLIコマンド実装
├── utils/              # ユーティリティ関数
├── types/              # TypeScript型定義
└── cli.js              # CLIエントリーポイント

tests/
├── unit/               # 単体テスト
└── integration/        # 統合テスト

### 設計原則
- コマンドパターン: 各機能をコマンドとして分離
- 引数検証: 入力値の厳密な検証
- ユーザビリティ: 直感的なインターフェース
```

### 品質基準テンプレート

**共通品質指標**:
```
### テストカバレッジ
- 最小目標: 80%以上
- 推奨目標: 90%以上
- クリティカルパス: 100%

### コード品質指標
- Complexity: 循環複雑度 10以下
- Function Length: 関数は20行以下を推奨
- File Length: ファイルは200行以下を推奨
```

**プロジェクトタイプ別パフォーマンス基準**:

- **Web Application**:
  - 初回読み込み: 3秒以内
  - Lighthouse Score: 90点以上
  - Bundle Size: 500KB以下

- **API Server**:
  - レスポンス時間: 200ms以内
  - スループット: 1000 req/sec以上
  - メモリ使用量: 512MB以下

- **CLI Tool**:
  - 起動時間: 1秒以内
  - メモリ使用量: 100MB以下
  - 実行時間: ユーザー体感で即座

get_architecture_description() {
    local project_type="$1"
    
    case "$project_type" in
        web-app)
            echo "モダンなウェブアプリケーション（SPA/MPA）"
            ;;
        api-server)
            echo "RESTful API サーバー（マイクロサービス対応）"
            ;;
        cli-tool)
            echo "コマンドラインインターface（シングルバイナリ）"
            ;;
        *)
            echo "カスタムアプリケーション"
            ;;
    esac

### アーキテクチャタイプ別説明

- **Web Application**: モダンなウェブアプリケーション（SPA/MPA）
- **API Server**: RESTful API サーバー（マイクロサービス対応）
- **CLI Tool**: コマンドラインインターフェース（シングルバイナリ）
- **カスタム**: その他のアプリケーションタイプ

### プロジェクト固有ガイドラインテンプレート

**Web Application**:
```
### フロントエンド開発原則
- レスポンシブデザイン: モバイルファースト
- アクセシビリティ: WCAG 2.1 AA準拠
- SEO対応: メタタグとセマンティックHTML
- パフォーマンス: 遅延読み込みとコード分割

### 状態管理
- ローカル状態: useState/useReducer
- グローバル状態: 必要最小限に留める
- 非同期状態: SWR/React Query活用

### セキュリティ
- XSS対策: 適切なエスケープ処理
- CSRF対策: CSRFトークン実装
- Content Security Policy: 適切なCSP設定
```

**API Server**:
```
### API設計原則
- RESTful: 適切なHTTPメソッドとステータスコード
- バージョニング: /api/v1/ 形式
- ドキュメント: OpenAPI/Swagger対応
- レート制限: 適切なスロットリング

### セキュリティ
- 認証: JWT/OAuth2.0実装
- 認可: ロールベースアクセス制御
- 入力検証: 厳密なバリデーション
- HTTPS: 本番環境では必須

### データベース
- マイグレーション: スキーマバージョン管理
- 接続プール: 効率的な接続管理
- トランザクション: ACID特性の保証
```

**CLI Tool**:
```
### CLI設計原則
- UNIX哲学: 単一機能に集中
- 標準入出力: パイプラインフレンドリー
- エラーハンドリング: 適切な終了コード
- ヘルプシステム: 使いやすいドキュメント

### 配布とインストール
- パッケージング: npm/homebrew対応
- クロスプラットフォーム: Windows/Mac/Linux対応
- 依存関係: 最小限の外部依存
- バージョン管理: セマンティックバージョニング
```

### デバッグ・トラブルシューティングテンプレート

**Web Application**:
```
**ビルドエラー**
# 依存関係の再インストール
rm -rf node_modules package-lock.json
npm install

# キャッシュクリア
npm run build -- --clean

**テスト失敗**
# テスト環境の確認
npm run test -- --verbose
npm run test -- --coverage

**パフォーマンス問題**
# バンドルサイズ分析
npm run build -- --analyze
```

**API Server**:
```
**サーバー起動問題**
# ポート使用状況確認
lsof -i :3000

# 環境変数確認
printenv | grep NODE_ENV

**データベース接続エラー**
# 接続テスト
npm run db:test
npm run migrate:status

**パフォーマンス問題**
# プロファイリング
npm run profile
```

**CLI Tool**:
```
**実行権限エラー**
# 実行権限付与
chmod +x src/cli.js

# グローバルインストール
npm link

**依存関係エラー**
# シンボリックリンク確認
npm ls -g --depth=0
```
```

## 実装ガイドライン

### CLAUDE.md生成の流れ
1. **プロジェクトタイプの判定**: 引数から判定またはプロジェクト構造から推測
2. **基本テンプレートの展開**: 共通のTDD原則とワークフロー情報
3. **プロジェクト固有情報の追加**: タイプ別のコマンド、アーキテクチャ、品質基準
4. **技術スタック情報の組み込み**: 具体的な技術選択に基づく詳細情報
5. **デバッグ情報の付加**: プロジェクトタイプ別のトラブルシューティング

### 使用場面
- **初期化時**: `/tdd:init`コマンド実行時の自動生成
- **プロジェクト更新時**: 既存CLAUDE.mdへのTDD設定追加
- **新規参加者向け**: プロジェクト理解のための情報提供

### カスタマイズポイント
- **プロジェクト固有ルール**: チーム独自の開発規約
- **技術的制約**: インフラやライブラリの制限事項
- **品質基準**: プロジェクト要件に応じた指標調整