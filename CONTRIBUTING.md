# 貢献ガイドライン

cc-tdd-kit への貢献を検討していただき、ありがとうございます。

## 貢献の方法

### バグ報告

バグを発見した場合は、[GitHub Issues](https://github.com/B16B1RD/cc-tdd-kit/issues) で報告してください。

**良いバグ報告には以下が含まれます：**

- 問題の明確な説明
- 再現手順
- 期待される動作
- 実際の動作
- 環境情報（OS、Claude Code バージョンなど）
- 可能であればスクリーンショットやログ

### 機能提案

新機能のアイデアがある場合も  
[GitHub Issues](https://github.com/B16B1RD/cc-tdd-kit/issues) で提案してください。

**良い機能提案には以下が含まれます：**

- 機能の明確な説明
- なぜその機能が必要か
- 想定される使用例
- 可能であれば実装のアイデア

### プルリクエスト

1. **フォーク & クローン**

   ```bash
   git clone https://github.com/B16B1RD/cc-tdd-kit.git
   cd cc-tdd-kit
   ```

2. **ブランチの作成**

   ```bash
   git checkout -b feature/amazing-feature
   ```

   ブランチ名の規則：
   - `feature/` - 新機能
   - `fix/` - バグ修正
   - `docs/` - ドキュメント更新
   - `refactor/` - リファクタリング

3. **変更の実施**
   - Kent Beck の TDD 原則に従ってください
   - コミットメッセージは以下の形式で：

     ```text
     [BEHAVIOR] Add new feature
     [STRUCTURE] Refactor existing code
     [DOCS] Update documentation
     [FIX] Fix bug in feature
     ```

4. **テスト**
   - 新機能には必ずテストを追加
   - 既存のテストがすべて通ることを確認

   ```bash
   bash tests/run-tests.sh
   ```

5. **プルリクエストの作成**
   - 変更内容の明確な説明
   - 関連する Issue 番号（あれば）
   - スクリーンショット（UI の変更がある場合）

## コーディング規約

### Bashスクリプト

- ShellCheck を使用してリントを実行
- 変数は `"${VAR}"` の形式で参照
- エラーハンドリングを適切に実装
- コメントは日本語で OK

### Markdownファイル

- 見出しは論理的な階層構造（H1 から H6 まで）に従って作成する
- コードブロックには言語を指定
- 日本語と英語の間には半角スペース

### ファイル構造

```text
src/
├── commands/        # メインコマンド
├── subcommands/     # サブコマンド
│   └── tdd/
└── shared/          # 共有リソース
```

## テスト

### テストの実行

```bash
# すべてのテストを実行
bash tests/run-tests.sh

# 特定のテストを実行
bash tests/test-install.sh
```

### テストの追加

新機能を追加する場合は、必ず対応するテストも追加してください。

## ドキュメント

- README.md の更新が必要な場合は忘れずに
- 新コマンドを追加した場合は、使用例も追加
- CHANGELOG.md に変更内容を記載

## コミュニティ

- 質問は  
  [GitHub Discussions](https://github.com/B16B1RD/cc-tdd-kit/discussions) で
- 日本語での議論も歓迎する

## ライセンス

貢献していただいたコードは、プロジェクトと同じ MIT ライセンスの下で公開されます。

## 感謝

貢献していただき、本当にありがとうございます。
あなたの協力により、cc-tdd-kit はより良いツールになります。
