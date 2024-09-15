#!/bin/bash -eux

PROJECT_ROOT="$(cd "$(dirname "$0")/../" && pwd)"
SCRIPTS_DIR=$PROJECT_ROOT/scripts

(cd $PROJECT_ROOT; make)

defaults write com.apple.dt.Xcode IDESkipPackagePluginFingerprintValidatation -bool YES
defaults write com.apple.dt.Xcode IDESkipMacroFingerprintValidation -bool YES

if [ "$CI_WORKFLOW" = "Release配信" ]; then
    $SCRIPTS_DIR/validate-tag-version
fi