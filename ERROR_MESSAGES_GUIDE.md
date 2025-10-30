# ⚠️ エラーメッセージ完全ガイド

## 📑 目次

- [環境関連のエラー](#環境関連のエラー)
- [Go言語の文法エラー](#go言語の文法エラー)
- [実行時エラー](#実行時エラー)
- [ネットワーク関連のエラー](#ネットワーク関連のエラー)
- [Codespaces関連のエラー](#codespaces関連のエラー)
- [提出関連のエラー](#提出関連のエラー)

---

## 環境関連のエラー

### エラー1: `permission denied`

#### エラーメッセージ例
```
bash: /go/bin/gopls: Permission denied
mkdir: cannot create directory '/go/src': Permission denied
touch: cannot touch 'test.txt': Permission denied
```

#### 原因
- ディレクトリやファイルの権限設定の問題
- rootユーザーで作成されたファイルにアクセスしようとしている

#### 解決方法

**方法1: 権限を確認**
```bash
# 権限を確認
ls -la /go
ls -la /workspaces

# 出力例:
# drwxr-xr-x  5 root   root   4096 Jan 10 10:00 go
# ↑ rootが所有者になっている場合は問題
```

**方法2: 新しいCodespaceを作成**
```
1. 現在のCodespaceを削除
2. リポジトリページで「Code」→「Codespaces」
3. 「Create codespace on main」で新規作成
```

**方法3: 教員に連絡**
- 環境設定の問題の可能性があるため、教員に報告

---

### エラー2: `go: command not found`

#### エラーメッセージ例
```
bash: go: command not found
zsh: command not found: go
```

#### 原因
- Goがインストールされていない
- 環境変数PATHが正しく設定されていない
- Codespaceの初期化が未完了

#### 解決方法

**方法1: Goのバージョン確認**
```bash
# Goがインストールされているか確認
go version

# 期待される出力:
# go version go1.23 linux/amd64
```

**方法2: PATHの確認**
```bash
# PATH環境変数を確認
echo $PATH

# /usr/local/go/bin が含まれているか確認
# /go/bin も含まれているか確認
```

**方法3: シェルの再起動**
```bash
# 新しいターミナルを開く
# または
exec $SHELL -l
```

**方法4: Codespaceの再起動**
```
1. Codespaceを停止
2. 再度起動
3. 初期化が完了するまで1-2分待つ
```

---

### エラー3: `GOPATH not set`

#### エラーメッセージ例
```
warning: GOPATH set to GOROOT (/usr/local/go) has no effect
```

#### 原因
- GOPATH環境変数が正しく設定されていない
- 通常は警告のみで動作に影響しない

#### 解決方法

**方法1: 環境変数を確認**
```bash
# 環境変数を確認
go env GOPATH
go env GOROOT

# 期待される出力:
# GOPATH=/go
# GOROOT=/usr/local/go
```

**方法2: 手動設定（通常は不要）**
```bash
# 必要な場合のみ
export GOPATH=/go
export PATH=$PATH:/go/bin
```

---

## Go言語の文法エラー

### エラー4: `cannot find package`

#### エラーメッセージ例
```
main.go:3:8: cannot find package "fmt" in any of:
    /usr/local/go/src/fmt (from $GOROOT)
    /go/src/fmt (from $GOPATH)

main.go:4:8: cannot find package "github.com/some/package"
```

#### 原因
- パッケージのインポートパスが間違っている
- 外部パッケージがインストールされていない
- 相対パスを使用している（非推奨）

#### 解決方法

**ケース1: 標準パッケージのエラー**
```go
// ❌ 間違い
import "./fmt"      // 相対パスは使えない
import "Fmt"        // 大文字小文字を間違えている
import "fmt.go"     // .goを付けない

// ✅ 正しい
import "fmt"
```

**ケース2: 外部パッケージのエラー**
```bash
# パッケージをインストール
go get github.com/some/package

# または go.mod を使用
go mod init myproject
go mod tidy
```

**ケース3: 自作パッケージのエラー**
```go
// ディレクトリ構造:
// week03/
//   main.go
//   mypackage/
//     hello.go

// ❌ 間違い
import "./mypackage"      // 相対パスは非推奨

// ✅ 正しい（go.mod使用）
// まず: go mod init week03
import "week03/mypackage"
```

---

### エラー5: `undefined: xxxxx`

#### エラーメッセージ例
```
./main.go:5:2: undefined: Println
./main.go:8:5: undefined: myFunction
./main.go:10:2: undefined: myVariable
```

#### 原因
- パッケージ名を省略している
- 関数や変数が定義されていない
- スコープの問題（別のブロック内で定義）

#### 解決方法

**ケース1: パッケージ名の省略**
```go
// ❌ 間違い
func main() {
    Println("Hello")  // fmtパッケージ名がない
}

// ✅ 正しい
import "fmt"

func main() {
    fmt.Println("Hello")  // パッケージ名.関数名
}
```

**ケース2: 未定義の関数**
```go
// ❌ 間違い
func main() {
    result := calculate(10)  // calculateが定義されていない
    fmt.Println(result)
}

// ✅ 正しい
func calculate(x int) int {  // 関数を定義
    return x * 2
}

func main() {
    result := calculate(10)
    fmt.Println(result)
}
```

**ケース3: スコープの問題**
```go
// ❌ 間違い
func main() {
    if true {
        x := 10
    }
    fmt.Println(x)  // xはifブロック内で定義されている
}

// ✅ 正しい
func main() {
    var x int  // 外側で定義
    if true {
        x = 10
    }
    fmt.Println(x)
}
```

---

### エラー6: `syntax error`

#### エラーメッセージ例
```
./main.go:5:10: syntax error: unexpected newline, expecting {
./main.go:8:15: syntax error: unexpected }, expecting comma or }
./main.go:12:1: syntax error: non-declaration statement outside function body
```

#### 原因
- 括弧の位置が間違っている
- 括弧の数が合っていない
- セミコロンが不要な場所にある
- 構文ルールを守っていない

#### 解決方法

**ケース1: 中括弧の位置**
```go
// ❌ 間違い - { が次の行にある
func main()
{
    fmt.Println("Hello")
}

// ✅ 正しい - { は同じ行
func main() {
    fmt.Println("Hello")
}
```

**ケース2: 括弧の不足**
```go
// ❌ 間違い
func main() {
    if x > 10 {
        fmt.Println("Large")
    // } が不足
    fmt.Println("End")
}

// ✅ 正しい
func main() {
    if x > 10 {
        fmt.Println("Large")
    }  // 閉じ括弧を追加
    fmt.Println("End")
}
```

**ケース3: 不要なセミコロン**
```go
// ❌ 間違い
func main() {
    x := 10;  // セミコロンは不要
    fmt.Println(x);
}

// ✅ 正しい
func main() {
    x := 10  // セミコロンなし
    fmt.Println(x)
}
```

---

### エラー7: `declared and not used`

#### エラーメッセージ例
```
./main.go:6:2: x declared and not used
./main.go:8:2: result declared and not used
```

#### 原因
- 変数を宣言したが使用していない
- Goでは未使用の変数はエラーになる

#### 解決方法

**方法1: 変数を使用する**
```go
// ❌ エラー
func main() {
    x := 10  // 宣言したが使っていない
    fmt.Println("Hello")
}

// ✅ 修正
func main() {
    x := 10
    fmt.Println(x)  // 使用する
}
```

**方法2: 変数を削除する**
```go
// ✅ 使わない変数は削除
func main() {
    // x := 10  削除
    fmt.Println("Hello")
}
```

**方法3: ブランク識別子を使用**
```go
// 関数が複数の値を返すが、一部だけ使う場合
func getData() (int, error) {
    return 42, nil
}

func main() {
    value, _ := getData()  // エラーは無視
    fmt.Println(value)
}
```

---

### エラー8: `cannot use xxx (type yyy) as type zzz`

#### エラーメッセージ例
```
./main.go:7:15: cannot use x (type string) as type int
./main.go:10:20: cannot use result (type float64) as type int
```

#### 原因
- 型が一致していない
- 暗黙的な型変換は行われない

#### 解決方法

```go
// ❌ 間違い
func printNumber(n int) {
    fmt.Println(n)
}

func main() {
    x := "123"
    printNumber(x)  // stringをintに渡せない
}

// ✅ 正しい - 型変換
import "strconv"

func main() {
    x := "123"
    n, err := strconv.Atoi(x)  // stringをintに変換
    if err != nil {
        fmt.Println("変換エラー")
        return
    }
    printNumber(n)
}

// または
func main() {
    var y float64 = 3.14
    x := int(y)  // float64をintに変換（小数点以下切り捨て）
    printNumber(x)
}
```

---

## 実行時エラー

### エラー9: `panic: runtime error: index out of range`

#### エラーメッセージ例
```
panic: runtime error: index out of range [3] with length 3

goroutine 1 [running]:
main.main()
    /workspaces/golang00/week03/main.go:8 +0x20
```

#### 原因
- 配列やスライスの範囲外にアクセスしている
- インデックスは0から始まる

#### 解決方法

```go
// ❌ 間違い
func main() {
    numbers := []int{10, 20, 30}  // 長さ3、インデックスは0,1,2
    fmt.Println(numbers[3])        // インデックス3は存在しない！
}

// ✅ 正しい - 範囲チェック
func main() {
    numbers := []int{10, 20, 30}
    
    index := 2  // 取得したいインデックス
    if index < len(numbers) {
        fmt.Println(numbers[index])
    } else {
        fmt.Println("インデックスが範囲外です")
    }
}

// ✅ 正しい - ループで安全にアクセス
func main() {
    numbers := []int{10, 20, 30}
    
    for i := 0; i < len(numbers); i++ {
        fmt.Println(numbers[i])
    }
    
    // または range を使用
    for i, num := range numbers {
        fmt.Printf("numbers[%d] = %d\n", i, num)
    }
}
```

---

### エラー10: `panic: runtime error: invalid memory address or nil pointer dereference`

#### エラーメッセージ例
```
panic: runtime error: invalid memory address or nil pointer dereference
[signal SIGSEGV: segmentation violation]
```

#### 原因
- nilポインタにアクセスしている
- 初期化されていない変数を使用

#### 解決方法

```go
// ❌ 間違い
func main() {
    var p *int  // nilポインタ
    fmt.Println(*p)  // nilを参照するとpanicが発生
}

// ✅ 正しい - nilチェック
func main() {
    var p *int
    
    if p != nil {
        fmt.Println(*p)
    } else {
        fmt.Println("ポインタがnilです")
    }
}

// ✅ 正しい - 初期化
func main() {
    x := 10
    p := &x  // ポインタを初期化
    fmt.Println(*p)  // 安全にアクセス可能
}
```

---

### エラー11: `panic: runtime error: integer divide by zero`

#### エラーメッセージ例
```
panic: runtime error: integer divide by zero
```

#### 原因
- 0で割り算をしている

#### 解決方法

```go
// ❌ 間違い
func main() {
    x := 10
    y := 0
    result := x / y  // 0で割るとpanic
    fmt.Println(result)
}

// ✅ 正しい - ゼロチェック
func main() {
    x := 10
    y := 0
    
    if y != 0 {
        result := x / y
        fmt.Println(result)
    } else {
        fmt.Println("エラー: 0で割ることはできません")
    }
}

// ✅ 関数で安全に処理
func safeDivide(a, b int) (int, error) {
    if b == 0 {
        return 0, fmt.Errorf("0で割ることはできません")
    }
    return a / b, nil
}

func main() {
    result, err := safeDivide(10, 0)
    if err != nil {
        fmt.Println(err)
        return
    }
    fmt.Println(result)
}
```

---

## ネットワーク関連のエラー

### エラー12: `port is already allocated`

#### エラーメッセージ例
```
listen tcp :8080: bind: address already in use
panic: ListenAndServe: listen tcp :8080: bind: address already in use
```

#### 原因
- ポート8080が既に使用中
- 前回のプログラムが正しく終了していない

#### 解決方法

**方法1: 実行中のプログラムを停止**
```bash
# ターミナルで Ctrl+C を押す
^C

# または、新しいターミナルで
pkill -f "go run"
```

**方法2: ポートを使用しているプロセスを確認**
```bash
# ポート8080を使用しているプロセスを確認
lsof -i :8080

# 出力例:
# COMMAND   PID  USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
# main    12345 vscode    3u  IPv6  12345      0t0  TCP *:8080 (LISTEN)

# プロセスを終了
kill -9 12345
```

**方法3: 別のポートを使用**
```go
// main.goで別のポートに変更
func main() {
    // ポート番号を変更
    http.HandleFunc("/", handler)
    http.ListenAndServe(":8081", nil)  // 8080 → 8081
}
```

---

### エラー13: `dial tcp: lookup xxx: no such host`

#### エラーメッセージ例
```
Get "https://api.example.com": dial tcp: lookup api.example.com: no such host
```

#### 原因
- URLのドメイン名が間違っている
- ネットワーク接続の問題
- DNSの解決ができない

#### 解決方法

**方法1: URLを確認**
```go
// URLのスペルを確認
url := "https://api.example.com"  // 正しいURLか確認

// よくある間違い:
// - httpsの's'忘れ
// - ドメイン名のタイポ
// - 余分なスペース
```

**方法2: ネットワーク接続を確認**
```bash
# ネットワーク接続を確認
ping google.com

# DNSを確認
nslookup api.example.com
```

**方法3: エラーハンドリング**
```go
resp, err := http.Get("https://api.example.com")
if err != nil {
    fmt.Printf("エラー: %v\n", err)
    // エラーの詳細を確認して対処
    return
}
defer resp.Body.Close()
```

---

### エラー14: `context deadline exceeded (Client.Timeout)`

#### エラーメッセージ例
```
Get "https://example.com": context deadline exceeded (Client.Timeout exceeded while awaiting headers)
```

#### 原因
- サーバーの応答が遅い
- タイムアウト時間が短すぎる
- ネットワークの問題

#### 解決方法

```go
// ❌ デフォルトのタイムアウト（短い）
resp, err := http.Get("https://slow-server.com")

// ✅ タイムアウトを延長
client := &http.Client{
    Timeout: 30 * time.Second,  // 30秒に設定
}
resp, err := client.Get("https://slow-server.com")
if err != nil {
    fmt.Printf("タイムアウト: %v\n", err)
    return
}
defer resp.Body.Close()
```

---

## Codespaces関連のエラー

### エラー15: Codespaceが起動しない

#### 症状
- 「Creating codespace...」で止まる
- エラーメッセージが表示される
- 空白の画面が表示される

#### 解決方法

**方法1: ブラウザのキャッシュをクリア**
```
Chrome:
1. Ctrl+Shift+Delete
2. 「キャッシュされた画像とファイル」にチェック
3. 「データを削除」

Edge:
1. Ctrl+Shift+Delete
2. 同様にキャッシュをクリア
```

**方法2: 別のブラウザを試す**
```
推奨ブラウザ:
- Google Chrome
- Microsoft Edge
- Firefox

避けるべき:
- Internet Explorer（非対応）
- 古いバージョンのブラウザ
```

**方法3: Codespaceを削除して再作成**
```
1. リポジトリページで「Code」→「Codespaces」
2. 問題のCodespaceの「...」メニュー
3. 「Delete」を選択
4. 「Create codespace on main」で新規作成
```

**方法4: GitHub Statusを確認**
```
https://www.githubstatus.com/
GitHubのサービスに障害がないか確認
```

---

### エラー16: ファイルが保存できない

#### エラーメッセージ例
```
Failed to save 'main.go': Unable to write file
EACCES: permission denied
```

#### 原因
- ファイルの権限がない
- ディスク容量不足
- ファイルが読み取り専用

#### 解決方法

**方法1: 権限を確認**
```bash
# ファイルの権限を確認
ls -la main.go

# 書き込み権限がない場合
chmod u+w main.go
```

**方法2: ディスク容量を確認**
```bash
# ディスク使用量を確認
df -h

# 不要なファイルを削除
rm -rf /tmp/*
go clean -cache -modcache
```

**方法3: Codespaceを再起動**
```
1. Codespaceを停止
2. 再起動
3. ファイルを再度編集
```

---

## 提出関連のエラー

### エラー17: 「Export changes to a branch」が押せない

#### 症状
- ボタンがグレーアウトしている
- クリックしても何も起こらない

#### 原因
- 変更がない
- すべての変更が既にコミットされている

#### 解決方法

**方法1: 変更を確認**
```
1. 左側のエクスプローラーを確認
2. ファイル名の横に「M」（Modified）マークがあるか
3. なければ何か編集して保存
```

**方法2: ファイルを保存**
```
1. Ctrl+S（Mac: Cmd+S）でファイルを保存
2. 「Export changes to a branch」を再試行
```

**方法3: Git statusを確認**
```bash
# ターミナルで変更を確認
git status

# 変更があれば表示される
# Changes not staged for commit:
#   modified:   week03/main.go
```

---

### エラー18: ブランチ名が見つからない

#### 症状
- 「Export changes to a branch」を実行したがブランチ名が表示されない
- GitHubでブランチが見つからない

#### 解決方法

**方法1: GitHubで確認**
```
1. リポジトリページを開く
2. 「X branches」をクリック
3. ブランチ一覧から最新のものを探す
4. 通常は「codespace-」で始まる名前
```

**方法2: ローカルで確認**
```bash
# すべてのブランチを表示
git branch -a

# 最近作成されたブランチを表示
git for-each-ref --sort=-committerdate refs/heads/
```

**方法3: 再度Export**
```
1. もう一度ファイルを編集
2. 保存
3. 「Export changes to a branch」を実行
4. 新しいブランチ名をLMSで報告
```

---

### エラー19: LMSで提出できない

#### 症状
- ブランチ名を入力しても「無効な形式」エラー
- 提出ボタンが押せない

#### 解決方法

**方法1: ブランチ名の形式を確認**
```
正しい形式:
codespace-symmetrical-guacamole-q74vxx47qp92x7wv

間違った形式:
- スペースが含まれている
- 余分な文字が入っている
- コピーミス
```

**方法2: ブランチ名を正確にコピー**
```
1. GitHubのブランチ一覧を開く
2. ブランチ名を選択
3. 右クリック→「コピー」
4. LMSに貼り付け
```

**方法3: ブラウザを変える**
```
- 別のブラウザでLMSにアクセス
- キャッシュをクリアしてから再試行
```

---

## エラーの予防

### デバッグのコツ

```go
// エラーハンドリングを必ず行う
result, err := someFunction()
if err != nil {
    fmt.Printf("エラー: %v\n", err)  // エラー内容を表示
    return
}

// デバッグ出力を追加
fmt.Printf("Debug: x = %v\n", x)  // 変数の値を確認
fmt.Printf("Debug: 処理を開始します\n")  // 処理の流れを確認
```

### コードレビューのチェックリスト

```
提出前に確認:
□ エラーハンドリングがある
□ nil チェックがある
□ 配列のインデックスチェックがある
□ 0除算のチェックがある
□ 未使用の変数がない
□ 括弧の数が合っている
□ インポートが正しい
```

---

## サポート

このガイドで解決しない場合:

1. **LMSの質問フォーラム** - 他の学生も同じ問題を経験している可能性
2. **授業の質疑応答** - 教員に直接質問
3. **オフィスアワー** - 個別サポート
4. **TA（ティーチングアシスタント）** - 技術的なサポート

---

**エラーは学習の機会です。焦らず、メッセージを読んで、一つずつ解決していきましょう！** 🚀
