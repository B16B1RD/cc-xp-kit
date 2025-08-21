# Quality Gates (Draft)

## Static Analysis / Lint

- Lint エラーが 1 件でもあれば **Fail**
- 重大/禁止ルールは PR をブロック

## Test Coverage

- Lines ≥ 80%（暫定）
- 新規/変更ファイルは既存平均 -5% 未満にならないこと

## Security

- 既知の **High/Critical** 脆弱性が検出された場合は **Fail**
- Secrets をコードに直書きしない（検出時は Fail）

## Performance / NFR（暫定値）

- Web: 主要操作の P95 応答 ≤ 200ms（暫定）
- CLI: 代表コマンドの実行時間 ≤ 2s（暫定）

## Failure Policy

- Gate Fail の PR はマージ不可
- 修正コミットで再実行、緑化後にレビュー再開
