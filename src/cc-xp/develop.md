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

@shared/tdd-principles.md

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

@shared/git-check.md

### テスト環境確認

@shared/test-env-check.md

**テスト環境がない場合は処理を停止**し、以下を案内：
```
⛔ TDD実行不可: テスト環境が未構築です

以下を先に実行してください：
→ /cc-xp:plan  # プロジェクト設定とテスト環境構築
```

### STATUS 確認

⚠️ **このコマンドではステータス確認のみ行います**

@shared/backlog-reader.md から `in-progress` ステータスのストーリーを確認：
- `"in-progress"` であることを確認
- **"done" の場合は処理停止**（review完了済み）
- **"testing" の場合は処理停止**（既にdevelop実行済み）

⛔ **TDDサイクル完了まではステータスを変更しない**
⛔ **done への変更は絶対に行わない（review accept のみ可能）**

## 🔴🟢🔵 TDD実行フェーズ

### 実装前チェック: 受け入れ基準とE2Eテストの確認

#### 1. 受け入れ基準の存在確認

backlog.yamlから対象ストーリーの `acceptance_criteria` を確認してください：

```yaml
acceptance_criteria:
  - "ブラウザでページを開くとゲーム画面が表示される"
  - "テトロミノが1秒間隔で自動的に1行下に移動する"
  - "プレースホルダーメッセージが表示されない"
```

**acceptance_criteria がない場合**：
```
⛔ TDD実行不可: 受け入れ基準が未定義です

以下を先に実行してください：
→ /cc-xp:story  # 受け入れ基準の詳細化
```

#### 2. E2Eテストファイルの確認と生成要求

**E2Eテストファイルの検出**：
- `test/*e2e*` パターンでファイルを検索
- `test/*integration*` パターンでファイルを検索
- Playwrightやその他のE2Eテストフレームワークの設定確認

**E2Eテストファイルが存在しない場合**：
```
⚠️ E2Eテストが必要: このストーリーには出力・表示要素が含まれています

以下のE2Eテストファイルを作成してください：
test/[story-id].e2e.js (またはプロジェクトに適した拡張子)

各acceptance_criteriaを以下の形式でテストケースに変換：

// acceptance_criteria: "ブラウザでページを開くとゲーム画面が表示される"
it('should_display_game_screen_when_page_loads', async () => {
  await page.goto('/');
  const gameElement = await page.locator('[data-testid="game-screen"]');
  expect(await gameElement.isVisible()).toBe(true);
});

// acceptance_criteria: "テトロミノが1秒間隔で自動的に1行下に移動する"
it('should_move_tetromino_down_every_second', async () => {
  const tetromino = await page.locator('[data-testid="tetromino"]');
  const initialY = (await tetromino.boundingBox()).y;
  await page.waitForTimeout(1000);
  const newY = (await tetromino.boundingBox()).y;
  expect(newY).toBeGreaterThan(initialY);
});
```

#### 3. E2Eテスト失敗確認（Red状態）

E2Eテストファイルが存在する場合、実行して失敗することを確認：

```bash
# E2Eテスト実行例
npm run test:e2e
# または
npx playwright test
```

**E2Eテストが成功してしまう場合**：
受け入れ基準が既に実装済みの可能性があります。reviewコマンドで確認を推奨。

#### 4. ユニットテスト（TODOテスト）の確認

既存のTODOテスト検出も並行して実行：

**TODOテストの判定条件**：
```javascript
it('should_implement_game_logic', () => {
  expect(true).toBe(false); // 🔴 未実装テスト
});
```

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

### 価値体験実現の確認（E2Eテストベース）

#### acceptance_criteria の完全実現確認

全TODOテスト実装完了後、E2Eテストを実行して受け入れ基準の実現を確認：

```bash
# E2Eテスト実行
npm run test:e2e
# または
npx playwright test
```

**E2Eテスト成功の確認項目**：
1. **全acceptance_criteriaのテストがPASS**
   - 各受け入れ基準が実際に動作している
   - プレースホルダーメッセージが表示されない
   - ユーザーが期待する出力・操作が実現されている

2. **minimum_experienceの完全実現**
   - E2EテストがPASSすることで、minimum_experienceが実現されている証明
   - 技術的成功＝価値実現の一致が保証される

3. **実際のアプリケーション動作確認**
   - ブラウザ/アプリを手動で起動して最終確認
   - E2Eテストで検証された動作が実際に体験可能

**E2Eテストが失敗する場合**：
- 受け入れ基準が未実装または不完全
- ユニットテストは成功しても、統合・表示層で問題がある
- この場合は実装を継続し、E2EテストがPASSするまで開発

### TDDサイクル完了条件

以下の条件をすべて満たした場合、TDDサイクル完了：

1. **全TODOテストが実装済み**（`expect(true).toBe(false)` が0件）
2. **全ユニットテストがPASS**
3. **🎯 全E2EテストがPASS**（受け入れ基準の完全実現）
4. **コードの重複が除去済み**
5. **設計品質が向上済み**

**最重要**: E2EテストのPASSがTDD完了の必須条件です。これにより：
- acceptance_criteriaの完全実現が保証される
- minimum_experienceが実際に体験可能であることが証明される
- 技術的成功と価値実現の一致が確認される

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

## 次のステップ

@shared/next-steps.md

### develop 完了時の重要な案内

TDDサイクル完了後、**必ず以下の形式で次のステップを案内してください**：

```
🚀 次のステップ
================
develop完了：ストーリーのレビューと価値検証を実施してください:
→ /cc-xp:review

価値体験確認とコード品質評価を実行し、accept/rejectを判定します。
```

**重要**:
- ステータスが "testing" に更新された場合、次は review コマンドです
- 決して "accept" を直接指示しないでください
- review コマンドでの評価後に accept/reject が判定されます