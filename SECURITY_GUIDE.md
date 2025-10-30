# 🔒 セキュリティとプライバシーガイド

## 📑 目次

- [なぜセキュリティが重要か](#なぜセキュリティが重要か)
- [個人情報の取り扱い](#個人情報の取り扱い)
- [API Keyと機密情報](#api-keyと機密情報)
- [ポート公開の注意事項](#ポート公開の注意事項)
- [環境変数の使用方法](#環境変数の使用方法)
- [安全なコーディング例](#安全なコーディング例)
- [提出前セキュリティチェックリスト](#提出前セキュリティチェックリスト)

---

## なぜセキュリティが重要か

### プログラミング学習におけるセキュリティの重要性

1. **個人情報の保護**
   - インターネット上に公開されたコードは誰でも閲覧可能
   - 一度公開された情報は完全に削除することが困難

2. **将来のキャリアへの影響**
   - セキュリティ意識は就職活動で評価される
   - 良いセキュリティ習慣は早い段階で身につける

3. **法的責任**
   - 個人情報保護法の遵守
   - 他人の情報を不適切に扱うと法的問題になる可能性

---

## 個人情報の取り扱い

### 個人情報とは

以下の情報は**個人情報**です。コードに含めてはいけません：

- ✅ **基本的な個人情報**
  - 実名（氏名）
  - 住所（都道府県以下の詳細）
  - 電話番号
  - メールアドレス（実際に使用しているもの）
  - 生年月日
  - 学生番号（課題提出を除く）

- ✅ **識別可能な情報**
  - 顔写真
  - マイナンバー
  - クレジットカード番号
  - 銀行口座情報
  - パスポート番号

- ✅ **デジタル情報**
  - SNSのアカウント名（実名の場合）
  - 個人のブログURL
  - 位置情報（GPS座標など）

### ❌ 悪い例

```go
package main

import "fmt"

func main() {
    // ❌ 実名を直接書いている
    name := "山田太郎"
    
    // ❌ 住所を書いている
    address := "大阪府大阪市中央区本町1-2-3 サンプルマンション101"
    
    // ❌ 電話番号を書いている
    phone := "090-1234-5678"
    
    // ❌ 実際のメールアドレスを書いている
    email := "yamada.taro@example.com"
    
    // ❌ 生年月日を書いている
    birthday := "1995年4月15日"
    
    fmt.Printf("名前: %s\n", name)
    fmt.Printf("住所: %s\n", address)
    fmt.Printf("電話: %s\n", phone)
    fmt.Printf("メール: %s\n", email)
    fmt.Printf("生年月日: %s\n", birthday)
}
```

### ✅ 良い例

```go
package main

import "fmt"

func main() {
    // ✅ ダミーデータや一般的な例を使用
    name := "テスト太郎"  // 明らかにダミーとわかる名前
    address := "東京都千代田区"  // 都道府県市区程度まで
    phone := "000-0000-0000"  // ダミーの電話番号
    email := "example@example.com"  // example.comドメイン
    
    fmt.Printf("名前: %s\n", name)
    fmt.Printf("住所: %s\n", address)
    fmt.Printf("電話: %s\n", phone)
    fmt.Printf("メール: %s\n", email)
}
```

### ✅ さらに良い例 - ユーザー入力を使用

```go
package main

import (
    "bufio"
    "fmt"
    "os"
)

func main() {
    reader := bufio.NewReader(os.Stdin)
    
    // ユーザーに入力させる（実行時に入力）
    fmt.Print("名前を入力してください: ")
    name, _ := reader.ReadString('\n')
    
    fmt.Print("住所を入力してください: ")
    address, _ := reader.ReadString('\n')
    
    // 入力されたデータを使用
    fmt.Printf("こんにちは、%s\n", name)
    fmt.Printf("お住まいは%sですね\n", address)
}
```

---

## API Keyと機密情報

### 機密情報の種類

以下の情報は**絶対にコードに直接書かない**:

1. **API Key / API Secret**
   - OpenAI API Key
   - Google Maps API Key
   - AWS Access Key
   - その他のサービスのAPI認証情報

2. **パスワード**
   - データベースのパスワード
   - サービスのログインパスワード
   - 暗号化キー

3. **トークン**
   - アクセストークン
   - リフレッシュトークン
   - セッショントークン

4. **接続情報**
   - データベース接続文字列
   - サーバーのIPアドレスとポート
   - 管理者アカウント情報

### ❌ 絶対にやってはいけない例

```go
package main

import (
    "fmt"
    "net/http"
)

func main() {
    // ❌ API Keyを直接書いている
    apiKey := "sk-proj-abc123xyz456def789ghi012jkl345mno678pqr901stu234"
    
    // ❌ データベースパスワードを書いている
    dbPassword := "MySecretPassword123!"
    
    // ❌ 接続文字列に認証情報を含めている
    dbURL := "mysql://admin:password123@db.example.com:3306/mydb"
    
    // API呼び出し
    url := fmt.Sprintf("https://api.example.com/data?key=%s", apiKey)
    resp, _ := http.Get(url)
    defer resp.Body.Close()
}
```

**問題点**:
- このコードをGitHubにpushすると、**世界中の誰でも**あなたのAPI Keyを見ることができる
- 悪意のある人があなたのAPI Keyを悪用する可能性
- 高額な課金が発生する危険性
- アカウントの停止や法的問題に発展する可能性

---

## 環境変数の使用方法

### 環境変数とは

- プログラムの外部で設定する変数
- コードに含めずに機密情報を管理できる
- GitHubに公開されない

### ✅ 正しい方法 1: 環境変数を使用

```go
package main

import (
    "fmt"
    "os"
)

func main() {
    // 環境変数から読み込む
    apiKey := os.Getenv("API_KEY")
    
    // 設定されているかチェック
    if apiKey == "" {
        fmt.Println("エラー: API_KEY環境変数が設定されていません")
        fmt.Println("設定方法: export API_KEY=your-key-here")
        return
    }
    
    // API Keyを使用
    fmt.Printf("API Key（最初の5文字）: %s...\n", apiKey[:5])
}
```

**環境変数の設定方法**:

```bash
# Codespaceのターミナルで実行
export API_KEY="your-actual-api-key-here"

# 確認
echo $API_KEY

# プログラム実行
go run main.go
```

### ✅ 正しい方法 2: .envファイルを使用

**.envファイル**（このファイルは.gitignoreに含まれているので安全）:

```bash
# .env
API_KEY=your-api-key-here
DATABASE_URL=mysql://user:password@localhost:3306/mydb
SECRET_TOKEN=your-secret-token
```

**Goコード**:

```go
package main

import (
    "bufio"
    "fmt"
    "os"
    "strings"
)

func loadEnv(filename string) error {
    file, err := os.Open(filename)
    if err != nil {
        return err
    }
    defer file.Close()
    
    scanner := bufio.NewScanner(file)
    for scanner.Scan() {
        line := scanner.Text()
        
        // コメント行や空行をスキップ
        if strings.HasPrefix(line, "#") || line == "" {
            continue
        }
        
        // KEY=VALUE形式を分割
        parts := strings.SplitN(line, "=", 2)
        if len(parts) == 2 {
            key := strings.TrimSpace(parts[0])
            value := strings.TrimSpace(parts[1])
            os.Setenv(key, value)
        }
    }
    
    return scanner.Err()
}

func main() {
    // .envファイルを読み込む
    err := loadEnv(".env")
    if err != nil {
        fmt.Printf("警告: .envファイルを読み込めませんでした: %v\n", err)
    }
    
    // 環境変数から取得
    apiKey := os.Getenv("API_KEY")
    if apiKey == "" {
        fmt.Println("エラー: API_KEYが設定されていません")
        return
    }
    
    fmt.Println("API Keyが正常に読み込まれました")
}
```

### .gitignoreの確認

`.gitignore`ファイルに以下が含まれていることを確認してください（既に設定済み）:

```
# 環境変数・機密情報
.env
.env.local
.env.*.local
*.key
*.pem
credentials.json
**/apikey.txt
**/token.txt
**/password.txt
```

---

## ポート公開の注意事項

### Codespacesのポート転送

Codespacesでは、Webサーバーを起動すると自動的にポートが転送されます。

```go
package main

import (
    "fmt"
    "net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "<h1>Hello, World!</h1>")
}

func main() {
    http.HandleFunc("/", handler)
    fmt.Println("サーバー起動: http://localhost:8080")
    http.ListenAndServe(":8080", nil)
}
```

### ポート転送の設定

Codespacesでは、ポートの公開範囲を設定できます：

1. **Private** - 自分だけがアクセス可能
2. **Public** - URLを知っている人全員がアクセス可能（デフォルト）

### ⚠️ Public設定の場合の注意事項

**Public設定では、URLを知っている誰でもアクセスできます！**

#### ❌ 表示してはいけない情報

```go
// ❌ 個人情報を表示
http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "<h1>学生情報</h1>")
    fmt.Fprintf(w, "<p>名前: 山田太郎</p>")
    fmt.Fprintf(w, "<p>学生番号: 12345678</p>")
    fmt.Fprintf(w, "<p>メール: yamada@example.com</p>")
})

// ❌ 機密情報を表示
http.HandleFunc("/admin", func(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "<h1>管理画面</h1>")
    fmt.Fprintf(w, "<p>API Key: %s</p>", os.Getenv("API_KEY"))
    fmt.Fprintf(w, "<p>データベース: %s</p>", dbPassword)
})

// ❌ 内部システム情報を表示
http.HandleFunc("/debug", func(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "サーバーIP: %s\n", serverIP)
    fmt.Fprintf(w, "データベースパス: %s\n", dbPath)
})
```

#### ✅ 安全な表示例

```go
// ✅ 課題の範囲内の情報のみ表示
http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "<h1>Hello, World!</h1>")
    fmt.Fprintf(w, "<p>現在時刻: %v</p>", time.Now().Format("2006-01-02 15:04:05"))
    fmt.Fprintf(w, "<p>これは課題のサンプルページです</p>")
})

// ✅ 匿名化されたデータの表示
http.HandleFunc("/data", func(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "<h1>データ一覧</h1>")
    fmt.Fprintf(w, "<p>ユーザーA: 100点</p>")
    fmt.Fprintf(w, "<p>ユーザーB: 95点</p>")
    fmt.Fprintf(w, "<p>ユーザーC: 88点</p>")
})
```

### ポート公開の管理

#### Privateに変更する方法

```
1. Codespacesの「ポート」タブを開く
2. ポート8080の行を右クリック
3. 「ポートの可視性の変更」→「Private」を選択
```

#### 公開URLの確認

```
1. 「ポート」タブで転送されたアドレスを確認
2. URLの形式:
   https://xxxx-8080.app.github.dev
   
3. このURLは推測が困難だが、共有すれば誰でもアクセス可能
```

---

## 安全なコーディング例

### 例1: ユーザー登録システム

```go
package main

import (
    "crypto/sha256"
    "encoding/hex"
    "fmt"
)

// ❌ 悪い例
func registerUserBad(username, password string) {
    // パスワードを平文で保存（危険！）
    fmt.Printf("ユーザー: %s, パスワード: %s\n", username, password)
}

// ✅ 良い例
func registerUserGood(username, password string) {
    // パスワードをハッシュ化
    hash := sha256.Sum256([]byte(password))
    hashedPassword := hex.EncodeToString(hash[:])
    
    // ハッシュ化されたパスワードのみを保存
    fmt.Printf("ユーザー: %s\n", username)
    fmt.Printf("パスワードハッシュ: %s\n", hashedPassword)
    
    // 注意: 実際のアプリケーションでは bcrypt などを使用
}

func main() {
    // ❌ 悪い例
    registerUserBad("yamada", "MyPassword123")
    
    // ✅ 良い例
    registerUserGood("testuser", "SecurePassword456")
}
```

### 例2: データベース接続

```go
package main

import (
    "database/sql"
    "fmt"
    "os"
)

// ❌ 悪い例
func connectDatabaseBad() {
    // 接続情報をハードコード（危険！）
    db, err := sql.Open("mysql", "admin:MyPassword123@tcp(db.example.com:3306)/mydb")
    if err != nil {
        fmt.Println(err)
    }
    defer db.Close()
}

// ✅ 良い例
func connectDatabaseGood() {
    // 環境変数から読み込む
    dbHost := os.Getenv("DB_HOST")
    dbUser := os.Getenv("DB_USER")
    dbPass := os.Getenv("DB_PASSWORD")
    dbName := os.Getenv("DB_NAME")
    
    // 接続情報が設定されているかチェック
    if dbHost == "" || dbUser == "" || dbPass == "" || dbName == "" {
        fmt.Println("エラー: データベース接続情報が設定されていません")
        return
    }
    
    // 接続文字列を構築
    dsn := fmt.Sprintf("%s:%s@tcp(%s)/%s", dbUser, dbPass, dbHost, dbName)
    db, err := sql.Open("mysql", dsn)
    if err != nil {
        fmt.Println("接続エラー:", err)
        return
    }
    defer db.Close()
    
    fmt.Println("データベースに接続しました")
}
```

### 例3: ファイルアップロード

```go
package main

import (
    "fmt"
    "io"
    "net/http"
    "os"
    "path/filepath"
)

// ✅ 安全なファイルアップロード
func uploadHandler(w http.ResponseWriter, r *http.Request) {
    // ファイルサイズの制限（10MB）
    r.ParseMultipartForm(10 << 20)
    
    file, handler, err := r.FormFile("uploadfile")
    if err != nil {
        http.Error(w, "ファイル取得エラー", http.StatusBadRequest)
        return
    }
    defer file.Close()
    
    // ファイル名のサニタイズ（安全性確保）
    filename := filepath.Base(handler.Filename)
    
    // 許可された拡張子のみ受け付ける
    ext := filepath.Ext(filename)
    allowedExts := []string{".txt", ".jpg", ".png", ".pdf"}
    
    allowed := false
    for _, allowedExt := range allowedExts {
        if ext == allowedExt {
            allowed = true
            break
        }
    }
    
    if !allowed {
        http.Error(w, "許可されていないファイル形式です", http.StatusBadRequest)
        return
    }
    
    // 安全なディレクトリにのみ保存
    uploadDir := "./uploads"
    os.MkdirAll(uploadDir, 0755)
    
    dst, err := os.Create(filepath.Join(uploadDir, filename))
    if err != nil {
        http.Error(w, "ファイル保存エラー", http.StatusInternalServerError)
        return
    }
    defer dst.Close()
    
    // ファイルをコピー
    _, err = io.Copy(dst, file)
    if err != nil {
        http.Error(w, "ファイル書き込みエラー", http.StatusInternalServerError)
        return
    }
    
    fmt.Fprintf(w, "ファイルが正常にアップロードされました: %s\n", filename)
}
```

---

## 提出前セキュリティチェックリスト

### 必須チェック項目

```
個人情報:
□ 実名が含まれていない
□ 住所（詳細）が含まれていない
□ 電話番号が含まれていない
□ 実際のメールアドレスが含まれていない
□ 生年月日が含まれていない
□ マイナンバーなどの識別番号が含まれていない

機密情報:
□ API Keyが直接書かれていない
□ パスワードが含まれていない
□ データベース接続情報が含まれていない
□ アクセストークンが含まれていない
□ 秘密鍵（private key）が含まれていない

コード品質:
□ ダミーデータを使用している
□ 環境変数を適切に使用している
□ エラーハンドリングがある
□ 入力値の検証がある

Webサーバー（該当する場合）:
□ 個人を特定できる情報を表示していない
□ 管理画面などの機密情報を公開していない
□ デバッグ情報を表示していない
```

### チェック方法

#### 1. コード全体を検索

```bash
# 自分の名前を検索（例）
grep -r "山田" .
grep -r "太郎" .

# 電話番号パターンを検索
grep -r "090-" .
grep -r "080-" .

# メールアドレスを検索
grep -r "@gmail.com" .
grep -r "@yahoo.co.jp" .

# APIキーのパターンを検索
grep -r "api_key\s*=" .
grep -r "API_KEY\s*=" .
grep -r "sk-proj-" .  # OpenAI API Keyのパターン
```

#### 2. .envファイルの確認

```bash
# .envファイルが.gitignoreに含まれているか確認
cat .gitignore | grep ".env"

# 出力に ".env" があればOK
```

#### 3. Git履歴の確認

```bash
# 機密情報が過去のコミットに含まれていないか確認
git log --all --full-history -- "*password*"
git log --all --full-history -- "*api_key*"
```

---

## よくある質問

### Q1: ダミーデータはどう作ればいいですか？

**A**: 以下のような方法があります

```go
// 明らかにテスト用とわかる名前
name := "テスト太郎"
name := "山田サンプル"
name := "Sample User"

// example.comドメインを使用（予約ドメイン）
email := "test@example.com"
email := "user@example.org"

// 架空の電話番号
phone := "000-0000-0000"
phone := "090-0000-0000"

// 一般的な住所（特定されない程度）
address := "東京都千代田区"
address := "大阪府大阪市"
```

### Q2: 課題で実際のAPIを使う必要がある場合は？

**A**: 環境変数を使用してください

```go
// ✅ 正しい方法
apiKey := os.Getenv("API_KEY")
if apiKey == "" {
    fmt.Println("API_KEYを設定してください")
    return
}

// README.mdに使用方法を記載
// 「実行前に export API_KEY=your-key を実行してください」
```

### Q3: 既にAPI Keyをpushしてしまいました

**A**: 以下の手順で対処してください

```
1. API Keyを即座に無効化・再発行
   - サービスの管理画面でキーを削除
   - 新しいキーを発行

2. 教員に報告
   - 状況を説明
   - 対処方法を相談

3. Git履歴から削除（高度）
   - git filter-branch などを使用
   - または新しいリポジトリを作成

重要: 一度公開された情報は完全には削除できません
```

### Q4: 学生番号は個人情報ですか？

**A**: 状況によります

```
✅ OK: 課題提出時のブランチ名に含める
     （教員が成績管理に使用）

❌ NG: Webページに表示する
     プログラムの出力に含める
     コメントに書く（提出以外の目的）
```

### Q5: テストデータにはどんな値を使えばいいですか？

**A**: 以下のような値が推奨されます

```go
// ✅ 良いテストデータ
users := []User{
    {Name: "Alice", Age: 25},  // 英語の一般的な名前
    {Name: "Bob", Age: 30},
    {Name: "Charlie", Age: 35},
}

// ✅ 日本語の場合
users := []User{
    {Name: "ユーザーA", Age: 25},
    {Name: "テスト太郎", Age: 30},
}

// ❌ 避けるべき
users := []User{
    {Name: "山田太郎", Age: 25},  // 実在しそうな名前
}
```

---

## まとめ

### セキュリティの3原則

1. **個人情報を書かない**
   - 実名、住所、電話番号、メールアドレスなど

2. **機密情報をコードに含めない**
   - API Key、パスワード、トークンは環境変数で管理

3. **公開前に確認する**
   - チェックリストを使って提出前に必ず確認

### 困ったときは

- **質問する前に**: このガイドとチェックリストを確認
- **判断に迷ったら**: 教員やTAに相談
- **問題が発生したら**: すぐに報告

---

**セキュリティは「知らなかった」では済まされません。常に意識して、安全なコードを書きましょう！** 🔒
