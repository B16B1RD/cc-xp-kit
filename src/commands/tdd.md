---
description: "統合TDD開発 - init, story, planを1コマンドで完全実行"
argument-hint: "作りたいものを説明してください（例: テトリスゲーム、REST APIサーバー）"
allowed-tools: ["Write", "Read", "LS", "WebSearch", "Bash", "TodoWrite"]
---

# 統合TDD開発

要望: $ARGUMENTS

## 🎯 統合開発フロー

この統合コマンドは以下の機能を順次実行します：
1. **要望分析・技術選択** 
2. **環境初期化** (従来の`/tdd:init`機能)
3. **ユーザーストーリー作成** (従来の`/tdd:story`機能)  
4. **イテレーション計画** (従来の`/tdd:plan`機能)
5. **実装開始案内**

## 指示

以下の5つのPhaseを**順次実行**してください：

---

## 🔍 Phase 1: 要望分析・技術選択

### 1.1 要望内容の詳細分析

**要望を詳しく分析**してください：

1. **作りたいもの**: $ARGUMENTS
2. **プロジェクトタイプを判定**してください：
   - **Web系**: "ウェブ", "サイト", "フロントエンド", "React", "Vue" → `web-app`
   - **API系**: "API", "サーバー", "REST", "GraphQL", "バックエンド" → `api-server`
   - **CLI系**: "コマンド", "ツール", "CLI", "スクリプト" → `cli-tool`
   - **ゲーム系**: "ゲーム", "パズル", "テトリス" → `web-app` (ブラウザゲーム)

### 1.2 技術スタックの選択

プロジェクトタイプに応じて**推奨技術スタック**を選択してください：

**重要な制約**:
- **JavaScriptプロジェクト**: bunまたはpnpmを使用してください。**npmは避けてください**。

**web-app**の場合:
- **フレームワーク**: React, Vue, Vanilla JS
- **パッケージマネージャー**: bun (推奨) または pnpm
- **テストフレームワーク**: Vitest, Jest

**api-server**の場合:
- **言語・フレームワーク**: Node.js + Express, FastAPI (Python), Go
- **データベース**: SQLite (開発), PostgreSQL (本格運用)

**cli-tool**の場合:
- **言語**: Python (argparse), Node.js (commander), Rust (clap)

### 1.3 開発フォルダ構造の提案

選択した技術スタックに応じて**推奨フォルダ構造**を提示してください。

---

## 🛠️ Phase 2: 環境初期化 (init統合)

### 2.1 プロジェクトタイプの再確認

Phase 1で判定したプロジェクトタイプを使用。
引数が不明確な場合は、現在のディレクトリから自動判定：
- `package.json` 存在 → web-app
- `requirements.txt` 存在 → cli-tool (Python)
- `Cargo.toml` 存在 → cli-tool (Rust)
- `go.mod` 存在 → api-server (Go)

### 2.2 アジャイル管理ディレクトリの作成

```bash
mkdir -p .claude/agile-artifacts/{stories,iterations,reviews,tdd-logs}
```

### 2.3 .gitignore の設定

個人用ログを除外し、チーム共有価値は含める：

```text
# TDD個人ログ（Git管理対象外）
.claude/agile-artifacts/tdd-logs/

# 一般的な除外項目
node_modules/
__pycache__/
.env
.DS_Store
```

### 2.4 Git リポジトリの初期化（必要な場合）

```bash
git init
git add .gitignore
git commit -m "[INIT] TDD environment setup with agile structure"
```

### 2.5 基本テスト環境の確認

プロジェクトタイプに応じてテストコマンドを確認：

**JavaScript/TypeScript**:
```bash
# パッケージマネージャーの確認とテストスクリプト確認
if command -v bun &> /dev/null; then
  echo "推奨: bun を使用"
elif command -v pnpm &> /dev/null; then
  echo "推奨: pnpm を使用"
else
  echo "推奨: bun または pnpm のインストールを検討"
fi
```

**Python**:
```bash
# テストフレームワークの確認
python -c "import pytest" 2>/dev/null && echo "pytest 利用可能" || echo "pytest インストール推奨"
```

---

## 📋 Phase 3: ユーザーストーリー作成 (story統合)

### 3.1 真のアジャイルユーザーストーリー作成

**アジャイル標準形式**で要望をユーザーストーリーに変換してください：

```
As a [ユーザータイプ]
I want [機能・行動]  
So that [価値・理由]
```

### 3.2 MVPファーストのストーリー分解

