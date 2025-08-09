---
description: XP plan – 包括的要求分析による価値あるストーリー抽出（真の目的理解重視）
argument-hint: '"ウェブブラウザで遊べるテトリスが欲しい"'
allowed-tools: Bash(date), Bash(echo), Bash(git:*), Bash(test), Bash(mkdir:*), Bash(cat), ReadFile, WriteFile
---

## ゴール

「$ARGUMENTS」から**真の目的**を理解し、ユーザーが本当に求める価値を実現する包括的なストーリーセットを生成する。

## XP + 要求理解原則

- **顧客価値最優先**: ユーザーの真のニーズを深く理解する
- **シンプルさ**: 本質的な機能に集中、不要な複雑性を排除  
- **包括的品質**: 機能・非機能・開発者要件を網羅
- **Working Software**: 実装可能で価値あるソフトウェアの素早い実現

## 5段階包括的要求分析プロセス

ユーザー要求「$ARGUMENTS」を以下の5段階で分析し、真の価値を実現するストーリーセットを生成します：

### Stage 1: 真の目的分析 🎯

表面的な要求の背後にある**本当のニーズ**を探ります：

**分析視点**：
- **現状の不満**: なぜこの要求が生まれたのか？既存の何に不満があるのか？
- **真の達成目標**: ユーザーが本当に解決したい根本問題は何か？  
- **成功のイメージ**: この要求が実現されたとき、ユーザーはどう感じるか？

#### 真の目的分析テンプレート集

**ゲーム・エンターテイメント系の例**:
```
「本格的なテトリスが欲しい」
→ 現状の不満: 既存テトリスが重い、操作性悪い、品質低い
→ 真の達成目標: ストレスフリーで質の高いパズルゲーム体験  
→ 成功のイメージ: いつでもすぐに楽しめる、満足度の高いゲーム

「シンプルなパズルゲーム」
→ 現状の不満: 複雑すぎるゲームに疲れている
→ 真の達成目標: リラックスできる軽い娯楽  
→ 成功のイメージ: 気軽に始めて気軽に終われる
```

**業務・生産性系の例**:
```
「タスク管理システムが欲しい」  
→ 現状の不満: 仕事の抜け漏れ、優先度不明、進捗不透明
→ 真の達成目標: 安心して仕事を進められる体制作り
→ 成功のイメージ: 頭を空っぽにして集中できる環境

「顧客管理システム」
→ 現状の不満: 顧客情報が散らばって営業効率悪い
→ 真の達成目標: 売上向上と顧客満足度の両立
→ 成功のイメージ: 顧客との関係が深まり売上増加
```

**コンテンツ・情報系の例**:
```
「ブログサイトを作りたい」
→ 現状の不満: 思考を整理して発信する場がない
→ 真の達成目標: 考えを言語化して他者と共有したい
→ 成功のイメージ: 読者とのコミュニケーションで成長

「ECサイト構築」  
→ 現状の不満: 商品を売る場所・方法が限られている
→ 真の達成目標: より多くの顧客にリーチして売上拡大
→ 成功のイメージ: 24時間自動で売上が上がる仕組み
```

#### 真の目的分析のガイドライン

**❌ 表面的分析（避けるべき）**:
- 「テトリスゲームが欲しい」→「テトリスを作る」
- 「管理システム」→「CRUDを作る」  
- 字面通りの解釈で要求の深さを見落とす

**✅ 深層分析（目指すべき）**:
- **5回のなぜ**: なぜそれが欲しいのか？を5回繰り返す
- **感情の探求**: 解決されたときの感情的価値は？
- **制約の理解**: 何が現在の解決を妨げているか？
- **成功の具体化**: 成功したときの具体的な状況は？

**分析のための質問フレームワーク**:
```
【現状確認】
・今は何を使っているか？
・それの何が不満か？
・いつから不満に感じているか？

【理想確認】  
・理想的には何ができるようになりたいか？
・誰が喜ぶか？
・どのような変化を期待しているか？

【制約確認】
・予算・時間・技術的な制約は？
・譲れない条件は？
・妥協できる部分は？
```

### Stage 2: 多角ペルソナ想定 👥

要求に関わる**すべての関係者**を想定します：

#### 📱 エンドユーザー系ペルソナ詳細ガイド

