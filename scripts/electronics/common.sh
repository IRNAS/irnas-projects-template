#!/usr/bin/env bash

# Set the GitHub owner and host here.
OWNER="MarkoSagadin"
HOST="github.com"

# Color codes
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[1;33m'
export BLUE='\033[0;34m'
export NC='\033[0m' # No Color

BANNER="###########################################################"

# Determine script location and repo root
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
REPO_PATH="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel)"
REPO=$(basename "$REPO_PATH")
export REPO_URL="https://$HOST/$OWNER/$REPO"

# Since the project is first created by Altium, it's remote repo uses the
# default "origin" name.
export ALTIUM_ORIGIN="origin"
# For the GitHub origin we choose a slightly different name.
export GITHUB_ORIGIN="gh_origin"

check_git() {
    # Abort if git is not installed
    if ! command -v git &>/dev/null; then
        echo -e "${RED}ERROR: git is not installed.${NC}"
        echo "Install it from: https://git-scm.com/downloads"
        exit 1
    fi
    echo -e "git: ${GREEN}installed${NC}"
}

check_gh() {
    # Abort if gh (GitHub CLI) is not installed
    if ! command -v gh &>/dev/null; then
        echo -e "${RED}ERROR: GitHub CLI tool (gh) is not installed.${NC}"
        echo "Install it from: https://cli.github.com/"
        exit 1
    fi
    echo -e "gh: ${GREEN}installed${NC}"
}

check_gh_auth() {
    # Check if gh is authenticated, if not do it.
    if ! gh auth status &>/dev/null; then
        echo "${BANNER}"
        echo -e "${YELLOW}WARN: No GitHub authentication detected, follow the instructions!${NC}"
        echo -e "${YELLOW}Press Y key for the first question.${NC}"
        echo "${BANNER}"
        gh auth login --hostname "$HOST" --git-protocol https --web
        echo "${BANNER}"
        echo -e "${GREEN}Authentication completed, continuing!${NC}"
        echo "${BANNER}"
    fi
    echo -e "GitHub account: ${GREEN}authenticated${NC}"
}

log_inf() {
    echo -e "${YELLOW}${1}${NC}"
}

press_to_exit() {
    read -pr "Press any key to exit..."
    exit 0
}
