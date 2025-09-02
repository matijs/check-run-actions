#!/usr/bin/env bash
set -euo pipefail

: "${GH_TOKEN:?GH_TOKEN is required}"
: "${__NAME__:?__NAME__ is required}"
: "${__HEAD_SHA__:?__HEAD_SHA__ is required}"

__check_run_id__=$(
  gh api "repos/${GITHUB_REPOSITORY}/check-runs" \
    --method POST \
    --header "Accept: application/vnd.github+json" \
    --header "X-GitHub-Api-Version: 2022-11-28" \
    --field "head_sha=${__HEAD_SHA__}" \
    --field "name=${__NAME__}" \
    --field "status=in_progress" \
    --field "started_at=$(date --utc +%Y-%m-%dT%H:%M:%SZ)" \
    --jq ".id"
  )

echo "check-run-id=${__check_run_id__}" >> "${GITHUB_OUTPUT}"

