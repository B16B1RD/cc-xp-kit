#!/usr/bin/env node

// Kent Beck TDD戦略判定ヘルパー
// Usage: node kent-beck-strategy.js [function-description]

const readline = require('readline');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

function analyzeComplexity(description) {
  const complexKeywords = [
    'アルゴリズム', '計算', '判定', '変換', '解析', '処理',
    'システム', '管理', '制御', '連携', '統合', '調整'
  ];
  
  const simpleKeywords = [
    '表示', '取得', '設定', '保存', '読み込', '削除',
    '追加', '更新', '確認', '初期化', '終了'
  ];
  
  const obviousKeywords = [
    '足す', '引く', '掛ける', '割る', '比較', '等しい',
    '大きい', '小さい', '長さ', 'サイズ', '数'
  ];
  
  const lowerDesc = description.toLowerCase();
  
  const complexScore = complexKeywords.filter(keyword => 
    lowerDesc.includes(keyword)).length;
  const simpleScore = simpleKeywords.filter(keyword => 
    lowerDesc.includes(keyword)).length;
  const obviousScore = obviousKeywords.filter(keyword => 
    lowerDesc.includes(keyword)).length;
  
  return { complexScore, simpleScore, obviousScore };
}

function recommendStrategy(description, isFirstImplementation = true, hasExistingTests = false) {
  const complexity = analyzeComplexity(description);
  
  // Obvious Implementation の判定
  if (complexity.obviousScore > 0 && description.length < 50) {
    return {
      strategy: 'Obvious Implementation',
      confidence: 'high',
      reason: '数学的に自明で短い処理のため',
      example: `function ${extractFunctionName(description)}(x) {\n  return x * x; // 1行で完結\n}`,
      nextStep: '実装後、すぐに次のテストに進む'
    };
  }
  
  // Triangulation の判定
  if (!isFirstImplementation && hasExistingTests) {
    return {
      strategy: 'Triangulation',
      confidence: 'high', 
      reason: '既存のテストがあり、パターンが見えてきたため',
      example: `// 2つ目のテストでハードコードを破る\nit('should handle different input', () => {\n  expect(${extractFunctionName(description)}(differentInput)).toBe(expectedResult);\n});`,
      nextStep: '一般化された実装を書く'
    };
  }
  
  // Fake It の判定（デフォルト、60%以上で使用）
  if (complexity.complexScore > 0 || isFirstImplementation) {
    return {
      strategy: 'Fake It',
      confidence: 'high',
      reason: '実装方法が不明確または最初の実装のため',
      example: `function ${extractFunctionName(description)}() {\n  return "固定値"; // 完全にハードコード\n}`,
      nextStep: 'テストを通してから、2つ目のテストで一般化'
    };
  }
  
  // フォールバック
  return {
    strategy: 'Fake It',
    confidence: 'medium',
    reason: '不明確な場合はFake It戦略を推奨',
    example: `function ${extractFunctionName(description)}() {\n  return null; // 最小限の実装\n}`,
    nextStep: 'まずテストを通してから考える'
  };
}

function extractFunctionName(description) {
  // 簡単な関数名抽出（改善の余地あり）
  const words = description.split(/\s+/);
  if (words.length > 0) {
    return words[0].toLowerCase().replace(/[^a-zA-Z0-9]/g, '') || 'doSomething';
  }
  return 'doSomething';
}

function generateTestTemplate(strategy, description) {
  const funcName = extractFunctionName(description);
  
  if (strategy === 'Fake It') {
    return `
// Step 1: 失敗するテスト (Red)
it('should ${description.toLowerCase()}', () => {
  const result = ${funcName}();
  expect(result).toBe("期待値"); // 具体的な期待値を設定
});

// Step 2: Fake It実装 (Green)
function ${funcName}() {
  return "期待値"; // 完全にハードコード
}

// Step 3: 2つ目のテストで一般化へ
it('should handle different case', () => {
  const result = ${funcName}("別の入力");
  expect(result).toBe("別の期待値");
});`;
  } else if (strategy === 'Triangulation') {
    return `
// 既存のテストに追加
it('should ${description.toLowerCase()} for edge case', () => {
  const result = ${funcName}("エッジケース");
  expect(result).toBe("エッジケース期待値");
});

// 一般化された実装
function ${funcName}(input) {
  // パターンが見えたので一般化
  return processInput(input);
}`;
  } else {
    return `
// Obvious Implementation
it('should ${description.toLowerCase()}', () => {
  const result = ${funcName}(input);
  expect(result).toBe(expectedOutput);
});

function ${funcName}(input) {
  return obviousCalculation(input); // 自明な実装
}`;
  }
}

async function interactiveMode() {
  console.log('🎯 Kent Beck TDD戦略判定ツール');
  console.log('=====================================\n');
  
  try {
    const description = await question('実装したい機能を説明してください: ');
    const isFirst = await question('これは最初の実装ですか？ (y/n): ');
    const hasTests = await question('既存のテストがありますか？ (y/n): ');
    
    const recommendation = recommendStrategy(
      description,
      isFirst.toLowerCase() === 'y',
      hasTests.toLowerCase() === 'y'
    );
    
    console.log('\n📋 推奨戦略レポート');
    console.log('=====================');
    console.log(`🎯 推奨戦略: ${recommendation.strategy}`);
    console.log(`🎪 信頼度: ${recommendation.confidence}`);
    console.log(`💡 理由: ${recommendation.reason}`);
    console.log('\n📝 実装例:');
    console.log(recommendation.example);
    console.log(`\n⏭️  次のステップ: ${recommendation.nextStep}`);
    
    const needTemplate = await question('\nテストテンプレートを生成しますか？ (y/n): ');
    if (needTemplate.toLowerCase() === 'y') {
      const template = generateTestTemplate(recommendation.strategy, description);
      console.log('\n📄 テストテンプレート:');
      console.log(template);
    }
    
  } catch (error) {
    console.log('\n👋 終了します');
  }
  
  rl.close();
}

function question(prompt) {
  return new Promise((resolve) => {
    rl.question(prompt, resolve);
  });
}

function commandLineMode() {
  const description = process.argv[2];
  if (!description) {
    console.log('使用法: node kent-beck-strategy.js "実装したい機能の説明"');
    process.exit(1);
  }
  
  const recommendation = recommendStrategy(description);
  console.log(`推奨戦略: ${recommendation.strategy}`);
  console.log(`理由: ${recommendation.reason}`);
  console.log('実装例:');
  console.log(recommendation.example);
}

// メイン実行
if (require.main === module) {
  if (process.argv.length > 2) {
    commandLineMode();
  } else {
    interactiveMode();
  }
}

module.exports = { recommendStrategy, analyzeComplexity, generateTestTemplate };