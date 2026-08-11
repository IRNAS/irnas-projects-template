#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

# shellcheck disable=SC1091
source "${SCRIPT_DIR}"/common.sh

echo
echo "${BANNER}"
echo "           Sync Altium project to GitHub script"
echo "${BANNER}"
echo

check_git
check_gh
check_gh_auth

echo -e "Altium project: ${GREEN}${REPO}${NC}"
echo

# Check if the repo exists, if not create it
log_inf "Checking for repo on GitHub..."
if ! gh repo view "${OWNER}/${REPO}" &>/dev/null; then
    echo "Repo not found, creating it"
    gh repo create "${OWNER}/${REPO}" --private &>/dev/null
    echo "Created new repo at: ${YELLOW}${REPO_URL}${NC}"
else
    echo -e "Found repo at: ${YELLOW}${REPO_URL}${NC}"
fi
echo

log_inf "Pushing repo to GitHub"
# Check first if the GITHUB_ORIGIN was added, then push
if git -C "${REPO_PATH}" remote get-url "${GITHUB_ORIGIN}" &>/dev/null; then
    git -C "${REPO_PATH}" remote set-url "${GITHUB_ORIGIN}" "${REPO_URL}".git
else
    git -C "${REPO_PATH}" remote add "${GITHUB_ORIGIN}" "${REPO_URL}".git
fi
git -C "${REPO_PATH}" push --force "${GITHUB_ORIGIN}" HEAD

echo
echo -e "${GREEN}Done!${NC}"
press_to_exit
