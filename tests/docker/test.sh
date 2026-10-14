#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)"
fixtures="$repo_root/tests/docker/fixtures"
image="textlint-action-test:${GITHUB_RUN_ID:-local}-$$"

cleanup() {
  docker image rm --force "$image" >/dev/null 2>&1 || true
}
trap cleanup EXIT

docker build --tag "$image" "$repo_root"

installed_packages="$(docker run --rm --entrypoint npm "$image" list --global --depth=0)"
for package in \
  textlint \
  textlint-filter-rule-allowlist \
  textlint-filter-rule-comments \
  textlint-rule-common-misspellings \
  textlint-rule-preset-ja-technical-writing \
  textlint-rule-preset-jtf-style
do
  if ! grep -Fq "$package@" <<<"$installed_packages"; then
    printf 'Expected global package %s to be installed\n' "$package" >&2
    exit 1
  fi
done

docker run --rm --volume "$fixtures:/fixtures:ro" "$image" /fixtures/pass

if output="$(docker run --rm --volume "$fixtures:/fixtures:ro" "$image" /fixtures/fail 2>&1)"; then
  printf 'Expected textlint to fail for the misspelled fixture\n' >&2
  exit 1
fi

if ! grep -Fq 'commonly misspelled word' <<<"$output"; then
  printf 'Expected a misspelling diagnostic from textlint, got:\n%s\n' "$output" >&2
  exit 1
fi
