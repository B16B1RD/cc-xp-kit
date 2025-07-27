# cc-tdd-kit

Claude Code 用の TDD 開発キット - Kent Beck 流で小さく始めて大きく育てる。

> [!NOTE]
> **このプロジェクトは Claude Code との Vibe Coding で作成された実験的プロジェクトです**  
>
> もともと個人的な開発効率化のために作ったツールですが、以下の理由で公開しています。
> - **Vibe Coding の実践例**として、新しい開発手法の可能性を示す
> - **TDD + AI ペアプロ**の具体的な成果物として参考になるかもしれない
> - 「**こんなやり方もあるよ**」という情報共有
>
> ただし、AI との協調開発で作成されたツールの安定性や保守性はまだ検証段階です。  
> 便利そうだと思われた方は、その点をご理解の上でお試しください。

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Compatible-blue)](https://www.anthropic.com/)

## このキットに含まれるもの

### オールインワンパッケージ

- **Claude Code カスタムスラッシュコマンド**の自動インストール
  - インストール先選択可能（ユーザー用 or プロジェクト用）
- **TDD専用コマンド**（`/tdd`, `/tdd-quick`）の追加
- Kent Beck 哲学に基づいたワークフロー  
- 必須ゲートによる品質保証
- フィードバック駆動の継続的改善

## クイックスタート（30秒）

```bash
# インストール
curl -fsSL \
  https://raw.githubusercontent.com/B16B1RD/cc-tdd-kit/main/install.sh \
  | bash

# プロジェクトで Claude Code を開始
cd my-project
claude

# TDD開発を即座に開始
/tdd-quick "Webで動くテトリスゲームを作りたい"
```

これだけで環境構築から TDD 実行まですべて自動で行われます。

## 基本的な使い方

### 1. 通常のワークフロー

```text
# 環境初期化
/tdd:init

# ストーリー作成
/tdd:story "TODOアプリを作りたい。
タスクの追加、完了、削除ができる。
ブラウザで動くシンプルなもの。"

# イテレーション計画（90分単位）
/tdd:plan 1

# TDD実行（イテレーション全体を自動実行）
/tdd:run

# 進捗確認
/tdd:status

# レビューと改善
/tdd:review 1
```

### 2. 実行モードの詳細

```bash
# イテレーション全体を連続実行（デフォルト）
/tdd:run

# 単一ステップのみ実行
/tdd:run --step

# ステップごとに確認しながら
/tdd:run --micro

# 特定のステップから再開
/tdd:run --step 2.3
```

## 特徴

### Kent Beck TDD原則

- **Red → Green → Refactor** の厳格な実施
- **Fake It戦略**（60%以上で使用）による素早い実装
- **Tidy First原則** - 構造的変更と振る舞いの変更を分離

### 必須ゲート

すべてのステップで以下を自動チェック。

- 動作確認（プロジェクトタイプに応じた自動実行）
- 受け入れ基準チェック
- フィードバック収集（イテレーション完了時）
- Git コミット（TDD/STRUCT/FEAT などのタグ付き）

### プロジェクトタイプの自動判定

- **Webアプリ** → HTML/JS/Canvas + Vitest
- **CLIツール** → Node.js/Python + Jest/pytest 等
- **API** → Express/FastAPI + テストフレームワーク

## インストール詳細

### インストールタイプ

インストール時に選択できます。

1. **ユーザー用**（推奨）
   - パス: `~/.claude/commands/`
   - 利点: 一度のインストールで全プロジェクトに使用可能

2. **プロジェクト用**
   - パス: `.claude/commands/`
   - 利点: プロジェクト固有のカスタマイズが可能

### システム要件

- Claude Code（最新版推奨）
- Git
- Node.js または Python（プロジェクトタイプによる）

## コマンドリファレンス

| コマンド | 説明 | 実行時間 |
|---------|------|----------|
| `/tdd-quick` | 要望から即座にTDD開始 | 90分〜 |
| `/tdd:init` | 環境準備とGit初期化 | 1分 |
| `/tdd:story` | ユーザーストーリー作成 | 3分 |
| `/tdd:plan` | イテレーション計画作成 | 2分 |
| `/tdd:run` | TDD実行 | 60-90分 |
| `/tdd:status` | 進捗状況表示 | 即座 |
| `/tdd:review` | 品質分析とフィードバック | 5分 |

## プロジェクト構造

インストール後、プロジェクトに以下が作成されます。

```text
your-project/
├── .claude/
│   ├── commands/          # プロジェクト用の場合のみ
│   └── agile-artifacts/
│       ├── stories/       # ユーザーストーリー
│       ├── iterations/    # イテレーション計画
│       ├── reviews/       # レビューとフィードバック
│       └── tdd-logs/      # 実行ログ
└── CLAUDE.md              # プロジェクト設定
```

## ライセンス

このプロジェクトは MIT ライセンスの下で公開されています。詳細は [LICENSE](LICENSE) ファイルを参照してください。

## 謝辞

- Kent Beck - TDD 哲学の創始者
- 深津（@fladdict）さん - Claude to Kiro kit に触発されて開発
- Anthropic - Claude Code の開発

## サポート

- バグ報告や機能要望  
  [GitHub Issues](https://github.com/B16B1RD/cc-tdd-kit/issues) へ
- 使い方の共有や質問  
  [GitHub Discussions](https://github.com/B16B1RD/cc-tdd-kit/discussions) へ

---

*シンプルに、小さく始めて、大きく育てる。それが Kent Beck 流 TDD の本質です。*
