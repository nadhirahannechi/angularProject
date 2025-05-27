#!/bin/bash

echo "📝 Génération du rapport Markdown"
echo "# Résultats des jobs AAP" > job_results/report.md

for result in job_results/job_*.json; do
  JOB_ID=$(jq -r '.id' "$result")
  STATUS=$(jq -r '.status' "$result")
  echo "- Job ID **$JOB_ID** : $STATUS" >> job_results/report.md
done

cat job_results/report.md
