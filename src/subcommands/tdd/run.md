---
description: "TDD実行環境。Red→Green→Refactorサイクルを実行し、必須ゲートを通過させながら開発を進めます。"
argument-hint: "実行オプション（--step|--micro|--step X.Y|--resume）"
allowed-tools: ["Bash", "Read", "Write", "TodoWrite"]
---

# TDD実行

オプション: $ARGUMENTS（--step, --micro, --step X.Y, --resume）

## 実行モード

### デフォルト: イテレーション全体の連続実行 🎯
オプションなしの場合、現在のイテレーションの全ステップを自動実行。

### オプション
- `--step`: 単一ステップのみ実行して終了
- `--micro`: ステップごとに確認しながら実行
- `--step X.Y`: 特定ステップから開始
- `--resume`: 中断箇所から再開

## 指示

以下を順次実行してください：

### 1. プロジェクト分析と準備

1. **プロジェクトコンテキストを分析**してください：
   - 現在のプロジェクト言語を判定
   - テストコマンドとリントコマンドを特定
   - プロジェクトタイプ（Web/API/CLI）を判定

2. **最新のイテレーションファイル**を読み込んでください：
   - `.claude/agile-artifacts/iterations/` から最新のファイルを確認
   - 実行すべきステップリストを取得
   - 前回フィードバックがあれば確認

3. **実行開始を宣言**してください：
   - イテレーション番号と総ステップ数を表示
   - 選択された実行モードを表示

### 2. TDD実行サイクル

各ステップについて、以下のTDD三段階を実行してください：

#### 🔴 RED フェーズ: テスト作成
1. **Kent Beck視点で最小限のテスト**を作成してください
2. **テストを実行**してください - **必須**：テストが失敗することを確認
   - 実行例: `pnpm test -- --watchAll=false --forceExit 2>&1`
3. **テスト失敗を確認**できない場合は、TDD原則違反として停止してください
4. テスト失敗確認後、**進捗を更新**してください

#### 🟢 GREEN フェーズ: 最小実装  
1. **Fake It戦略**でテストを通す最小実装を行ってください
2. **テストを実行**してください - **必須**：テストが成功することを確認
   - 実行例: `pnpm test -- --watchAll=false --forceExit 2>&1`
3. **リント/品質チェック**を実行してください
   - 実行例: `pnpm lint 2>&1`、`pnpm typecheck 2>&1`
4. 全て成功後、**Gitコミット**を実行してください：
   ```bash
   git add .
   git commit -m "[BEHAVIOR] Step X.Y: Fake It implementation"
   ```
5. **進捗を更新**してください

#### 🔵 REFACTOR フェーズ: 構造改善（必要時）
1. **構造的改善のみ**実行してください（振る舞いは変更しない）
2. **テストを再実行**してください - **必須**：振る舞いが保持されていることを確認
3. **リント/品質チェック**を実行してください
4. 全て成功後、**Gitコミット**を実行してください：
   ```bash
   git add .
   git commit -m "[STRUCTURE] Step X.Y: Refactor for better structure"
   ```
5. **進捗を更新**してください

### 3. 必須ゲート確認

各ステップ完了後、以下を確認してください（詳細は @~/.claude/commands/shared/mandatory-gates.md を参照）：

1. **動作確認**：プロジェクトタイプに応じて実施
   - **Web**: 開発サーバーを起動してブラウザで確認
     - 実行例: `pnpm dev 2>&1` または `bun dev 2>&1`
     - **重要**: タイムアウト対策として必ず `2>&1` を付けてください
   - **CLI**: コマンド実行結果を確認  
   - **API**: サーバーを起動してAPIレスポンスを確認
     - 実行例: `pnpm start 2>&1` または `npm run server 2>&1`

2. **受け入れ基準チェック**：
   - ストーリーファイルの完了条件を確認
   - 未完了項目があれば継続作業

3. **進捗同期**：
   - ストーリーファイル（`.claude/agile-artifacts/stories/project-stories.md`）を更新
   - イテレーションファイル（`.claude/agile-artifacts/iterations/iteration-*.md`）を更新

### 4. 完了処理

#### 単一ステップ完了時（--stepオプション）
次のステップの実行方法を案内してください。

#### イテレーション完了時（デフォルト）

### 🎯 成果物確認（必須ステップ）

実装完了後、作成した成果物を以下の手順で確認してください：

#### 1. プロジェクトタイプ判定

以下を確認してプロジェクトタイプを判定してください：
- `package.json`の存在とscripts設定
- `requirements.txt`、`pyproject.toml`の存在
- `Cargo.toml`、`go.mod`の存在
- フレームワーク固有ファイル（`next.config.js`、`vite.config.js`等）

#### 2. タイプ別確認手順

判定されたプロジェクトタイプに応じて、以下から適切な確認方法を選択・実行してください：

