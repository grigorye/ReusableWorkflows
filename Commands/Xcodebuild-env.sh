#! /bin/bash

set -x
set -euo pipefail

stderr-filter() {
    grep -v '^objc\[.*\]'
}

xcodebuild() {
    security list-keychains
    # I could not get status from stderr-filter pipe to be passed through (even
    # when employing PIPESTATUS), so for now it is disabled.
    if false; then
        (command xcodebuild "$@" 2>&1 >&3 3>&- | stderr-filter >&2 3>&-) 3>&1
    else
        command xcodebuild "$@"
    fi
}

xcpretty() {
    if [ "${XCPRETTY_ENABLED:-}" != "NO" ] && command -v xcbeautify >/dev/null; then
        command xcbeautify -q
    elif [ "${XCODEBUILD_GREP_VERBOSE:-}" != "NO" ]; then
        grep --line-buffered -v '^ '
    else
        grep --line-buffered '^'
    fi
}