**主要ユーザー（直接利用者）**:
```
【ゲーム・エンタメ系】
・カジュアルゲーマー: 空き時間の暇つぶし、ストレス解消目的
・コアゲーマー: 高い完成度、競技性、やり込み要素を求める
・ファミリー層: 家族で楽しめる、安心安全なコンテンツ

【ビジネス・生産性系】  
・個人事業主: 効率化、コスト削減、売上向上が最優先
・チームリーダー: メンバー管理、進捗把握、品質向上
・一般従業員: 日々の作業効率、ストレス軽減、使いやすさ

【情報・コンテンツ系】
・コンテンツ作成者: 発信力、reach拡大、収益化
・情報消費者: 欲しい情報への素早いアクセス、質の高いコンテンツ
・コミュニティ参加者: 他者との交流、知識共有、帰属感
```

**二次ユーザー（間接影響者）**:
```
・顧客: エンドユーザーのサービス品質向上の恩恵
・家族: エンドユーザーの効率化・ストレス軽減の恩恵  
・同僚: 共同作業の効率化、情報共有の改善
・競合他社: 市場変化への対応必要性
```

#### 🔧 技術系ペルソナ詳細ガイド

**開発者（コード担当）**:
```
・フロントエンド開発者: UI/UX、ユーザビリティ、レスポンシブ対応
・バックエンド開発者: API、データベース、パフォーマンス、スケーラビリティ  
・フルスタック開発者: 全体アーキテクチャ、統合、デプロイメント
・メンテナンス担当者: バグ修正、機能追加、レガシーコード対応
```

**運用者（システム管理）**:
```
・インフラエンジニア: サーバー管理、ネットワーク、セキュリティ
・DevOpsエンジニア: CI/CD、自動化、監視、障害対応
・データベース管理者: データ整合性、バックアップ、最適化
・セキュリティ担当者: 脆弱性対策、アクセス制御、コンプライアンス
```

**品質保証（テスト・検証）**:
```
・QAエンジニア: テスト計画、自動化、品質基準定義
・テスター: 手動テスト、ユーザビリティ確認、バグ検出  
・パフォーマンステスター: 負荷試験、レスポンス測定、最適化提案
```

#### 💼 ビジネス系ペルソナ詳細ガイド

**意思決定者（方針・予算）**:
```
・プロダクトオーナー: 機能優先度、リリース計画、ROI最大化
・技術責任者: アーキテクチャ方針、技術選択、品質基準
・プロジェクトマネージャー: スケジュール、リソース配分、リスク管理
・経営陣: 予算承認、戦略方針、市場ポジショニング
```

**利害関係者（関心・影響）**:
```
・営業チーム: 売上目標、顧客満足、競合優位性
・マーケティング: ユーザー獲得、ブランド価値、市場シェア
・サポートチーム: 問い合わせ対応、ユーザー教育、満足度向上
・投資家・株主: ROI、成長性、持続可能性
```

#### ペルソナ想定のガイドライン

**❌ 表面的ペルソナ（避けるべき）**:
- 「ユーザー」「開発者」「管理者」等の抽象的な分類
- 具体性のない一般論的なペルソナ設定
- エンドユーザーのみで技術・ビジネス系を無視

**✅ 深層ペルソナ（目指すべき）**:
- **具体的な状況**: いつ、どこで、なぜ使うのか
- **動機の理解**: 何を達成したくて、何に困っているのか  
- **制約の把握**: 時間、予算、技術スキル等の限界
- **感情の考慮**: 使用時の感情、期待、不安

**ペルソナ設定フレームワーク**:
```
【基本属性】
・役割/職業: 具体的な立場と責任範囲
・経験レベル: 初心者/中級者/上級者/専門家
・利用環境: デバイス、時間帯、場所の制約

【動機・目標】  
・機能的動機: 効率化、問題解決、目標達成
・感情的動機: 満足感、安心感、優越感
・社会的動機: 承認、共有、貢献

【制約・課題】
・時間制約: 忙しさ、締切、優先度
・技術制約: スキルレベル、使用環境、学習コスト
・予算制約: コスト感覚、投資対効果への期待
```

### Stage 3: 達成目標の具体化 🎯

各ペルソナが**本当に達成したいこと**を明確化します：

**分析項目**：
- **機能的ゴール**: 何ができるようになりたいか
- **感情的ゴール**: どう感じたいか
- **効率的ゴール**: どう改善したいか
- **制約条件**: 何に制限されているか

### Stage 4: 全要件種別の網羅的抽出 📋

見落としがちな要件も含めて**包括的に**洗い出します：

