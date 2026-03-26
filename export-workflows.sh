#!/bin/bash
# N8N ワークフローをJSONファイルとしてエクスポートするスクリプト

# .envファイルから設定を読み込む
if [ -f ".env" ]; then
  export $(grep -v '^#' .env | xargs)
fi

if [ -z "$N8N_API_KEY" ] || [ -z "$N8N_BASE_URL" ]; then
  echo "Error: N8N_API_KEY と N8N_BASE_URL を .env ファイルに設定してください"
  exit 1
fi

echo "N8N ワークフロー一覧を取得中..."
WORKFLOWS=$(curl -s -H "X-N8N-API-KEY: $N8N_API_KEY" "$N8N_BASE_URL/api/v1/workflows")

if [ $? -ne 0 ]; then
  echo "Error: APIへの接続に失敗しました"
  exit 1
fi

echo "$WORKFLOWS" | python3 -c "
import json, sys, os

data = json.load(sys.stdin)
workflows = data.get('data', [])

print(f'取得したワークフロー数: {len(workflows)}')

for wf in workflows:
    wf_id = wf['id']
    wf_name = wf['name']
    # ファイル名に使えない文字を置換
    safe_name = wf_name.replace('/', '_').replace('\\\\', '_').replace(':', '_')
    filename = f'{safe_name}.json'
    with open(filename, 'w', encoding='utf-8') as f:
        json.dump(wf, f, ensure_ascii=False, indent=2)
    print(f'  保存: {filename}')
"

echo "エクスポート完了"
