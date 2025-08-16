# テスト環境確認

## テスト実行環境の確認

プロジェクトにテスト実行環境があることを確認してください：

```bash
# いずれかのコマンドが実行可能であることを確認
npm test || yarn test || pnpm test || bun test ||
python -m pytest || python -m unittest ||
go test ./... ||
cargo test ||
bundle exec rspec ||
dotnet test
```

**テスト環境がない場合は処理を停止**し、以下を案内：

```
⛔ TDD実行不可: テスト環境が未構築です

以下を先に実行してください：
→ /cc-xp:plan  # プロジェクト設定とテスト環境構築
```

## E2Eテスト環境の確認（必須）

**⚠️ CRITICAL**: E2E テストが必須のため、Playwright の環境確認を実行してください。

### Playwright環境の確認

以下を順次確認してください：

1. **Playwrightインストール確認**：
   ```bash
   npx playwright --version
   ```

2. **Playwrightが未インストールの場合**：
   ```bash
   npm install --save-dev @playwright/test
   npx playwright install
   ```

3. **playwright.config.js の存在確認**：
   - 存在しない場合は develop コマンドで自動生成される

4. **E2Eテストディレクトリ確認**：
   ```bash
   mkdir -p test/e2e
   ```

### E2E環境構築失敗時の対応

Playwright 環境の構築に失敗した場合は処理を停止し、以下を案内：

```
⛔ E2Eテスト環境構築失敗: Playwrightの設定が必要です

以下を手動で実行してから再度実行してください：
→ npm install --save-dev @playwright/test
→ npx playwright install
→ mkdir -p test/e2e
```

## プロジェクトタイプ検出とテスト環境構築

### 言語・フレームワークの検出

- package.json → JavaScript/TypeScript/Node.js
- requirements.txt/pyproject.toml → Python
- Cargo.toml → Rust
- go.mod → Go
- Gemfile → Ruby

### テストランナーの確認・セットアップ

#### JavaScript/TypeScript

package.json が存在する場合は以下を確認・実行してください：
- test スクリプトが存在しない場合は、"jest"または"vitest"を追加してください
- jest がインストールされていない場合は、`npm install --save-dev jest jest-environment-jsdom`を実行してください  
- **Playwright（E2Eテスト必須）**：`npm install --save-dev @playwright/test && npx playwright install`を実行してください
- `npm install`を実行して全依存関係をインストールしてください

**Jest設定の確認・追加**：
package.json に以下の Jest 設定を追加してください（存在しない場合）：
```json
{
  "jest": {
    "collectCoverage": true,
    "collectCoverageFrom": [
      "src/**/*.{js,ts}",
      "!src/**/*.test.{js,ts}",
      "!src/**/*.spec.{js,ts}"
    ],
    "coverageThreshold": {
      "global": {
        "branches": 85,
        "functions": 85,
        "lines": 85,
        "statements": 85
      }
    },
    "testEnvironment": "jsdom"
  }
}
```

#### Python

requirements.txt または pyproject.toml が存在する場合：
- pytest が見つからない場合は、`pip install pytest`を実行してください

#### Go

`go mod tidy`を実行してモジュール依存関係を整理してください

## テストディレクトリ構造生成

**標準構造の作成**:

以下のテストディレクトリ構造を作成してください：
- `test/unit` - ユニットテスト用
- `test/e2e` - E2E テスト用（必須）
- `test/integration` - 統合テスト用  
- `test/regression` - 回帰テスト用
- `docs/cc-xp` - cc-xp-kit 作業ファイル用

**初期テストファイル生成**:
```javascript
// test/setup.spec.js
describe('Project Setup', () => {
  it('should have test environment ready', () => {
    expect(true).toBe(true);
  });
});
```