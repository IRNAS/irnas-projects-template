#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

# shellcheck disable=SC1091
source "${SCRIPT_DIR}"/common.sh

echo
echo "${BANNER}"
echo "           Create GitHub release script"
echo "${BANNER}"
echo

check_git
check_gh
check_gh_auth
echo

VERSION="${1:-}"
if [[ -z ${VERSION} ]]; then
    read -rp "Enter the release version (format: v1.2.3): " VERSION
fi

if [[ ! ${VERSION} =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo -e "${RED}ERROR: Invalid version format. Use format: v1.2.3.${NC}"
    press_to_exit
fi

OUTPUT_DIR="${REPO_PATH}/output"
if [[ ! -d ${OUTPUT_DIR} || -z "$(ls -A "${OUTPUT_DIR}")" ]]; then
    echo -e "${RED}ERROR: Output folder is missing or empty. Exiting.${NC}"
    press_to_exit
fi

"${SCRIPT_DIR}/update_changelog.sh" "${VERSION}"

echo
log_inf "Creating a new commit with updated Changelog"
cd "${REPO_PATH}"
git add CHANGELOG.md
git commit -m "docs: update CHANGELOG.md for release ${VERSION}"

echo
log_inf "Creating a tag"
git tag "${VERSION}"

echo
log_inf "Pushing new commit and tag to Altium remote repo"
git push "${ALTIUM_ORIGIN}" HEAD "${VERSION}"
echo
log_inf "Pushing new commit and tag to GitHub remote repo"
git push "${GITHUB_ORIGIN}" HEAD "${VERSION}"

RELEASE_NOTES=$(awk -v ver="${VERSION#v}" '
  BEGIN { in_section=0 }
  $0 ~ "^## \\[" ver "\\]" {
    in_section=1; next
  }
  in_section && /^## \[/ { exit }
  in_section { print }
' "${REPO_PATH}/CHANGELOG.md")

echo
log_inf "Creating a GitHub release"
gh release create "${VERSION}" --title "${VERSION}" --notes "${RELEASE_NOTES}"

cd "${OUTPUT_DIR}"

echo
log_inf "Uploading files in ${OUTPUT_DIR} to the release."

# shellcheck disable=SC2046
gh release upload "${VERSION}" $(ls)

echo
echo -e "${GREEN}Release ${VERSION} was created successfully.${NC}"
press_to_exit
