# cc-xp-kit

*🤖 このキットは [Claude Code](https://claude.ai/code) を使った Vibe Coding で開発されました*

Kent Beck XP + TDD 統合開発を、5 つのスラッシュコマンドで。

## 🎯 哲学

> "シンプルさこそが究極の洗練である" - レオナルド・ダ・ヴィンチ

Kent Beck の XP 原則と TDD サイクルを完全統合し、フィーチャーレベルでの実用的開発を実現します。

- **コミュニケーション** - ユーザーストーリー中心の対話型開発
- **シンプルさ** - 5 つのコマンドによる明確なワークフロー
- **フィードバック** - Red→Green→Refactor による継続的改善
- **勇気** - フィーチャーブランチでの安心実験
- **尊重** - モダンツールチェーンと開発者体験の最適化

## 🚀 クイックスタート

### 新規プロジェクトで始める（推奨）

```bash
# 1. 新しいプロジェクトディレクトリを作成
mkdir my-awesome-project
cd my-awesome-project

# 2. cc-xp-kit をプロジェクトにインストール
curl -fsSL https://raw.githubusercontent.com/B16B1RD/cc-xp-kit/main/install.sh | bash -s -- --project

# 3. Claude Code を起動
# Claude Code起動後、以下のコマンドを実行：
/cc-xp:plan "ウェブブラウザで遊べるテトリスが欲しい"
```

### その他のインストール方法

**既存プロジェクトの場合**：
```bash
cd your-existing-project
curl -fsSL https://raw.githubusercontent.com/B16B1RD/cc-xp-kit/main/install.sh | bash -s -- --project
```

**ユーザー用インストール**（全プロジェクトで共通利用）：
```bash
curl -fsSL https://raw.githubusercontent.com/B16B1RD/cc-xp-kit/main/install.sh | bash -s -- --user
```

## 🔄 5 つの XP ワークフロー

### 完全統合された開発サイクル

```bash
# 1. 計画立案（YAGNI 原則）
/cc-xp:plan "作りたいもの"

# 2. ユーザーストーリー詳細化
/cc-xp:story

# 3. TDD 実装（Red→Green→Refactor）
/cc-xp:develop

# 4. 動作確認とフィードバック
/cc-xp:review [accept/reject]

# 5. 振り返りと継続的改善
/cc-xp:retro
```

### 実際の使用例

```bash
# 新機能の計画
/cc-xp:plan "ユーザー登録機能を追加したい"

# ストーリー詳細化
/cc-xp:story

# TDD 実装
/cc-xp:develop

# 動作確認
/cc-xp:review

# 受け入れまたは修正
/cc-xp:review accept    # または reject "理由"

# 振り返り
/cc-xp:retro
```

## 🛠️ モダンツールチェーン対応

プロジェクトの言語を自動検出し、最適なツールを使用します。

- **JavaScript/TypeScript**: Bun または pnpm + Vite
- **Python**: uv + Ruff + pytest  
- **Rust**: Cargo（標準）
- **Go**: Go modules（標準）
- **Ruby**: mise + Bundler
- **Java**: SDKMAN + Gradle/Maven
- **C#**: .NET CLI（標準）

## 💡 なぜ cc-xp-kit を選ぶのか

### 従来の XP/TDD ツールの問題

- 概念的すぎて実装が曖昧
- ツールチェーン統合の複雑さ
- フィーチャーレベルでの実用性不足

### cc-xp-kit の解決策

- **明確な 5 ステップ** - 迷わない開発フロー
- **フィーチャーブランチ統合** - Git ワークフローと完全連携
- **実用的 TDD** - Red→Green→Refactor の厳密実行
- **バックログ管理** - YAML 形式でのストーリー追跡

## 🏗️ プロジェクト構造

### cc-xp-kit 構造

```
cc-xp-kit/
├── src/cc-xp/                # 📦 5 つの XP コマンド
│   ├── plan.md              # 計画立案
│   ├── story.md             # ストーリー詳細化
│   ├── develop.md           # TDD 実装
│   ├── review.md            # 動作確認
│   └── retro.md             # 振り返り
├── install.sh                # モダンインストーラー
├── tests/                    # テストスイート
└── docs/                     # ドキュメント
```

### ユーザープロジェクト構造

```
your-project/
├── .claude/commands/        # インストールされたコマンド（プロジェクトローカル）
│   └── cc-xp/
│       ├── plan.md          # /cc-xp:plan
│       ├── story.md         # /cc-xp:story
│       ├── develop.md       # /cc-xp:develop
│       ├── review.md        # /cc-xp:review
│       └── retro.md         # /cc-xp:retro
├── docs/cc-xp/              # プロジェクトデータ（自動生成）
│   ├── backlog.yaml         # ストーリーバックログ
│   ├── metrics.json         # ベロシティ・メトリクス
│   └── stories/             # 詳細化されたストーリー
└── .git/                    # フィーチャーブランチ管理
```

## 🎯 実用的な機能

### バックログ管理

- **YAML 形式** - 人間が読みやすく、Git で追跡可能
- **ストーリーポイント** - Size (1～8) + Value (High/Medium/Low)
- **状態管理** - todo → selected → in-progress → testing → done

### メトリクス追跡

- **ベロシティ** - 完了ストーリーポイント/時間
- **サイクルタイム** - Red→Green→Refactor の所要時間  
- **Git 統計** - コミット数、変更行数による客観的分析

### フィーチャーブランチ戦略

- **ストーリー単位ブランチ** - `story-{id}` での作業分離
- **TDD フェーズコミット** - Red → Green → Refactor の段階的コミット
- **自動マージ・タグ** - 受け入れ時の自動処理

## 📜 ライセンス

MIT License - 自由に使ってください。

---

*"勇気とは、恐怖に直面した効果的な行動である" - Kent Beck*

*小さく始めて、継続的にフィードバックを得る。それが XP の本質です。*