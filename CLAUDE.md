# CLAUDE.md

This file provides guidance to Claude Code when working with code in this repository.

## 🧠 Claude認知能力強化プロトコル

### 📅 日付認識プロトコル (CRITICAL)
- **現在日時**: 必ず `date +"%Y-%m-%d"` コマンドで年月日を完全取得
- **検索範囲計算**: 過去1年程度をカバーする複数年検索を実施
  ```bash
  CURRENT_YEAR=$(date +%Y)
  PREV_YEAR=$((CURRENT_YEAR - 1))
  SEARCH_RANGE="${PREV_YEAR} ${CURRENT_YEAR}"
  ```
- **季節対応検索**: 年初（1-3月）は前年中心、年末（10-12月）は翌年予測も含む
- **Web検索クエリ**: 「recent modern latest」など年非依存キーワードを優先使用
- 環境情報の受動的確認ではなく、Bashコマンドでの能動的検証を徹底

### 🎯 論理思考プロトコル (MANDATORY)
- 回答前に「**段階的に考えます**」を必ず宣言
- 前提条件を箇条書きで明示
- 結論までの論理ステップを1→2→3で明示
- 複雑な問題は必ず分解して考える

### 🔍 自動検証プロトコル (ENFORCED)
- 回答完了後に必ず以下を自問:
  1. "この答えは論理的に正しいか？"
  2. "見落としている重要な観点はないか？"
  3. "最新情報をWeb検索で確認すべきか？"
- 疑問があれば即座に検証実行

## プロジェクト概要

cc-tdd-kit は Claude Code 用の TDD 開発キットです。
Kent Beck 流の TDD 原則に基づいて、Red → Green → Refactor サイクルを厳格に実施します。
小さく始めて大きく育てる開発を支援します。

## 基本コマンド

### テスト実行

```bash
bash tests/run-tests.sh
```

### インストールテスト

```bash
# ユーザー用インストール (1を選択)
bash install.sh

# プロジェクト用インストール (2を選択)
bash install.sh

# アンインストール
bash install.sh uninstall
```

### コード品質チェック（ShellCheck利用可能時）

```bash
shellcheck install.sh
```

## アーキテクチャ

### 主要ディレクトリ構造

- `src/commands/` - メインコマンド（`/tdd`, `/tdd-quick`）
- `src/subcommands/tdd/` - TDD サブコマンド（`init`、`story`、`plan`、`run`、`status`、`review`）
- `src/shared/` - 共通リソース（Kent Beck 原則、必須ゲート、プロジェクト検証など）
- `tests/` - 自動テストスイート
- `examples/` - 使用例（api-server, cli-tool, web-app）

### 設計原則

- **Tidy First原則** - 構造的変更（[STRUCTURE]）と振る舞いの変更（[BEHAVIOR]）を厳格に分離
- **必須ゲート** - 各ステップで動作確認、受け入れ基準チェック、Git コミットを強制
- **プログレッシブ表示** - 必要な情報を必要なときに表示（`-v` オプションで詳細表示）

### TDD ワークフロー

1. `/tdd:init` - 環境初期化と Git 初期化
2. `/tdd:story` - ユーザーストーリー作成
3. `/tdd:plan` - 90 分イテレーション計画
4. `/tdd:run` - TDD 実行（連続実行 or ステップ実行）
5. `/tdd:status` - 進捗確認
6. `/tdd:review` - 品質分析とフィードバック

### インストールタイプ

- **ユーザー用** - `~/.claude/commands/` で全プロジェクトで利用可能
- **プロジェクト用** - `.claude/commands/` でプロジェクト固有カスタマイズ可能

## データ管理

各プロジェクトに `.claude/agile-artifacts/` ディレクトリが作成され、以下を管理します。

- `stories/` - ユーザーストーリー（Git 管理対象）
- `iterations/` - イテレーション計画（Git 管理対象）
- `reviews/` - レビューとフィードバック（Git 管理対象）
- `tdd-logs/` - 実行ログ（Git 管理対象外、個人用）

### Git管理方針

- チーム共有価値の高い情報（stories, iterations, reviews）は Git 管理
- 個人的な実行ログ（tdd-logs）は`.gitignore`で除外
- プロジェクトの成長過程と学習内容を追跡可能に

## Kent Beck TDD 戦略

- **Fake It 戦略**（60%以上で使用）- 最初はハードコーディングで実装
- **Triangulation** - 2 つ目のテストで一般化
- **Obvious Implementation** - 明白な場合のみ最初から正しい実装

