---
description: XP retro – 価値実現振り返りと継続的観察
allowed-tools: Bash(date), Bash(echo), Bash(git:*), Bash(grep), Bash(wc:*), ReadFile, WriteFile
---

# XP Retro - 価値実現振り返り

## ゴール

価値実現の観点から短いサイクルを振り返り、**次をもっと価値ある**ものにするための学びを得る。

## XP原則

@shared/xp-principles.md

## 共通処理

@shared/git-check.md

## Gitメトリクスの収集

### イテレーション期間の特定

- 最初の plan コミット: !git log --reverse --grep="feat: イテレーション計画" --format="%at" -1
- 現在時刻（UNIX 時間）: !date +%s

上記の差分から経過時間を計算してください。見つからない場合は、2 時間前からを対象期間としてください。

### コミット統計の収集

- 総コミット数: !git log --oneline --since="2 hours ago"
- 開発関連コミット数: !git log --oneline --since="2 hours ago" --grep="feat\|fix\|test"
- 完了ストーリー数: !git log --oneline --since="2 hours ago" --grep="✨"

### 変更統計の収集

- 変更ファイル数: !git diff --name-only main..HEAD
- 変更サマリー: !git diff --stat main..HEAD
- 頻繁に変更されたファイル: !git log --since="2 hours ago" --name-only --pretty=format:

## 🔴🟢🔵 TDD品質メトリクス分析

### TDDサイクル遵守状況

以下のGitコミット分析により、真のTDD実践度を測定します：

#### Red-Green-Refactorサイクル完全性

```bash
# Kent Beck TDDサイクルの確認
git log --oneline --since="2 hours ago" --grep="\[Red\]" --format="%h %s"
git log --oneline --since="2 hours ago" --grep="\[Green\]" --format="%h %s"
git log --oneline --since="2 hours ago" --grep="\[Refactor\]" --format="%h %s"
```

**TDD完全性評価**:
- **完全なサイクル数**: Red→Green→Refactorを順守したストーリー数
- **不完全サイクル数**: サイクルの抜けがあるストーリー数
- **TDD違反数**: 実装先行コミット（アンチパターン）の数

#### テストファースト遵守率

```bash
# テストファイル vs 実装ファイルの時系列確認
git log --name-only --pretty=format:"%h %ct" --since="2 hours ago" | grep -E "\.(spec|test|e2e)\.js$"
git log --name-only --pretty=format:"%h %ct" --since="2 hours ago" | grep -E "^src/.*\.js$"
```

**テストファースト評価**:
- **テストファースト率**: テストが実装より先に追加された割合
- **実装先行数**: テストなしで実装が追加された件数（重大な問題）
- **テストカバレッジ**: 全実装に対してテストが存在する割合

### TDD効果測定

#### 品質向上効果

```bash
# 品質関連のメトリクス
git log --oneline --since="2 hours ago" --grep="fix:" | wc -l  # バグ修正数
git log --oneline --since="2 hours ago" --grep="reject" | wc -l # レビューreject数
```

**品質効果評価**:
- **バグ密度**: 実装に対するバグ修正の比率
- **レビューreject率**: 初回レビューでのreject発生率
- **デグレード発生数**: 過去に動いていた機能の破壊数
- **回帰テストによる予防成功数**: 回帰テストが実際にバグを検出した数

#### 開発速度への影響

```bash
# 開発効率のメトリクス
git log --oneline --since="2 hours ago" | wc -l  # 総コミット数
find docs/cc-xp -name "*.md" -newer "2 hours ago" | wc -l  # 完了ストーリー数
```

**効率効果評価**:
- **開発サイクルタイム**: ストーリー開始から完了までの時間
- **TDDオーバーヘッド**: テスト記述にかかる追加時間
- **リファクタリング効率**: Refactorフェーズでのコード改善効果
- **設計改善効果**: TDDによるコード設計品質の向上度

### TDD実践推奨事項生成

TDD分析結果に基づいて、具体的な改善提案を生成：

**高品質TDD実践の場合**:
```
✅ TDD Excellence Status
======================
Red-Green-Refactor完全遵守: 100%
テストファースト率: 95%以上  
回帰テスト生成: 適切
アンチパターン: 0件

🎯 Excellence継続のために:
• 現在の高品質TDD習慣を維持
• チーム内でのTDDベストプラクティス共有
• 新しいリファクタリングパターンの探索
```

**改善が必要な場合**:
```
⚠️ TDD Quality Issues Detected
==============================
テストファースト率: 60%（要改善）
アンチパターン検出: 5件（深刻）
回帰テスト不足: 3ストーリー

🔧 改善アクション:
• 実装前の必須テスト作成の徹底
• [Red]→[Green]→[Refactor]コミット規律の徹底
• review reject時の回帰テスト生成確認
• TDD原則違反の撲滅（テスト修正禁止など）
```

## 戦略的メトリクス分析

### 拡張メトリクスファイルの確認

@docs/cc-xp/metrics.json から**従来と新規の両方の指標**を確認してください。

### 仮説検証成功率分析（新機能）

backlog.yamlの**hypothesis_driven**セクションの実績を分析：

```yaml
# docs/cc-xp/metrics.json内の新セクション例
hypothesis_driven:
  total_hypotheses: 12       # 設定した仮説総数
  validated_hypotheses: 8    # 検証成功した仮説数
  success_rate: 66.7%       # 仮説検証成功率
  business_value_realization: 78%  # ビジネス価値実現度
```

**仮説検証KPIの分析**:
- **仮説検証成功率**: 60%以上で良好、80%以上で優秀
- **価値実現度**: minimum_experience実現率の測定
- **ビジネス価値実現**: business_value達成度の評価

### 2階層健全性評価システム（新機能）

#### ビジネス健全性評価（重要度70%）

**価値実現健全性**:
- 仮説検証成功率: [%]
- minimum_experience実現率: [%]
- ユーザー価値実現度: [%]
- ビジネス価値創出度: [%]

**総合ビジネス健全性**: [ビジネス重要度70%の算出結果]

#### 技術健全性評価（重要度30%）

**TDD品質健全性**:
- Red-Green-Refactor完全遵守率: [%]
- テストファースト遵守率: [%]
- テストカバレッジ: [%]
- アンチパターン検出率: [%]（逆指標）

**総合技術健全性**: [技術重要度30%の算出結果]

#### 統合健全性スコア算出

```
総合健全性 = (ビジネス健全性 × 0.7) + (技術健全性 × 0.3)
```

**健全性判定基準**:
- **90%以上**: 🟢 優秀（継続推奨）
- **80-89%**: 🟡 良好（微調整推奨）  
- **70-79%**: 🟠 要注意（改善必要）
- **70%未満**: 🔴 問題あり（戦略見直し必要）

## 振り返り結果の記録と次のアクション

### 振り返りサマリーの生成

```markdown
# Retrospective Summary

## 期間: [開始日時] - [終了日時]

## 価値実現メトリクス
- 完了ストーリー数: [N]件
- 価値実現率: [%]
- ユーザー体験向上度: [%]

## TDD品質メトリクス  
- TDD完全性: [%]
- テストファースト率: [%]
- コード品質向上度: [%]

## 統合健全性スコア: [%]
- ビジネス健全性: [%] (重要度70%)
- 技術健全性: [%] (重要度30%)

## 改善アクション
1. [改善項目1]
2. [改善項目2]
3. [改善項目3]
```

## 次のステップ

@shared/next-steps.md