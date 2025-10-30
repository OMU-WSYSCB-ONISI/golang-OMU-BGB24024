#!/bin/bash
# GitHub Classroom用：週次課題ディレクトリ一括作成スクリプト
# 使用方法: bash create-weekly-structure.sh

set -e

echo "📁 週次課題ディレクトリ構造を作成します（week01～week15）"
echo "================================================"

# 週数の定義
TOTAL_WEEKS=15

# 各週のディレクトリとファイルを作成
for week in $(seq -f "%02g" 1 $TOTAL_WEEKS); do
    WEEK_DIR="week${week}"
    
    echo "作成中: ${WEEK_DIR}/"
    
    # ディレクトリ作成
    mkdir -p "${WEEK_DIR}"
    
    # README.md作成
    cat > "${WEEK_DIR}/README.md" << EOF
# Week ${week}: [学習テーマ]

## 🚀 Codespaceの起動

### 初回起動（初めて課題に取り組む時）
1. GitHubリポジトリページで「**Code**」ボタン（緑色）をクリック
2. 「**Codespaces**」タブを選択
3. 「**Create codespace on main**」をクリック
4. 環境構築に1-2分待つ
5. VS Codeのような画面が表示されたら作業開始

### 2回目以降（既にCodespaceがある場合）
1. GitHubリポジトリページで「**Code**」ボタンをクリック
2. 「**Codespaces**」タブで既存のCodespace名を確認
3. Codespace名をクリックして「**Open in browser**」を選択
4. 約3秒で起動

⚠️ **重要**: 複数のCodespaceを作成しないでください。1つを学期を通じて使用します。

---

## 📚 この週の学習テーマ

（学習テーマの概要を1-2行で記載）

**詳細な課題内容・要件・締切はLMSで確認してください。**

---

## 🔧 プログラムの実行

### 基本的な実行方法

1. \`main.go\`ファイルを開く
2. 画面右上の「**▶ Run Code**」ボタンをクリック
3. 画面下部のターミナルに結果が表示される

**または**:
- ファイル上で右クリック → 「**Run Code**」を選択

### プレビューの表示（Webサーバー課題のみ）

**注意**: LMSの課題内容で「Webサーバー」「HTTP」「ブラウザで確認」などの指示がある場合のみ実施してください。

1. プログラムを実行（上記の方法）
2. \`Ctrl+Shift+P\`（Mac: \`Cmd+Shift+P\`）でコマンドパレット
3. 「**simple browser**」と入力
4. 「**Simple Browser: Show**」を選択  
5. \`http://localhost:8080\` と入力してEnter
6. 右側にブラウザ画面が表示される

\`\`\`
┌─────────────────┬─────────────────┐
│ main.go (編集)   │ プレビュー       │
│                 │ (表示)           │
└─────────────────┴─────────────────┘
\`\`\`

### コード変更後の確認

1. ファイルを保存（\`Ctrl+S\` / \`Cmd+S\`）
2. 「▶ Run Code」ボタンをクリック
3. ブラウザ画面で右クリック → 「Reload」を選択

---

## 📤 提出方法（Git操作不要）

### 簡単3ステップで提出完了

1. Codespacesで画面左下の「≡」メニューをクリック
2. 「Codespaces」→「**Export changes to a branch**」を選択
3. 「**Create branch**」をクリック
4. 表示されたブランチ名をコピー
5. LMSの提出ボックスにブランチ名を入力して提出

### ブランチ名の例

\`\`\`
codespace-symmetrical-guacamole-q74vxx47qp92x7wv
\`\`\`

### 再提出する場合

1. \`main.go\`を修正
2. 再度「Export changes to a branch」を実行
3. 新しいブランチ名をLMSで報告

---

## ⚠️ 超重要：作業終了後はCodespaceを停止

**必ず停止してください！停止しないと課金され続けます。**

### 停止手順（約10秒）

1. GitHubのリポジトリページを開く
2. 「Code」→「Codespaces」タブ
3. 実行中のCodespaceの右側「...」メニュー
4. 「**Stop codespace**」を選択
5. ステータスが「Stopped」になれば完了 ✅

### 停止のタイミング

- ✅ **課題提出後（すぐに停止）**
- ✅ 30分以上離席する時
- ✅ その日の作業を終える時
- ✅ 他の授業に移る時
- ✅ PCをシャットダウンする前

### なぜ停止が重要？

\`\`\`
無料枠: 月180コア時間（2コアで90時間/月）

停止を忘れると:
24時間放置 = 48コア時間消費
→ 2日で無料枠の半分以上を使用

停止を習慣化すれば:
週3-4時間の使用 = 月12-16時間
→ 無料枠内で十分
\`\`\`

詳細は **CODESPACE_STOP_GUIDE.md** を参照してください。

---

## 💡 ヒント

- コードのフォーマット: ファイル保存時に自動実行
- 文法チェック: 問題があればエディタに赤線が表示されます
- 過去の週のコードを参考にできます
- 分からないことがあれば、LMSの質問フォーラムで質問してください

---

## ⚠️ 注意事項

- ✅ 詳細な要件は必ずLMSで確認してください
- ✅ 締切はLMSで確認してください
- ✅ ブランチ名の報告を忘れずに！
- ✅ プログラム実行は「▶ Run Code」ボタンを使用
- ⚠️ **作業終了後は必ずCodespaceを停止**

---

## 📁 ファイル構成

- \`main.go\` - メインプログラムファイル（編集対象）
- \`README.md\` - このファイル（概要のみ）

---

**詳細な課題内容・締切・評価基準はLMSで確認してください。**
EOF
    
    echo "  ✅ ${WEEK_DIR}/README.md"
    
    # main.go作成
    cat > "${WEEK_DIR}/main.go" << EOF
package main

import "fmt"

func main() {
	// Week ${week}: ここに課題のコードを記述してください
	// 詳細な課題内容はLMSで確認してください
	
	fmt.Println("Week ${week} 課題")
	
	// 以下に実装してください
	
}
EOF
    
    echo "  ✅ ${WEEK_DIR}/main.go"
done

echo ""
echo "================================================"
echo "✅ 全${TOTAL_WEEKS}週分のディレクトリ作成が完了しました"
echo ""
echo "📋 作成されたディレクトリ:"
ls -d week*/
echo ""
echo "📝 次のステップ:"
echo "  1. 各週のREADME.mdで学習テーマを記載"
echo "  2. GitHubにコミット・プッシュ"
echo "     git add week*"
echo "     git commit -m 'Add weekly assignment structure (week01-week15)'"
echo "     git push origin main"
echo "  3. GitHub Classroomでテンプレートリポジトリとして設定"
echo ""
echo "================================================"
