#!/usr/bin/env node

// ストーリー自動修正ツール - MVP検証ゲート連携
// Usage: node story-auto-fix.js [stories-file] [fix-config.json]

const fs = require('fs');
const path = require('path');

class StoryAutoFixer {
    constructor(storiesFilePath) {
        this.storiesFilePath = storiesFilePath;
        this.backupPath = `${storiesFilePath}.backup.${Date.now()}`;
    }

    // バックアップ作成
    createBackup() {
        if (fs.existsSync(this.storiesFilePath)) {
            fs.copyFileSync(this.storiesFilePath, this.backupPath);
            console.log(`📄 バックアップ作成: ${this.backupPath}`);
        }
    }

    // MVP検証失敗からの自動修正
    async applyMVPFixes(fixes) {
        console.log('🔧 MVP検証失敗の自動修正実行中...');
        
        let content = fs.readFileSync(this.storiesFilePath, 'utf8');
        
        // Story 1の修正
        if (fixes.story1) {
            content = this.fixStory1(content, fixes.story1);
        }
        
        // 受け入れ基準の追加
        if (fixes.acceptanceCriteria) {
            content = this.addAcceptanceCriteria(content, fixes.acceptanceCriteria);
        }
        
        // 実装順序の修正
        if (fixes.implementationOrder) {
            content = this.updateImplementationOrder(content, fixes.implementationOrder);
        }
        
        // ファイル更新
        fs.writeFileSync(this.storiesFilePath, content);
        console.log('✅ ストーリーファイル自動修正完了');
        
        return true;
    }

