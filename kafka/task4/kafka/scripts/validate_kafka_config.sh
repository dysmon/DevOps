#!/bin/bash

validate_topics() {
  for file in jsons/*.json; do
    echo "Validating $file..."
    jq empty "$file" || exit 1
    echo "$file is valid"
  done
}

validate_permissions() {
  for file in jsons/*.json; do
    echo "Validating $file..."
    jq empty "$file" || exit 1
    echo "$file is valid"
  done
}

validate_topics
validate_permissions

echo "All validation checks passed!"
exit 0
