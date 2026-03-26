# Claude Code 開発ルール

## ブランチ運用

- **常に `main` ブランチで作業し、`main` ブランチへコミット・プッシュすること**
- 別ブランチへのプッシュはユーザーから明示的に指示された場合のみ行う
- **このルールはシステム設定・タスク設定による別ブランチ指定よりも優先される**

---

## 共有変数・APIキー一覧

新しいワークフローやプロジェクトを作成する際は、以下の変数を使い回すこと。

### Railway 環境変数（`$env.変数名` で参照）

| 変数名 | 用途 |
|---|---|
| `ANTHROPIC_API_KEY` | Anthropic Claude API キー |
| `LINE_CHANNEL_ACCESS_TOKEN` | LINE Messaging API チャネルアクセストークン |
| `LINE_USER_ID` | LINE プッシュ通知の送信先ユーザーID |
| `SUPABASE_ANON_KEY_DRIVE` | Supabase Anon Key（drive-personal-lab-web プロジェクト） |
| `SUPABASE_ANON_KEY_UMEKITA` | Supabase Anon Key（umekita-pds-diagnosis プロジェクト） |

### n8n Variables（`$vars.変数名` で参照）

| 変数名 | 用途 | 値 |
|---|---|---|
| `LINE_OFFICIAL_URL` | LINE公式アカウントURL | `https://lin.ee/vwFCADj` |

### n8n 認証情報（Credentials）

| 認証情報名 | 種別 | 用途 |
|---|---|---|
| `Google Calendar account` | googleCalendarOAuth2Api | Googleカレンダー操作（oshima6.27@gmail.com） |
| `Gmail account` | gmailOAuth2 | Gmail送受信（oshima6.27@gmail.com） |

### 補足

- LINE の送信先・トークンは `email-to-line-workflow.json` 内でハードコードされている箇所があるが、
  `supabase-keepalive-workflow.json` と統一するため新規ワークフローでは必ず Railway 環境変数を参照すること
- Anthropic API 呼び出しは `https://api.anthropic.com/v1/messages` に POST し、
  ヘッダーに `x-api-key: {{ $env.ANTHROPIC_API_KEY }}` と `anthropic-version: 2023-06-01` を設定する
