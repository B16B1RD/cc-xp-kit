# 貢献ガイドライン

cc-tdd-kit への貢献をご検討いただき、ありがとうございます！　❤️

あなたの貢献により、cc-tdd-kit はより良いツールになります。すべての種類の貢献を歓迎し、評価しています。

## 📋 目次

- [行動規範](#行動規範)
- [セキュリティ](#セキュリティ)
- [質問がありますか？](#質問がありますか)
- [貢献の方法](#貢献の方法)
  - [バグ報告](#バグ報告)
  - [機能提案](#機能提案)
  - [初回貢献者向けタスク](#初回貢献者向けタスク)
  - [コード貢献](#コード貢献)
- [開発環境のセットアップ](#開発環境のセットアップ)
- [プルリクエストプロセス](#プルリクエストプロセス)
- [スタイルガイドライン](#スタイルガイドライン)
- [貢献者の認識](#貢献者の認識)

## 行動規範

このプロジェクトとそのコミュニティは、[行動規範](CODE_OF_CONDUCT.md) を遵守しています。参加することにより、この規範を守ることに同意したものとみなされます。許容できない行動を発見した場合は、プロジェクトチームまでご報告ください。

## セキュリティ

セキュリティの脆弱性を発見した場合は、**公開のIssueを作成しないでください**。代わりに [セキュリティポリシー](SECURITY.md) に従って報告してください。

## 質問がありますか？

> **Note**: プロジェクトに関する質問をするためだけにIssueを作成しないでください。

質問やヘルプが必要な場合は、以下をご利用ください：

- 📢 [GitHub Discussions](https://github.com/B16B1RD/cc-tdd-kit/discussions) - 一般的な質問や議論
- 💬 コミュニティでの議論（日本語・英語どちらでも歓迎）
- 📚 [README.md](README.md) - 基本的な使用方法

## 貢献の方法

### バグ報告

バグを発見した場合は、[GitHub Issues](https://github.com/B16B1RD/cc-tdd-kit/issues) で報告してください。

#### バグ報告の前に

- 📖 [README](README.md) を読んで、バグではない可能性を確認してください
- 🔍 既存の Issue で同じ問題が報告されていないか検索してください
- 🆕 最新バージョンで問題が発生することを確認してください

#### 良いバグ報告の要素

- **明確で説明的なタイトル**
- **詳細な問題の説明**
- **再現手順** (可能な限り具体的に)
- **期待される動作**
- **実際の動作**
- **環境情報**:
  - OS (例: macOS 13.4, Ubuntu 22.04)
  - Claude Code バージョン
  - cc-tdd-kit バージョン
- **ログ出力やスクリーンショット** (該当する場合)

### 機能提案

新機能のアイデアがある場合は、[GitHub Discussions](https://github.com/B16B1RD/cc-tdd-kit/discussions) で議論を開始するか、[GitHub Issues](https://github.com/B16B1RD/cc-tdd-kit/issues) で提案してください。

#### 良い機能提案の要素

- **機能の明確な説明**
- **なぜその機能が必要か** (問題の説明)
- **想定される使用例**
- **可能であれば実装のアイデア**
- **既存の代替手段との比較**

### 初回貢献者向けタスク

初めて貢献される方は、以下のラベルが付いた Issue をご覧ください：

- 🌱 `good first issue` - 初心者に適したタスク
- 🆘 `help wanted` - コミュニティからの協力を求めているタスク
- 📚 `documentation` - ドキュメントの改善

### コード貢献

コードの貢献を歓迎します！以下の種類の貢献が可能です：

- 🐛 バグ修正
- ✨ 新機能の実装
- 📚 ドキュメントの改善
- 🎨 コードの改善・リファクタリング
- ✅ テストの追加・改善

## 開発環境のセットアップ

### 前提条件

- **Git** - バージョン管理
- **Bash** - シェルスクリプト実行環境
- **ShellCheck** - コード品質チェック (推奨)
- **act** - GitHub Actions ローカルテスト (推奨)

### セットアップ手順

1. **リポジトリをフォーク**
   - GitHub でリポジトリの「Fork」ボタンをクリック

2. **ローカルにクローン**
   ```bash
   git clone https://github.com/YOUR_USERNAME/cc-tdd-kit.git
   cd cc-tdd-kit
   ```

3. **上流リポジトリを追加**
   ```bash
   git remote add upstream https://github.com/B16B1RD/cc-tdd-kit.git
   ```

4. **開発ツールのインストール** (任意)
   ```bash
   # ShellCheck (macOS)
   brew install shellcheck
   
   # ShellCheck (Ubuntu)
   sudo apt-get install shellcheck
   
   # act (GitHub Actions ローカルテスト)
   curl -s https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash
   ```

5. **動作確認**
   ```bash
   # テストの実行
   bash tests/run-tests.sh
   
   # GitHub Actions のローカルテスト
   act --list
   ```

## プルリクエストプロセス

### 1. ブランチの作成

```bash
git checkout -b feature/amazing-feature
```

**ブランチ名の規則:**
- `feature/` - 新機能
- `fix/` - バグ修正
- `docs/` - ドキュメント更新
- `refactor/` - リファクタリング
- `test/` - テスト追加・改善

### 2. 変更の実施

- **Kent Beck の TDD 原則** に従って開発してください
- **小さく、集中した変更** を心がけてください
- **適切なテスト** を追加してください

### 3. コミット

**コミットメッセージの形式:**
```text
[BEHAVIOR] Add new feature
[STRUCTURE] Refactor existing code
[DOCS] Update documentation
[FIX] Fix bug in feature
```

**コミットのベストプラクティス:**
- 構造的変更と振る舞いの変更を分離
- 1 つのコミットで 1 つの論理的変更
- 明確で説明的なメッセージ

### 4. テスト

```bash
# すべてのテストを実行
bash tests/run-tests.sh

# GitHub Actions のローカルテスト
act -j test-install
act -j shellcheck
act -j markdown-lint
```

**テストが通るまでプルリクエストを作成しないでください。**

### 5. プルリクエストの作成

以下を含めてください：

- **変更内容の明確な説明**
- **関連するIssue番号** (`Fixes #123`, `Closes #456`)
- **テスト方法** (該当する場合)
- **スクリーンショット** (UI 変更の場合)
- **破壊的変更** (該当する場合)

## スタイルガイドライン

### Bashスクリプト

- **ShellCheck** を使用してリントを実行
- 変数は `"${VAR}"` の形式で参照
- エラーハンドリングを適切に実装
- 関数名は `snake_case`
- 定数は `UPPER_CASE`
- コメントは日本語で OK

### Markdownファイル

- 見出しは論理的な階層構造（H1 から H6 まで）
- コードブロックには言語を指定
- 日本語と英語の間には半角スペース
- リンクは説明的なテキストを使用

### コミット・PR

- **Conventional Commits** を基にしたコミットメッセージ
- PR タイトルは変更内容を簡潔に説明
- 1 つの PR で複数の無関係な変更を含めない

## 貢献者の認識

すべての貢献者に感謝の気持ちを込めて：

- 🎉 **リリースノート** で貢献者をクレジット
- 🏆 **GitHub Contributors** グラフに表示
- 💝 **コミュニティでの感謝** の表明

将来的には [All Contributors](https://allcontributors.org/) の導入も検討しています。

## プロジェクト構造

```text
cc-tdd-kit/
├── .github/               # GitHub設定
│   ├── workflows/         # GitHub Actions
│   ├── ISSUE_TEMPLATE/    # Issueテンプレート
│   └── PULL_REQUEST_TEMPLATE.md
├── src/
│   ├── commands/          # メインコマンド
│   ├── subcommands/       # サブコマンド
│   │   └── tdd/
│   └── shared/            # 共有リソース
├── tests/                 # テストスイート
├── docs/                  # ドキュメント
└── examples/              # 使用例
```

## ヘルプとサポート

困った時は遠慮なくお聞きください：

- 💬 [GitHub Discussions](https://github.com/B16B1RD/cc-tdd-kit/discussions) で質問
- 📖 [ドキュメント](docs/) を確認
- 🔍 [既存のIssue](https://github.com/B16B1RD/cc-tdd-kit/issues) を検索

## ライセンス

貢献していただいたコードは、プロジェクトと同じ MIT ライセンスの下で公開されます。詳細は [LICENSE](LICENSE) をご覧ください。

## 感謝

貢献していただき、本当にありがとうございます！　🙏

あなたの協力により、cc-tdd-kit はより良いツールになり、Kent Beck の TDD 原則を実践するすべての開発者の支援につながります。

---

> 💡 **初回貢献者の方へ**: 不明な点があれば、遠慮なく質問してください。私たちは皆さんの学習と成長を支援します！

最終更新: 2025-07-25