#### ✅ 機能要件詳細チェックリスト

**🎯 コア機能（システムの核心価値）**:
- [ ] **基本操作**: ユーザーが最も頻繁に行う操作
  ```
  例: ゲーム→プレイ操作、Todo→タスク追加/完了、EC→商品検索/購入
  判定: これがないとシステムの意味がない機能
  ```
- [ ] **データ処理**: データの変換・計算・処理ロジック
  ```
  例: スコア計算、在庫管理、レポート生成
  判定: ユーザーが期待する結果を生成する処理
  ```

**📊 データ管理（CRUD操作）**:
- [ ] **入力・作成**: データの新規登録機能
- [ ] **表示・取得**: データの参照・検索・フィルタ機能  
- [ ] **更新・編集**: 既存データの変更機能
- [ ] **削除・アーカイブ**: データの削除・無効化機能
- [ ] **バリデーション**: データの妥当性検証
- [ ] **インポート/エクスポート**: 外部データとの連携

**👥 ユーザー管理（認証・権限）**:
- [ ] **認証**: ログイン・ログアウト・パスワード管理
- [ ] **認可**: 機能・データへのアクセス制御
- [ ] **プロファイル**: ユーザー情報の管理・設定
- [ ] **多要素認証**: セキュリティ強化が必要な場合
- [ ] **ソーシャルログイン**: 外部アカウント連携

**🔗 外部連携（統合・API）**:
- [ ] **サードパーティAPI**: 外部サービスとの連携
- [ ] **決済システム**: 課金・支払い処理
- [ ] **通知システム**: メール・プッシュ・SMS通知
- [ ] **ファイルストレージ**: 画像・動画・文書の管理
- [ ] **分析ツール**: GA、マーケティングツール連携

#### ✅ 非機能要件詳細チェックリスト

**🎨 UI/UX（ユーザー体験）**:
- [ ] **視覚デザイン**: 色・フォント・レイアウト・ブランディング
  ```
  判定基準: ブランドイメージに合致、ターゲットユーザーに訴求
  ```
- [ ] **使いやすさ**: 直感的操作、学習コスト、エラー防止
  ```
  判定基準: 初回利用で迷わない、3クリック以内で目的達成
  ```
- [ ] **アクセシビリティ**: 障害者対応、多様なユーザー対応
  ```
  判定基準: WCAG準拠、キーボード操作対応、読み上げソフト対応
  ```
- [ ] **レスポンシブ**: PC・タブレット・スマホ対応
  ```
  判定基準: 主要デバイスで適切に表示・操作可能
  ```

**⚡ パフォーマンス（速度・効率）**:
- [ ] **レスポンス時間**: ユーザー操作への応答速度
  ```
  判定基準: 1秒以内（検索）、3秒以内（ページ読み込み）
  ```
- [ ] **スループット**: 同時処理可能な操作数
  ```
  判定基準: 想定同時ユーザー数でのストレステスト通過
  ```
- [ ] **リソース効率**: CPU・メモリ・ストレージ使用量
  ```
  判定基準: 予算内でのインフラ運用、合理的なリソース使用
  ```
- [ ] **バッテリー影響**: モバイルデバイスでの電力消費
  ```
  判定基準: 長時間利用でも極端なバッテリー消費なし
  ```

**🔒 セキュリティ（データ保護）**:
- [ ] **認証強度**: パスワード・多要素認証の強度
- [ ] **データ暗号化**: 保存・通信時の暗号化
- [ ] **入力検証**: SQLインジェクション・XSS対策
- [ ] **権限制御**: 最小権限原則、不正アクセス防止
- [ ] **ログ・監査**: セキュリティイベントの記録
- [ ] **プライバシー**: GDPR・個人情報保護法対応

**🌐 可用性（安定稼働）**:
- [ ] **稼働率**: 99.9%等のSLA要件
- [ ] **災害対策**: バックアップ・復旧計画
- [ ] **冗長化**: 単一障害点の排除
- [ ] **メンテナンス**: 計画停止時間の最小化

**🔧 互換性（環境対応）**:
- [ ] **ブラウザ**: Chrome・Firefox・Safari・Edge対応
- [ ] **OS**: Windows・Mac・Linux・iOS・Android対応  
- [ ] **レガシー**: 古いバージョン・システムとの共存
- [ ] **国際化**: 多言語・多通貨・タイムゾーン対応

