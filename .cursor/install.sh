#!/usr/bin/env bash
# Idempotent Cloud Agent bootstrap for OpenClip.
#
# OpenClip's app + tests are macOS-only (Swift 6 / AppKit / SwiftUI / Xcode) and cannot
# build on a Linux Cloud Agent. This provisions the repo's Linux-runnable developer
# tooling instead: the Python localization generator (scripts/generate_localizable.py)
# and the extension scaffold/validate scripts (jq + Node).
set -euo pipefail

echo "==> Ensuring Linux dev tooling for OpenClip"

# jq drives scripts/validate_extension.sh (and new_extension.sh's post-scaffold check).
if ! command -v jq >/dev/null 2>&1; then
    echo "--> installing jq"
    sudo apt-get update -y
    sudo apt-get install -y --no-install-recommends jq
fi

echo "python3: $(python3 --version 2>&1)"
echo "jq:      $(jq --version 2>&1)"
echo "node:    $(node --version 2>&1)"
echo "npm:     $(npm --version 2>&1)"

# Verify the localization generator runs (it is pure-Python, no third-party deps).
python3 scripts/generate_localizable.py

echo "==> OpenClip Linux tooling ready"
