#!/bin/bash
for file in test_data/*.json; do
  echo "🔍 Vérification du fichier $file"
  jq . "$file" || exit 1
done