**🌐 Webアプリ系**
- **React/Vue/Angular SPA**: 
  ```bash
  pnpm dev  # または npm run dev、bun dev
  ```
  ブラウザで `http://localhost:3000` を開いて動作確認

- **静的HTML**: 
  ```bash
  # 直接開く、または
  python3 -m http.server 8000
  ```
  ブラウザで `http://localhost:8000` または直接HTMLファイルを開く

- **Next.js/Nuxt.js**: 
  ```bash
  pnpm dev
  ```
  フル機能（SSR、API Routes等）の動作確認

**🖥️ CLI ツール系**
- **Node.js CLI**: 
  ```bash
  node dist/cli.js --help  # または pnpm cli --help
  ```
  ヘルプ表示と基本コマンド実行を確認

- **Python CLI**: 
  ```bash
  python main.py --help  # または python -m package --help
  ```
  コマンドライン引数処理と基本機能を確認

- **Go CLI**: 
  ```bash
  go run . --help  # またはビルドした実行ファイル
  ```
  バイナリ動作と基本機能を確認

**🔌 API サーバー系**
- **Express.js/Fastify**: 
  ```bash
  pnpm start  # または npm run server
  curl http://localhost:3000/api/health  # ヘルスチェック
  ```

- **FastAPI/Django**: 
  ```bash
  uvicorn main:app --reload  # または python manage.py runserver
  ```
  ブラウザで `http://localhost:8000/docs` （OpenAPI docs）を確認

- **Spring Boot**: 
  ```bash
  ./gradlew bootRun  # または mvn spring-boot:run
  curl http://localhost:8080/actuator/health
  ```

**📦 ライブラリ系**
- **npm package**: 
  ```bash
  pnpm build
  node -e "const lib = require('./dist'); console.log(lib)"
  ```
  ビルド成功とインポート可能性を確認

- **Python package**: 
  ```bash
  python -c "import package_name; print('Import successful')"
  ```
  インポート可能性と基本API動作を確認

- **Go module**: 
  ```bash
  go test ./...
  go mod tidy
  ```
  テスト実行とモジュール整合性を確認

**🖱️ デスクトップアプリ系**
- **Electron**: 
  ```bash
  pnpm electron  # または npm run electron
  ```
  アプリケーション起動と基本UI動作を確認

- **Tauri**: 
  ```bash
  cargo tauri dev  # または pnpm tauri dev
  ```
  ネイティブアプリケーション起動を確認

- **Java GUI**: 
  ```bash
  java -jar target/app.jar  # またはIDE実行
  ```
  GUI表示と基本操作を確認

**📊 データ分析系**
- **Jupyter Notebook**: 
  ```bash
  jupyter lab  # または jupyter notebook
  ```
  ノートブック実行と結果出力を確認

- **R Markdown**: 
  ```bash
  Rscript -e "rmarkdown::render('analysis.Rmd')"
  ```
  レポート生成と出力ファイルを確認

**📱 モバイル系**
- **React Native**: 
  ```bash
  pnpm start  # Metro bundler起動
  ```
  エミュレータまたは実機での動作確認

- **Flutter**: 
  ```bash
  flutter run
  ```
  エミュレータまたは実機での動作確認

#### 3. 確認完了チェック

以下を確認してください：
- ✅ 成果物が正常に動作する
- ✅ 実装した全機能が期待通りに動作する  
- ✅ ストーリーの受け入れ基準を全て満たしている
- ✅ エラーや警告が発生していない

### 📋 次のステップ選択

**成果物確認が完了した後**、以下から選択してください：

1. **イテレーション開始** 🚀 - 次のイテレーション自動計画
2. **フィードバック収集** 💭 - 詳細フィードバック収集
3. **機能追加** ➕ - 追加機能の分析と計画
4. **品質向上** 🔧 - コード品質向上
5. **プロジェクト完了** ✅ - プロジェクト終了

#### フィードバック入力時（選択肢2）
ユーザーに以下を質問してフィードバックを収集してください：
「成果物確認を含めた今回のイテレーションについて、ご感想や改善点があれば教えてください。」

フィードバック収集後、再度選択肢を表示してください。

## 重要な原則

- **Kent Beck TDD戦略**を厳格に適用（詳細は @~/.claude/commands/shared/kent-beck-principles.md を参照）
- **Fake It戦略**（60%以上で使用） - 最初はハードコーディング
- **Triangulation** - 2つ目のテストで一般化
- **必須ゲート**通過なしでの進行は禁止
- **コミット規則**の遵守（@~/.claude/commands/shared/commit-rules.md を参照）

## エラー対応

エラー発生時は、以下を確認して対応してください：
1. テスト環境は正しく動作しているか？
2. 依存関係は適切にインストールされているか？
3. TDD原則に従った手順で進行しているか？