## 品質管理

- 全テストスイートによる自動検証
- ShellCheck によるシェルスクリプト品質チェック
- インストール/アンインストール機能の統合テスト
- ファイル整合性チェック
- Markdown lint チェック（textlint 使用）

## リリース管理

### バージョニング

[Semantic Versioning](https://semver.org/) に準拠します。

- **MAJOR** - 破壊的変更（例: 0.x.x → 1.0.0）
- **MINOR** - 新機能追加（例: 0.1.x → 0.2.0）  
- **PATCH** - バグ修正・改善（例: 0.1.0 → 0.1.1）

### リリースプロセス

1. **コード変更**
   - 全テストが通ることを確認
   - Markdown lint エラーがないことを確認

2. **CHANGELOG.md更新**
   - 変更内容を該当するセクション（Added/Changed/Fixed/Removed）に具体的に記載
   - リリース日を記載（例: `## [0.2.1] - 2025-01-28`）

3. **タグ付けの注意点**
   - **必ず最新のコミット後にタグ付け**を実行
   - タグ作成前に必要な変更が全てコミット済みか確認
   - タグメッセージには簡潔な変更概要を含める

4. **実行手順**

   ```bash
   # 1. 変更をコミット
   git add -A
   git commit -m "[BEHAVIOR] 新機能の説明"
   
   # 2. CHANGELOGを更新
   # （CHANGELOG.mdを編集）
   git add CHANGELOG.md
   git commit -m "[STRUCTURE] v0.x.x CHANGELOGエントリを追加"
   
   # 3. タグ付け（最新コミットに対して）
   git tag v0.x.x -m "v0.x.x: 変更概要"
   
   # 4. プッシュ
   git push origin main
   git push origin v0.x.x
   ```

### タグ付け後の追加変更

タグ付け後に追加のコミットが発生した場合の対処法です。

- パッチバージョンとして新しいタグを作成（推奨）
- 例: v0.2.0 → v0.2.1（リント修正など）

### GitHub Actions

- Markdown lint エラーは必ずローカルで修正してからプッシュ
- CI が通らない状態でのタグ付けは避ける

## スラッシュコマンド設計原則 (CRITICAL)

### ❌ 絶対に避けるべきアンチパターン

1. **bashスクリプトの組み込み**
   - スラッシュコマンド内でのbashスクリプト実行
   - source コマンドでの外部ファイル読み込み  
   - 複雑なshell関数の定義と実行

2. **設定ファイル依存の複雑化**
   - YAML/JSON形式の設定ファイル読み込み
   - 外部ファイルからの値取得処理
   - 設定に基づく条件分岐処理

3. **複雑なPhase/Step構造**
   - Phase 1/2/3 のような段階的実行構造
   - Step 1.1/1.2 のような細分化された手順
   - 条件分岐による複雑なフロー制御

### ✅ 推奨する正しいアプローチ

1. **純粋な自然言語指示**
   ```markdown
   ## 指示
   
   以下を実行してください：
   
   1. **要望を分析**してプロジェクトタイプを判定してください。
   2. **技術スタックを選択**してください。重要な制約：
      - **JavaScriptプロジェクト**: bunまたはpnpmを使用してください。**npmは避けてください**。
   ```

2. **Claude の標準ツール活用**
   - Read, LS, Grep, Bash ツールでの直接操作
   - Taskツールでのサブコマンド呼び出し
   - WebSearchでの最新情報取得

3. **明確で具体的な制約指示**
   - 「npmは避けてください」のような明確な禁止事項
   - 「bunまたはpnpm」のような具体的な選択肢
   - 自然言語での判断基準提示

### 🎯 設計哲学

- **シンプルさ**: Claudeが理解しやすい自然な日本語指示
- **直接性**: 中間ファイルや複雑な処理を介さない直接的な指示
- **柔軟性**: Claudeの判断力を活用した適応的な処理
- **保守性**: 人間が読んで理解できる明確な指示文

### 📋 修正時のチェックリスト

スラッシュコマンドを修正する際は以下を確認：

- [ ] bashスクリプトが含まれていないか？
- [ ] 外部設定ファイルに依存していないか？
- [ ] Phase/Step構造が複雑すぎないか？
- [ ] 自然言語の「〜してください」形式か？
- [ ] Claudeの標準ツールのみ使用しているか？
- [ ] 制約や禁止事項が明確に記載されているか？

これらの原則に従うことで、Claude Code の哲学に完全に準拠した、保守性の高いスラッシュコマンドを維持できます。