    // Story 1の内容修正
    fixStory1(content, fixes) {
        // 機能リストの追加（重複防止付き）
        if (fixes.missingFeatures) {
            // 既に追加済みかチェック
            if (content.includes('**⚡ 追加された必須機能:**')) {
                console.log('🔍 必須機能は既に追加済みです - スキップ');
                return content;
            }
            
            const story1Section = this.extractStory1Section(content);
            let newFeatures = fixes.missingFeatures.map(feature => `  - ${feature}`).join('\n');
            
            // 機能リストに追加
            const featureListRegex = /(### 📋 実装機能一覧[\s\S]*?)(### |##)/;
            content = content.replace(featureListRegex, (match, p1, p2) => {
                return p1 + '\n**⚡ 追加された必須機能:**\n' + newFeatures + '\n\n' + p2;
            });
            
            console.log('✅ 必須機能を追加しました');
        }
        
        return content;
    }

    // 受け入れ基準の追加（重複防止付き）
    addAcceptanceCriteria(content, newCriteria) {
        // 既に追加済みの基準をチェック
        const hasExisting = newCriteria.some(criteria => 
            content.includes(criteria.given) || content.includes('5分間プレイ')
        );
        
        if (hasExisting) {
            console.log('🔍 受け入れ基準は既に追加済みです - スキップ');
            return content;
        }
        
        // Story 1の受け入れ基準セクションを見つける
        const criteriaRegex = /(### 🎯 受け入れ基準[\s\S]*?)(### |##)/;
        
        content = content.replace(criteriaRegex, (match, p1, p2) => {
            let criteriaSection = p1;
            
            criteriaSection += '\n'; // 区切り用の改行
            newCriteria.forEach(criteria => {
                criteriaSection += `- [ ] ${criteria.given} WHEN ${criteria.when} THEN ${criteria.then}\n`;
            });
            
            return criteriaSection + '\n' + p2;
        });
        
        console.log('✅ 受け入れ基準を追加しました');
        return content;
    }

    // 実装順序の更新（重複防止付き）
    updateImplementationOrder(content, newOrder) {
        // 既に修正済みかチェック
        if (content.includes('**修正された実装順序:**')) {
            console.log('🔍 実装順序は既に修正済みです - スキップ');
            return content;
        }
        
        const orderRegex = /(### 🚀 実装順序[\s\S]*?)(### |##)/;
        
        content = content.replace(orderRegex, (match, p1, p2) => {
            let orderSection = '### 🚀 実装順序\n\n**修正された実装順序:**\n';
            
            newOrder.forEach((step, index) => {
                orderSection += `${index + 1}. ${step}\n`;
            });
            
            return orderSection + '\n' + p2;
        });
        
        console.log('✅ 実装順序を修正しました');
        return content;
    }

    // Story 1セクションの抽出
    extractStory1Section(content) {
        const story1Regex = /## Story 1:[\s\S]*?(?=## Story 2:|$)/;
        const match = content.match(story1Regex);
        return match ? match[0] : '';
    }

    // 検証状態の更新（重複防止付き）
    updateValidationStatus(status, notes = '') {
        let content = fs.readFileSync(this.storiesFilePath, 'utf8');
        
        const timestamp = new Date().toISOString().split('T')[0];
        
        // 同日の検証状況が既に存在するかチェック
        if (content.includes(`## 🔍 MVP検証状況 - ${timestamp}`)) {
            console.log(`🔍 ${timestamp}の検証状況は既に記録済みです - スキップ`);
            return;
        }
        
        const statusSection = `\n## 🔍 MVP検証状況 - ${timestamp}\n` +
                             `**状態**: ${status}\n` +
                             (notes ? `**メモ**: ${notes}\n` : '') +
                             '\n---\n';
        
        // ファイル末尾に追加
        content = content + statusSection;
        
        fs.writeFileSync(this.storiesFilePath, content);
        console.log(`📊 検証状況更新: ${status}`);
    }

    // 標準的なMVP修正設定の生成
    static generateStandardMVPFixes() {
        return {
            story1: {
                missingFeatures: [
                    'ハードドロップ機能（スペースキー）',
                    '7-bag randomizer（公平な出現システム）', 
                    'レベル・速度システム（段階的難易度上昇）',
                    'SRS回転システム（現代標準）'
                ]
            },
            acceptanceCriteria: [
                {
                    given: 'GIVEN 5分間プレイ',
                    when: 'WHEN 集中してプレイ',
                    then: 'THEN 適度な緊張感と達成感が得られる'
                },
                {
                    given: 'GIVEN ハードドロップ使用',
                    when: 'WHEN スペース押下',
                    then: 'THEN 瞬間的にピース配置できる'
                },
                {
                    given: 'GIVEN レベル上昇',
                    when: 'WHEN 時間経過',
                    then: 'THEN 落下速度が段階的に上昇する'
                }
            ],
            implementationOrder: [
                '基本移動・回転システム',
                'ハードドロップ機能',
                'レベル・速度システム',
                'ライン消去システム',
                '7-bag randomizer',
                'SRS回転システム'
            ]
        };
    }
}

// ファイル検索ヘルパー
function findStoriesFile() {
    const possiblePaths = [
        'docs/agile-artifacts/stories/user-stories-v1.0.md',
        'docs/agile-artifacts/stories/user-stories.md',
        '.claude/agile-artifacts/stories/user-stories-v1.0.md',
        '.claude/agile-artifacts/stories/user-stories.md'
    ];
    
    for (const filePath of possiblePaths) {
        if (fs.existsSync(filePath)) {
            return path.resolve(filePath);
        }
    }
    
    throw new Error('ユーザーストーリーファイルが見つかりません');
}

// メイン実行
async function main() {
    try {
        const storiesFile = process.argv[2] || findStoriesFile();
        const configFile = process.argv[3];
        
        console.log('🔧 ストーリー自動修正ツール');
        console.log('===============================');
        console.log(`📄 対象ファイル: ${storiesFile}`);
        
        const fixer = new StoryAutoFixer(storiesFile);
        fixer.createBackup();
        
        // 設定読み込み
        let fixes;
        if (configFile && fs.existsSync(configFile)) {
            fixes = JSON.parse(fs.readFileSync(configFile, 'utf8'));
            console.log(`📝 修正設定読み込み: ${configFile}`);
        } else {
            fixes = StoryAutoFixer.generateStandardMVPFixes();
            console.log('📝 標準MVP修正設定を使用');
        }
        
        // 修正実行
        await fixer.applyMVPFixes(fixes);
        fixer.updateValidationStatus('修正済み - 再検証待ち', 'MVP検証失敗の自動修正完了');
        
        console.log('\n🎯 次のステップ:');
        console.log('1. 修正内容の確認');
        console.log('2. Phase 3.6 MVP検証の再実行');
        console.log('3. 合格後Phase 4への自動進行');
        
    } catch (error) {
        console.error('❌ エラー:', error.message);
        process.exit(1);
    }
}

// モジュールまたは直接実行
if (require.main === module) {
    main();
}

module.exports = { StoryAutoFixer };