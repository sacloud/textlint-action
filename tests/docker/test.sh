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

docker run --rm --entrypoint node "$image" -e '
const dependencies = require("./package.json").dependencies;
for (const [name, expected] of Object.entries(dependencies)) {
  const actual = require(`./node_modules/${name}/package.json`).version;
  if (actual !== expected) {
    console.error(`Expected ${name}@${expected}, got ${actual}`);
    process.exitCode = 1;
  }
}
'

docker run --rm --volume "$fixtures:/fixtures:ro" "$image" /fixtures/pass

if output="$(docker run --rm --volume "$fixtures:/fixtures:ro" "$image" /fixtures/fail 2>&1)"; then
  printf 'Expected textlint to fail for the misspelled fixture\n' >&2
  exit 1
fi

if ! grep -Fq 'commonly misspelled word' <<<"$output"; then
  printf 'Expected a misspelling diagnostic from textlint, got:\n%s\n' "$output" >&2
  exit 1
fi