**Kent Beck原則**: 「最小限から始めて段階的に拡張」

要望を以下の優先度でストーリーに分解：

**Story 1 (MVP)**: 最小限の動作確認
- 基本的な動作が目視確認できる
- 「これが動いている」と実感できる

**Story 2-3 (Core)**: 核心機能
- ユーザーが最も期待している価値
- 「これがないと意味がない」機能

**Story 4+ (Enhancement)**: 拡張機能
- 「あったら嬉しい」機能
- 段階的改善要素

### 3.3 受け入れ基準の定義

各ストーリーに具体的な**受け入れ基準 (Acceptance Criteria)**を定義：

```
GIVEN [前提条件]
WHEN [実行操作]  
THEN [期待結果]
```

### 3.4 ストーリーファイルの作成

`.claude/agile-artifacts/stories/` ディレクトリに以下の形式でファイルを作成：

**ファイル名**: `user-stories-v1.0.md`

**テンプレート**:
```markdown
# ユーザーストーリー v1.0

**プロジェクト**: [要望名]
**作成日**: [今日の日付]
**技術スタック**: [選択した技術]

## Story 1: MVP - [簡潔な機能名]

**ストーリー**:
As a [ユーザー]
I want [機能]
So that [価値]

**受け入れ基準**:
- [ ] GIVEN [前提] WHEN [操作] THEN [結果]
- [ ] [追加の基準...]

**優先度**: 🔥 CRITICAL (MVP)
**工数見積**: [時間]

## Story 2: Core - [機能名]
[同様の形式...]

## Story 3: Core - [機能名] 
[同様の形式...]
```

---

## 📅 Phase 4: イテレーション計画 (plan統合)

### 4.1 Kent Beck "90分ルール" の適用

**短期集中の90分イテレーション**で実装計画を作成：

1. **90分で達成可能な最小機能**を特定
2. **Red-Green-Refactorサイクル**を3-5回実行
3. **動作確認とコミット**まで完了

### 4.2 実装順序の決定

**MVPファースト原則**で実装順序を決定：

**Iteration 1 (90分)**: Story 1のMVP実装
- Task 1.1: 失敗するテスト作成 (Red)
- Task 1.2: 最小実装 (Green)  
- Task 1.3: リファクタリング (Refactor)
- Task 1.4: 動作確認・コミット

### 4.3 Kent Beck三大戦略の適用計画

各Task実装時の戦略を事前に計画：

**Fake It戦略** (60%以上で使用):
- 実装方法が不明確
- 複雑なビジネスロジック
- まずはハードコーディングで動かす

**Triangulation戦略**:
- 2つ目のテストで一般化
- パターンが見えてきた時

**Obvious Implementation戦略**:
- 数学的に自明な処理のみ
- 1行で完結する簡単な処理

### 4.4 技術的制約・リスクの洗い出し

**技術リスク**:
- 未経験の技術スタック
- パフォーマンス要件
- 外部API依存

**対応策**:
- スパイクソリューション（調査用実装）
- 代替手段の準備
- 段階的複雑化

### 4.5 イテレーション計画ファイルの作成

`.claude/agile-artifacts/iterations/` ディレクトリに以下を作成：

**ファイル名**: `iteration-plan-v1.0.md`

**テンプレート**:
```markdown
# イテレーション計画 v1.0

**プロジェクト**: [要望名]
**計画日**: [今日の日付]
**イテレーション期間**: 90分

## Iteration 1: MVP実装

**目標**: Story 1の完全実装

**Task分解**:
### Task 1.1: [機能名] テスト作成 (Red) - 15分
- [ ] 失敗するテストの作成
- [ ] テスト実行で Red 確認
- [ ] コミット: [BEHAVIOR] Add failing test for [機能名]

### Task 1.2: [機能名] 最小実装 (Green) - 20分  
- [ ] [戦略名] 戦略で最小実装
- [ ] テスト実行で Green 確認
- [ ] コミット: [BEHAVIOR] Implement [機能名] with [戦略名]

### Task 1.3: [機能名] リファクタリング (Refactor) - 15分
- [ ] 構造改善・命名改善
- [ ] 全テスト Green 確認
- [ ] コミット: [STRUCTURE] Refactor [機能名] for clarity

### Task 1.4: 動作確認・統合 - 15分
- [ ] 実際の動作確認
- [ ] ユーザー目線での価値確認
- [ ] README更新（実行方法）

**成功基準**:
- [ ] 全テスト通過
- [ ] 実際に動作確認できる
- [ ] ユーザーが価値を実感できる

**次のイテレーション候補**:
- Story 2: [次の機能名]
- Story 1の改善・拡張
```

