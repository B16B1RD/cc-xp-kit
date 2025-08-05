# cc-xp-kit

Kent Beck XP + TDD統合開発を、5つのスラッシュコマンドで。

## 🎯 哲学

> "シンプルさこそが究極の洗練である" - レオナルド・ダ・ヴィンチ

Kent BeckのXP原則とTDDサイクルを完全統合し、フィーチャーレベルでの実用的開発を実現します：

- **コミュニケーション** - ユーザーストーリー中心の対話型開発
- **シンプルさ** - 5つのコマンドによる明確なワークフロー
- **フィードバック** - Red→Green→Refactorによる継続的改善
- **勇気** - フィーチャーブランチでの安心実験
- **尊重** - モダンツールチェーンと開発者体験の最適化

## 🚀 クイックスタート

```bash
# インストール（10秒）
curl -fsSL https://raw.githubusercontent.com/B16B1RD/cc-tdd-kit/main/install.sh | bash

# 開発用ブランチからインストール
curl -fsSL https://raw.githubusercontent.com/B16B1RD/cc-tdd-kit/main/install.sh | bash -s -- --branch develop

# XPワークフロー開始
/cc-xp:plan "ウェブブラウザで遊べるテトリスが欲しい"
```

## 🔄 5つのXPワークフロー

### 完全統合された開発サイクル

```bash
# 1. 計画立案（YAGNI原則）
/cc-xp:plan "作りたいもの"

# 2. ユーザーストーリー詳細化
/cc-xp:story

# 3. TDD実装（Red→Green→Refactor）
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

# TDD実装
/cc-xp:develop

# 動作確認
/cc-xp:review

# 受け入れまたは修正
/cc-xp:review accept    # または reject "理由"

# 振り返り
/cc-xp:retro
```

## 🛠️ モダンツールチェーン対応

プロジェクトの言語を自動検出し、最適なツールを使用：

- **JavaScript/TypeScript**: Bun または pnpm + Vite
- **Python**: uv + Ruff + pytest  
- **Rust**: Cargo（標準）
- **Go**: Go modules（標準）
- **Ruby**: mise + Bundler
- **Java**: SDKMAN + Gradle/Maven
- **C#**: .NET CLI（標準）

## 💡 なぜcc-xp-kit？

### 従来のXP/TDDツールの問題

- 概念的すぎて実装が曖昧
- ツールチェーン統合の複雑さ
- フィーチャーレベルでの実用性不足

### cc-xp-kitの解決策

- **明確な5ステップ** - 迷わない開発フロー
- **フィーチャーブランチ統合** - Gitワークフローと完全連携
- **実用的TDD** - Red→Green→Refactorの厳密実行
- **バックログ管理** - YAML形式でのストーリー追跡

## 🏗️ プロジェクト構造

### cc-xp-kit構造
```
cc-xp-kit/
├── src/cc-xp/                # 📦 5つのXPコマンド
│   ├── plan.md              # 計画立案
│   ├── story.md             # ストーリー詳細化
│   ├── develop.md           # TDD実装
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
- **YAML形式** - 人間が読みやすく、Gitで追跡可能
- **ストーリーポイント** - Size(1,2,3,5,8) + Value(High/Medium/Low)
- **状態管理** - todo → selected → in-progress → testing → done

### メトリクス追跡
- **ベロシティ** - 完了ストーリーポイント/時間
- **サイクルタイム** - Red→Green→Refactorの所要時間  
- **Git統計** - コミット数、変更行数による客観的分析

### フィーチャーブランチ戦略
- **ストーリー単位ブランチ** - `story-{id}` での作業分離
- **TDDフェーズコミット** - Red🔴 → Green✅ → Refactor♻️
- **自動マージ・タグ** - 受け入れ時の自動処理

## 🤝 貢献

XPの実用性を高める改善提案を歓迎します。Kent Beck原則を維持しながらの機能拡張をお願いします。

## 📜 ライセンス

MIT License - 自由に使ってください。

---

*"勇気とは、恐怖に直面した効果的な行動である" - Kent Beck*

*小さく始めて、継続的にフィードバックを得る。それがXPの本質です。*