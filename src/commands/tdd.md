# 🚀 TDD開発ツール

Kent Beck流TDDで、小さく始めて大きく育てる開発を支援します。

## 使い方

### 初めての方
```bash
/tdd-quick "作りたいものを3行で説明"
```
これだけで環境構築からTDD実行まで自動で行います。

### 通常の流れ
```bash
/tdd:init              # 環境初期化
/tdd:story "要望"      # ストーリー作成
/tdd:plan 1            # イテレーション計画
/tdd:run               # TDD実行（イテレーション単位）
/tdd:status            # 進捗確認
/tdd:review 1          # レビュー
```

## コマンド一覧

| コマンド | 説明 | 時間 |
|---------|------|------|
| `tdd:init` | 環境準備とGit初期化 | 1分 |
| `tdd:story` | 要望からストーリー作成 | 3分 |
| `tdd:plan` | イテレーション計画 | 2分 |
| `tdd:run` | TDD実行（イテレーション全体） | 60-90分 |
| `tdd:status` | 現在の進捗表示 | 即座 |
| `tdd:review` | 品質分析とフィードバック | 5分 |

## オプション

### tdd:run のオプション
- （デフォルト） - イテレーション全体を連続実行
- `--step` - 単一ステップのみ実行
- `--micro` - ステップごとに確認しながら実行
- `--step X.Y` - 特定のステップから開始
- `--resume` - 中断箇所から再開

### tdd:status のオプション
- `-v` - 詳細表示
- `--simple` - 最小表示（デフォルト）

## 💡 特徴

### Kent Beck TDD
- 🔴 RED → 🟢 GREEN → 🔵 REFACTOR
- 2-5分のマイクロサイクル
- Fake It戦略で素早く実装

### 必須ゲート
- ✅ 動作確認（自動実行）
- ✅ 受け入れ基準チェック
- ✅ フィードバック収集
- ✅ Gitコミット

### プログレッシブ表示
必要な情報を必要なときに。詳細が必要なら `-v` オプションを使用。

## 📚 詳細情報

共通リソースは `~/.claude/commands/shared/` を参照：
- kent-beck-principles.md - TDD原則
- mandatory-gates.md - 必須チェックポイント
- project-verification.md - 動作確認方法
- error-handling.md - エラー対応
- commit-rules.md - コミット規則

## 🎯 次のアクション

新規プロジェクトで:
```bash
cd my-new-project
/tdd-quick "シンプルなTODOアプリを作りたい"
```

既存プロジェクトで:
```bash
cd existing-project
/tdd:init
```

## 📍 インストールタイプ: ユーザー用

このTDDツールはユーザー用としてインストールされています。
どのプロジェクトでも使用できます。
プロジェクト固有のデータは `.claude/agile-artifacts/` に保存されます。
