---
description: "5分で動くプロトタイプを作成 - MVPファースト超高速開発"
argument-hint: "作りたいものを説明してください（例: テトリスゲーム）"
allowed-tools: ["Write", "Read", "LS", "Bash"]
---

# 5分MVP超高速プロトタイプ

要望: $ARGUMENTS

## 🚀 指示: 5分で動くものを作る

**Kent Beck "Make it work" 原則**に基づき、以下を実行してください：

### 1. 要望から最小限の動作を即座に定義（30秒）

**要望を分析**して、**30秒で判断できる最小限の動作**を決定してください：

- **テトリス** → 色付き正方形1つを画面表示
- **計算機** → "2+2=4" を画面表示
- **チャット** → "Hello World" メッセージ表示
- **API** → `{"status": "working"}` レスポンス
- **ブログ** → 1つの記事タイトル表示
- **ゲーム** → キャラクター1つの表示
- **ツール** → 基本コマンド1つの実行

### 2. 技術スタック即座判定（30秒）

要望から最適な技術を**30秒で決定**：

**Web系（画面表示必要）**:
```bash
# 最速: 1つのHTMLファイル
echo '<!DOCTYPE html><html><body><h1>動いた！</h1></body></html>' > index.html
```

**CLI系（コマンド実行）**:
```bash
# Node.js
echo 'console.log("Hello World!")' > main.js
# または Python
echo 'print("Hello World!")' > main.py
```

**API系（データ返却）**:
```bash
# 最小Express
echo 'const http=require("http");http.createServer((req,res)=>res.end("Working!")).listen(3000)' > server.js
```

### 3. 3分実装（恥ずかしいハードコーディング）

**Fake It戦略**で恥ずかしいくらいシンプルに実装：

```javascript
// 例: テトリスの場合
document.body.innerHTML = '<div style="width:20px;height:20px;background:red;margin:100px"></div>';
```

```python
# 例: 計算機の場合
print("2 + 2 = 4")  # 最初は固定値でOK
```

**重要**: 完璧さは後回し、動作を最優先

### 4. 1分動作確認

**作成したものを即座に確認**：

- **HTML** → ブラウザで直接開く
- **Node.js** → `node main.js`
- **Python** → `python main.py`
- **API** → `node server.js` → `curl localhost:3000`

### 5. 30秒で次の価値を決定

**現在動いているもの**を見て、次に追加したい価値を決定：

- テトリス：正方形 → 次：左右移動
- 計算機：固定計算 → 次：ボタン入力
- チャット：固定メッセージ → 次：入力欄

## 🎯 5分Spike段階完了確認

```text
🎉 5分Spike達成チェック (Kent Beck探索原則)
==========================================

✅ 何かが動作している（技術的可能性確認）
✅ 目に見える結果がある（学習成果確認）
✅ ユーザーが「おお！」と思える（体験価値確認）
✅ 次の15分で何を追加するか決まっている

🔍 **Spike段階の判断基準**:
「動作確認できた → 次の価値へ」
⚠️ バグや細かい問題は気にしない（探索が目的）

🚀 継続開発オプション:

1. 【推奨】MVP段階へ → /tdd:plan micro
   15分で仮説検証とバグ修正を行う
   
2. 正式ストーリー作成 → /tdd:story [要望]
   3段階開発モデルで計画的に進める
   
3. 初期化してから → /tdd:init
   TDD環境をしっかり整える
   
4. 満足したら終了 → お疲れ様でした！
   Spikeレベルで十分な場合

💡 **次の段階での変化**:
- MVP段階（15分）: バグ修正が重要になります
- Product段階（30分）: 品質確保が必須になります
```

## 🚨 MVPファースト原則

- **30秒判断**: 技術選択に悩まない
- **3分実装**: 完璧を求めない
- **恥ずかしいコード**: Fake Itを恐れない
- **動作最優先**: 構造は後回し
- **即座確認**: 動かない時間を作らない

**Kent Beck格言**: "Make it work, make it right, make it fast"
→ まず動かす、後で正しくする、最後に速くする