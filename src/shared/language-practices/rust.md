# Rust モダンプラクティス

## パッケージ管理
```yaml
primary: cargo        # Rust 標準のビルドシステム
registry: crates.io   # 公式パッケージレジストリ
lockfile: Cargo.lock  # 依存関係のロックファイル
```

## プロジェクト構造
```
project/
├── src/
│   ├── lib.rs          # ライブラリのエントリーポイント
│   ├── main.rs         # 実行可能ファイルのエントリーポイント
│   ├── bin/            # 追加の実行可能ファイル
│   └── modules/        # モジュール分割
├── tests/              # 統合テスト
│   └── integration_test.rs
├── benches/            # ベンチマーク
│   └── benchmark.rs
├── examples/           # 使用例
├── target/             # ビルド成果物（Git無視）
├── Cargo.toml          # プロジェクト設定
├── Cargo.lock          # 依存関係ロック
├── rust-toolchain.toml # Rust ツールチェーンバージョン
└── .rustfmt.toml      # フォーマッター設定
```

## テストフレームワーク
```yaml
unit_test: "組み込み #[test]"
integration_test: tests/
benchmark: criterion    # 高精度ベンチマーク
property_test: proptest # プロパティベーステスト
```

## 開発ツール
```yaml
formatter: rustfmt     # 公式フォーマッター
linter: clippy        # 公式リンター
analyzer: rust-analyzer # LSP サーバー
audit: cargo-audit    # セキュリティ監査
```

## 実行コマンド
```bash
# ビルド・実行
build: "cargo build"
build_release: "cargo build --release"
run: "cargo run"
run_release: "cargo run --release"

# テスト実行
test: "cargo test"
test_verbose: "cargo test -- --nocapture"
test_single: "cargo test test_name"
bench: "cargo bench"

# コード品質
fmt: "cargo fmt"
fmt_check: "cargo fmt -- --check"
lint: "cargo clippy -- -D warnings"
check: "cargo check"

# ドキュメント
doc: "cargo doc --open"
doc_private: "cargo doc --document-private-items"

# 依存関係管理
add_dep: "cargo add"
update_deps: "cargo update"
audit: "cargo audit"
tree: "cargo tree"  # 依存関係ツリー表示

# その他
clean: "cargo clean"
publish: "cargo publish"
```

## Git 無視パターン
```gitignore
# ビルド成果物
/target/
**/*.rs.bk

# エディタ
*.swp
*.swo
*~
.idea/
.vscode/

# デバッグ
*.pdb

# Mac
.DS_Store

# バックアップ
*.orig
```

## ベストプラクティス
- **エラーハンドリング**: `Result<T, E>` と `?` 演算子を活用
- **所有権**: 借用チェッカーを活かした安全なメモリ管理
- **並行性**: `Arc<Mutex<T>>` より `channels` を優先
- **トレイト**: ジェネリックな実装のためにトレイトを定義
- **モジュール**: 機能ごとにモジュールを分割
- **ドキュメント**: `///` でAPIドキュメントを記述
- **例**: `examples/` ディレクトリに実用例を配置
- **ベンチマーク**: パフォーマンスクリティカルなコードは計測

## Cargo.toml の推奨設定
```toml
[profile.release]
opt-level = 3
lto = true          # Link Time Optimization
codegen-units = 1   # 単一コード生成ユニット

[profile.dev]
opt-level = 0
debug = true
```