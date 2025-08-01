#!/usr/bin/env node

// 受け入れ基準をテストケースに自動変換するヘルパー
// Usage: node acceptance-to-test.js [user-stories-file-path]

const fs = require('fs');
const path = require('path');

function parseAcceptanceCriteria(content) {
  const criteriaPattern = /GIVEN\s+(.+?)\s+WHEN\s+(.+?)\s+THEN\s+(.+?)(?=\n|$)/g;
  const criteria = [];
  let match;
  
  while ((match = criteriaPattern.exec(content)) !== null) {
    criteria.push({
      given: match[1].trim(),
      when: match[2].trim(),
      then: match[3].trim()
    });
  }
  
  return criteria;
}

function generateTestCode(criteria, projectType = 'game') {
  const tests = criteria.map((criterion, index) => {
    const testName = `should ${criterion.then.toLowerCase()} when ${criterion.when.toLowerCase()}`;
    
    if (projectType === 'game') {
      return `
  it('${testName}', () => {
    // Arrange: ${criterion.given}
    const canvas = document.createElement('canvas');
    const game = new TetrisGame(canvas);
    
    // Act: ${criterion.when}
    // TODO: 実装 - ${criterion.when}
    
    // Assert: ${criterion.then}
    // TODO: 検証 - ${criterion.then}
    expect(true).toBe(true); // Fake It: 最初はハードコード
  });`;
    } else if (projectType === 'web') {
      return `
  it('${testName}', () => {
    // Arrange: ${criterion.given}
    // TODO: セットアップ - ${criterion.given}
    
    // Act: ${criterion.when}
    // TODO: 実装 - ${criterion.when}
    
    // Assert: ${criterion.then}
    // TODO: 検証 - ${criterion.then}
    expect(true).toBe(true); // Fake It: 最初はハードコード
  });`;
    } else {
      return `
  it('${testName}', () => {
    // Arrange: ${criterion.given}
    // Act: ${criterion.when}
    // Assert: ${criterion.then}
    expect(true).toBe(true); // Fake It: 最初はハードコード
  });`;
    }
  });
  
  return `describe('Acceptance Criteria Tests', () => {${tests.join('\n')}
});`;
}

function detectProjectType(content) {
  const gameKeywords = ['ゲーム', 'テトリス', 'canvas', 'ピース', 'プレイ'];
  const webKeywords = ['ウェブ', 'サイト', 'ページ', 'フォーム', 'ログイン'];
  const apiKeywords = ['API', 'エンドポイント', 'レスポンス', 'リクエスト'];
  
  const lowerContent = content.toLowerCase();
  
  if (gameKeywords.some(keyword => lowerContent.includes(keyword.toLowerCase()))) {
    return 'game';
  } else if (webKeywords.some(keyword => lowerContent.includes(keyword.toLowerCase()))) {
    return 'web';
  } else if (apiKeywords.some(keyword => lowerContent.includes(keyword.toLowerCase()))) {
    return 'api';
  }
  
  return 'generic';
}

function main() {
  const userStoriesPath = process.argv[2] || 'docs/agile-artifacts/stories/user-stories-v1.0.md';
  
  if (!fs.existsSync(userStoriesPath)) {
    console.error(`❌ エラー: user-storiesファイルが見つかりません: ${userStoriesPath}`);
    console.log('使用法: node acceptance-to-test.js [user-stories-file-path]');
    process.exit(1);
  }
  
  console.log('🔄 受け入れ基準をテストケースに変換中...');
  
  const content = fs.readFileSync(userStoriesPath, 'utf8');
  const criteria = parseAcceptanceCriteria(content);
  
  if (criteria.length === 0) {
    console.log('⚠️  受け入れ基準が見つかりませんでした。');
    console.log('GIVEN-WHEN-THEN形式で記述されているか確認してください。');
    process.exit(0);
  }
  
  const projectType = detectProjectType(content);
  const testCode = generateTestCode(criteria, projectType);
  
  // テストファイルのパス決定
  const testDir = 'tests';
  if (!fs.existsSync(testDir)) {
    fs.mkdirSync(testDir, { recursive: true });
  }
  
  const testFilePath = path.join(testDir, 'acceptance.test.js');
  
  // 既存テストファイルがある場合はバックアップ
  if (fs.existsSync(testFilePath)) {
    const backupPath = `${testFilePath}.backup.${Date.now()}`;
    fs.copyFileSync(testFilePath, backupPath);
    console.log(`📄 既存テストファイルをバックアップ: ${backupPath}`);
  }
  
  fs.writeFileSync(testFilePath, testCode);
  
  console.log('✅ テストケース変換完了！');
  console.log(`📍 出力ファイル: ${testFilePath}`);
  console.log(`🎯 プロジェクトタイプ: ${projectType}`);
  console.log(`📊 変換された受け入れ基準数: ${criteria.length}`);
  console.log();
  console.log('🚀 次のステップ:');
  console.log('1. テストを実行して失敗することを確認:');
  console.log('   bun test');
  console.log('2. Fake It戦略で最小実装を開始');
  console.log('3. Red-Green-Refactorサイクルを継続');
}

if (require.main === module) {
  main();
}

module.exports = { parseAcceptanceCriteria, generateTestCode, detectProjectType };