**📈 スケーラビリティ（成長対応）**:
- [ ] **ユーザー増**: 利用者数の増加への対応
- [ ] **データ増**: データ量の増加への対応
- [ ] **機能拡張**: 新機能追加への対応準備
- [ ] **地理的拡張**: 複数地域展開への対応

#### ✅ 開発者要件詳細チェックリスト

**🧪 テスト（品質保証）**:
- [ ] **ユニットテスト**: 個別機能の動作確認
  ```
  判定基準: カバレッジ80%以上、CI/CDで自動実行
  ```
- [ ] **統合テスト**: システム間連携の確認
  ```
  判定基準: 主要なデータフロー・APIの動作確認
  ```
- [ ] **E2Eテスト**: ユーザー視点での全体動作確認
  ```
  判定基準: 主要なユーザージャーニーの自動テスト
  ```
- [ ] **パフォーマンステスト**: 負荷・ストレステスト
- [ ] **セキュリティテスト**: 脆弱性・侵入テスト

**🔧 保守性（メンテナンス容易性）**:
- [ ] **コード品質**: 可読性・一貫性・複雑度管理
  ```
  判定基準: リンター・フォーマッター導入、コードレビュー必須
  ```
- [ ] **ドキュメント**: 設計書・API仕様・運用手順
  ```
  判定基準: 新メンバーが1週間以内に開発参加可能
  ```
- [ ] **リファクタリング**: コード改善のしやすさ
  ```
  判定基準: 自動テストでリファクタリングを安全に実行
  ```
- [ ] **設定管理**: 環境設定・機能フラグの管理
  ```
  判定基準: 環境ごとの設定分離、設定変更の影響範囲明確
  ```

**🚀 拡張性（機能追加容易性）**:
- [ ] **モジュール設計**: 疎結合・高凝集の設計
- [ ] **API設計**: 拡張可能なインターフェース設計  
- [ ] **プラグイン機構**: サードパーティによる機能拡張
- [ ] **設定可能性**: 管理画面での機能ON/OFF

**📊 監視（運用可視化）**:
- [ ] **アプリケーションログ**: エラー・操作・パフォーマンス
- [ ] **メトリクス**: CPU・メモリ・レスポンス時間・エラー率
- [ ] **アラート**: 異常検知・通知の仕組み
- [ ] **ダッシュボード**: 運用状況の可視化

**🚢 デプロイ（リリース管理）**:
- [ ] **自動化**: CI/CD パイプライン
- [ ] **ブルーグリーン**: ダウンタイムなしデプロイ
- [ ] **ロールバック**: 問題発生時の迅速な復旧
- [ ] **環境管理**: 開発・ステージング・本番環境の分離

#### 要件判定のガイドライン

**🎯 優先度判定基準**:
```
Must Have: システムの核心価値、これがないと意味がない
Should Have: 品質・体験向上、競合優位性に寄与  
Could Have: あると便利、将来的に追加検討
Won't Have: 現時点では不要、明確に除外
```

**📊 影響度評価**:
```
High: 多数のユーザー・ペルソナに影響
Medium: 特定のユーザー・シナリオに重要
Low: 限定的なケースでのみ重要
```

### Stage 5: 構造化User Story生成 📝

全要件を「As a [persona], I want [capability], So that [value]」形式で整理します：

#### 📋 User Story作成フレームワーク

**基本テンプレート**：
```
As a [具体的なペルソナ]
I want [明確な機能・能力]  
So that [実現される価値・利益]

Given [前提条件]
When [操作・イベント]  
Then [期待される結果]
And [追加条件・制約]
```

**優れたUser Storyの条件（INVEST原則）**：
- **Independent**: 他のストーリーから独立している
- **Negotiable**: 詳細は交渉・調整可能
- **Valuable**: ユーザーに明確な価値をもたらす  
- **Estimable**: 工数見積もりが可能
- **Small**: 1イテレーションで完了できるサイズ
- **Testable**: テストで検証可能

#### 📱 エンドユーザー向けストーリー詳細

**🎯 機能要件ストーリー（直接操作）**:

*ゲーム系例*:
```
As a puzzle game enthusiast  
I want to play Tetris with official 7-piece system
So that I can enjoy authentic competitive gameplay

Acceptance Criteria:
Given I open the game in browser
When I start a new game
Then I should see standard 10x20 playing field
And all 7 tetromino pieces (I,O,T,S,Z,J,L) should appear
And pieces should follow SRS rotation rules
And line clearing should work according to official rules

Priority: Must Have
Size: 5 points
```

