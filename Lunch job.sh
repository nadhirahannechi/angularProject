#!/bin/bash

AAP_URL="https://ton-aap.exemple.com"
AAP_TOKEN="Bearer $AAP_TOKEN"

mkdir -p job_results

for file in test_data/*.json; do
  echo "🟢 Traitement de $file"
  EXTRA_VARS=$(cat "$file" | jq -c '.')
  JOB_TEMPLATE_ID=$(jq -r '.job_template_id' "$file")

  echo "➡️ Lancement du Job Template $JOB_TEMPLATE_ID"

  RESPONSE=$(curl -s -X POST "$AAP_URL/api/v2/job_templates/$JOB_TEMPLATE_ID/launch/" \
    -H "Content-Type: application/json" \
    -H "Authorization: $AAP_TOKEN" \
    -d "{\"extra_vars\": $EXTRA_VARS}")

  JOB_ID=$(echo "$RESPONSE" | jq '.job')
  if [[ "$JOB_ID" == "null" || -z "$JOB_ID" ]]; then
    echo "❌ Erreur sur $file"
    echo "$RESPONSE"
    exit 1
  fi

  echo "⏳ Job ID $JOB_ID lancé"
  STATUS=""
  while [[ "$STATUS" != "successful" && "$STATUS" != "failed" && "$STATUS" != "error" ]]; do
    STATUS=$(curl -s "$AAP_URL/api/v2/jobs/$JOB_ID/" -H "Authorization: $AAP_TOKEN" | jq -r '.status')
    echo "🔁 Statut du job $JOB_ID : $STATUS"
    sleep 10
  done

  curl -s "$AAP_URL/api/v2/jobs/$JOB_ID/" -H "Authorization: $AAP_TOKEN" > "job_results/job_$JOB_ID.json"
done
