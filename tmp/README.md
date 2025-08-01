# 一時ファイル置き場 (tmp/)

このディレクトリは Claude に参照させたい一時的なファイルを配置する場所です。

## 使い方

### 1. 実行結果を参照させたい場合

```bash
# 例: コマンド実行結果を保存
/tdd-quick "テトリスゲーム" > tmp/execution-result.txt

# Claude に参照させる
"@tmp/execution-result.txt を確認して改善案を提案して"
```

### 2. エラーログを共有したい場合

```bash
# エラーログを保存
npm test 2>&1 > tmp/test-error.log

# Claude に参照させる
"@tmp/test-error.log のエラーを解決して"
```

### 3. スクリーンショットを共有したい場合

```text
# スクリーンショットを tmp/ に保存
# 例: tmp/screenshot.png

# Claude に参照させる
"@tmp/screenshot.png のUIを改善して"
```

## 注意事項

- このディレクトリ内のファイルは Git で追跡されません
- 機密情報は置かないでください
- 定期的に不要なファイルは削除してください

## ファイル命名規則（推奨）

- `execution-result-YYYY-MM-DD.txt` - 実行結果
- `error-log-YYYY-MM-DD.log` - エラーログ
- `screenshot-feature-name.png` - スクリーンショット
- `test-data.json` - テストデータ

## クリーンアップ

```bash
# すべての一時ファイルを削除（.gitkeep と README.md は残す）
find tmp -type f ! -name '.gitkeep' ! -name 'README.md' -delete
```