*ビジネス系例*:
```
As a project manager
I want to create and assign tasks to team members
So that I can distribute work efficiently and track progress

Acceptance Criteria:
Given I'm logged in to the system
When I create a new task
Then I should be able to set title, description, due date, and assignee
And the assigned team member should receive a notification
And the task should appear in both my dashboard and assignee's dashboard
And I should be able to track completion status

Priority: Must Have  
Size: 3 points
```

**✨ 体験要件ストーリー（UI/UX・品質）**:

*パフォーマンス例*:
```
As a mobile user on slow internet
I want the app to load quickly and work smoothly
So that I can use it even with poor connectivity

Acceptance Criteria:
Given I have a 3G connection
When I open the application
Then initial page should load within 3 seconds
And core functions should be available within 5 seconds
And the app should cache essential data for offline use
And loading states should provide clear feedback

Priority: Should Have
Size: 2 points  
```

*アクセシビリティ例*:
```
As a visually impaired user
I want to navigate the app using screen readers
So that I can access all functionality independently

Acceptance Criteria:
Given I'm using a screen reader (NVDA/JAWS/VoiceOver)
When I navigate through the application
Then all interactive elements should have proper labels
And navigation should follow logical tab order  
And important information should be announced clearly
And keyboard shortcuts should be available for main actions

Priority: Should Have
Size: 3 points
```

#### 🔧 開発者向けストーリー詳細

**🧪 品質要件ストーリー**:
```
As a developer
I want comprehensive test coverage for core game logic  
So that I can refactor code safely and prevent regressions

Acceptance Criteria:
Given the core game logic is implemented
When I run the test suite
Then unit test coverage should be at least 80%
And all critical game mechanics should have integration tests
And E2E tests should cover main user journeys
And tests should run in CI/CD pipeline automatically

Priority: Must Have
Size: 3 points
```

**🔧 保守性要件ストーリー**:
```
As a future maintainer
I want clean, well-documented code architecture
So that I can understand and modify the system efficiently  

Acceptance Criteria:
Given the codebase is complete
When a new developer joins the team
Then they should be able to run the system locally within 30 minutes
And key architectural decisions should be documented
And code should follow consistent style guidelines
And each module should have clear responsibilities

Priority: Should Have
Size: 2 points
```

#### 💼 ビジネス・利害関係者向けストーリー

**💰 価値要件ストーリー**:
```
As a product owner
I want usage analytics and performance metrics
So that I can make data-driven decisions about features

Acceptance Criteria:
Given users are actively using the system
When I check the analytics dashboard
Then I should see user engagement metrics (DAU, session time)
And feature usage statistics should be tracked
And performance metrics (load time, error rate) should be visible
And data should be updated in real-time

Priority: Should Have  
Size: 3 points
```

**🔒 リスク要件ストーリー**:
```
As a compliance officer
I want user data to be protected according to GDPR
So that we avoid legal issues and maintain user trust

Acceptance Criteria:  
Given users provide personal information
When data is collected, stored, or processed
Then explicit consent should be obtained
And users should be able to view, edit, and delete their data
And data should be encrypted in transit and at rest
And breach notification procedures should be in place

Priority: Must Have
Size: 4 points
```

#### 🎯 ストーリー整理・優先度設定フレームワーク

**カテゴリ別整理**:
```
📱 User Experience Stories
├── [Must] Core functionality - immediate user value
├── [Should] Quality improvements - competitive advantage  
└── [Could] Convenience features - nice to have

🔧 Developer Experience Stories  
├── [Must] Essential tooling - development efficiency
├── [Should] Quality gates - long-term sustainability
└── [Could] Advanced tooling - optimization

💼 Business Value Stories
├── [Must] Revenue/growth drivers - business critical
├── [Should] Analytics/insights - decision support
└── [Could] Advanced features - future expansion
```

**優先度決定マトリクス**:
```
         High Impact    Low Impact
High Effort    Should      Could
Low Effort      Must      Should

Must Have: High impact, low effort OR business critical
Should Have: High impact, high effort OR competitive advantage  
Could Have: Low impact OR future enhancement
Won't Have: Low impact, high effort OR out of scope
```

**サイジングガイドライン**:
```
1 Point: Simple config/UI change (half day)
2 Points: Small feature addition (1 day)  
3 Points: Medium feature with testing (2-3 days)
5 Points: Complex feature or integration (1 week)
8 Points: Major feature/architecture change (2 weeks)
```

