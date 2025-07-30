---
description: "要望からユーザーストーリーを作成し、受け入れ基準を設定。プロダクトオーナーの視点で価値を定義します。"
argument-hint: "作成したいストーリーの説明（例: ログイン機能）"
allowed-tools: ["Write", "Read", "LS", "WebSearch", "Bash"]
---

# ユーザーストーリーの作成

要望: $ARGUMENTS

## 実行内容

### 1. 本質分析（5つのなぜ）

要望の背景にある本質的なニーズを探ります。

### 2. プロジェクトタイプ判定と動的技術選定

**段階的に考えます：**

#### Step 1: プロジェクトタイプの判定

要求内容から最適なプロジェクトタイプを判定：

- **Web アプリケーション**: ウェブ、ブラウザ、UI、ゲーム、HTML関連
- **API サーバー**: API、サーバー、データベース、認証、バックエンド関連  
- **CLI ツール**: コマンド、ツール、スクリプト、自動化関連
- **データ分析**: 分析、機械学習、データ処理、可視化関連
- **システムツール**: システム、パフォーマンス、低レベル処理関連
- **モバイルアプリ**: モバイル、アプリ、React Native、Flutter関連

#### Step 2: インストール済みツールの検出

**利用可能なツールを事前チェック：**

Bashツールで以下のコマンドを順次実行してインストール済みツールを確認：

**JavaScript/TypeScript系ツール確認：**
```
which bun && echo "✓ bun installed" || echo "✗ bun not found"
which pnpm && echo "✓ pnpm installed" || echo "✗ pnpm not found"
which npm && echo "✓ npm installed" || echo "✗ npm not found"
```

**Python系ツール確認：**
```
which uv && echo "✓ uv installed" || echo "✗ uv not found"
which poetry && echo "✓ poetry installed" || echo "✗ poetry not found"  
which pip && echo "✓ pip installed" || echo "✗ pip not found"
```

#### Step 3: 言語・技術スタックの動的検索と選択肢提示

判定されたプロジェクトタイプとインストール済みツールに基づいて、**最新技術動向を検索**：

**Web検索による最新技術情報の取得:**
- パフォーマンス重視: 「latest [プロジェクトタイプ] package manager performance comparison」
- 開発者体験重視: 「recent developer experience [プロジェクトタイプ] tooling latest modern」
- ベンチマーク比較: 「latest [言語] build tool speed benchmark」
- 採用トレンド: 「modern development workflow [プロジェクトタイプ] trends recent」
- 年非依存検索: 「latest modern [プロジェクトタイプ] best practices current」

**プロジェクトタイプ別の推奨構成:**

### JavaScript/TypeScript プロジェクト（Web App/API/CLI）

```text
📦 パッケージマネージャー（検出済み: [インストール済みツール]）:
1. bun - 最速、オールインワン（ランタイム+パッケージマネージャー） ⚡推奨
2. pnpm - 高速、ディスク効率的、ワークスペース対応
3. npm - 互換性最優先の場合のみ

🔧 ビルドツール:
1. esbuild/swc - ミリ秒単位のビルド速度 ⚡推奨
2. vite - 優れた開発体験、HMR対応
3. webpack - レガシープロジェクト用

🧪 テストフレームワーク:
1. vitest - Vite統合、超高速実行 ⚡推奨
2. jest + swc - 高速トランスパイル版
3. jest - 標準構成
```

### Python プロジェクト（API/データ分析/CLI）

```text
📦 パッケージマネージャー（検出済み: [インストール済みツール]）:
1. uv - Rust実装、10-100x高速 ⚡推奨
2. poetry - モダンな依存関係管理
3. pip - 互換性重視の場合のみ

🔧 ビルド・タスクランナー:
1. rye/hatch - モダンプロジェクト管理 ⚡推奨
2. make + pyproject.toml - シンプル構成
3. setuptools - レガシー用

🧪 テストフレームワーク:
1. pytest + pytest-xdist - 並列実行対応 ⚡推奨
2. pytest - 標準構成
3. unittest - 組み込み標準
```

あなたの選択（デフォルト=1）:
- 未入力の場合、最速のモダンツールを自動選択
- インストール済みの最速ツールを優先

#### Step 4: 選択結果の保存

ユーザーの選択に基づいて `.claude/agile-artifacts/project-config.json` を作成：

```json
{
  "project_type": "判定結果",
  "selected_stack": {
    "package_manager": "ユーザー選択結果",
    "build_tool": "ユーザー選択結果",
    "test_framework": "ユーザー選択結果", 
    "language": "ユーザー選択結果",
    "additional_tools": ["lint", "format", "type-check"]
  },
  "selection_rationale": {
    "performance_priority": "高速性重視/安定性重視/実験性重視",
    "team_experience": "考慮事項",
    "project_constraints": "特別な制約"
  }
}
```

### 3. 技術選定の最新情報検索

選択された技術スタックについて、より詳細な最新情報を検索：

- 公式ドキュメントの最新バージョン情報
- ベストプラクティスとアンチパターン
- パフォーマンス特性と制約事項
- チーム導入時の注意点

### 4. ストーリー分割

以下の 3 つのリリースに分けて、段階的に価値を提供：

- **Release 0**: 最初の 30 分で見えるもの（2-3 ストーリー）
- **Release 1**: 基本的な価値（3-4 ストーリー）  
- **Release 2**: 継続的な価値（3-4 ストーリー）

### 3. ストーリー形式

```text
Story X.Y: [簡潔なタイトル]
As a [役割]
I want [機能]
So that [価値]

見積もり: XX分
受け入れ基準:
- [ ] 具体的で検証可能な条件1
- [ ] 具体的で検証可能な条件2
- [ ] 具体的で検証可能な条件3

確認履歴:
- [ ] 実装時の動作確認
- [ ] 統合時の確認
```

### 5. ファイル作成

以下の2つのファイルを作成：

**A. プロジェクト設定**: `.claude/agile-artifacts/project-config.json`
- プロジェクトタイプ判定結果
- 技術スタック情報
- 要件特性（deployment方法等）

**B. ユーザーストーリー**: `.claude/agile-artifacts/stories/project-stories.md`
- 本質分析の結果
- ペルソナと成功指標
- リリース計画（プロジェクトタイプ最適化済み）
- 各ストーリーの詳細
- プロジェクトタイプ別の確認方法

### 6. コミット

Bashツールで以下を実行してストーリーファイルをコミット：
```
git add .claude/agile-artifacts/
git commit -m "[BEHAVIOR] Create user stories with project type analysis"
```

## 原則

- **YAGNI**: 今必要ない機能は含めない
- **検証可能**: 曖昧な基準を避ける
- **段階的**: 小さく始めて大きく育てる

## 完了後

```text
📝 ストーリーとプロジェクト設定を作成しました！

🎯 プロジェクト判定: [Web App/API/CLI]
🛠️ 技術スタック: [選択された技術群]
📊 ストーリー総数: X個、推定: Y時間

次: /tdd:init (判定結果ベースでモダン環境構築)
```
