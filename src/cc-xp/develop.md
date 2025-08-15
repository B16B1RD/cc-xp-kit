---
description: XP develop – Kent Beck式Test-Driven Development実践
argument-hint: '[story-id] [--red|--green|--refactor] ※省略時は in-progress ストーリーを使用'
allowed-tools: Bash(git:*), Bash(date), Bash(test), Bash(npm:*), Bash(pnpm:*), Bash(yarn:*), Bash(bun:*), Bash(python:*), Bash(pytest:*), Bash(cargo:*), Bash(go:*), Bash(bundle:*), Bash(dotnet:*), Bash(gradle:*), Bash(npx:*), Bash(ls), WriteFile, ReadFile, mcp__playwright__*
---

# XP Develop - Kent Beck式TDD

## 🎯 ゴール

**Test-Driven Development (Kent Beck)** により、設計品質の高いソフトウェアを実装する。

**TDDの本質**: テストはドキュメントであり、仕様であり、設計手法である。

## TDD原則

@src/cc-xp/shared/tdd-principles.md

## 🚨 CRITICAL: ステータス変更の厳格制限

1. **status を done に変更することは絶対禁止**
   - develop コマンドは testing までしか進めない
   - done への変更は review accept のみが可能
   - 「ストーリー完了」という判断は行わない

2. **backlog.yaml の複数回更新禁止**
   - STEP 0-3 以外での status 変更は絶対禁止
   - 終了時の status 更新は絶対に行わない

## 開始前の確認

### 共通処理

@src/cc-xp/shared/git-check.md

### テスト環境確認

@src/cc-xp/shared/test-env-check.md

**テスト環境がない場合は処理を停止**し、以下を案内：
```
⛔ TDD実行不可: テスト環境が未構築です

以下を先に実行してください：
→ /cc-xp:plan  # プロジェクト設定とテスト環境構築
```

### STATUS 確認

⚠️ **このコマンドではステータス確認のみ行います**

@src/cc-xp/shared/backlog-reader.md から `in-progress` ステータスのストーリーを確認：
- `"in-progress"` であることを確認
- **"done" の場合は処理停止**（review完了済み）
- **"testing" の場合は処理停止**（既にdevelop実行済み）

⛔ **TDDサイクル完了まではステータスを変更しない**
⛔ **done への変更は絶対に行わない（review accept のみ可能）**

## 🔴🟢🔵 TDD実行フェーズ

### 実装前チェック: TODOテスト検出

#### TODOテスト検出と進捗確認

テストファイル内のTODOテストを検出し、反復的TDDサイクルの準備を行ってください。

**TODOテストの判定条件**：
```javascript
// パターン1: TODOコメント付きテスト
it('should_move_tetromino_down_when_time_passes', () => {
  // TODO: 落下中のテトロミノをセットアップ
  expect(true).toBe(false); // 🔴 未実装テスト
});

// パターン2: スケルトンテスト
it('should_handle_collision', () => {
  expect(true).toBe(false); // 🔴 仮の失敗テスト
});
```

**検出処理**：
1. テストファイル内の全 `it()` を走査
2. `// TODO:` コメントまたは `expect(true).toBe(false)` を含むテストをTODOと判定
3. TODOテスト数と実装済みテスト数をカウント
4. 進捗状況を表示（例：「テスト進捗: 3/7 実装済み, 4件のTODOテスト検出」）

**TODOテスト検出時の処理**：
- **TODOテストが存在する場合**: 反復的TDDサイクルを開始
- **TODOテストが0件の場合**: 通常のTDD完了条件チェックへ進行

### TDDサイクル実行

#### 一度に1つのテストだけ（TODOテスト順次実装）

**厳格なルール**:
1. **1つのテストを書く** → **そのテストを通す** → **構造を改善する**
2. **複数機能の同時実装は禁止**
3. **一度に1つの振る舞いのみ**
4. **最小限の進歩を積み重ねる**

#### Red-Green-Refactorサイクル

**🔴 Red フェーズ**：
1. 1つのTODOテストを選択
2. テストを実行して失敗することを確認
3. 失敗の原因が期待通りであることを確認

**🟢 Green フェーズ**：
1. テストを通す最小限のコードを実装
2. そのテストのみが通ることを確認
3. 他のテストが壊れていないことを確認

**🔵 Refactor フェーズ**：
1. 全テストが通る状態で構造を改善
2. 重複の除去
3. 可読性の向上
4. 設計の改善

#### TODOテスト順次処理

各TODOテストについて以下を実行：

1. **選択したTODOテストの Red フェーズ**
2. **Green フェーズ：最小実装**
3. **Refactor フェーズ：構造改善**
4. **次のTODOテストへ進行**

全TODOテストの実装が完了するまで反復してください。

### 価値体験実現の確認

#### minimum_experience の実装確認

全TODOテスト実装完了後、価値体験テストを実行：

```javascript
// 価値体験実現確認テスト例
it('should_provide_minimum_experience_to_user', () => {
  // backlog.yamlのminimum_experienceが実際に体験可能であることを確認
});
```

**価値体験確認項目**：
1. minimum_experience が実際に動作する
2. ユーザーが期待する価値を体験できる
3. 技術的成功と価値実現が一致している

### TDDサイクル完了条件

以下の条件をすべて満たした場合、TDDサイクル完了：

1. **全TODOテストが実装済み**（`expect(true).toBe(false)` が0件）
2. **全テストがPASS**
3. **価値体験テストがPASS**
4. **コードの重複が除去済み**
5. **設計品質が向上済み**

### ステータス更新（最終段階のみ）

TDDサイクル完了後、以下を実行：

1. backlog.yamlのストーリーステータスを `in-progress` から `testing` に更新
2. `updated_at` を現在時刻で更新
3. `development_notes` に実装サマリーを追加

```yaml
development_notes: |
  TDD実装完了:
  - 実装テスト数: [N]件
  - Red-Green-Refactorサイクル: [N]回完了
  - 価値体験実現: minimum_experience 確認済み
  - 設計品質: リファクタリング[N]回実施
```

### 完了確認

```
🔧 TDD Development 完了
========================
対象ストーリー: [story-id]
実装テスト数: [N]件
TDDサイクル数: [N]回

品質メトリクス:
✅ Red-Green-Refactor完全遵守
✅ テストファースト原則遵守
✅ 価値体験実現確認済み
✅ 設計品質向上確認済み

ステータス: in-progress → testing
```

## 次のステップ

@src/cc-xp/shared/next-steps.md