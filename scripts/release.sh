#!/bin/bash
set -euo pipefail

# podlite-skills release
# Usage: scripts/release.sh X.Y.Z [--dry-run]
#
# Bumps the plugin version in .claude-plugin/marketplace.json, commits it,
# tags vX.Y.Z, pushes main and the tag, and creates the GitHub release with
# the commit subjects since the previous tag as notes.
#
# The commit goes through `git ecommit` with the file named on the command
# line, so nothing else in the index is touched. Set RELEASE_PLAIN_COMMIT=1
# to use a plain `git commit` instead.
# The release is created with the token of the gh account in RELEASE_GH_USER
# (default: zag); the active gh account is not switched.

REPO="podlite/podlite-skills"
MANIFEST=".claude-plugin/marketplace.json"
GH_USER="${RELEASE_GH_USER:-zag}"

VERSION="${1:-}"
DRY_RUN=""
[[ "${2:-}" == "--dry-run" ]] && DRY_RUN=1

if [[ ! "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Usage: scripts/release.sh X.Y.Z [--dry-run]"
  exit 1
fi
TAG="v${VERSION}"

cd "$(git rev-parse --show-toplevel)"

echo "-> Checking prerequisites..."
if [[ "$(git rev-parse --abbrev-ref HEAD)" != "main" ]]; then
  echo "ERROR: not on main"; exit 1
fi
if ! git diff --quiet || ! git diff --cached --quiet; then
  echo "ERROR: uncommitted changes. Commit them first."; exit 1
fi
if git rev-parse -q --verify "refs/tags/${TAG}" >/dev/null; then
  echo "ERROR: tag ${TAG} already exists"; exit 1
fi
command -v gh >/dev/null || { echo "ERROR: gh CLI not found"; exit 1; }
TOKEN=$(gh auth token --user "$GH_USER" 2>/dev/null) || { echo "ERROR: no gh token for ${GH_USER}"; exit 1; }

CURRENT=$(node -p "require('./${MANIFEST}').plugins[0].version")
PREV_TAG=$(git describe --tags --abbrev=0 2>/dev/null || true)
RANGE="${PREV_TAG:+${PREV_TAG}..}HEAD"

NOTES_FILE=$(mktemp)
{
  echo "## What's Changed"
  echo ""
  git log --reverse --format='- %s' "$RANGE" | grep -v '^- release: ' || true
  echo ""
  echo "Install: \`npx skills add ${REPO}\`"
  if [[ -n "$PREV_TAG" ]]; then
    echo ""
    echo "**Full Changelog**: https://github.com/${REPO}/compare/${PREV_TAG}...${TAG}"
  fi
} > "$NOTES_FILE"

echo "   version:  ${CURRENT} -> ${VERSION}"
echo "   previous: ${PREV_TAG:-none}"
echo "   unpushed: $(git rev-list --count origin/main..HEAD) commit(s)"
echo "-> Release notes:"
sed 's/^/   /' "$NOTES_FILE"

if [[ -n "$DRY_RUN" ]]; then
  echo ""
  echo "=== DRY RUN: nothing changed ==="
  rm -f "$NOTES_FILE"
  exit 0
fi

echo "-> Bumping ${MANIFEST}..."
node -e "
const fs=require('fs'); const p='${MANIFEST}';
const j=JSON.parse(fs.readFileSync(p,'utf8')); j.plugins[0].version='${VERSION}';
fs.writeFileSync(p, JSON.stringify(j,null,2)+'\n');"

echo "-> Committing..."
if [[ "${RELEASE_PLAIN_COMMIT:-}" == "1" ]]; then
  git commit -q -m "release: ${TAG}" -- "$MANIFEST"
else
  git ecommit -q -m "release: ${TAG}" -- "$MANIFEST"
fi
git tag -a "$TAG" -m "$TAG"

echo "-> Pushing..."
git push origin main
git push origin "$TAG"

echo "-> Creating GitHub release..."
GH_TOKEN="$TOKEN" gh release create "$TAG" --repo "$REPO" --title "$TAG" \
  --notes-file "$NOTES_FILE" --verify-tag
rm -f "$NOTES_FILE"

echo ""
echo "Release ${TAG}: https://github.com/${REPO}/releases/tag/${TAG}"