#### 受け入れ条件作成ガイド

**❌ 悪い例（曖昧・検証困難）**:
```
Then the system should work well
And users should be satisfied  
And performance should be good
```

**✅ 良い例（具体的・測定可能）**:
```
Then login should complete within 2 seconds
And success rate should be >99% for valid credentials
And error messages should clearly explain failures
And invalid attempts should be logged for security
```

**受け入れ条件チェックリスト**:
- [ ] 測定可能な基準が含まれている
- [ ] 成功・失敗のケースが明確
- [ ] 異常系・エラー処理が考慮されている
- [ ] セキュリティ・パフォーマンス要件が含まれている
- [ ] 実装者がテスト方法をイメージできる

---

## 実行プロセス

### 基本環境の確認
- 現在時刻: !date +"%Y-%m-%dT%H:%M:%S%:z"
- イテレーションID: !date +%s  
- Git状態: !git status --short
- プロジェクト構造: !test -d docs/cc-xp || mkdir -p docs/cc-xp

### 要求分析の実行

ユーザー要求「$ARGUMENTS」について、5段階分析を順次実行してください：

#### Step 1: 真の目的分析の実行

**質問**：
1. この要求の背景にある現状の不満は何ですか？
2. ユーザーが本当に解決したい根本問題は何ですか？
3. 成功したとき、ユーザーはどのような価値を感じますか？

**分析結果を記録**：
```bash
echo "=== Stage 1: 真の目的分析 ===" > analysis_report.tmp
echo "要求: $ARGUMENTS" >> analysis_report.tmp
echo "分析日時: $(date)" >> analysis_report.tmp
echo "" >> analysis_report.tmp
```

#### Step 2: ペルソナ想定の実行  

**主要ペルソナの特定**：
- **エンドユーザー**: 誰がこのソフトウェアを直接使うか？
- **開発者**: 誰がこのコードを書く・保守するか？
- **利害関係者**: 誰がこの成果に関心を持つか？

各ペルソナの動機・制約・期待値を具体化してください。

#### Step 3: 達成目標の分解実行

各ペルソナについて：
- **機能的ゴール**: 何ができるようになりたいか
- **感情的ゴール**: どう感じたいか  
- **制約条件**: 何に制限されているか

#### Step 4: 要件の網羅的抽出実行

上記チェックリストを使用して：
- ✅ 機能要件: コア機能、データ管理等
- ✅ 非機能要件: UI/UX、パフォーマンス、セキュリティ等
- ✅ 開発者要件: テスト、保守性、拡張性等

見落としがちな要件も含めて洗い出してください。

#### Step 5: User Story生成の実行

全要件を以下形式で整理：

```markdown
## エンドユーザー向けストーリー

### Must Have (核心価値)
As a [specific persona]
I want [concrete capability]  
So that [clear value]

### Should Have (品質向上)
As a [specific persona]
I want [concrete capability]
So that [clear value]

## 開発者向けストーリー

### 品質・保守性
As a developer
I want [development capability]
So that [development value]

## 利害関係者向けストーリー

### ビジネス価値  
As a [business persona]
I want [business capability]
So that [business value]
```

---

## backlog.yaml生成

分析結果を基にbacklog.yamlを生成：

```bash
mkdir -p docs/cc-xp
cat > docs/cc-xp/backlog.yaml << 'EOF'
# イテレーションメタデータ  
iteration:
  id: $(date +%s)
  created_at: $(date +"%Y-%m-%dT%H:%M:%S%:z")
  user_request: "$ARGUMENTS"
  analysis_completed: true

# 生成されたストーリー
stories: []
EOF
```

各ストーリーをbacklogに追加し、優先度・サイズ・価値を設定してください。

---

## 完了確認

分析完了後、以下を表示してください：

```
🎯 包括的要求分析完了
========================
ユーザー要求: "$ARGUMENTS"
生成ストーリー数: [X]個
- Must Have: [X]個  
- Should Have: [X]個
- Could Have: [X]個

📋 要件カバレッジ
- ✅ 機能要件: [X]個
- ✅ 非機能要件: [X]個  
- ✅ 開発者要件: [X]個

👥 対象ペルソナ
- エンドユーザー: [personas]
- 開発者: [personas]  
- 利害関係者: [personas]

🚀 次のステップ
===============
ストーリー詳細化を開始:
→ /cc-xp:story
```