---

## 🚀 Phase 5: 実装開始案内

### 5.1 開発環境の最終確認

**実装開始前チェックリスト**:
- [ ] Git リポジトリが初期化されている
- [ ] テスト環境が構築されている  
- [ ] ユーザーストーリーが作成されている
- [ ] 90分イテレーション計画が完成している
- [ ] 実装戦略が決定されている

### 5.2 TDD開始コマンドの案内

**Kent Beck純正TDD**で実装を開始してください：

```bash
# 具体的機能の実装開始
/tdd:run [Story 1の機能名]

# 例:
/tdd:run display-block  # テトリスブロック表示
/tdd:run add-numbers    # 計算機の加算機能
/tdd:run health-check   # APIのヘルスチェック
```

### 5.3 品質ゲート設定の確認

各実装後に必ず以下を実行：

```bash
# テスト実行
[パッケージマネージャー] test -- --watchAll=false --forceExit

# 品質チェック  
[パッケージマネージャー] run lint
[パッケージマネージャー] run typecheck  # TypeScriptの場合

# 動作確認
[パッケージマネージャー] run dev
```

### 5.4 継続的フィードバックループの設定

**各機能完成後の確認手順**:

1. **動作デモ**: 実際にユーザーが使える状態か？
2. **価値確認**: ユーザーにとって価値があるか？
3. **次の優先度**: 次に重要な機能は何か？
4. **改善点**: 現在の実装で改善すべき点は？

### 5.5 完了メッセージの表示

```text
🎉 統合TDD開発環境の構築完了！

📋 作成された成果物:
├── .claude/agile-artifacts/
│   ├── stories/user-stories-v1.0.md     # ユーザーストーリー
│   ├── iterations/iteration-plan-v1.0.md # イテレーション計画
│   └── [その他のディレクトリ]

🎯 プロジェクト概要:
- **要望**: $ARGUMENTS
- **技術スタック**: [選択した技術]
- **MVPストーリー**: [Story 1の内容]
- **初回イテレーション**: 90分でMVP実装

🚀 実装開始準備完了:

Kent Beck純正TDDで実装開始:
/tdd:run [Story 1の機能名]

プロジェクト状況確認:
/tdd:status

品質レビュー実施:
/tdd:review

💡 TDD原則の実践:
1. Red → Green → Refactor サイクル厳守
2. 失敗するテストから必ず開始
3. 最小実装で Green を達成
4. 振る舞いを変えずに構造改善

🎯 成功の鍵:
- テストファースト厳守
- 90分集中イテレーション
- 継続的フィードバック
- アジャイル価値の実現
```

## 完了条件

**Phase 1**: 
- ✅ 要望分析完了・技術スタック決定
- ✅ 推奨フォルダ構造提示

**Phase 2**:
- ✅ .claude/agile-artifacts/ 構造が作成されている
- ✅ .gitignore が適切に設定されている  
- ✅ Git リポジトリが初期化されている（必要な場合）
- ✅ テスト環境の状態が確認されている

**Phase 3**:
- ✅ MVPファーストのユーザーストーリーが作成されている
- ✅ 受け入れ基準が具体的に定義されている
- ✅ stories/ ディレクトリにファイルが保存されている

**Phase 4**:
- ✅ 90分イテレーション計画が作成されている
- ✅ Kent Beck戦略の適用計画が完成している
- ✅ iterations/ ディレクトリにファイルが保存されている

**Phase 5**:
- ✅ 実装開始コマンドが明確に案内されている
- ✅ 品質ゲートが設定されている
- ✅ 継続的フィードバックループが確立されている

## エラーハンドリング

**Phase 1 失敗**: 要望不明確・技術スタック判定不可
→ 詳細な要望確認を依頼

**Phase 2 失敗**: Git初期化失敗・既存プロジェクト衝突  
→ 既存状況確認・競合解決案提示

**Phase 3 失敗**: ユーザーストーリー作成失敗・入力値不正
→ ストーリー形式の再説明・要望の再整理

**Phase 4 失敗**: イテレーション計画作成失敗・工数見積もり異常
→ より小さな単位での計画作成・リスク要因の特定

**Phase 5 失敗**: 最終案内表示失敗
→ 前段階の結果確認・部分的成功要素の保護