#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

# shellcheck disable=SC1091
source "${SCRIPT_DIR}"/common.sh

echo
log_inf "Updating Changelog"

CHANGELOG="${REPO_PATH}/CHANGELOG.md"

# Get the remote URL from gh_origin
REMOTE_URL="$(git -C "${REPO_PATH}" remote get-url gh_origin 2>/dev/null || true)"
if [[ -z ${REMOTE_URL} ]]; then
    echo -e "${RED}Remote 'gh_origin' not found!${NC}"
    press_to_exit
fi

# Normalize GitHub URL (handles git@ and https://)
if [[ $REMOTE_URL =~ ^git@github.com:(.*)\.git$ ]]; then
    GH_REPO="https://github.com/${BASH_REMATCH[1]}"
elif [[ $REMOTE_URL =~ ^https://github.com/(.*)\.git$ ]]; then
    GH_REPO="https://github.com/${BASH_REMATCH[1]}"
else
    echo -e "${RED}Unsupported remote URL format: ${REMOTE_URL}${NC}"
    press_to_exit
fi

# Check if Unreleased section exists and is not empty
UNRELEASED_CONTENT=$(awk '/## \[Unreleased\]/ {found=1; next} /^## \[/ {found=0} found {print}' "${CHANGELOG}")
if [[ -z ${UNRELEASED_CONTENT} ]]; then
    echo -e "${RED}Unreleased section is empty, exiting!${NC}"
    press_to_exit
fi

# Get version from argument or prompt the user
VERSION="${1:-}"
if [[ -z ${VERSION} ]]; then
    read -rp "Enter the new version (format: v1.2.3): " VERSION
fi

# Validate version string
if [[ ! ${VERSION} =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo -e "${RED}Invalid version format. Use format: v1.2.3${NC}"
    press_to_exit
fi

# Remove 'v' prefix for display in the changelog header
VERSION_NO_V="${VERSION#v}"

# Get today's date
DATE="$(date +%Y-%m-%d)"

# Get previous version from changelog
PREV_VERSION=$(awk '/^## \[([0-9]+\.[0-9]+\.[0-9]+)\]/ {print gensub(/## \[([0-9]+\.[0-9]+\.[0-9]+)\].*/, "\\1", "g"); exit}' "${CHANGELOG}")

# Insert new version entry
awk -v ver="${VERSION_NO_V}" -v date="${DATE}" '
    BEGIN {in_unreleased=0}
    /^## \[Unreleased\]/ {
        print;
        print "";
        print "## [" ver "] - " date;
        in_unreleased=1;
        next;
    }
    in_unreleased && /^## \[/ {
        in_unreleased=0;
    }
    in_unreleased {
        print;
        next;
    }
    {
        print;
    }
' "${CHANGELOG}" >"${CHANGELOG}.tmp" && mv "${CHANGELOG}.tmp" "${CHANGELOG}"

# Check if there are any existing links at the bottom
HAS_LINKS=$(awk '/^\[.*\]: / {print; found=1} END { if (!found) exit 1 }' "${CHANGELOG}" 2>/dev/null || echo "")

FIRST_COMMIT=$(git -C "${REPO_PATH}" rev-list --max-parents=0 HEAD)

if [[ -z ${HAS_LINKS} ]]; then
    # First release, no previous versions
    # shellcheck disable=SC2129
    echo "" >>"${CHANGELOG}"
    echo "[Unreleased]: ${GH_REPO}/compare/${VERSION}...HEAD" >>"${CHANGELOG}"
    echo "[$VERSION_NO_V]: ${GH_REPO}/compare/${FIRST_COMMIT}...${VERSION}" >>"${CHANGELOG}"
else

    # Update links
    awk -v repo="${GH_REPO}" -v ver="${VERSION}" -v ver_no_v="${VERSION_NO_V}" -v prev="${PREV_VERSION}" '
        BEGIN { unreleased_done=0 }
        /^\[Unreleased\]: / {
            unreleased_done=1;
            print "[Unreleased]: " repo "/compare/" ver "...HEAD";
            print "[" ver_no_v "]: " repo "/compare/v" prev "..." ver;
            next;
        }
        {
            print;
        }
        END {
            if (!unreleased_done) {
                print "[Unreleased]: " repo "/compare/" ver "...HEAD";
                print "[" ver_no_v "]: " repo "/compare/v" prev "..." ver;
            }
        }
    ' "${CHANGELOG}" >"${CHANGELOG}.tmp" && mv "${CHANGELOG}.tmp" "${CHANGELOG}"
fi

echo -e "CHANGELOG.md was updated with version ${YELLOW}${VERSION}${NC}"
