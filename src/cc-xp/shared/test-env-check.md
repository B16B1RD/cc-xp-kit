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

## プロジェクトタイプ検出とテスト環境構築

### 言語・フレームワークの検出

- package.json → JavaScript/TypeScript/Node.js
- requirements.txt/pyproject.toml → Python
- Cargo.toml → Rust
- go.mod → Go
- Gemfile → Ruby

### テストランナーの確認・セットアップ

#### JavaScript/TypeScript

package.jsonが存在する場合は以下を確認・実行してください：
- testスクリプトが存在しない場合は、"jest"または"vitest"を追加してください
- jestがインストールされていない場合は、`npm install --save-dev jest jest-environment-jsdom`を実行してください  
- `npm install`を実行して全依存関係をインストールしてください

#### Python

requirements.txtまたはpyproject.tomlが存在する場合：
- pytestが見つからない場合は、`pip install pytest`を実行してください

#### Go

`go mod tidy`を実行してモジュール依存関係を整理してください

## テストディレクトリ構造生成

**標準構造の作成**:

以下のテストディレクトリ構造を作成してください：
- `test/unit` - ユニットテスト用
- `test/integration` - 統合テスト用  
- `test/regression` - 回帰テスト用
- `docs/cc-xp` - cc-xp-kit作業ファイル用

**初期テストファイル生成**:
```javascript
// test/setup.spec.js
describe('Project Setup', () => {
  it('should have test environment ready', () => {
    expect(true).toBe(true);
  });
});
```