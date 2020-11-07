#!/bin/bash

#Trying to print rules
echo "Rules:"
grep -o -n '^deny.*' /opa/rules/*.rego | while read line; do echo -e "  ☑️ $line"; done
echo

find /opa/projects/ -maxdepth 1 -mindepth 1 -name "${PROJECT_DIR_PATTERN}" -type d | while read proj; do
  echo "Validating ${proj} .."

  # Collect all artifacts to input.json 
  collie --repository ${proj} --conf /opa/cfg/conf.yml --silent > input.json
  echo "Artifacts to validate:"
  cat input.json | jq ' . | to_entries[]? | .key as $parent | .value[]? | "  📜 \($parent): \(.path)"' -r | cat
  #cat input.json

  # Run OPA
  opa eval -d /opa/rules/ -i input.json "${RUN_RULES}" 2>/dev/null > output.json
  #cat output.json
  echo "Errors: "
  cat output.json | jq ' .errors[]? | "  ⚠️ \(.location.file):\(.location.row): \(.code): \(.message)"' -r | cat
  echo "Results: "
  cat output.json | jq ' .result[]?.expressions[]? | . as $parent | .value[] | "  ❌ \($parent.text): \(.)"' -r | cat
  echo
done
