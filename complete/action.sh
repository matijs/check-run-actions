#!/usr/bin/env bash
set -euxo pipefail

: "${GH_TOKEN:?GH_TOKEN is required}"
: "${__CHECK_RUN_ID__:?__CHECK_RUN_ID__ is required}"
: "${__CONCLUSION__:?__CONCLUSION__ is required}"

gh api "repos/${GITHUB_REPOSITORY}/check-runs/${__CHECK_RUN_ID__}" \
  --method PATCH \
  --header "Accept: application/vnd.github+json" \
  --header "X-GitHub-Api-Version: 2022-11-28" \
  --field "status=completed" \
  --field "conclusion=${__CONCLUSION__}" \
  --field "completed_at=$(date --utc +%Y-%m-%dT%H:%M:%SZ)"

